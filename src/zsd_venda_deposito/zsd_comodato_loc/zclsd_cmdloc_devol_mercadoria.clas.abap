class ZCLSD_CMDLOC_DEVOL_MERCADORIA definition
  public
  final
  create public .

public section.

  methods CHAMADA_EXIT
    importing
      !IS_VBAK type TDS_XVBAK optional
      !IT_VBAP type TT_VBAPVB optional
    returning
      value(RT_MENSAGENS) type BAPIRET2_TAB .
  methods FUNCAO_DEVOLUCAO
    importing
      !IS_KEY type ZSSD_KEY_COMODLOC
      !IV_MICRO type CHAR1 optional
      !IS_VBAK type TDS_XVBAK optional
      !IT_VBAP type TT_VBAPVB optional
    returning
      value(RT_MENSAGENS) type BAPIRET2_TAB .
  methods FUNCAO_MOVIMENTO_MM
    importing
      !IS_VBAK type TDS_XVBAK
      !IT_VBAP type TT_VBAPVB .
  methods DEVOLUCAO
    importing
      !IS_KEY type ZSSD_KEY_COMODLOC
      !IS_VBAK type TDS_XVBAK
      !IT_VBAP type TT_VBAPVB
    returning
      value(RT_MENSAGENS) type BAPIRET2_TAB .
  methods MOVIMENTO_MM
    importing
      !IS_VBAK type TDS_XVBAK
      !IT_VBAP type TT_VBAPVB
    exporting
      !EV_MAT_DOC type BAPI2017_GM_HEAD_RET-MAT_DOC
      !EV_DOC_YEAR type BAPI2017_GM_HEAD_RET-DOC_YEAR .
  class-methods SETUP_MESSAGES
    importing
      !P_TASK type CLIKE .
  methods CALL_SHDB_SERNR
    importing
      !IV_VBELN type BAPIVBELN-VBELN
      !IV_LINES type I .
protected section.
private section.

  data GT_MSG_LOG type BAL_T_MSG .
  constants:
    "! <p class="shorttext synchronized">Constantes da tabela de Parâmetros</p>
    BEGIN OF gc_const,
      msg_class      TYPE sy-msgid         VALUE 'ZSD_AUTO_CONT_DIS',
      msg_sucess     TYPE sy-msgty         VALUE 'S',
      msg_error      TYPE sy-msgty         VALUE 'E',
      object         TYPE balobj_d         VALUE 'ZSD_AUTO',
      subobject      TYPE balsubobj        VALUE 'ZSD_AUTO',
      msg_10         TYPE sy-msgno         VALUE '010',
      msg_11         TYPE sy-msgno         VALUE '011',
      vtweg_macro    TYPE vbak-vtweg       VALUE '10',
      mtv_rec_08     TYPE vbap-abgru       VALUE '08',
      mtv_rec_09     TYPE vbap-abgru       VALUE '09',
      auart_z023     TYPE vbak-auart       VALUE 'Z023',
      auart_z024     TYPE vbak-auart       VALUE 'Z024',
      auart_yd74     TYPE vbak-auart       VALUE 'YD74',
      auart_yd75     TYPE vbak-auart       VALUE 'YD75',
      auart_yd76     TYPE vbak-auart       VALUE 'YD76',
      auart_yd77     TYPE vbak-auart       VALUE 'YD77',
      auart_yr74     TYPE vbak-auart       VALUE 'YR74',
      auart_yr77     TYPE vbak-auart       VALUE 'YR77',
      auart_yr75     TYPE vbak-auart       VALUE 'YR75',
      auart_yr76     TYPE vbak-auart       VALUE 'YR76',
      ord_rea_r06    TYPE augru            VALUE 'R06',
      ord_rea_r07    TYPE augru            VALUE 'R07',
      tp_opera_macro TYPE char5            VALUE 'Macro',
      goods_mov      TYPE bapi2017_gm_code VALUE '05',
      movtyp_yg6     TYPE bwart            VALUE 'YG6',
      movtyp_yg8     TYPE bwart            VALUE 'YG8',
      cat_devol      TYPE vbtypl_n         VALUE 'H',
      chg_tabname    TYPE tabname          VALUE 'VBAP',
      chg_field      TYPE fieldname        VALUE 'ABGRU',
      bsark_carg     TYPE vbak-bsark       VALUE 'CARG',
      vbbp           TYPE tdobject         VALUE 'VBBP',
      z010           TYPE tdid             VALUE 'Z010',
      zpr1           TYPE kscha            VALUE 'ZPR1',
    END OF gc_const .
  constants:
    BEGIN OF gc_param,
      modulo     TYPE ze_param_modulo  VALUE 'SD',
      chv1_food  TYPE ze_param_chave   VALUE 'CONTRATOS FOOD',
      chv2_demc  TYPE ze_param_chave   VALUE 'DEVOLUÇÃOMACRO',
      chv2_mm    TYPE ze_param_chave   VALUE 'ENTRADA MM',
*      chv3_movtp TYPE ze_param_chave_3 VALUE 'MOVE_TYPE',
      chv3_mwskz TYPE ze_param_chave_3 VALUE 'MWSKZ',
    END OF gc_param .
  class-data GT_MENSAGENS type BAPIRET2_T .
  class-data GV_WAIT_ASYNC type ABAP_BOOL .
  constants GC_UPDT type UPDKZ_D value 'U' ##NO_TEXT.
  constants GC_DELT type UPDKZ_D value 'D' ##NO_TEXT.

  methods CHAMA_BAPIS
    importing
      !IV_ERDAT type VBAK-ERDAT
      !IV_WERKS type VBAP-WERKS
      !IV_AUART type VBAK-AUART
      !IV_VBELN type VBAK-VBELN
      !IV_VTWEG type VBAK-VTWEG
      !IV_ABGRU type VBAP-ABGRU
      !IV_FATURA type VBELN_NACH
      !IV_XBLNR type XBLNR_V
      !IV_VSBED type VSBED optional
      !IT_VBAP type TT_VBAPVB optional
      !IV_IHREZ type IHREZ optional
    exporting
      !EV_NEW_SALESDOC type VBELN_VA
    returning
      value(RT_RETURN) type BAPIRET2_T .
  methods SERNR_UPDATE
    importing
      !IS_KEY type ZSSD_KEY_UPDT_SERNR .
  methods REGISTRA_LOG
    returning
      value(RV_BALLOGHNDL) type BALLOGHNDL .
  methods GET_PARAM_SIMPL
    importing
      !IV_CHAVE1 type ZE_PARAM_CHAVE
      !IV_CHAVE2 type ZE_PARAM_CHAVE
      !IV_CHAVE3 type ZE_PARAM_CHAVE_3
    returning
      value(RV_VALOR) type ZE_PARAM_LOW .
  methods VALIDA_POSNR
    importing
      !IV_POSNR type POSNR_VA
    returning
      value(RV_MULTIPLICADOR) type I .
ENDCLASS.



CLASS ZCLSD_CMDLOC_DEVOL_MERCADORIA IMPLEMENTATION.


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

    DO 10 TIMES.

      CALL FUNCTION 'SD_SALES_DOCUMENT_ENQUEUE'
        EXPORTING
          vbeln              = iv_vbeln
          i_check_scenario_a = abap_true
        EXCEPTIONS
          foreign_lock       = 1
          system_failure     = 2
          no_change          = 3
          OTHERS             = 4.

      IF sy-subrc IS INITIAL.
        DATA(lv_desbloq) = abap_true.

        CALL FUNCTION 'DEQUEUE_EVVBAKE'
          EXPORTING
            mandt = sy-mandt
            vbeln = iv_vbeln.

        EXIT.
      ELSE.
        WAIT UP TO 1 SECONDS.
      ENDIF.
    ENDDO.

    IF lv_desbloq IS NOT INITIAL.

      CALL TRANSACTION 'VA02'
                 USING lt_bdcdata
                  MODE lv_mode
         MESSAGES INTO lt_bdcmsgcoll.

      WAIT UP TO 2 SECONDS.

      CALL TRANSACTION 'VA02'
                 USING lt_bdcdata
                  MODE lv_mode
         MESSAGES INTO lt_bdcmsgcoll.

    ENDIF.

  ENDMETHOD.


  METHOD chama_bapis.

    DATA: lt_return   TYPE STANDARD TABLE OF bapiret2,
          lt_auart    TYPE STANDARD TABLE OF vbak-auart,
          lt_item_in  TYPE STANDARD TABLE OF bapisditm,
          lt_item_inx TYPE STANDARD TABLE OF bapisditmx.

    DATA: ls_header_in  TYPE bapisdh1,
          ls_header_inx TYPE bapisdh1x.

    DATA: lv_salesdocument_ex TYPE vbeln_va.

    " Macro
    IF iv_vtweg = gc_const-vtweg_macro.
      DATA(lv_auart_new) = CONV auart( COND ze_param_chave( WHEN iv_auart = gc_const-auart_z023
                                                             THEN gc_const-auart_yd76
                                                            WHEN iv_auart = gc_const-auart_z024
                                                             THEN gc_const-auart_yd77 ) ).
    ELSE. " Micro
      IF iv_abgru = gc_const-mtv_rec_08.
        lv_auart_new = COND ze_param_chave( WHEN iv_auart = gc_const-auart_z023
                                              THEN gc_const-auart_yd75
                                            WHEN iv_auart = gc_const-auart_z024
                                              THEN gc_const-auart_yd74 ).

      ELSEIF iv_abgru = gc_const-mtv_rec_09.
        lv_auart_new = COND ze_param_chave( WHEN iv_auart = gc_const-auart_z023
                                              THEN gc_const-auart_yr75
                                            WHEN iv_auart = gc_const-auart_z024
                                              THEN gc_const-auart_yr74 ).
      ENDIF.
    ENDIF.

    " Iniciando cópia da ordem de venda &1.
    APPEND VALUE #( type       = gc_const-msg_sucess
                    id         = gc_const-msg_class
                    number     = gc_const-msg_11
                    message_v1 = iv_vbeln ) TO rt_return.

    CALL FUNCTION 'BAPI_SALESDOCUMENT_COPY'
      EXPORTING
        salesdocument    = iv_fatura
        documenttype     = lv_auart_new
      IMPORTING
        salesdocument_ex = lv_salesdocument_ex
      TABLES
        return           = lt_return.

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
      APPEND VALUE #( type       = <fs_return>-type
                      id         = <fs_return>-id
                      number     = <fs_return>-number
                      message_v1 = <fs_return>-message_v1
                      message_v2 = <fs_return>-message_v2
                      message_v3 = <fs_return>-message_v3
                      message_v4 = <fs_return>-message_v4 ) TO rt_return.

      IF <fs_return>-type = gc_const-msg_error.
        DATA(lv_error) = abap_true.
      ENDIF.

    ENDLOOP.

    IF lv_error = abap_false.

      ev_new_salesdoc = lv_salesdocument_ex.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

      " Documento &1 do tipo &2 criado com sucesso.
      APPEND VALUE #( type       = gc_const-msg_sucess
                      id         = gc_const-msg_class
                      number     = gc_const-msg_10
                      message_v1 = lv_salesdocument_ex
                      message_v2 = lv_auart_new ) TO rt_return.

      DO 5 TIMES.
        " Lógica necessária para confirmar os dados
        SELECT SINGLE vbeln
          FROM vbak
         WHERE vbeln = @lv_salesdocument_ex
          INTO @DATA(lv_vbeln).

        IF sy-subrc IS NOT INITIAL.
          WAIT UP TO 1 SECONDS.
          CONTINUE.
        ELSE.
          EXIT.
        ENDIF.
      ENDDO.

      DATA(lv_salesdoc) = lv_salesdocument_ex.

      ls_header_in-ord_reason = COND augru( WHEN lv_auart_new = gc_const-auart_yr74
                                              OR lv_auart_new = gc_const-auart_yr77
                                              OR lv_auart_new = gc_const-auart_yd74
                                              OR lv_auart_new = gc_const-auart_yd77
                                             THEN gc_const-ord_rea_r06

                                            WHEN lv_auart_new = gc_const-auart_yr75
                                              OR lv_auart_new = gc_const-auart_yr76
                                              OR lv_auart_new = gc_const-auart_yd75
                                              OR lv_auart_new = gc_const-auart_yd76
                                             THEN gc_const-ord_rea_r07 ).
      ls_header_in-ref_doc_l  = iv_xblnr.
      ls_header_in-ship_cond  = iv_vsbed.
      ls_header_in-po_method  = 'FLUI'.
      ls_header_in-purch_no_c = iv_ihrez.

      ls_header_inx-updateflag = 'U'.
      ls_header_inx-ord_reason = abap_true.
      ls_header_inx-po_method  = abap_true.
      ls_header_inx-ref_doc_l  = abap_true.
      ls_header_inx-ship_cond  = abap_true.
      ls_header_inx-purch_no_c = abap_true.

* LSCHEPP - 8000006370 - Deposito Divergente Entrada Macro - 04.04.2023 Início
      SELECT CAST( substring(  a~refkey, 1, 10 ) AS CHAR ) AS mblnr,
             CAST( substring(  a~refkey, 11, 4 ) AS NUMC ) AS mjahr
        FROM j_1bnflin AS a
        INNER JOIN j_1bnfdoc AS b ON a~docnum = b~docnum
        WHERE b~nfenum EQ @iv_xblnr
          AND a~reftyp EQ 'MD'
        INTO TABLE @DATA(lt_doc_mat).
      IF sy-subrc EQ 0.
        SELECT a~lgort, b~xabln
          FROM mseg AS a
          INNER JOIN mkpf AS b ON a~mblnr = b~mblnr
                              AND a~mjahr = b~mjahr
          INTO TABLE @DATA(lt_deposito)
          FOR ALL ENTRIES IN @lt_doc_mat
          WHERE a~mblnr EQ @lt_doc_mat-mblnr
            AND a~mjahr EQ @lt_doc_mat-mjahr.
        IF sy-subrc EQ 0.
          DELETE lt_deposito WHERE xabln NE iv_fatura.
          TRY.
              DATA(lv_lgort) = lt_deposito[ 1 ]-lgort.
            CATCH cx_sy_itab_line_not_found.
          ENDTRY.
        ENDIF.
      ENDIF.

      IF lv_lgort IS INITIAL.
        lv_lgort = '1037'.
      ENDIF.

      IF NOT it_vbap IS INITIAL.
        DATA(lt_vbap) = it_vbap.
      ELSE.
        SELECT *
          FROM vbap
          INTO TABLE @lt_vbap
          WHERE vbeln = @lv_salesdoc.
      ENDIF.

*      LOOP AT it_vbap ASSIGNING FIELD-SYMBOL(<fs_vbap>).
      LOOP AT lt_vbap ASSIGNING FIELD-SYMBOL(<fs_vbap>).
* LSCHEPP - 8000006370 - Deposito Divergente Entrada Macro - 04.04.2023 Fim
        lt_item_in = VALUE #( BASE lt_item_in ( itm_number = <fs_vbap>-posnr
                                                material   = <fs_vbap>-matnr
*                                                store_loc  = '1037' ) ).
                                                store_loc  = lv_lgort ) ).

        lt_item_inx = VALUE #( BASE lt_item_inx ( itm_number = <fs_vbap>-posnr
                                                  store_loc  = abap_true ) ).
      ENDLOOP.

      CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
        EXPORTING
          salesdocument    = lv_salesdoc
          order_header_in  = ls_header_in
          order_header_inx = ls_header_inx
        TABLES
          return           = lt_return
          order_item_in    = lt_item_in
          order_item_inx   = lt_item_inx.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

    ELSE.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

    ENDIF.

    DATA(lv_balloghndl) = registra_log( ).

  ENDMETHOD.


  METHOD devolucao.

    DATA: lt_return   TYPE bapiret2_t,
          lt_item_in  TYPE STANDARD TABLE OF bapisditm,
          lt_item_inx TYPE STANDARD TABLE OF bapisditmx.

    DATA: ls_order_header_inx TYPE bapisdh1x.

    DATA: lv_nw_salesdoc TYPE vbeln_va,
          lv_lines       TYPE i,
          lv_tabkey      TYPE cdtabkey,
          lv_xblnr       TYPE xblnr_v,
          lv_contrato    TYPE sales_contract,
          lv_item        TYPE sales_contract_item.

    DATA: lv_name  TYPE thead-tdname,
          lt_lines TYPE tline_tab.

    DATA: lt_conditions_in  TYPE STANDARD TABLE OF bapicond,
          lt_conditions_inx TYPE STANDARD TABLE OF bapicondx.

    DATA: ls_xvbak TYPE tds_xvbak.

    DATA: lv_multiplicador TYPE i,
          lv_posnr         TYPE posnr_va.

    IF is_vbak IS INITIAL.
      SELECT SINGLE *
      FROM vbak
      WHERE vbeln EQ @is_key-contrato
      INTO @ls_xvbak.
    ELSE.
      ls_xvbak = is_vbak.
    ENDIF.

    "contratos de carga podem ser importados com numeração de itens errados, então validamos a numeração do primeiro item 1 item.
    SELECT salescontractitem
      FROM i_salescontractitem
      WHERE salescontract = @is_key-contrato
      ORDER BY salescontractitem ASCENDING
      INTO @lv_posnr
      UP TO 1 ROWS.
    ENDSELECT.

    lv_multiplicador = me->valida_posnr( iv_posnr = lv_posnr ).

    IF it_vbap[] IS INITIAL.

      SELECT vbak~erdat,
             vbap~werks,
             vbak~auart,
             vbak~vbeln,
             vbak~vtweg,
             vbak~kunnr,
             vbak~vsbed,
             vbap~abgru
        FROM vbak
       INNER JOIN vbap ON vbap~vbeln = vbak~vbeln
                      AND vbap~abgru IS NOT INITIAL
       WHERE vbak~vbeln = @is_key-contrato
        INTO TABLE @DATA(lt_vbak).

      IF sy-subrc NE 0.
        " Nenhum registro encontrado para os parâmetros informados.
        MESSAGE s012(zsd_auto_cont_dis) DISPLAY LIKE gc_const-msg_error.
        RETURN.
      ENDIF.

      DATA(lt_vbak_aux) = lt_vbak[].

      SORT lt_vbak_aux BY erdat
                          werks
                          auart
                          vbeln
                          vtweg
                          kunnr
                          vsbed
                          abgru DESCENDING.

      DELETE ADJACENT DUPLICATES FROM lt_vbak_aux COMPARING erdat
                                                            werks
                                                            auart
                                                            vbeln
                                                            vtweg
                                                            kunnr
                                                            vsbed.

      lt_vbak[] = lt_vbak_aux[].

      DATA(lt_vbak_fae) = lt_vbak[].

      SORT lt_vbak_fae BY vbeln.
      DELETE ADJACENT DUPLICATES FROM lt_vbak_fae COMPARING vbeln.

      IF lt_vbak_fae[] IS NOT INITIAL.

        SELECT a~vbeln,
               a~posnr,
               a~matnr,
               a~pstyv,
               a~abgru,
               b~auart,
               b~kunnr
          FROM vbap AS a
         INNER JOIN vbak AS b ON b~vbeln = a~vbeln
           FOR ALL ENTRIES IN @lt_vbak_fae
         WHERE a~vbeln = @lt_vbak_fae-vbeln
          INTO TABLE @DATA(lt_itens).

        IF sy-subrc IS INITIAL.
          SORT lt_itens BY vbeln
                           posnr.
        ENDIF.
      ENDIF.

    ELSE.

      SELECT vbak~erdat,
             vbap~werks,
             vbak~auart,
             vbak~vbeln,
             vbak~vtweg,
             vbak~kunnr,
             vbak~vsbed,
             vbap~abgru
        FROM vbak
       INNER JOIN vbap ON vbap~vbeln = vbak~vbeln
         FOR ALL ENTRIES IN @it_vbap
       WHERE vbak~vbeln = @it_vbap-vbeln
        INTO TABLE @lt_vbak.

      IF sy-subrc NE 0.
        " Nenhum registro encontrado para os parâmetros informados.
        MESSAGE s012(zsd_auto_cont_dis) DISPLAY LIKE gc_const-msg_error.
        RETURN.
      ENDIF.

      lt_vbak_aux[] = lt_vbak[].

      SORT lt_vbak_aux BY erdat
                          werks
                          auart
                          vbeln
                          vtweg
                          kunnr
                          vsbed
                          abgru DESCENDING.

      DELETE ADJACENT DUPLICATES FROM lt_vbak_aux COMPARING erdat
                                                            werks
                                                            auart
                                                            vbeln
                                                            vtweg
                                                            kunnr
                                                            vsbed.
      lt_vbak[] = lt_vbak_aux[].

      DATA(lt_vbak_itm) = lt_vbak[].
      SORT lt_vbak_itm BY vbeln.
      DELETE ADJACENT DUPLICATES FROM lt_vbak_itm COMPARING vbeln.

      IF lt_vbak_itm[] IS NOT INITIAL.

        SELECT vbeln,
               posnr
          FROM vbap
           FOR ALL ENTRIES IN @lt_vbak_itm
         WHERE vbeln = @lt_vbak_itm-vbeln
          INTO TABLE @DATA(lt_vbap_excl).

        IF sy-subrc IS INITIAL.

          DATA(lt_vbap_aux) = it_vbap[].
          SORT lt_vbap_aux BY vbeln
                              posnr.

          LOOP AT lt_vbap_excl ASSIGNING FIELD-SYMBOL(<fs_vbap_excl>).

            READ TABLE lt_vbap_aux TRANSPORTING NO FIELDS
                                                 WITH KEY vbeln = <fs_vbap_excl>-vbeln
                                                          posnr = <fs_vbap_excl>-posnr
                                                          BINARY SEARCH.
            IF sy-subrc IS NOT INITIAL.
              lt_item_in = VALUE #( BASE lt_item_in ( itm_number = <fs_vbap_excl>-posnr * lv_multiplicador ) ).

              lt_item_inx = VALUE #( BASE lt_item_inx ( itm_number = <fs_vbap_excl>-posnr * lv_multiplicador
                                                        updateflag = gc_delt ) ).
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.

      SORT lt_vbak BY vbeln.

      LOOP AT it_vbap ASSIGNING FIELD-SYMBOL(<fs_vbap>).

        READ TABLE lt_vbak ASSIGNING FIELD-SYMBOL(<fs_vbak>)
                                             WITH KEY vbeln = <fs_vbap>-vbeln
                                             BINARY SEARCH.
        IF sy-subrc IS INITIAL.

          IF <fs_vbak>-abgru IS INITIAL.
            <fs_vbak>-abgru = <fs_vbap>-abgru.
          ENDIF.

          <fs_vbak>-vsbed = ls_xvbak-vsbed.

          lt_itens = VALUE #( BASE lt_itens ( vbeln = <fs_vbap>-vbeln
                                              posnr = <fs_vbap>-posnr
                                              matnr = <fs_vbap>-matnr
                                              pstyv = <fs_vbap>-pstyv
                                              abgru = <fs_vbap>-abgru
                                              auart = <fs_vbak>-auart
                                              kunnr = <fs_vbak>-kunnr ) ).

        ENDIF.
      ENDLOOP.
    ENDIF.

    IF lt_itens[] IS NOT INITIAL.

      " Busca itens já faturados
      SELECT vbelv,
             posnv,
             vbtyp_n
        FROM vbfa
       WHERE vbelv   = @is_key-contrato
         AND vbtyp_n = @gc_const-cat_devol
        INTO TABLE @DATA(lt_vbfa_devol).
      IF sy-subrc IS INITIAL.
        SORT lt_vbfa_devol BY vbelv
                              posnv.
      ENDIF.

      DATA(ls_vbak_ref) = VALUE #( lt_vbak[ 1 ] OPTIONAL ).

      IF ls_vbak_ref-vtweg = gc_const-vtweg_macro
     "AND ls_xvbak-bsark <> gc_const-bsark_carg
     AND ( ls_vbak_ref-auart = gc_const-auart_z023 OR
           ls_vbak_ref-auart = gc_const-auart_z024 ).

        LOOP AT lt_itens ASSIGNING FIELD-SYMBOL(<fs_itens>).
          IF <fs_itens>-abgru IS NOT INITIAL.
            READ TABLE lt_vbfa_devol ASSIGNING FIELD-SYMBOL(<fs_vbfa_devol>)
                                                   WITH KEY vbelv = <fs_itens>-vbeln
                                                            posnv = <fs_itens>-posnr
                                                            BINARY SEARCH.
            IF sy-subrc IS NOT INITIAL.
              lv_tabkey = sy-mandt && is_key-contrato && <fs_itens>-posnr.
              EXIT.
            ENDIF.
          ENDIF.
        ENDLOOP.

        IF lv_tabkey IS NOT INITIAL.

          lv_contrato = lv_tabkey+3(10).
          lv_item     = lv_tabkey+13.

          SELECT contrato,
                 contratoitem,
                 serie
            FROM zc_sd_locais_equip_app
           WHERE contrato     = @lv_contrato
             AND contratoitem = @lv_item
            INTO @DATA(ls_equip)
              UP TO 1 ROWS.
          ENDSELECT.

          IF sy-subrc IS INITIAL.

            SELECT a~objectclas,
                   a~objectid,
                   a~changenr,
                   b~udate
              FROM cdpos AS a
             INNER JOIN cdhdr AS b ON b~objectclas = a~objectclas
                                  AND b~objectid   = a~objectid
                                  AND b~changenr   = a~changenr
             WHERE a~objectid = @is_key-contrato
               AND a~tabname  = @gc_const-chg_tabname
               AND a~tabkey   = @lv_tabkey
               AND a~fname    = @gc_const-chg_field
              INTO TABLE @DATA(lt_cdpos).

            IF sy-subrc IS INITIAL.

              DATA(lt_cdpos_fae) = lt_cdpos[].
              SORT lt_cdpos_fae BY udate.
              DELETE ADJACENT DUPLICATES FROM lt_cdpos_fae COMPARING udate.

              SELECT mblnr,
                     mjahr,
                     bwart,
                     xblnr_mkpf,
                     cpudt_mkpf
                FROM mseg
                 FOR ALL ENTRIES IN @lt_cdpos_fae
               WHERE bwart IN ( @gc_const-movtyp_yg8, @gc_const-movtyp_yg6 )
                 AND cpudt_mkpf = @lt_cdpos_fae-udate
                INTO TABLE @DATA(lt_mseg).

              IF sy-subrc IS INITIAL.
                SORT lt_mseg BY mblnr
                                mjahr.

                DATA(lt_mseg_fae) = lt_mseg[].
                SORT lt_mseg_fae BY mblnr.
                DELETE ADJACENT DUPLICATES FROM lt_mseg_fae COMPARING mblnr.

                SELECT material,
                       serialnumber,
                       materialdocument
                  FROM i_serialnumbermaterialdocument
                   FOR ALL ENTRIES IN @lt_mseg_fae
                 WHERE materialdocument = @lt_mseg_fae-mblnr
                   AND serialnumber     = @ls_equip-serie
                  INTO TABLE @DATA(lt_matdocmnt).

                IF sy-subrc IS INITIAL.
                  SORT lt_matdocmnt BY serialnumber.

                  LOOP AT lt_matdocmnt ASSIGNING FIELD-SYMBOL(<fs_matdocmnt>).

                    READ TABLE lt_mseg ASSIGNING FIELD-SYMBOL(<fs_mseg_aux>)
                                                     WITH KEY mblnr = <fs_matdocmnt>-materialdocument
                                                     BINARY SEARCH.
                    IF sy-subrc IS INITIAL.
                      DATA(lv_refkey) = <fs_mseg_aux>-xblnr_mkpf.
                      EXIT.
                    ENDIF.
                  ENDLOOP.

                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

        IF lv_refkey IS NOT INITIAL.
          lv_xblnr = lv_refkey.
        ELSE.

          IF lv_tabkey IS NOT INITIAL.
            lv_contrato = lv_tabkey+3(10).
            lv_item     = lv_tabkey+13.

            SELECT SINGLE nfretorno
              FROM zi_sd_inf_distrato_app
              WHERE contrato = @lv_contrato
              AND contratoitem = @lv_item
              INTO @lv_xblnr.
          ELSE.
            SELECT nfretorno
              FROM zi_sd_inf_distrato_app
              WHERE contrato = @is_key-contrato
              ORDER BY contratoitem DESCENDING
              INTO @lv_xblnr
              UP TO 1 ROWS.
            ENDSELECT.
          ENDIF.

          "lv_xblnr = is_key-nfesaida.
        ENDIF.

      ENDIF.

      IF ls_xvbak-bsark = gc_const-bsark_carg. "Contratos via CARGA

        LOOP AT lt_itens ASSIGNING <fs_itens>.

          IF <fs_itens>-abgru IS NOT INITIAL.

            READ TABLE lt_vbfa_devol ASSIGNING <fs_vbfa_devol>
                                            WITH KEY vbelv = <fs_itens>-vbeln
                                                     posnv = <fs_itens>-posnr BINARY SEARCH.
            IF sy-subrc IS NOT INITIAL.

              CLEAR: lv_name.
              REFRESH lt_lines.

              lv_name = |{ <fs_itens>-vbeln }{ <fs_itens>-posnr }|.

              IF lv_name IS NOT INITIAL.

                CALL FUNCTION 'READ_TEXT'
                  EXPORTING
                    id                      = gc_const-z010
                    language                = sy-langu
                    name                    = lv_name
                    object                  = gc_const-vbbp
                  TABLES
                    lines                   = lt_lines
                  EXCEPTIONS
                    id                      = 1
                    language                = 2
                    name                    = 3
                    not_found               = 4
                    object                  = 5
                    reference_check         = 6
                    wrong_access_to_archive = 7
                    OTHERS                  = 8.

                IF sy-subrc IS INITIAL.
                  LOOP AT lt_lines ASSIGNING FIELD-SYMBOL(<fs_lines>).
                    DATA(lv_nfe) = <fs_lines>-tdline+26(8).
                    SPLIT <fs_lines>-tdline AT '/' INTO DATA(lv_chave) DATA(lv_valor).
                  ENDLOOP.

                  IF lv_valor IS NOT INITIAL.

                    CONDENSE lv_valor NO-GAPS.
                    REPLACE ALL OCCURRENCES OF ',' IN lv_valor WITH '.'.

                    "Alterar valor da condição
                    APPEND VALUE #( cond_type   = gc_const-zpr1
                                    cond_value  = lv_valor / 10
                                    itm_number  = <fs_itens>-posnr * lv_multiplicador ) TO lt_conditions_in.

                    APPEND VALUE #( cond_type  = gc_const-zpr1
                                    cond_value = 'X'
                                    itm_number = <fs_itens>-posnr * lv_multiplicador
                                    updateflag = 'I' ) TO lt_conditions_inx.

                  ENDIF.

                  IF lv_xblnr IS INITIAL AND
                    lv_nfe IS NOT INITIAL.
                    lv_xblnr = lv_nfe.
                  ENDIF.

                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.

      ENDIF.

      IF lv_xblnr IS INITIAL.
        lv_xblnr = is_key-nfesaida.
      ENDIF.

      DATA(lt_itens_fae) = lt_itens[].
      SORT lt_itens_fae BY vbeln
                           posnr.
      DELETE ADJACENT DUPLICATES FROM lt_itens_fae COMPARING vbeln
                                                             posnr.

      SELECT sdaufnr,
             posnr,
             sernr
        FROM ser02 AS a
       INNER JOIN objk AS b ON b~obknr = a~obknr
         FOR ALL ENTRIES IN @lt_itens
       WHERE sdaufnr = @lt_itens-vbeln
         AND posnr   = @lt_itens-posnr
        INTO TABLE @DATA(lt_objk).

      IF sy-subrc IS INITIAL.
        SORT lt_objk BY sdaufnr
                        posnr.
      ENDIF.

      DATA(ls_itens) = VALUE #( lt_itens[ 1 ] OPTIONAL ).

      IF ls_itens IS NOT INITIAL.
        SELECT SINGLE ihrez
          FROM vbkd
         WHERE vbeln = @ls_itens-vbeln
           AND posnr = @ls_itens-posnr
          INTO @DATA(lv_ihrez).
      ENDIF.

      IF lv_ihrez IS INITIAL.
        SELECT SINGLE ihrez
          FROM vbkd
         WHERE vbeln = @ls_itens-vbeln
           AND posnr IS INITIAL
          INTO @lv_ihrez.
      ENDIF.

    ENDIF.

    LOOP AT lt_vbak REFERENCE INTO DATA(ls_vbak).

      CLEAR lv_nw_salesdoc.

      lt_return = chama_bapis( EXPORTING iv_erdat        = ls_vbak->erdat
                                         iv_werks        = ls_vbak->werks
                                         iv_auart        = ls_vbak->auart
                                         iv_vbeln        = ls_vbak->vbeln
                                         iv_vtweg        = ls_vbak->vtweg
                                         iv_abgru        = ls_vbak->abgru
                                         "iv_fatura       = is_key-fatura
                                         iv_fatura       = COND #( WHEN ls_xvbak-bsark EQ gc_const-bsark_carg
                                                                       THEN is_key-contrato
                                                                       ELSE is_key-fatura )
                                         iv_xblnr        = lv_xblnr
                                         iv_vsbed        = ls_vbak->vsbed
                                         it_vbap         = it_vbap[]
                                         iv_ihrez        = lv_ihrez
                               IMPORTING ev_new_salesdoc = lv_nw_salesdoc ).

      APPEND LINES OF lt_return TO rt_mensagens.
      FREE lt_return[].

      IF lv_nw_salesdoc IS NOT INITIAL.
        CLEAR lv_lines.

        READ TABLE lt_itens TRANSPORTING NO FIELDS
                                          WITH KEY vbeln = ls_vbak->vbeln
                                          BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          LOOP AT lt_itens ASSIGNING <fs_itens> FROM sy-tabix.
            IF <fs_itens>-vbeln NE ls_vbak->vbeln.
              EXIT.
            ENDIF.

            IF <fs_itens>-abgru IS INITIAL.
              lt_item_in = VALUE #( BASE lt_item_in ( itm_number = <fs_itens>-posnr * lv_multiplicador ) ).

              lt_item_inx = VALUE #( BASE lt_item_inx ( itm_number = <fs_itens>-posnr * lv_multiplicador
                                                        updateflag = gc_delt ) ).
              CONTINUE.

            ELSE.

              READ TABLE lt_vbfa_devol ASSIGNING <fs_vbfa_devol>
                                        WITH KEY vbelv = <fs_itens>-vbeln
                                                 posnv = <fs_itens>-posnr
                                                 BINARY SEARCH.
              IF sy-subrc IS INITIAL.
                lt_item_in = VALUE #( BASE lt_item_in ( itm_number = <fs_itens>-posnr * lv_multiplicador ) ).

                lt_item_inx = VALUE #( BASE lt_item_inx ( itm_number = <fs_itens>-posnr * lv_multiplicador
                                                          updateflag = gc_delt ) ).
                CONTINUE.
              ENDIF.
            ENDIF.

            READ TABLE lt_objk ASSIGNING FIELD-SYMBOL(<fs_objk>)
                                             WITH KEY sdaufnr = <fs_itens>-vbeln
                                                      posnr   = <fs_itens>-posnr
                                                      BINARY SEARCH.

            IF sy-subrc IS INITIAL.
              sernr_update( is_key = VALUE #( document   = lv_nw_salesdoc
                                              itm_number = ( <fs_itens>-posnr * lv_multiplicador )
                                              sernr      = <fs_objk>-sernr
                                              matnr      = <fs_itens>-matnr
                                              partn_numb = <fs_itens>-kunnr
                                              auart      = <fs_itens>-auart
                                              pstyv      = <fs_itens>-pstyv
                                             ) ).
              ADD 1 TO lv_lines.
            ENDIF.
          ENDLOOP.

          IF lt_item_in[] IS NOT INITIAL OR
            ( lt_conditions_in IS NOT INITIAL AND lt_conditions_inx IS NOT INITIAL ).

            ls_order_header_inx-updateflag = gc_updt.

            DO 10 TIMES.
              CALL FUNCTION 'SD_SALES_DOCUMENT_ENQUEUE'
                EXPORTING
                  vbeln              = lv_nw_salesdoc
                  i_check_scenario_a = abap_true
                EXCEPTIONS
                  foreign_lock       = 1
                  system_failure     = 2
                  no_change          = 3
                  OTHERS             = 4.

              IF sy-subrc IS INITIAL.

                DATA(lv_desbloq) = abap_true.

                CALL FUNCTION 'DEQUEUE_EVVBAKE'
                  EXPORTING
                    mandt = sy-mandt
                    vbeln = lv_nw_salesdoc.

                EXIT.

              ELSE.
                WAIT UP TO '0.5' SECONDS.
              ENDIF.
            ENDDO.

            IF lv_desbloq IS NOT INITIAL.
              CLEAR lv_desbloq.

              CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
                EXPORTING
                  salesdocument    = lv_nw_salesdoc
                  order_header_inx = ls_order_header_inx
                TABLES
                  return           = lt_return
                  order_item_in    = lt_item_in
                  order_item_inx   = lt_item_inx
                  conditions_in    = lt_conditions_in
                  conditions_inx   = lt_conditions_inx.

              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                EXPORTING
                  wait = abap_true.
            ENDIF.

            FREE: lt_item_in[].
          ENDIF.

          call_shdb_sernr( EXPORTING iv_vbeln = lv_nw_salesdoc
                                     iv_lines = lv_lines ).

        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD funcao_devolucao.

    FREE: gv_wait_async,
          gt_mensagens[].

    CALL FUNCTION 'ZFMSD_CMDLOC_DEVOLUCAO_REMESSA'
      STARTING NEW TASK 'ZSD_COMODATO'
*      CALLING setup_messages ON END OF TASK
      EXPORTING
        is_key   = is_key
        iv_micro = iv_micro
        is_vbak  = is_vbak
        it_vbap  = it_vbap.

    rt_mensagens = VALUE #( BASE rt_mensagens ( id     = 'ZSD_COMODATO_LOC'
                                                number = '011'
                                                type   = 'S' ) ).

*    WAIT UNTIL gv_wait_async = abap_true.
*    rt_mensagens = gt_mensagens[].

  ENDMETHOD.


  METHOD funcao_movimento_mm.

    CLEAR gv_wait_async.

    CALL FUNCTION 'ZFMSD_CMDLOC_MOVIMT_MM'
      STARTING NEW TASK 'ZSD_MOVIMT_MM'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        is_vbak = is_vbak
        it_vbap = it_vbap[].

    WAIT UNTIL gv_wait_async = abap_true.

  ENDMETHOD.


  METHOD get_param_simpl.

    TRY.

        DATA(lo_object) = NEW zclca_tabela_parametros( ).

        lo_object->m_get_single( EXPORTING iv_modulo = gc_param-modulo
                                           iv_chave1 = iv_chave1
                                           iv_chave2 = iv_chave2
                                           iv_chave3 = iv_chave3
                                 IMPORTING ev_param  = rv_valor
                               ).
      CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros
    ENDTRY.

  ENDMETHOD.


  METHOD movimento_mm.

    DATA: lt_goodsmvt_item         TYPE STANDARD TABLE OF bapi2017_gm_item_create,
          lt_return                TYPE STANDARD TABLE OF bapiret2,
          lt_goodsmvt_serialnumber TYPE STANDARD TABLE OF bapi2017_gm_serialnumber.

    DATA: ls_goodsmvt_header TYPE bapi2017_gm_head_01.

    DATA: lv_goodsmvt_code TYPE bapi2017_gm_code,
          lv_matdoc        TYPE bapi2017_gm_head_ret-mat_doc,
          lv_docyear       TYPE bapi2017_gm_head_ret-doc_year,
          lv_mwskz         TYPE mwskz.

    DATA: lv_name  TYPE thead-tdname,
          lt_lines TYPE tline_tab.

    DATA: lv_entry_qnt       TYPE erfmg,
          lv_ext_base_amount TYPE bapi_j_1bexbase.

    CHECK is_vbak IS NOT INITIAL.

    SELECT SINGLE salescontract,
                  solicitacao,
                  tpoperacao,
                  docnumnfesaida,
                  docnumentrada,
                  docfatura,
                  centrodestino,
                  centroorigem
      FROM zi_sd_cockpit_app
     WHERE salescontract = @is_vbak-vbeln
      INTO @DATA(ls_cockpit).

    IF sy-subrc IS INITIAL.
      IF ls_cockpit-tpoperacao     EQ gc_const-tp_opera_macro
     AND ( ( ls_cockpit-docnumnfesaida IS NOT INITIAL AND ls_cockpit-docnumentrada  IS NOT INITIAL ) OR
         ( is_vbak-bsark EQ gc_const-bsark_carg ) ). "CARGA não vai ter doc de entrada/saída

        SELECT vbeln,
               posnr,
               abgru
          FROM vbap
         WHERE vbeln = @is_vbak-vbeln
          INTO TABLE @DATA(lt_recusds).

        IF sy-subrc IS INITIAL.

          SORT lt_recusds BY vbeln
                             posnr.

          DATA(lt_itens) = it_vbap[].
          FREE: lt_itens.

          " Verifica o que já foi recusado
          LOOP AT it_vbap ASSIGNING FIELD-SYMBOL(<fs_vbap>).

            IF <fs_vbap>-abgru IS INITIAL.
              CONTINUE.
            ENDIF.

            READ TABLE lt_recusds ASSIGNING FIELD-SYMBOL(<fs_recusds>)
                                                WITH KEY vbeln = <fs_vbap>-vbeln
                                                         posnr = <fs_vbap>-posnr
                                                         BINARY SEARCH.
            IF sy-subrc           IS INITIAL
           AND <fs_recusds>-abgru IS INITIAL.
              APPEND <fs_vbap> TO lt_itens.
            ENDIF.
          ENDLOOP.

          IF lt_itens[] IS NOT INITIAL.

            SELECT SINGLE docnum,
                          pstdat,
                          docdat,
                          nfenum,
                          series,
                          parid
              FROM j_1bnfdoc
             WHERE docnum = @ls_cockpit-docnumnfesaida
              INTO @DATA(ls_doc).

            IF sy-subrc IS INITIAL OR
              is_vbak-bsark EQ gc_const-bsark_carg.

              SELECT docnum,
                     itmnum,
                     menge,
                     netwr
                FROM j_1bnflin
               WHERE docnum = @ls_cockpit-docnumnfesaida
                INTO TABLE @DATA(lt_lin).

              IF sy-subrc IS INITIAL.
                SORT lt_lin BY itmnum.
              ENDIF.

              SELECT contrato,
                     contratoitem,
                     serie
                FROM zi_sd_locais_equip_app
                 FOR ALL ENTRIES IN @lt_itens
               WHERE contrato     = @lt_itens-vbeln
                 AND contratoitem = @lt_itens-posnr
                INTO TABLE @DATA(lt_serie).

              IF sy-subrc IS INITIAL.
                SORT lt_serie BY contrato
                                 contratoitem.
              ENDIF.

              SELECT SINGLE werks,
                            kunnr
                FROM t001w
               WHERE werks = @ls_cockpit-centroorigem
                INTO @DATA(ls_t001w).

              TRY.
                  DATA(lo_param) = NEW zclca_tabela_parametros( ).

                  lo_param->m_get_single( EXPORTING iv_modulo = gc_param-modulo
                                                    iv_chave1 = gc_param-chv1_food
                                                    iv_chave2 = gc_param-chv2_mm
                                                    iv_chave3 = gc_param-chv3_mwskz
                                          IMPORTING ev_param  = lv_mwskz ).
                CATCH zcxca_tabela_parametros.
              ENDTRY.

              IF is_vbak-bsark EQ gc_const-bsark_carg. "Contratos via CARGA

                READ TABLE lt_itens ASSIGNING FIELD-SYMBOL(<fs_item_carg>) INDEX 1.

                lv_name = |{ <fs_item_carg>-vbeln }{ <fs_item_carg>-posnr }|.

                CALL FUNCTION 'READ_TEXT'
                  EXPORTING
                    id                      = gc_const-z010
                    language                = sy-langu
                    name                    = lv_name
                    object                  = gc_const-vbbp
                  TABLES
                    lines                   = lt_lines
                  EXCEPTIONS
                    id                      = 1
                    language                = 2
                    name                    = 3
                    not_found               = 4
                    object                  = 5
                    reference_check         = 6
                    wrong_access_to_archive = 7
                    OTHERS                  = 8.


                IF sy-subrc IS INITIAL.
                  LOOP AT lt_lines ASSIGNING FIELD-SYMBOL(<fs_lines>).
                    DATA(lv_nfe) = <fs_lines>-tdline+26(8).
                    SPLIT <fs_lines>-tdline AT '/' INTO DATA(lv_chave) DATA(lv_valor).
*                    IF lv_nfe IS NOT INITIAL.
*                      EXIT.
*                    ENDIF.
                  ENDLOOP.

                  CONDENSE lv_valor NO-GAPS.
                  REPLACE ALL OCCURRENCES OF ',' IN lv_valor WITH '.'.

                ENDIF.

              ENDIF.

              ls_goodsmvt_header = VALUE #( "pstng_date    = ls_doc-pstdat
                                            pstng_date    = sy-datum
*                                            doc_date      = COND #( WHEN is_vbak-bsark EQ gc_const-bsark_carg
*                                                                       THEN sy-datum
*                                                                       ELSE ls_doc-docdat )
                                            doc_date      = sy-datum
                                            ref_doc_no    = COND #( WHEN is_vbak-bsark EQ gc_const-bsark_carg
                                                                       THEN lv_nfe
                                                                       ELSE ls_doc-nfenum && ls_doc-series )
                                            gr_gi_slip_no = ls_cockpit-docfatura ).

              lv_goodsmvt_code = gc_const-goods_mov.

              SELECT
                _ser02~sdaufnr AS vbeln,
                _ser02~posnr,
                _eqbs~b_werk,
                _eqbs~b_lager
              FROM ser02 AS _ser02
              JOIN objk AS _objk ON _ser02~obknr = _objk~obknr
              JOIN eqbs AS _eqbs ON _objk~equnr = _eqbs~equnr
              WHERE _ser02~sdaufnr = @is_vbak-vbeln
              INTO TABLE @DATA(lt_lgort).

              IF sy-subrc IS INITIAL.
                SORT lt_lgort BY vbeln posnr.
              ENDIF.

              LOOP AT lt_itens ASSIGNING FIELD-SYMBOL(<fs_itens>).
                CLEAR: lv_entry_qnt, lv_ext_base_amount.

                READ TABLE lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin>)
                                                WITH KEY itmnum = <fs_itens>-posnr
                                                BINARY SEARCH.

                IF sy-subrc IS INITIAL OR
                  is_vbak-bsark EQ gc_const-bsark_carg.

                  READ TABLE lt_lgort ASSIGNING FIELD-SYMBOL(<fs_lgort>)
                                                  WITH KEY vbeln = <fs_itens>-vbeln
                                                           posnr = <fs_itens>-posnr BINARY SEARCH.

                  IF is_vbak-bsark EQ gc_const-bsark_carg.
                    lv_entry_qnt = <fs_itens>-kwmeng.
                    "lv_ext_base_amount = <fs_itens>-netwr.
                    lv_ext_base_amount = lv_valor.
                  ELSE.
                    lv_entry_qnt = <fs_lin>-menge.
                    lv_ext_base_amount = <fs_lin>-netwr.
                  ENDIF.

                  lt_goodsmvt_item = VALUE #( BASE lt_goodsmvt_item ( material        = <fs_itens>-matnr
                                                                      plant           = <fs_lgort>-b_werk
                                                                      "plant           = ls_cockpit-centrodestino
                                                                      "stge_loc        = <fs_itens>-lgort
                                                                      stge_loc        = <fs_lgort>-b_lager
                                                                      move_type       = COND #( WHEN is_vbak-auart = gc_const-auart_z023
                                                                                                 THEN gc_const-movtyp_yg6
                                                                                                 ELSE gc_const-movtyp_yg8 )
                                                                      vendor          = ls_t001w-kunnr
                                                                      "entry_qnt       = <fs_lin>-menge
                                                                      entry_qnt       = lv_entry_qnt
                                                                      "ext_base_amount = <fs_lin>-netwr
                                                                      ext_base_amount = lv_ext_base_amount
                                                                      tax_code        = lv_mwskz
                                                                     ) ).
                ENDIF.
              ENDLOOP.

              LOOP AT lt_serie ASSIGNING FIELD-SYMBOL(<fs_serie>).
                lt_goodsmvt_serialnumber = VALUE #( BASE lt_goodsmvt_serialnumber ( matdoc_itm = sy-tabix
                                                                                    serialno   = <fs_serie>-serie ) ).
              ENDLOOP.

              CLEAR: lv_matdoc,
                     lv_docyear.


              "usado no programa: ZSDI_CHECK_DATE_DOC
              DATA: lv_check TYPE abap_bool VALUE abap_true.
              EXPORT lv_check FROM lv_check TO MEMORY ID 'ZMVT_CMM'.

              CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
                EXPORTING
                  goodsmvt_header       = ls_goodsmvt_header
                  goodsmvt_code         = lv_goodsmvt_code
                IMPORTING
                  materialdocument      = lv_matdoc
                  matdocumentyear       = lv_docyear
                TABLES
                  goodsmvt_item         = lt_goodsmvt_item
                  goodsmvt_serialnumber = lt_goodsmvt_serialnumber
                  return                = lt_return.

              IF lv_matdoc IS NOT INITIAL.
                CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                  EXPORTING
                    wait = abap_true.

                ev_mat_doc  = lv_matdoc.
                ev_doc_year = lv_docyear.
              ENDIF.

            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD registra_log.

    DATA: ls_log          TYPE bal_s_log,
          ls_log_handle   TYPE  balloghndl,
          lt_t_log_handle TYPE  bal_t_logh.

    ls_log-object    = gc_const-object.
    ls_log-subobject = gc_const-subobject.
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
        MESSAGE  ID <fs_msg_log>-msgid TYPE <fs_msg_log>-msgty NUMBER <fs_msg_log>-msgno
                                                                 WITH <fs_msg_log>-msgv1
                                                                      <fs_msg_log>-msgv2
                                                                      <fs_msg_log>-msgv3
                                                                      <fs_msg_log>-msgv4
                                                         DISPLAY LIKE <fs_msg_log>-msgty.
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

    rv_balloghndl = ls_log_handle.

  ENDMETHOD.


  METHOD sernr_update.

    DATA(lv_serie)   = is_key-sernr.
    DATA(lv_matnr)   = is_key-matnr.
    DATA(lv_doument) = is_key-document.
    DATA(lv_item)    = is_key-itm_number.
    DATA(lv_debitor) = is_key-partn_numb.
    DATA(lv_auart)   = is_key-auart.
    DATA(lv_postyp)  = is_key-pstyv.

    DO 10 TIMES.
      CALL FUNCTION 'SD_SALES_DOCUMENT_ENQUEUE'
        EXPORTING
          vbeln              = lv_doument
          i_check_scenario_a = abap_true
        EXCEPTIONS
          foreign_lock       = 1
          system_failure     = 2
          no_change          = 3
          OTHERS             = 4.

      IF sy-subrc IS INITIAL.
        DATA(lv_desbloq) = abap_true.

        CALL FUNCTION 'DEQUEUE_EVVBAKE'
          EXPORTING
            mandt = sy-mandt
            vbeln = lv_doument.

        EXIT.
      ELSE.
        WAIT UP TO 1 SECONDS.
      ENDIF.

    ENDDO.

    IF lv_desbloq IS NOT INITIAL.
      CLEAR lv_desbloq.

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
    ENDIF.

  ENDMETHOD.


  METHOD setup_messages.

    DATA: lv_matdoc  TYPE bapi2017_gm_head_ret-mat_doc,
          lv_docyear TYPE bapi2017_gm_head_ret-doc_year.

    CASE p_task.
      WHEN 'ZSD_COMODATO'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMSD_CMDLOC_DEVOLUCAO_REMESSA'
          IMPORTING
            et_return = gt_mensagens.

        gv_wait_async = abap_true.

      WHEN 'ZSD_MOVIMT_MM'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMSD_CMDLOC_MOVIMT_MM'
         IMPORTING
           ev_matdoc        = lv_matdoc
           ev_docyear       = lv_docyear.

        gv_wait_async = abap_true.

    ENDCASE.

  ENDMETHOD.


  METHOD chamada_exit.

    SELECT SINGLE salescontract,
                  solicitacao,
                  tpoperacao,
                  docfatura,
                  nfesaida
      FROM zi_sd_cockpit_app
     WHERE salescontract = @is_vbak-vbeln
      INTO @DATA(ls_cockpit).

    IF sy-subrc IS INITIAL.

      IF ls_cockpit-tpoperacao = gc_const-tp_opera_macro.
        funcao_movimento_mm( EXPORTING is_vbak = is_vbak
                                       it_vbap = it_vbap[]
                                       ).
      ELSE.

        SELECT vbeln,
               posnr,
               abgru
          FROM vbap
         WHERE vbeln = @is_vbak-vbeln
          INTO TABLE @DATA(lt_recusds).

        IF sy-subrc IS INITIAL.

          SORT lt_recusds BY vbeln
                             posnr.

          DATA(lt_itens) = it_vbap[].
          FREE: lt_itens.

          " Verifica o que já foi recusado
          LOOP AT it_vbap ASSIGNING FIELD-SYMBOL(<fs_vbap>).

            IF <fs_vbap>-abgru IS INITIAL.
              CONTINUE.
            ENDIF.

            READ TABLE lt_recusds ASSIGNING FIELD-SYMBOL(<fs_recusds>)
                                                WITH KEY vbeln = <fs_vbap>-vbeln
                                                         posnr = <fs_vbap>-posnr
                                                         BINARY SEARCH.
            IF sy-subrc           IS INITIAL
           AND <fs_recusds>-abgru IS INITIAL.
              APPEND <fs_vbap> TO lt_itens.
            ENDIF.
          ENDLOOP.
        ENDIF.

        IF lt_itens[] IS NOT INITIAL.
          funcao_devolucao( is_key = VALUE #( contrato = ls_cockpit-salescontract
                                              fatura   = ls_cockpit-docfatura
                                              nfesaida = ls_cockpit-nfesaida
                                              )
                            iv_micro = abap_true
                            is_vbak  = is_vbak
                            it_vbap  = lt_itens[]  ).
        ENDIF.

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD valida_posnr.
    IF iv_posnr MOD 10 = 0.
      "'O número é múltiplo de 10'.
      "rv_multiplica = abap_true.
      rv_multiplicador = 1.
    ELSE.
      "'O número não é múltiplo de 10'.
      "rv_multiplica = abap_false.
      rv_multiplicador = 10.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
