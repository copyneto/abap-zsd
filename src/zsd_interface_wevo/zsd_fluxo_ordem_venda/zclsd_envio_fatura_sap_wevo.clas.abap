"!<p><h2>Envio de ordem de venda da SAP para WEVO </h2></p>
"!<br/><br/>
"!<p><strong>Autor:</strong> Flávia Leite</p>
"!<p><strong>Data:</strong> 08 de ago de 2022</p>
CLASS zclsd_envio_fatura_sap_wevo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      "! Campos da fatura que serão enviados ao WEVO
      BEGIN OF ty_dados_fatura,
        nfenum          TYPE j_1bnfdoc-nfenum,
        code            TYPE j_1bnfdoc-code,
        salesdocument   TYPE i_billingdocumentitembasic-salesdocument,
        billingdocument TYPE i_billingdocumentitembasic-billingdocument,
      END OF ty_dados_fatura .

    "! NFE Saída
    CONSTANTS gc_nfe_saida TYPE j_1bnfdoc-direct VALUE '2' ##NO_TEXT.
    "! Formato NF Eletrônica
    CONSTANTS gc_form_nf_eletronica TYPE j_1bnfdoc-form VALUE 'NF55' ##NO_TEXT.
    "! Item Primeiro
    CONSTANTS gc_item_primeiro TYPE j_1bnflin-itmnum VALUE '000010' ##NO_TEXT.
    CONSTANTS:
      "! Leitura de range Tipo de pedido WEVO
      BEGIN OF gc_tipo_pedido_wevo,
        modulo TYPE ztca_param_mod-modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'WEVO',
        chave2 TYPE ztca_param_par-chave2 VALUE 'TIPO_PED',
      END OF gc_tipo_pedido_wevo .

    "! Captura de dados da badi J_1BNF_ADD_DATA e envio de dados da fatura para WEVO
    "! @parameter IS_HEADER | Cabeçalho do documento
    METHODS main
      IMPORTING
        !is_header TYPE j_1bnfdoc .
  PROTECTED SECTION.
private section.

  methods ENVIA_FATURA_WEVO
    importing
      !IS_FATURA type TY_DADOS_FATURA .
ENDCLASS.



CLASS ZCLSD_ENVIO_FATURA_SAP_WEVO IMPLEMENTATION.


  METHOD envia_fatura_wevo.

    DATA:
      lt_return TYPE bapiret2_tab.

    CALL FUNCTION 'ZFMSD_ENVIO_FATURA_WEVO'
      IN BACKGROUND TASK AS SEPARATE UNIT
      EXPORTING
        iv_nfenum          = is_fatura-nfenum
        iv_code            = is_fatura-code
        iv_salesdocument   = is_fatura-salesdocument
        iv_billingdocument = is_fatura-billingdocument
      TABLES
        et_return          = lt_return.

    SORT lt_return BY type.

    READ TABLE lt_return TRANSPORTING NO FIELDS
        WITH KEY type = if_xo_const_message=>error BINARY SEARCH.

    IF sy-subrc EQ 0.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD main.

    DATA:
      lr_valid_code       TYPE RANGE OF j_1bnfdoc-code,
      lr_tipo_pedido_wevo TYPE RANGE OF i_salesdocument-customerpurchaseordertype.

    DATA(lo_param) = NEW zclca_tabela_parametros(  ).

    TRY.
        lo_param->m_get_range(
          EXPORTING
            iv_modulo = gc_tipo_pedido_wevo-modulo
            iv_chave1 = gc_tipo_pedido_wevo-chave1
            iv_chave2 = gc_tipo_pedido_wevo-chave2
          IMPORTING
            et_range  = lr_tipo_pedido_wevo
        ).
      CATCH zcxca_tabela_parametros.

        FREE lr_tipo_pedido_wevo.
        RETURN.

    ENDTRY.

    lr_valid_code = VALUE #(  sign = rsmds_c_sign-including
                              option = rsmds_c_option-equal
                              ( low = '100' )
                              ( low = '101' )
                              ( low = '102' )
                              ( low = '103' )
                    ).

    " Valida status, direção e formato da NF para envio da fatura ao Wevo
    IF is_header-code IN lr_valid_code
        AND is_header-direct EQ gc_nfe_saida
        AND is_header-form   EQ gc_form_nf_eletronica.

      SELECT SINGLE
        br_notafiscalitem,
        br_nfsourcedocumentnumber
        FROM i_br_nfitem
            WHERE br_notafiscal EQ @is_header-docnum
                AND br_notafiscalitem EQ @gc_item_primeiro
               INTO @DATA(ls_nfitem).

      IF ls_nfitem IS NOT INITIAL.
        SELECT SINGLE
          billingdocument,
          salesdocument
          FROM i_billingdocumentitembasic
           WHERE billingdocument = @ls_nfitem-br_nfsourcedocumentnumber
            AND billingdocumentitem = @ls_nfitem-br_notafiscalitem
          INTO @DATA(ls_fat).

        IF ls_fat IS NOT INITIAL.
          SELECT SINGLE
            salesdocument,
            customerpurchaseordertype
            FROM i_salesdocument
             WHERE salesdocument = @ls_fat-salesdocument
            INTO @DATA(ls_ordem).

        ENDIF.
      ENDIF.

      " Se o sistema destino for diferente de WEVO, sai do processamento sem envio de informações
      IF ls_ordem-customerpurchaseordertype NOT IN lr_tipo_pedido_wevo.
        RETURN.
      ENDIF.

      " Envia dados da fatura para o WEVO
      DATA(ls_envio_fatura) = VALUE ty_dados_fatura(
                                      nfenum          = is_header-nfenum
                                      code            = is_header-code
                                      salesdocument   = ls_ordem-salesdocument
                                      billingdocument = ls_fat-billingdocument
                                  ).

      me->envia_fatura_wevo( ls_envio_fatura ).


    ENDIF.

  ENDMETHOD.
ENDCLASS.
