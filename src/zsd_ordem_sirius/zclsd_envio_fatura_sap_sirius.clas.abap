"!<p><h2>Envio de ordem de venda da SAP para SIRIUS </h2></p>
"!<br/><br/>
"!<p><strong>Autor:</strong> Anderson Miazato</p>
"!<p><strong>Data:</strong> 03 de nov de 2021</p>
CLASS zclsd_envio_fatura_sap_sirius DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      "! Campos da fatura que serão enviados ao Sirius
      BEGIN OF ty_dados_fatura,
        nfenum          TYPE j_1bnfdoc-nfenum,
        code            TYPE j_1bnfdoc-code,
        salesdocument   TYPE ZI_SD_NFitemSirius-SalesDocument,
        billingdocument TYPE I_BillingDocumentItemBasic-BillingDocument,
      END OF ty_dados_fatura.

    CONSTANTS:
      "! NFE Saída
      gc_nfe_saida          TYPE j_1bnfdoc-direct VALUE '2',
      "! Formato NF Eletrônica
      gc_form_nf_eletronica TYPE j_1bnfdoc-form VALUE 'NF55',
      "! Item Primeiro
      gc_item_primeiro      TYPE ZI_SD_NFitemSirius-Item VALUE '000010'.

    CONSTANTS:
      "! Leitura de range Tipo de pedido Sirius
      BEGIN OF gc_tipo_pedido_sirius,
        modulo TYPE ztca_param_mod-modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'SIRIUS',
        chave2 TYPE ztca_param_par-chave2 VALUE 'TIPO_PED',
      END OF gc_tipo_pedido_sirius.

    METHODS:
      "! Captura de dados da badi J_1BNF_ADD_DATA e envio de dados da fatura para Sirius
      "! @parameter IS_HEADER | Cabeçalho do documento
      main
        IMPORTING
          !is_header TYPE j_1bnfdoc.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      "! Envia dados da fatura para o Sirius
      "! @parameter is_fatura | Campos da Fatura
      envia_fatura_sirius
        IMPORTING is_fatura TYPE ty_dados_fatura.
ENDCLASS.



CLASS zclsd_envio_fatura_sap_sirius IMPLEMENTATION.

  METHOD main.

    DATA:
      lr_valid_code         TYPE RANGE OF j_1bnfdoc-code,
      lr_tipo_pedido_sirius TYPE RANGE OF ZI_SD_NFitemSirius-CustomerPurchaseOrderType.

    DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 22.07.2023

    TRY.
        lo_param->m_get_range(
          EXPORTING
            iv_modulo = gc_tipo_pedido_sirius-modulo
            iv_chave1 = gc_tipo_pedido_sirius-chave1
            iv_chave2 = gc_tipo_pedido_sirius-chave2
          IMPORTING
            et_range  = lr_tipo_pedido_sirius
        ).
      CATCH zcxca_tabela_parametros.

        FREE lr_tipo_pedido_sirius.
        RETURN.

    ENDTRY.

    lr_valid_code = VALUE #(  sign = rsmds_c_sign-including
                              option = rsmds_c_option-equal
                              ( low = '100' )
                              ( low = '101' )
                              ( low = '102' )
                              ( low = '103' )
                    ).

    " Valida status, direção e formato da NF para envio da fatura ao Sirius
    IF is_header-code IN lr_valid_code
        AND is_header-direct EQ gc_nfe_saida
        AND is_header-form   EQ gc_form_nf_eletronica.

      SELECT
        Document,
        Item,
        ReferenceKey,
        SalesDocument,
        CustomerPurchaseOrderType
        FROM ZI_SD_NFitemSirius
            WHERE Document EQ @is_header-docnum
                AND Item EQ @gc_item_primeiro
        INTO TABLE @DATA(lt_NFitem).

      IF sy-subrc NE 0.
        RETURN.
      ENDIF.

      " Se o sistema destino for diferente de Sirius, sai do processamento sem envio de informações
      READ TABLE lt_nfitem ASSIGNING FIELD-SYMBOL(<fs_nfitem>) INDEX 1.
      IF sy-subrc EQ 0.

        IF <fs_nfitem>-CustomerPurchaseOrderType NOT IN lr_tipo_pedido_sirius.
          RETURN.
        ENDIF.

      ENDIF.

      " Envia dados da fatura para o Sirius
      DATA(ls_envio_fatura) = VALUE ty_dados_fatura(
                                      nfenum          = is_header-nfenum
                                      code            = is_header-code
                                      salesdocument   = <fs_nfitem>-SalesDocument
                                      billingdocument = <fs_nfitem>-ReferenceKey
                                  ).

      me->envia_fatura_sirius( ls_envio_fatura ).


    ENDIF.

  ENDMETHOD.

  METHOD envia_fatura_sirius.

    DATA:
      lt_return TYPE bapiret2_tab.

    CALL FUNCTION 'ZFMSD_ENVIO_FATURA_SIRIUS'
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

ENDCLASS.
