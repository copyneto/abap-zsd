"! <p class="shorttext synchronized">Automatização do processo de criar contrato e distrato</p>
"! Autor: Carlos Adriano Garcia
"! <br>Data: 03/09/2021
"!
CLASS zclsd_autom_contrato_distrato DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! <p class="shorttext synchronized">Executar contrato distrato</p>
    "! @parameter iv_erdat  | <p class="shorttext synchronized">Data de criação do registro</p>
    "! @parameter iv_werks  | <p class="shorttext synchronized">Centro</p>
    "! @parameter iv_auart  | <p class="shorttext synchronized">Tipo de documento de vendas</p>
    "! @parameter iv_vbeln  | <p class="shorttext synchronized">Documento de vendas</p>
    "! @parameter rv_BALLOGHNDL  | <p class="shorttext synchronized">Documento de vendas</p>
    METHODS executar
      IMPORTING
        !iv_erdat            TYPE vbak-erdat
        !iv_werks            TYPE vbap-werks
        !iv_auart            TYPE vbak-auart
        !iv_vbeln            TYPE vbak-vbeln
        !iv_vtweg            TYPE vbak-vtweg
      EXPORTING
        !ev_new_salesdoc     TYPE vbeln_va
      RETURNING
        VALUE(rv_balloghndl) TYPE balloghndl .
    METHODS sernr_update
      IMPORTING
        !is_key TYPE zssd_key_updt_sernr .
    METHODS call_shdb_sernr
      IMPORTING
        !iv_vbeln TYPE bapivbeln-vbeln
        !iv_lines TYPE i .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
          "! <p class="shorttext synchronized">Tipo range de documento de vendas</p>
      tt_auart TYPE RANGE OF vbak-auart .

    CONSTANTS:
      "! <p class="shorttext synchronized">Constantes da tabela de Parâmetros</p>
      BEGIN OF gc_param,
        modulo     TYPE ztca_param_par-modulo VALUE 'SD',
        key1       TYPE ztca_param_par-chave1 VALUE 'CONTRATOS FOOD',
        key2       TYPE ztca_param_par-chave2 VALUE 'TIPOS DE CONTRATO',
        dev_macro  TYPE ztca_param_par-chave2 VALUE 'DEVOLUÇÃO MACRO',
        stge_loc   TYPE ztca_param_par-chave3 VALUE 'STGE_LOC',
        move_type  TYPE ztca_param_par-chave3 VALUE 'MOVE_TYP',
        tax_code   TYPE ztca_param_par-chave3 VALUE 'TAXCODE',
        key1_auart TYPE ztca_param_par-chave1 VALUE 'AUART',
        object     TYPE balobj_d              VALUE 'ZSD_AUTO',
        subobject  TYPE balsubobj             VALUE 'ZSD_AUTO',
        msg_class  TYPE arbgb                 VALUE 'ZSD_AUTO_CONT_DIS',
      END OF gc_param .
    "! <p class="shorttext synchronized">Constante categoria de documento = Ordem</p>
    CONSTANTS gc_vbtyp_n TYPE vbtyp_n VALUE 'C' ##NO_TEXT.
    CONSTANTS gc_goodsmvt_code TYPE bapi2017_gm_code VALUE '05' ##NO_TEXT.
    DATA gt_msg_log TYPE bal_t_msg .

    "! <p class="shorttext synchronized">Busca parâmetros</p>
    "! @parameter iv_key1  | <p class="shorttext synchronized">Parâmetro chave 1</p>
    "! @parameter iv_key2  | <p class="shorttext synchronized">Parâmetro chave 2</p>
    "! @parameter iv_key3  | <p class="shorttext synchronized">Parâmetro chave 3</p>
    "! @parameter ev_param | <p class="shorttext synchronized">Parâmetro tipo</p>
    METHODS get_param
      IMPORTING
        !iv_key1  TYPE ztca_param_par-chave1
        !iv_key2  TYPE ztca_param_par-chave2
        !iv_key3  TYPE ztca_param_par-chave3
      EXPORTING
        !ev_param TYPE any .
    "! <p class="shorttext synchronized">Busca parâmetros range</p>
    "! @parameter iv_key1  | <p class="shorttext synchronized">Parâmetro chave 1</p>
    "! @parameter iv_key2  | <p class="shorttext synchronized">Parâmetro chave 2</p>
    "! @parameter rt_auart | <p class="shorttext synchronized">Parâmetro range</p>
    METHODS get_param_range
      IMPORTING
        !iv_key1        TYPE ztca_param_par-chave1
        !iv_key2        TYPE ztca_param_par-chave2
      RETURNING
        VALUE(rt_auart) TYPE tt_auart .
    "! <p class="shorttext synchronized">Verifica se contrato possui ordem venda</p>
    "! @parameter iv_vbeln  | <p class="shorttext synchronized">Documento de vendas</p>
    "! @parameter rv_retorno | <p class="shorttext synchronized">Retorno</p>
    METHODS contrato_possui_ordem_venda
      IMPORTING
        !iv_vbeln         TYPE vbak-vbeln
      RETURNING
        VALUE(rv_retorno) TYPE abap_bool .
    "! <p class="shorttext synchronized">Busca tipo documento destino</p>
    "! @parameter iv_auart  | <p class="shorttext synchronized">Tipo de Documento Origem</p>
    "! @parameter rv_retorno | <p class="shorttext synchronized">Tipo de Documento Destino</p>
    METHODS busca_tipo_documento_destino
      IMPORTING
        !iv_auart         TYPE auart_von
        !iv_operacao      TYPE ze_param_chave
      RETURNING
        VALUE(rv_retorno) TYPE auart_nach .
    METHODS registra_log
      RETURNING
        VALUE(rv_balloghndl) TYPE balloghndl .
ENDCLASS.



CLASS zclsd_autom_contrato_distrato IMPLEMENTATION.


  METHOD get_param_range.
    CLEAR rt_auart.
    TRY.
        DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).      " INSERT - JWSILVA - 21.07.2023

        lo_param->m_get_range(                                          " CHANGE - JWSILVA - 21.07.2023
          EXPORTING
            iv_modulo = gc_param-modulo
            iv_chave1 = iv_key1
            iv_chave2 = iv_key2
          IMPORTING
            et_range  = rt_auart
        ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.
  ENDMETHOD.


  METHOD get_param.
    CLEAR ev_param.
    TRY.
        DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).      " INSERT - JWSILVA - 21.07.2023

        lo_param->m_get_single( EXPORTING iv_modulo = gc_param-modulo   " CHANGE - JWSILVA - 21.07.2023
                                          iv_chave1 = iv_key1
                                          iv_chave2 = iv_key2
                                          iv_chave3 = iv_key3
                                IMPORTING ev_param  = ev_param ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.
  ENDMETHOD.


  METHOD contrato_possui_ordem_venda.
    SELECT COUNT(*) FROM vbfa
      WHERE vbelv   = iv_vbeln
        AND vbtyp_n = gc_vbtyp_n.
    rv_retorno = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.


  METHOD busca_tipo_documento_destino.

    SELECT SINGLE low
      FROM ztca_param_val
      WHERE modulo = @gc_param-modulo
        AND chave1 = @gc_param-key1_auart
        AND chave2 = @iv_operacao
        AND chave3 = @iv_auart
      INTO @DATA(lv_retorno).

    IF sy-subrc = 0.
      rv_retorno = lv_retorno.
    ENDIF.

  ENDMETHOD.


  METHOD executar.

    DATA: lt_return           TYPE STANDARD TABLE OF bapiret2,
          lt_auart            TYPE STANDARD TABLE OF vbak-auart,
          lv_salesdocument_ex TYPE vbeln_va.

    CONSTANTS: BEGIN OF lc_vtweg,
                 v1  TYPE vbak-vtweg VALUE '01',
                 v2  TYPE vbak-vtweg VALUE '02',
                 v3  TYPE vbak-vtweg VALUE '03',
                 v4  TYPE vbak-vtweg VALUE '04',
                 v5  TYPE vbak-vtweg VALUE '05',
                 v6  TYPE vbak-vtweg VALUE '06',
                 v7  TYPE vbak-vtweg VALUE '07',
                 v8  TYPE vbak-vtweg VALUE '08',
                 v9  TYPE vbak-vtweg VALUE '09',
                 v10 TYPE vbak-vtweg VALUE '10',
                 v14 TYPE vbak-vtweg VALUE '14',
                 v16 TYPE vbak-vtweg VALUE '16',
               END OF lc_vtweg.

    DATA: lr_vtweg TYPE RANGE OF vbak-vtweg.

    lr_vtweg = VALUE #( ( sign = 'I' option = 'EQ' low = lc_vtweg-v1 )
                        ( sign = 'I' option = 'EQ' low = lc_vtweg-v2 )
                        ( sign = 'I' option = 'EQ' low = lc_vtweg-v3 )
                        ( sign = 'I' option = 'EQ' low = lc_vtweg-v4 )
                        ( sign = 'I' option = 'EQ' low = lc_vtweg-v5 )
                        ( sign = 'I' option = 'EQ' low = lc_vtweg-v6 )
                        ( sign = 'I' option = 'EQ' low = lc_vtweg-v7 )
                        ( sign = 'I' option = 'EQ' low = lc_vtweg-v8 )
                        ( sign = 'I' option = 'EQ' low = lc_vtweg-v9 )
                        ( sign = 'I' option = 'EQ' low = lc_vtweg-v14 )
                        ( sign = 'I' option = 'EQ' low = lc_vtweg-v16 ) ).

    IF NOT contrato_possui_ordem_venda( iv_vbeln ).

* BEGIN OF INSERT - JWSILVA - 12.10.2022
      DATA(lv_operacao) = COND ze_param_chave( WHEN iv_vtweg = lc_vtweg-v10
                                                 THEN 'MACRO'
                                               WHEN iv_vtweg IN lr_vtweg
                                                 THEN 'MICRO' ).

      DATA(lv_auart_new) = me->busca_tipo_documento_destino( iv_auart    = iv_auart
                                                             iv_operacao = lv_operacao ).

      " Iniciando cópia da ordem de venda &1.
      APPEND VALUE #( msgty = 'S'
                      msgid = gc_param-msg_class
                      msgno = '011'
                      msgv1 = iv_vbeln ) TO gt_msg_log.

* END OF INSERT - JWSILVA - 12.10.2022

      CALL FUNCTION 'BAPI_SALESDOCUMENT_COPY'
        EXPORTING
          salesdocument    = iv_vbeln
*         documenttype     = busca_tipo_documento_destino( iv_auart ) " DELETE - JWSILVA - 12.10.2022
          documenttype     = lv_auart_new                             " INSERT - JWSILVA - 12.10.2022
*         testrun          = space
        IMPORTING
          salesdocument_ex = lv_salesdocument_ex                      " INSERT - JWSILVA - 12.10.2022
        TABLES
          return           = lt_return.

      LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
        APPEND VALUE #( msgty   = <fs_return>-type
                        msgid = <fs_return>-id
                        msgno = <fs_return>-number
                        msgv1 = <fs_return>-message_v1
                        msgv2 = <fs_return>-message_v2
                        msgv3 = <fs_return>-message_v3
                        msgv4 = <fs_return>-message_v4 ) TO gt_msg_log.

        IF <fs_return>-type = 'E'.
          DATA(lv_error) = abap_true.
        ENDIF.

      ENDLOOP.

      IF lv_error = abap_false.

        ev_new_salesdoc = lv_salesdocument_ex.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.

        " Documento &1 do tipo &2 criado com sucesso.
        APPEND VALUE #( msgty = 'S'
                        msgid = gc_param-msg_class
                        msgno = '010'
                        msgv1 = lv_salesdocument_ex
                        msgv2 = lv_auart_new ) TO gt_msg_log.

      ELSE.

        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      ENDIF.
* END OF CHANGE - JWSILVA - 12.10.2022
    ENDIF.

*    SELECT docnum, pstdat, docdat, nfenum, series, parid  UP TO 1 ROWS FROM j_1bnfdoc
*    INTO @DATA(ls_nf_documento)
*    WHERE docnum = @iv_vbeln.
*    ENDSELECT.
*
*    IF sy-subrc = 0.
*      SELECT * FROM j_1bnflin INTO TABLE @DATA(lt_nf_itens)
*      WHERE docnum = @iv_vbeln.
*      IF sy-subrc = 0.
*        SELECT vbeln, vbelv, posnv FROM vbfa INTO TABLE @DATA(lt_vbfa)
*        FOR ALL ENTRIES IN @lt_nf_itens            "#EC CI_NO_TRANSFORM
*        WHERE vbeln = @lt_nf_itens-refkey(10)
*          AND vbtyp_v = 'J'.       "#EC CI_NOFIELD "#EC CI_NO_TRANSFORM
*        IF sy-subrc = 0.
*          SELECT obknr, lief_nr, posnr FROM ser01 INTO TABLE @DATA(lt_ser01)
*          FOR ALL ENTRIES IN @lt_vbfa
*          WHERE lief_nr = @lt_vbfa-vbelv
*            AND posnr = @lt_vbfa-posnv.            "#EC CI_NO_TRANSFORM
*          IF sy-subrc = 0.
*            SELECT obknr, sernr FROM objk INTO TABLE @DATA(lt_objk)
*            FOR ALL ENTRIES IN @lt_ser01
*            WHERE obknr = @lt_ser01-obknr.         "#EC CI_NO_TRANSFORM
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ELSE.
*      APPEND VALUE #(
*      msgty   = 'E'
*      msgid = gc_param-msg_class
*      msgno = '008'
*      msgv1 = iv_vbeln ) TO gt_msg_log.
*
*      lv_error = abap_true.
**      rv_balloghndl = me->registra_log( ).
**      EXIT.
*    ENDIF.
*
*    DATA(ls_goodsmvt_header) = VALUE bapi2017_gm_head_01(
*      pstng_date = ls_nf_documento-pstdat
*      doc_date = ls_nf_documento-docdat
*      ref_doc_no = ls_nf_documento-nfenum && ls_nf_documento-series
*      gr_gi_slip_no = iv_vbeln
*    ).
*    DATA:
*      lt_goodsmvt_item         TYPE bapi2017_gm_item_create_t,
*      lt_goodsmvt_serialnumber TYPE bapi2017_gm_serialnumber_t,
*      lv_stge_loc              TYPE bapi2017_gm_item_create-stge_loc,
*      lv_move_type             TYPE bapi2017_gm_item_create-move_type,
**      lv_taxcode         TYPE bapi2017_gm_item_create-tax_code,
*      lt_goodsmvt_return       TYPE STANDARD TABLE OF bapiret2.
*
*    get_param( EXPORTING iv_key1  = gc_param-key1
*                         iv_key2  = gc_param-dev_macro
*                         iv_key3  = gc_param-stge_loc
*               IMPORTING ev_param = lv_stge_loc ).
*
*    get_param( EXPORTING iv_key1  = gc_param-key1
*                         iv_key2  = gc_param-dev_macro
*                         iv_key3  = gc_param-move_type
*               IMPORTING ev_param = lv_move_type ).
*
**    get_param( EXPORTING iv_key1  = gc_param-key1
**                         iv_key2  = gc_param-dev_macro
**                         iv_key3  = gc_param-taxcode
**               IMPORTING ev_param = lv_taxcode ).
*    SORT lt_vbfa BY vbeln.
*    SORT lt_ser01 BY lief_nr posnr.
*    SORT lt_objk BY obknr.
*    DATA lv_item TYPE numc4.
*    LOOP AT lt_nf_itens ASSIGNING FIELD-SYMBOL(<fs_nf_item>).
*      ADD 1 TO lv_item.
*
*      APPEND VALUE #(
*        material = <fs_nf_item>-matnr
*        plant = iv_werks
*        stge_loc = lv_stge_loc
*        move_type = lv_move_type
*        vendor = ls_nf_documento-parid
*        entry_qnt = <fs_nf_item>-menge
**        EXT_BASE_AMOUNT  = <fs_nf_item>-netwr "amount_sv ---ver qual dos dois
**        TAX_CODE = lv_taxcode --verificar tax_code
*      ) TO lt_goodsmvt_item.
*
*
*      READ TABLE lt_vbfa ASSIGNING FIELD-SYMBOL(<fs_vbfa>) WITH KEY vbeln = <fs_nf_item>-refkey(10) BINARY SEARCH.
*      IF sy-subrc = 0.
*        READ TABLE lt_ser01 ASSIGNING FIELD-SYMBOL(<fs_ser01>) WITH KEY lief_nr = <fs_vbfa>-vbelv posnr = <fs_vbfa>-posnv BINARY SEARCH.
*        IF sy-subrc = 0.
*          READ TABLE lt_objk ASSIGNING FIELD-SYMBOL(<fs_objk>) WITH KEY obknr = <fs_ser01>-obknr BINARY SEARCH.
*          IF sy-subrc = 0.
*            DATA(lv_obknr) = <fs_objk>-obknr.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*
*      APPEND VALUE #(
*        matdoc_itm = lv_item
*        serialno = lv_obknr
*      ) TO lt_goodsmvt_serialnumber.
*
*    ENDLOOP.

*    APPEND VALUE #(
*    msgty   = 'S'
*    msgid = gc_param-msg_class
*    msgno = '004' ) TO gt_msg_log.
*
*    CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
*      EXPORTING
*        goodsmvt_header       = ls_goodsmvt_header
*        goodsmvt_code         = gc_goodsmvt_code
**       testrun               = space
**       goodsmvt_ref_ewm      =
**       goodsmvt_print_ctrl   =
**      IMPORTING
**       goodsmvt_headret      =
**       materialdocument      =
**       matdocumentyear       =
*      TABLES
*        goodsmvt_item         = lt_goodsmvt_item
*        goodsmvt_serialnumber = lt_goodsmvt_serialnumber
*        return                = lt_goodsmvt_return
**       goodsmvt_serv_part_data =
**       extensionin           =
**       goodsmvt_item_cwm     =
*      .
*
*    lv_error = abap_false.
*
*    LOOP AT lt_goodsmvt_return ASSIGNING FIELD-SYMBOL(<fs_goodsmvt_return>).
*      APPEND VALUE #(
*      msgty   = <fs_goodsmvt_return>-type
*      msgid = <fs_goodsmvt_return>-id
*      msgno = <fs_goodsmvt_return>-number
*      msgv1 = <fs_goodsmvt_return>-message_v1
*      msgv2 = <fs_goodsmvt_return>-message_v2
*      msgv3 = <fs_goodsmvt_return>-message_v3
*      msgv4 = <fs_goodsmvt_return>-message_v4
*                ) TO gt_msg_log.
*
*      IF <fs_goodsmvt_return>-type = 'E'.
*        lv_error = abap_true.
*      ENDIF.
*
*    ENDLOOP.
*
*    IF lv_error = abap_false.
*      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
*      APPEND VALUE #(
*      msgty   = 'S'
*      msgid = gc_param-msg_class
*      msgno = '005' ) TO gt_msg_log.
*    ENDIF.

*    lv_error = abap_false.
*
*    SELECT * FROM vbap
*    WHERE vbeln = @iv_vbeln
*      AND abgru IS NOT INITIAL
*    INTO TABLE @DATA(lt_vbap).
*    IF sy-subrc = 0.
*      DATA(lr_auart) = get_param_range(
*        iv_key1 = gc_param-key1
*        iv_key2 = gc_param-key2
*      ).
*
*      SELECT vbeln, posnn FROM vbfa
*      FOR ALL ENTRIES IN @lt_vbap
*      WHERE vbelv = @lt_vbap-vbeln
*        AND posnv = @lt_vbap-posnr
*        AND vbtyp_n = 'C'
*       INTO TABLE @DATA(lt_vbfa_ordem).            "#EC CI_NO_TRANSFORM
*      IF sy-subrc = 0.
*        SELECT vbeln, posnn FROM vbfa
*        FOR ALL ENTRIES IN @lt_vbfa_ordem
*        WHERE vbelv = @lt_vbfa_ordem-vbeln
*          AND posnv = @lt_vbfa_ordem-posnn
*          AND vbtyp_n = 'J'
*         INTO TABLE @DATA(lt_vbfa_remessa).        "#EC CI_NO_TRANSFORM
*        IF sy-subrc = 0.
*          SELECT vbeln, posnn FROM vbfa
*          FOR ALL ENTRIES IN @lt_vbfa_remessa
*          WHERE vbelv = @lt_vbfa_remessa-vbeln
*            AND posnv = @lt_vbfa_remessa-posnn
*            AND vbtyp_n = 'M'
*           INTO TABLE @DATA(lt_vbfa_fatura).       "#EC CI_NO_TRANSFORM
*          IF sy-subrc <> 0.
*            DATA(lv_erro) = abap_true.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    else.
*      APPEND VALUE #(
*      msgty   = 'E'
*      msgid = gc_param-msg_class
*      msgno = '009'
*      msgv1 = iv_vbeln ) TO gt_msg_log.
*
*      lv_error = abap_true.
*    ENDIF.
*
*    IF lv_erro = abap_true.
*
***verificar na tabela de parâmetro o tipo de ordem de retorno
***(Módulo: SD, Chave 1: CONTRATOS FOOD, Chave 2: tp.OV retorno, CHave 2: ABGRU, obter valor mínimo)
**
*      DATA  lv_salesdocument_ex TYPE vbeln_va .
*
*      APPEND VALUE #(
*      msgty   = 'S'
*      msgid = gc_param-msg_class
*      msgno = '002' ) TO gt_msg_log.
*
*      CALL FUNCTION 'BAPI_SALESDOCUMENT_COPY'
*        EXPORTING
*          salesdocument    = iv_vbeln "qual nr do documento
*          documenttype     = iv_auart "qual tipo de documento
**         testrun          = space
*        IMPORTING
*          salesdocument_ex = lv_salesdocument_ex
*        TABLES
*          return           = lt_return.
*
*      lv_error = abap_false.
*
*      LOOP AT lt_return ASSIGNING <fs_return>.
*        APPEND VALUE #(
*        msgty   = <fs_return>-type
*        msgid = <fs_return>-id
*        msgno = <fs_return>-number
*        msgv1 = <fs_return>-message_v1
*        msgv2 = <fs_return>-message_v2
*        msgv3 = <fs_return>-message_v3
*        msgv4 = <fs_return>-message_v4
*                  ) TO gt_msg_log.
*
*        IF <fs_return>-type = 'E'.
*          lv_error = abap_true.
*        ENDIF.
*
*      ENDLOOP.
*
*      IF lv_error = abap_false.
*        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
*
*        APPEND VALUE #(
*        msgty   = 'S'
*        msgid = gc_param-msg_class
*        msgno = '003' ) TO gt_msg_log.
*
***      A BAPI de modificação deverá ser chamada para eliminar os itens que foram
***      criado na cópia acima que não estão relacionamentos ao POSNN obtido inicialmente.
*        DATA:
*          lt_return_change TYPE STANDARD TABLE OF bapiret2,
*          lt_order_item    TYPE bapisditm_tt,
*          lt_order_itemx   TYPE bapisditmx_tt.
*
*        DATA(ls_order_header_inx) = VALUE bapisdh1x( updateflag = 'U' ).
*
*
*        LOOP AT lt_vbap ASSIGNING FIELD-SYMBOL(<fs_vbap>).
*          APPEND VALUE #( itm_number = <fs_vbap>-posnr  ) TO lt_order_item.
*          APPEND VALUE #(
*            itm_number = <fs_vbap>-posnr
*            updateflag = 'D'
*          ) TO lt_order_itemx.
*        ENDLOOP.
*
*        APPEND VALUE #(
*        msgty   = 'S'
*        msgid = gc_param-msg_class
*        msgno = '006' ) TO gt_msg_log.
*
*        CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
*          EXPORTING
*            salesdocument    = lv_salesdocument_ex
**           order_header_in  =
*            order_header_inx = ls_order_header_inx
**           simulation       =
**           behave_when_error     = space
**           int_number_assignment = space
**           logic_switch     =
**           no_status_buf_init    = space
*          TABLES
*            return           = lt_return_change
*            order_item_in    = lt_order_item
*            order_item_inx   = lt_order_itemx.
*
*        lv_error = abap_false.
*
*        LOOP AT lt_return_change ASSIGNING FIELD-SYMBOL(<fs_return_change>).
*          APPEND VALUE #(
*          msgty   = <fs_return_change>-type
*          msgid = <fs_return_change>-id
*          msgno = <fs_return_change>-number
*          msgv1 = <fs_return_change>-message_v1
*          msgv2 = <fs_return_change>-message_v2
*          msgv3 = <fs_return_change>-message_v3
*          msgv4 = <fs_return_change>-message_v4
*                    ) TO gt_msg_log.
*
*          IF <fs_return>-type = 'E'.
*            lv_error = abap_true.
*          ENDIF.
*        ENDLOOP.
*
*        IF lv_error = abap_false.
*          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
*          APPEND VALUE #(
*          msgty   = 'S'
*          msgid = gc_param-msg_class
*          msgno = '007' ) TO gt_msg_log.
*        ENDIF.
*      ENDIF.
*    ENDIF.

    rv_balloghndl = me->registra_log( ).


  ENDMETHOD.


  METHOD registra_log.

    DATA: ls_log          TYPE bal_s_log,
          ls_log_handle   TYPE  balloghndl,
          lt_t_log_handle TYPE  bal_t_logh.

    ls_log-object    = gc_param-object.
    ls_log-subobject = gc_param-subobject.
    ls_log-alprog    = sy-repid.

    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING
        i_s_log                 = ls_log
      IMPORTING
        e_log_handle            = ls_log_handle
      EXCEPTIONS
        log_header_inconsistent = 1
        OTHERS                  = 2.
    IF sy-subrc <> 0.
      MESSAGE e001(zsd_auto_cont_dis).
    ENDIF.

    APPEND ls_log_handle TO lt_t_log_handle.


    LOOP AT gt_msg_log ASSIGNING FIELD-SYMBOL(<fs_msg_log>).

      CALL FUNCTION 'BAL_LOG_MSG_ADD'
        EXPORTING
          i_log_handle     = ls_log_handle
          i_s_msg          = <fs_msg_log>
        EXCEPTIONS
          log_not_found    = 1
          msg_inconsistent = 2
          log_is_full      = 3
          OTHERS           = 4.
      IF sy-subrc <> 0.
        MESSAGE e001(zsd_auto_cont_dis).
      ENDIF.

      IF sy-batch = abap_true.
        "DATA: lv_message TYPE string.
*        MESSAGE  ID <fs_msg_log>-msgid TYPE 'E' NUMBER <fs_msg_log>-msgno
*        MESSAGE  ID <fs_msg_log>-msgid TYPE <fs_msg_log>-msgty NUMBER <fs_msg_log>-msgno
*           WITH <fs_msg_log>-msgv1 <fs_msg_log>-msgv2  <fs_msg_log>-msgv3  <fs_msg_log>-msgv4
*           DISPLAY LIKE <fs_msg_log>-msgty.

        "concatenate <fs_msg_log>-msgv1 <fs_msg_log>-msgv2 <fs_msg_log>-msgv3 <fs_msg_log>-msgv4 into lv_message.
        "message id <fs_msg_log>-msgid into LV_STRING.

        MESSAGE ID <fs_msg_log>-msgid TYPE <fs_msg_log>-msgty NUMBER <fs_msg_log>-msgno INTO DATA(lv_mtext)
        WITH <fs_msg_log>-msgv1 <fs_msg_log>-msgv2 <fs_msg_log>-msgv3 <fs_msg_log>-msgv4.
        WRITE: / lv_mtext.
      ENDIF.

    ENDLOOP.


    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
        i_t_log_handle   = lt_t_log_handle[]
      EXCEPTIONS
        log_not_found    = 1
        save_not_allowed = 2
        numbering_error  = 3
        OTHERS           = 4.

    IF sy-subrc <> 0.
      MESSAGE e001(zsd_auto_cont_dis).
    ENDIF.

    rv_balloghndl =  ls_log_handle.


  ENDMETHOD.


  METHOD call_shdb_sernr.

    DATA: lt_bdcdata    TYPE STANDARD TABLE OF bdcdata,
          lt_bdcmsgcoll TYPE STANDARD TABLE OF bdcmsgcoll.

    DATA: lv_mode TYPE char1 VALUE 'N'.

    lt_bdcdata = VALUE #( BASE lt_bdcdata ( program  = 'SAPMV45A'
                                            dynpro   = '0102'
                                            dynbegin = 'X' ) ).

    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_OKCODE'
                                            fval = '=ENT2' ) ).

    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'VBAK-VBELN'
                                            fval = iv_vbeln ) ).

    lt_bdcdata = VALUE #( BASE lt_bdcdata ( program  = 'SAPMV45A'
                                            dynpro   = '4001'
                                            dynbegin = 'X' ) ).

    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_OKCODE'
                                            fval = '=FEAZ' ) ).

    DO iv_lines TIMES.
      lt_bdcdata = VALUE #( BASE lt_bdcdata ( program  = 'SAPMSSY0'
                                              dynpro   = '0120'
                                              dynbegin = 'X' ) ).

      lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_OKCODE'
                                              fval = '=&ALL' ) ).

      lt_bdcdata = VALUE #( BASE lt_bdcdata ( program  = 'SAPMSSY0'
                                              dynpro   = '0120'
                                              dynbegin = 'X' ) ).

      lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_OKCODE'
                                              fval = '=FEBE' ) ).

      lt_bdcdata = VALUE #( BASE lt_bdcdata ( program  = 'SAPLIPW1'
                                              dynpro   = '0300'
                                              dynbegin = 'X' ) ).

      lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_OKCODE'
                                              fval = '=RWS' ) ).
    ENDDO.

    lt_bdcdata = VALUE #( BASE lt_bdcdata ( program  = 'SAPMV45A'
                                            dynpro   = '4001'
                                            dynbegin = 'X' ) ).

    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_OKCODE'
                                            fval = '=SICH' ) ).

    CALL TRANSACTION 'VA02'
               USING lt_bdcdata
                MODE lv_mode
       MESSAGES INTO lt_bdcmsgcoll.

  ENDMETHOD.


  METHOD sernr_update.

    DATA(lv_serie)   = is_key-sernr.
    DATA(lv_matnr)   = is_key-matnr.
    DATA(lv_doument) = is_key-document.
    DATA(lv_item)    = is_key-itm_number.
    DATA(lv_debitor) = is_key-partn_numb.
    DATA(lv_auart)   = is_key-auart.
    DATA(lv_postyp)  = is_key-pstyv.

    CALL FUNCTION 'SERNR_ADD_TO_AU'
      EXPORTING
        sernr                 = lv_serie
        profile               = '0006'
        material              = lv_matnr
        quantity              = '1'
        j_vorgang             = space
        document              = lv_doument
        item                  = lv_item
        debitor               = lv_debitor
        vbtyp                 = 'G'
        sd_auart              = lv_auart
        sd_postyp             = lv_postyp
      EXCEPTIONS
        konfigurations_error  = 1
        serialnumber_errors   = 2
        serialnumber_warnings = 3
        no_profile_operation  = 4
        OTHERS                = 5.

    IF sy-subrc EQ 0.
      CALL FUNCTION 'SERIAL_LISTE_POST_AU'.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
