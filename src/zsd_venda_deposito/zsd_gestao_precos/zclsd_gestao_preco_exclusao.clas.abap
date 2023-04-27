CLASS zclsd_gestao_preco_exclusao DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      tt_return    TYPE TABLE OF bapiret2 .

    TYPES ty_item TYPE ztsd_preco_i .
    TYPES:
      ty_t_item         TYPE STANDARD TABLE OF ztsd_preco_i.

    "! Chama BAPI para atualização das datas das condições de preço
    "! @parameter iv_data_in  | Data Inicio Validade
    "! @parameter iv_data_fim | Data Fim Validade
    "! @parameter is_record   | Registro selecionado no app.
    "! @parameter et_return   | Mensagens de retorno
    METHODS exclusao
      IMPORTING
        !iv_data_in  TYPE dats
        !iv_data_fim TYPE dats
        !is_record   TYPE zi_sd_lista_de_preco
        !iv_op_type  TYPE char5
        !is_newitem  TYPE zi_sd_lista_de_preco
      EXPORTING
        !et_return   TYPE tt_return.

    METHODS atualizar_periodo
      IMPORTING
        !iv_data_in   TYPE dats
        !iv_data_fim  TYPE dats
        !is_record    TYPE zi_sd_lista_de_preco
        !iv_op_type   TYPE char5
        !it_scale     TYPE ty_t_item OPTIONAL
        !it_old_scale TYPE ty_t_item OPTIONAL
      EXPORTING
        !et_return    TYPE tt_return
      CHANGING
        !cs_newitem   TYPE zi_sd_lista_de_preco.

    METHODS atualizar_vigencia
      IMPORTING
        !iv_data_in   TYPE dats
        !iv_data_fim  TYPE dats
        !is_record    TYPE zi_sd_lista_de_preco
        !iv_op_type   TYPE char5
        !it_scale     TYPE ty_t_item OPTIONAL
        !it_old_scale TYPE ty_t_item OPTIONAL
      EXPORTING
        !et_return    TYPE tt_return
      CHANGING
        !cs_newitem   TYPE zi_sd_lista_de_preco.
  PROTECTED SECTION.
private section.

  types:
    ty_lt_bapicondit   TYPE STANDARD TABLE OF bapicondit WITH DEFAULT KEY .
  types:
    ty_lt_bapicondhd   TYPE STANDARD TABLE OF bapicondhd WITH DEFAULT KEY .
  types:
    ty_lt_bapicondct   TYPE STANDARD TABLE OF bapicondct WITH DEFAULT KEY .
  types:
    ty_lt_bapicondit_1 TYPE STANDARD TABLE OF bapicondit WITH DEFAULT KEY .
  types:
    ty_lt_bapicondhd_1 TYPE STANDARD TABLE OF bapicondhd WITH DEFAULT KEY .
  types:
    ty_lt_bapicondct_1 TYPE STANDARD TABLE OF bapicondct WITH DEFAULT KEY .
  types:
    ty_lt_ykonp        TYPE STANDARD TABLE OF konpdb WITH DEFAULT KEY .
  types:
    ty_lt_ykonh        TYPE STANDARD TABLE OF konhdb WITH DEFAULT KEY .
  types:
    ty_lt_xkonh        TYPE STANDARD TABLE OF konhdb WITH DEFAULT KEY .
  types:
    ty_lt_xkonp        TYPE STANDARD TABLE OF konpdb WITH DEFAULT KEY .
  types:
    ty_lt_ykondat      TYPE STANDARD TABLE OF vkondat WITH DEFAULT KEY .
  types:
    ty_lt_xkondat      TYPE STANDARD TABLE OF vkondat WITH DEFAULT KEY .
  types:
    ty_lt_ykonh_1      TYPE STANDARD TABLE OF konhdb WITH DEFAULT KEY .
  types:
    ty_lt_ykonp_1      TYPE STANDARD TABLE OF konpdb WITH DEFAULT KEY .
  types:
    ty_lt_bapicondct_2 TYPE STANDARD TABLE OF bapicondct WITH DEFAULT KEY .
  types:
    ty_lt_bapicondhd_2 TYPE STANDARD TABLE OF bapicondhd WITH DEFAULT KEY .
  types:
    ty_lt_bapicondit_2 TYPE STANDARD TABLE OF bapicondit WITH DEFAULT KEY .
  types:
    ty_lt_bapicondqs_2 TYPE STANDARD TABLE OF bapicondqs WITH DEFAULT KEY .

  constants GC_UPDATE type C value 'U' ##NO_TEXT.
  data GV_KNUMH type KNUMH .

  methods FILL_BAPI
    importing
      !IV_DATA_IN type DATS
      !IV_DATA_FIM type DATS
      !IS_RECORD type ZI_SD_LISTA_DE_PRECO
      !IV_OP_TYPE type CHAR5
      !IV_OPERATION type CHAR3
      !IT_ITEM_SCALE type TY_T_ITEM optional
    exporting
      !EV_003 type C
      !EV_004 type C
      !ET_BAPICONDCT type TY_LT_BAPICONDCT_2
      !ET_BAPICONDHD type TY_LT_BAPICONDHD_2
      !ET_BAPICONDIT type TY_LT_BAPICONDIT_2
      !ET_BAPICONDQS type TY_LT_BAPICONDQS_2 .
  methods BUSCA_CONDICOES
    importing
      !IS_RECORD type ZI_SD_LISTA_DE_PRECO
    exporting
      !ET_YKONH type TY_LT_YKONH_1
      !ET_YKONP type TY_LT_YKONP_1 .
  methods ALTERA_CONDICOES
    changing
      !CT_YKONP type ZCLSD_GESTAO_PRECO_EXCLUSAO=>TY_LT_YKONP
      !CT_YKONH type ZCLSD_GESTAO_PRECO_EXCLUSAO=>TY_LT_YKONH
      !CT_XKONH type TY_LT_XKONH
      !CT_XKONP type TY_LT_XKONP
      !CT_YKONDAT type TY_LT_YKONDAT
      !CT_XKONDAT type TY_LT_XKONDAT .
  methods ATUALIZA_MODIFICACOES
    importing
      !IS_RECORD type ZI_SD_LISTA_DE_PRECO
      !IV_VALID_FROM type SY-DATUM
    changing
      !CT_YKONP type TY_LT_YKONP
      !CT_YKONH type TY_LT_YKONH .
  methods ALTERA_DADOS_BAPI
    importing
      !IV_OPERATION type C
      !IV_DATA_IN type DATS
      !IV_DATA_FIM type DATS
      !IS_RECORD type ZI_SD_LISTA_DE_PRECO
    changing
      !CT_BAPICONDIT type TY_LT_BAPICONDIT_1
      !CT_BAPICONDHD type TY_LT_BAPICONDHD_1
      !CT_BAPICONDCT type TY_LT_BAPICONDCT_1 .
  methods CALL_BAPI
    exporting
      !ET_RETURN type ZCLSD_GESTAO_PRECO_EXCLUSAO=>TT_RETURN
    changing
      !CT_BAPICONDIT type TY_LT_BAPICONDIT
      !CT_BAPICONDHD type TY_LT_BAPICONDHD
      !CT_BAPICONDCT type TY_LT_BAPICONDCT
      !CT_BAPICONDQS type TY_LT_BAPICONDQS_2 .
  methods COMMIT_WORK
    importing
      !IT_RETURN type ZCLSD_GESTAO_PRECO_EXCLUSAO=>TT_RETURN .
  methods ADD_DATA_CONDITONS
    importing
      !IV_DATA_IN type DATS optional
      !IV_DATA_FIM type DATS optional
      !IS_RECORD type ZI_SD_LISTA_DE_PRECO
      !IV_OPERATION type CHAR3
    changing
      !CT_RETURN type ZCLSD_GESTAO_PRECO_EXCLUSAO=>TT_RETURN
      !CT_BAPICONDCT type ZCLSD_GESTAO_PRECO_EXCLUSAO=>TY_LT_BAPICONDCT
      !CT_BAPICONDHD type ZCLSD_GESTAO_PRECO_EXCLUSAO=>TY_LT_BAPICONDHD
      !CT_BAPICONDIT type ZCLSD_GESTAO_PRECO_EXCLUSAO=>TY_LT_BAPICONDIT .
  methods DATA_CALCULATION
    importing
      !IV_DATA type BEGDA
      !IV_SINAL type CHAR1
    returning
      value(RV_DATA) type BEGDA .
  methods MODIFY_DATA_TO_PERIOD
    importing
      !IV_DATA_IN type DATS
      !IV_DATA_FIM type DATS
      !IS_RECORD type ZI_SD_LISTA_DE_PRECO
      !IV_OP_TYPE type CHAR5
      !IV_004 type CHAR3
      !IT_ITEM_SCALE type TY_T_ITEM
    exporting
      !ET_RETURN type ZCLSD_GESTAO_PRECO_EXCLUSAO=>TT_RETURN .
  methods ADD_NEW_PERIOD
    importing
      !IV_DATA_IN type DATS
      !IV_DATA_FIM type DATS
      !IV_OP_TYPE type CHAR5
      !IS_NEWITEM type ZI_SD_LISTA_DE_PRECO
      !IV_004 type CHAR3
      !IT_ITEM_SCALE type TY_T_ITEM
    exporting
      !ET_RETURN type ZCLSD_GESTAO_PRECO_EXCLUSAO=>TT_RETURN .
  methods ADD_NEW_PERIOD_UNLIMITE
    importing
      !IS_NEWITEM type ZI_SD_LISTA_DE_PRECO
      !IV_OP_TYPE type CHAR5
      !IS_RECORD type ZI_SD_LISTA_DE_PRECO
      !IV_DATA_FIM type DATS
      !IV_DATA_IN type DATS
      !IV_004 type CHAR3
      !IT_ITEM_SCALE type TY_T_ITEM
    changing
      !CT_RETURN type ZCLSD_GESTAO_PRECO_EXCLUSAO=>TT_RETURN .
  methods GET_COND
    changing
      !CS_NEWITEM type KNUMH .
  methods UPDATE_LOG_BDCP2
    importing
      !IT_RETURN type ZCLSD_GESTAO_PRECO_EXCLUSAO=>TT_RETURN .
ENDCLASS.



CLASS ZCLSD_GESTAO_PRECO_EXCLUSAO IMPLEMENTATION.


  METHOD altera_condicoes.

    DATA lt_ykonm TYPE STANDARD TABLE OF vkonm.
    DATA lt_xkonm TYPE STANDARD TABLE OF vkonm.
    DATA lt_ykonw TYPE STANDARD TABLE OF vkonw.
    DATA lt_xkonw TYPE STANDARD TABLE OF vkonw.

    CALL FUNCTION 'SD_CONDITION_CHANGE_DOCS_WRITE'
      TABLES
        p_xkondat = ct_xkondat
        p_xkonh   = ct_xkonh
        p_xkonm   = lt_xkonm
        p_xkonp   = ct_xkonp
        p_xkonw   = lt_xkonw
        p_ykondat = ct_ykondat
        p_ykonh   = ct_ykonh
        p_ykonm   = lt_ykonm
        p_ykonp   = ct_ykonp
        p_ykonw   = lt_ykonw.


  ENDMETHOD.


  METHOD altera_dados_bapi.
    DATA lv_cond TYPE char10.

    READ TABLE ct_bapicondit ASSIGNING FIELD-SYMBOL(<fs_bapicondit>) INDEX 1.
    IF sy-subrc = 0.
      <fs_bapicondit>-operation = iv_operation.
      IF iv_data_in EQ iv_data_fim.
        <fs_bapicondit>-indidelete = ' '.
        get_cond( CHANGING cs_newitem = lv_cond ).
        <fs_bapicondit>-cond_no = lv_cond.
      ELSE.
        <fs_bapicondit>-indidelete = 'X'.
      ENDIF.
    ENDIF.

    READ TABLE ct_bapicondhd ASSIGNING FIELD-SYMBOL(<fs_bapicondhd>) INDEX 1.
    IF sy-subrc = 0.
      <fs_bapicondhd>-operation = iv_operation.

      IF NOT lv_cond IS INITIAL.
        <fs_bapicondhd>-cond_no = lv_cond.
      ENDIF.

      IF iv_data_in IS NOT INITIAL.
        <fs_bapicondhd>-valid_from = iv_data_in .
      ELSE.
        <fs_bapicondhd>-valid_from = is_record-datab.
      ENDIF.

      IF iv_data_fim IS NOT INITIAL.
        <fs_bapicondhd>-valid_to = iv_data_fim.
      ELSE.
        <fs_bapicondhd>-valid_to = is_record-datbi.
      ENDIF.
    ENDIF.

    READ TABLE ct_bapicondct ASSIGNING FIELD-SYMBOL(<fs_bapicondct>) INDEX 1.
    IF sy-subrc = 0.
      <fs_bapicondct>-operation = iv_operation.

      IF NOT lv_cond IS INITIAL.
        <fs_bapicondct>-cond_no = lv_cond.
      ENDIF.

      IF iv_data_in IS NOT INITIAL.
        <fs_bapicondct>-valid_from = iv_data_in .
      ELSE.
        <fs_bapicondct>-valid_from = is_record-datab.
      ENDIF.

      IF iv_data_fim IS NOT INITIAL.
        <fs_bapicondct>-valid_to = iv_data_fim.
      ELSE.
        <fs_bapicondct>-valid_to = is_record-datbi.
      ENDIF.
    ENDIF.


  ENDMETHOD.


  METHOD exclusao.

    CONSTANTS lc_003 TYPE char3 VALUE '003'.
    CONSTANTS lc_004 TYPE char3 VALUE '004'.
    CONSTANTS lc_009 TYPE char3 VALUE '009'.
    DATA lt_ykonh TYPE ty_lt_ykonh.
    DATA lt_ykonp TYPE ty_lt_ykonp.
    DATA lt_bapicondct TYPE ty_lt_bapicondct.
    DATA lt_bapicondhd TYPE ty_lt_bapicondhd.
    DATA lt_bapicondit TYPE ty_lt_bapicondit.
    DATA lt_bapicondqs TYPE ty_lt_bapicondqs_2.
    DATA ls_bapicondct TYPE bapicondct.
    DATA ls_bapicondhd TYPE bapicondhd.

* ---------------------------------------------------------------------------
* Exclui o registro existente
* ---------------------------------------------------------------------------
    fill_bapi( EXPORTING
               iv_data_in    = iv_data_in
               iv_data_fim   = iv_data_fim
               is_record     = is_record
               iv_op_type    = iv_op_type
               iv_operation  = lc_003
               IMPORTING
               et_bapicondct = lt_bapicondct
               et_bapicondhd = lt_bapicondhd
               et_bapicondit = lt_bapicondit
               et_bapicondqs = lt_bapicondqs ).

    call_bapi( IMPORTING
                 et_return = et_return
               CHANGING
                 ct_bapicondit = lt_bapicondit
                 ct_bapicondhd = lt_bapicondhd
                 ct_bapicondct = lt_bapicondct
                 ct_bapicondqs = lt_bapicondqs ).

    commit_work( et_return ).

* ---------------------------------------------------------------------------
* Modifica a "Data desde" do registro excluido com o D+1
* ---------------------------------------------------------------------------

    DATA(lv_data_in) = data_calculation( iv_data = iv_data_fim iv_sinal = '+' ).

    add_data_conditons( EXPORTING
                         iv_data_in    = lv_data_in
                         is_record     = is_record
                         iv_operation  = lc_009
                        CHANGING
                         ct_return     = et_return
                         ct_bapicondct = lt_bapicondct
                         ct_bapicondhd = lt_bapicondhd
                         ct_bapicondit = lt_bapicondit ).

* ---------------------------------------------------------------------------
* Inclui uma linha igual a existente e modifica o "Data até" do registro excluido com o D-1
* ---------------------------------------------------------------------------
    DATA(lv_data_fim) = data_calculation( iv_data = iv_data_in iv_sinal = '-' ).
    add_data_conditons( EXPORTING
                         iv_data_fim   = lv_data_fim
                         is_record     = is_record
                         iv_operation  = lc_004
                        CHANGING
                         ct_return = et_return
                         ct_bapicondct = lt_bapicondct
                         ct_bapicondhd = lt_bapicondhd
                         ct_bapicondit = lt_bapicondit ).


* ---------------------------------------------------------------------------
* Inclui uma linha igual a existente e modifica o "Data desde/até" , sendo datas iguais
* ---------------------------------------------------------------------------

    add_data_conditons( EXPORTING
                         iv_data_in    = iv_data_in
                         iv_data_fim   = iv_data_fim
                         is_record     = is_record
                         iv_operation  = lc_004
                        CHANGING
                         ct_return = et_return
                         ct_bapicondct = lt_bapicondct
                         ct_bapicondhd = lt_bapicondhd
                         ct_bapicondit = lt_bapicondit ).


    busca_condicoes( EXPORTING
                is_record = is_newitem
               IMPORTING
                et_ykonh = lt_ykonh
                et_ykonp = lt_ykonp ).

    atualiza_modificacoes( EXPORTING
                            is_record     = is_newitem
                            iv_valid_from = iv_data_in
                           CHANGING
                            ct_ykonp = lt_ykonp
                            ct_ykonh = lt_ykonh ).

    commit_work( et_return ).



  ENDMETHOD.


  METHOD add_data_conditons.

    CONSTANTS lc_004 TYPE char3 VALUE '004'.
    DATA lt_bapicondqs TYPE ty_lt_bapicondqs_2.

    altera_dados_bapi( EXPORTING
                            iv_operation = iv_operation
                            is_record   = is_record
                            iv_data_fim = iv_data_fim
                            iv_data_in  = iv_data_in
                           CHANGING
                            ct_bapicondit = ct_bapicondit
                            ct_bapicondhd = ct_bapicondhd
                            ct_bapicondct = ct_bapicondct ).

    call_bapi( IMPORTING
                 et_return = ct_return
               CHANGING
                 ct_bapicondit = ct_bapicondit
                 ct_bapicondhd = ct_bapicondhd
                 ct_bapicondct = ct_bapicondct
                 ct_bapicondqs = lt_bapicondqs ).



    commit_work( ct_return ).

  ENDMETHOD.


  METHOD fill_bapi.

    CONSTANTS: lc_c      TYPE c VALUE 'C',
               lc_brl(3) TYPE c VALUE 'BRL',
               lc_003(3) TYPE c VALUE '003', "Eliminar
               lc_004(3) TYPE c VALUE '004', "Modificar
               lc_1      TYPE c VALUE '1',
               lc_0      TYPE c VALUE '0',
               lc_01(2)  TYPE c VALUE '01',
               lc_un(2)  TYPE c VALUE 'UN'.

    DATA: lt_bapicondct  TYPE  TABLE OF bapicondct,
          lt_bapicondhd  TYPE  TABLE OF bapicondhd,
          lt_bapicondit  TYPE  TABLE OF bapicondit,
          lt_bapicondqs  TYPE  TABLE OF bapicondqs,
          lt_bapicondvs  TYPE  TABLE OF bapicondvs,
          lt_bapiknumhs  TYPE  TABLE OF bapiknumhs,
          lt_mem_initial TYPE  TABLE OF cnd_mem_initial,

          ls_bapicondct  TYPE bapicondct,
          ls_bapicondhd  TYPE bapicondhd,
          ls_bapicondit  TYPE bapicondit,
          ls_bapicondqs  TYPE bapicondqs,
          ls_bapicondvs  TYPE bapicondvs,
          ls_bapiknumhs  TYPE bapiknumhs,
          ls_mem_initial TYPE cnd_mem_initial.

    CLEAR ls_bapicondct.

    ls_bapicondct-cond_usage = iv_op_type+1(1).
    ls_bapicondct-applicatio = is_record-kappl.
    ls_bapicondct-cond_type  = is_record-kschl.
    ls_bapicondct-operation  = iv_operation.

    IF is_record-pltyp IS NOT INITIAL.
      ls_bapicondct-varkey     = |{ is_record-vtweg }{ is_record-pltyp }{ is_record-werks }{ is_record-matnr }|.
      ls_bapicondct-table_no   = iv_op_type+2(3).
    ELSE.
      ls_bapicondct-varkey     = |{ is_record-vtweg }{ is_record-werks }{ is_record-matnr }|.
      ls_bapicondct-table_no   = iv_op_type+2(3)..
    ENDIF.

    IF iv_operation NE lc_003.
      IF iv_data_in IS NOT INITIAL.
        ls_bapicondct-valid_from = iv_data_in .
      ELSE.
        ls_bapicondct-valid_from = is_record-datab.
      ENDIF.

      IF iv_data_fim IS NOT INITIAL.
        ls_bapicondct-valid_to   = iv_data_fim.
      ELSE.
        ls_bapicondct-valid_to = is_record-datbi.
      ENDIF.
    ELSE.
      ls_bapicondct-valid_from = is_record-datab.
      ls_bapicondct-valid_to   = is_record-datbi.
    ENDIF.

    ls_bapicondct-cond_no    = is_record-knumh.
    APPEND ls_bapicondct TO et_bapicondct.

    CLEAR ls_bapicondhd.

    ls_bapicondhd-operation  = iv_operation.
    ls_bapicondhd-cond_no    = is_record-knumh.
    ls_bapicondhd-created_by = sy-uname.
    ls_bapicondhd-creat_date = sy-datum.
    ls_bapicondhd-cond_usage = iv_op_type+1(1)..
    ls_bapicondhd-created_by  = sy-uname.
    ls_bapicondhd-creat_date  = sy-datum.
    ls_bapicondhd-applicatio = is_record-kappl.
    ls_bapicondhd-cond_type  = is_record-kschl.
    IF is_record-pltyp IS NOT INITIAL.
      ls_bapicondhd-varkey     =  |{ is_record-vtweg }{ is_record-pltyp }{ is_record-werks }{ is_record-matnr }| .
      ls_bapicondhd-table_no   = iv_op_type+2(3)..
    ELSE.
      ls_bapicondhd-varkey     =  |{ is_record-vtweg }{ is_record-werks }{ is_record-matnr }| .
      ls_bapicondhd-table_no   = iv_op_type+2(3)..
    ENDIF.

    ls_bapicondhd-valid_to = ls_bapicondct-valid_to .
    ls_bapicondhd-valid_from   = ls_bapicondct-valid_from .

    APPEND ls_bapicondhd TO et_bapicondhd.

    CLEAR ls_bapicondit.
    IF iv_operation EQ lc_003.
      ls_bapicondit-operation  = lc_003.
      ls_bapicondit-indidelete = 'X'.
    ENDIF.
    ls_bapicondit-operation  = iv_operation.
    ls_bapicondit-cond_no    = is_record-knumh.
    ls_bapicondit-cond_count = lc_01.
    ls_bapicondit-applicatio = is_record-kappl.
    ls_bapicondit-cond_type  = is_record-kschl.
    ls_bapicondit-scaletype  = iv_op_type+1(1)..
    ls_bapicondit-scalebasin = abap_false .
    ls_bapicondit-scale_qty  = lc_0.
    ls_bapicondit-calctypcon = lc_c.
    ls_bapicondit-cond_value = is_record-kbetr.
    ls_bapicondit-condcurr   = is_record-konwa.
    ls_bapicondit-cond_p_unt = 1.
    ls_bapicondit-cond_unit  = is_record-kmein.
    ls_bapicondit-lowerlimit = is_record-mxwrt.
    ls_bapicondit-upperlimit = is_record-gkwrt.
    IF lines( it_item_scale[] ) > 1.
      ls_bapicondit-scalebasin  = 'C'.
    ENDIF.
    APPEND ls_bapicondit TO et_bapicondit.

    DATA(lv_index) = 0.

    IF iv_operation NE lc_003.
      LOOP AT it_item_scale[] INTO DATA(ls_item_qs). "#EC CI_LOOP_INTO_WA #EC CI_STDSEQ #EC CI_NESTED
        CLEAR ls_bapicondqs.
        ls_bapicondqs-operation   = iv_operation.
        ls_bapicondqs-cond_no     = is_record-knumh.
        ls_bapicondqs-cond_count  = 1.
        ls_bapicondqs-line_no     = lv_index = lv_index + 1.
        ls_bapicondqs-scale_qty   = ls_item_qs-scale.
        ls_bapicondqs-cond_unit   = ls_item_qs-base_unit.
        ls_bapicondqs-currency    = ls_item_qs-sug_value.
        ls_bapicondqs-condcurr    = ls_item_qs-currency.
        APPEND ls_bapicondqs TO et_bapicondqs[].
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD atualiza_modificacoes.

    DATA lt_xkonh   TYPE TABLE OF konhdb.
    DATA lt_xkonp   TYPE TABLE OF konpdb.
    DATA lt_ykondat TYPE TABLE OF vkondat.
    DATA lt_xkondat TYPE TABLE OF vkondat.
    DATA lt_ykonm   TYPE TABLE OF vkonm.
    DATA lt_xkonm   TYPE TABLE OF vkonm.
    DATA lt_ykonw   TYPE TABLE OF vkonw.
    DATA lt_xkonw   TYPE TABLE OF vkonw.
    DATA ls_xkondat TYPE vkondat.
    DATA ls_ykondat TYPE vkondat.

    SELECT * FROM konh
    APPENDING CORRESPONDING FIELDS OF TABLE
    lt_xkonh WHERE knumh = is_record-knumh.
    SORT lt_xkonh BY knumh.
    LOOP AT  lt_xkonh ASSIGNING FIELD-SYMBOL(<fs_xkonh>).
      <fs_xkonh>-updkz = gc_update.
    ENDLOOP.

    SELECT * FROM konp
    APPENDING CORRESPONDING FIELDS OF TABLE
           lt_xkonp WHERE knumh = is_record-knumh.
    LOOP AT  lt_xkonp  ASSIGNING FIELD-SYMBOL(<fs_xkonp>).
      <fs_xkonp>-updkz = gc_update.
    ENDLOOP.

    IF lt_xkondat[] IS INITIAL.
      LOOP AT lt_xkonh ASSIGNING <fs_xkonh>.
        ls_xkondat-knumh = <fs_xkonh>-knumh.
        ls_xkondat-datan = iv_valid_from.
        READ TABLE ct_ykonh ASSIGNING FIELD-SYMBOL(<fs_ykonh>) WITH KEY knumh = <fs_xkonh>-knumh BINARY SEARCH.
        IF <fs_ykonh> IS ASSIGNED.
          ls_xkondat-datab = <fs_ykonh>-datab.
          ls_xkondat-datbi = <fs_ykonh>-datbi.
          ls_xkondat-kz    = <fs_ykonh>-updkz.
        ELSE.
          READ TABLE lt_xkonh ASSIGNING FIELD-SYMBOL(<fs_xkonh_aux>) WITH KEY knumh = <fs_xkonh>-knumh BINARY SEARCH.
          IF <fs_xkonh_aux> IS ASSIGNED.
            ls_xkondat-datab = <fs_xkonh>-datab.
            ls_xkondat-datbi = <fs_xkonh>-datbi.
            ls_xkondat-kz    = <fs_xkonh>-updkz.
          ENDIF.
        ENDIF.
        APPEND ls_xkondat TO lt_xkondat.
      ENDLOOP.
    ENDIF.

    IF lt_ykondat[] IS INITIAL.
      LOOP AT ct_ykonh ASSIGNING <fs_ykonh>.
        ls_ykondat-knumh = <fs_ykonh>-knumh.
        ls_ykondat-datan = <fs_ykonh>-datab.
        ls_ykondat-datab = <fs_ykonh>-datab.
        ls_ykondat-datbi = <fs_ykonh>-datbi.
        ls_ykondat-kz    = <fs_ykonh>-updkz.
        APPEND ls_ykondat TO lt_ykondat.
      ENDLOOP.
    ENDIF.

    altera_condicoes( CHANGING
                         ct_ykonp = ct_ykonp
                         ct_ykonh = ct_ykonh
                         ct_xkonh = lt_xkonh
                         ct_xkonp = lt_xkonp
                         ct_ykondat = lt_ykondat
                         ct_xkondat = lt_xkondat ).
  ENDMETHOD.


  METHOD busca_condicoes.

    DATA lt_ykonh   TYPE TABLE OF konhdb.
    DATA lt_ykonp   TYPE TABLE OF konpdb.

    SELECT * FROM konh
    APPENDING CORRESPONDING FIELDS OF TABLE et_ykonh
    WHERE knumh EQ is_record-knumh.
    SORT et_ykonh BY knumh.
    LOOP AT et_ykonh ASSIGNING FIELD-SYMBOL(<fs_ykonh>).
      <fs_ykonh>-updkz = gc_update.
    ENDLOOP.

    SELECT * FROM konp APPENDING CORRESPONDING FIELDS OF TABLE
           et_ykonp WHERE knumh = is_record-knumh.
    LOOP AT et_ykonp ASSIGNING FIELD-SYMBOL(<fs_ykonp>).
      <fs_ykonp>-updkz = gc_update.
    ENDLOOP.

  ENDMETHOD.


  METHOD call_bapi.

    DATA lt_mem_initial TYPE STANDARD TABLE OF cnd_mem_initial.
    DATA lt_bapiknumhs TYPE STANDARD TABLE OF bapiknumhs.
    DATA lt_bapicondvs TYPE STANDARD TABLE OF bapicondvs.

    FREE et_return.
    CALL FUNCTION 'BAPI_PRICES_CONDITIONS'
      TABLES
        ti_bapicondct  = ct_bapicondct
        ti_bapicondhd  = ct_bapicondhd
        ti_bapicondit  = ct_bapicondit
        ti_bapicondqs  = ct_bapicondqs
        ti_bapicondvs  = lt_bapicondvs
        to_bapiret2    = et_return
        to_bapiknumhs  = lt_bapiknumhs
        to_mem_initial = lt_mem_initial
      EXCEPTIONS
        update_error   = 1
        OTHERS         = 2.


    IF sy-subrc IS NOT INITIAL.

      et_return = VALUE #( BASE et_return ( id         = sy-msgid
                                            type       = sy-msgty
                                            number     = sy-msgno
                                            message_v1 = sy-msgv1
                                            message_v2 = sy-msgv2
                                            message_v3 = sy-msgv3
                                            message_v4 = sy-msgv4 ) ).
    ENDIF.


  ENDMETHOD.


  METHOD commit_work.

    DATA lt_nriv TYPE nriv_tt.

    IF line_exists( it_return[ type = 'E' ] ).
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

      APPEND VALUE #(
        client    = sy-mandt
        object    = 'KONH'
        nrrangenr = '01'
        nrlevel   = gv_knumh ) TO lt_nriv.

      "Atualiza o Range de Numeração
      CALL FUNCTION 'CNV_RN_ADJUST_NRIV'
        TABLES
          it_nriv          = lt_nriv
        EXCEPTIONS
          no_authorization = 1
          OTHERS           = 2.
      IF sy-subrc <> 0.
        CLEAR lt_nriv.
      ENDIF.

      CALL FUNCTION 'DEQUEUE_E_KONH_KKS'
        EXPORTING
          mode_konh_kks = 'E'
          knumh         = gv_knumh.

      update_log_bdcp2( it_return ).

    ENDIF.

  ENDMETHOD.


  METHOD update_log_bdcp2.

    CONSTANTS: lc_tabname TYPE bdi_chptr-tabname VALUE 'KONPAE',
               lc_fldname TYPE bdi_chptr-fldname VALUE 'KBETR',
               lc_cdchgid TYPE bdi_chptr-cdchgid VALUE 'U',
               lc_cond_a  TYPE edidc-mestyp      VALUE 'COND_A'.

    DATA  lt_cp_data TYPE TABLE OF bdi_chptr.

    TRY.

        DATA(lv_knumh) = CONV knumh( it_return[ type   = 'S' id = 'CND_EXCHANGE' ]-message_v1 ). "#EC CI_STDSEQ

        APPEND VALUE #( tabname = lc_tabname
                        fldname = lc_fldname
                        cdobjcl = lc_cond_a
                        cdobjid = lv_knumh
                        cdchgid = lc_cdchgid    ) TO lt_cp_data.

        CALL FUNCTION 'CHANGE_POINTERS_CREATE_DIRECT'
          EXPORTING
            message_type          = lc_cond_a
          TABLES
            t_cp_data             = lt_cp_data
          EXCEPTIONS
            number_range_problems = 1
            OTHERS                = 2.

        IF sy-subrc <> 0.
          CLEAR lt_cp_data.
        ENDIF.

      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD data_calculation.

    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = iv_data
        days      = 01
        months    = 00
        signum    = iv_sinal
        years     = 00
      IMPORTING
        calc_date = rv_data.

  ENDMETHOD.


  METHOD atualizar_vigencia.

    CONSTANTS lc_004 TYPE char3 VALUE '004'.
    DATA lt_ykonh TYPE ty_lt_ykonh.
    DATA lt_ykonp TYPE ty_lt_ykonp.
    DATA lt_bapicondct TYPE ty_lt_bapicondct.
    DATA lt_bapicondhd TYPE ty_lt_bapicondhd.
    DATA lt_bapicondit TYPE ty_lt_bapicondit.
    DATA lt_bapicondqs TYPE ty_lt_bapicondqs_2.

* ---------------------------------------------------------------------------
* Modifica a "Data até" do registro excluido com o D-1
* ---------------------------------------------------------------------------

    DATA(lv_data_fim) = data_calculation( iv_data = cs_newitem-datab iv_sinal = '-' ).

    fill_bapi( EXPORTING
               iv_data_in    = is_record-datab
               iv_data_fim   = lv_data_fim
               is_record     = is_record
               iv_op_type    = iv_op_type
               iv_operation  = lc_004
               it_item_scale = it_old_scale
               IMPORTING
               et_bapicondct = lt_bapicondct
               et_bapicondhd = lt_bapicondhd
               et_bapicondit = lt_bapicondit
               et_bapicondqs = lt_bapicondqs ).

    call_bapi( IMPORTING
                 et_return = et_return
               CHANGING
                 ct_bapicondit = lt_bapicondit
                 ct_bapicondhd = lt_bapicondhd
                 ct_bapicondct = lt_bapicondct
                 ct_bapicondqs = lt_bapicondqs ).

    commit_work( et_return ).


* ---------------------------------------------------------------------------
* Inclui nova linha com as datas do arquivo
* ---------------------------------------------------------------------------
    CLEAR: lt_bapicondct[],
           lt_bapicondhd[],
           lt_bapicondit[],
           lt_bapicondqs[].

    get_cond( CHANGING cs_newitem = cs_newitem-knumh ).

    fill_bapi( EXPORTING
              iv_data_in    = iv_data_in
              iv_data_fim   = iv_data_fim
              is_record     = cs_newitem
              iv_op_type    = iv_op_type
              iv_operation  = lc_004
              it_item_scale = it_scale
              IMPORTING
               et_bapicondct = lt_bapicondct
               et_bapicondhd = lt_bapicondhd
               et_bapicondit = lt_bapicondit
               et_bapicondqs = lt_bapicondqs ).

    call_bapi( IMPORTING
             et_return = et_return
           CHANGING
                 ct_bapicondit = lt_bapicondit
                 ct_bapicondhd = lt_bapicondhd
                 ct_bapicondct = lt_bapicondct
                 ct_bapicondqs = lt_bapicondqs ).

    busca_condicoes( EXPORTING
                is_record = cs_newitem
               IMPORTING
                et_ykonh = lt_ykonh
                et_ykonp = lt_ykonp ).

    atualiza_modificacoes( EXPORTING
                            is_record     = cs_newitem
                            iv_valid_from = iv_data_in
                           CHANGING
                            ct_ykonp = lt_ykonp
                            ct_ykonh = lt_ykonh ).

    commit_work( et_return ).



  ENDMETHOD.


  METHOD get_cond.

    CLEAR gv_knumh.

*    SELECT SINGLE knumh
*      FROM zi_sd_ckpt_gestao_preco_knumh
*            INTO @DATA(lv_knumh).
*
*    cs_newitem = lv_knumh + '1'.
*    cs_newitem = |{ cs_newitem ALPHA = IN  }|.

* ---------------------------------------------------------------------------
* Recuperar novo número da condição
* ---------------------------------------------------------------------------
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'
        object                  = 'KONH'
        ignore_buffer           = 'X'
      IMPORTING
        number                  = gv_knumh
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.

    IF sy-subrc = 0.

      CALL FUNCTION 'ENQUEUE_E_KONH_KKS'
        EXPORTING
          mode_konh_kks  = 'E'
          knumh          = gv_knumh
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.

      IF sy-subrc <> 0.
        get_cond( CHANGING cs_newitem = cs_newitem ).
      ENDIF.

      cs_newitem = gv_knumh.
      cs_newitem = |{ cs_newitem ALPHA = IN  }|.

    ENDIF.

  ENDMETHOD.


  METHOD atualizar_periodo.

    CONSTANTS lc_004 TYPE char3 VALUE '004'.


* ---------------------------------------------------------------------------
* Atualiza a data de vencimento do registro existente
* ---------------------------------------------------------------------------

    modify_data_to_period( EXPORTING
                        iv_data_in    = iv_data_in
                        iv_data_fim   = iv_data_fim
                        is_record     = is_record
                        iv_op_type    = iv_op_type
                        iv_004        = lc_004
                        it_item_scale = it_old_scale
                       IMPORTING
                        et_return   = et_return ).

* ---------------------------------------------------------------------------
* Inclui o novo período com o preço de válidade limitado
* ---------------------------------------------------------------------------

    get_cond( CHANGING cs_newitem = cs_newitem-knumh ).

    add_new_period( EXPORTING
                     iv_data_in    = iv_data_in
                     iv_data_fim   = iv_data_fim
                     iv_op_type    = iv_op_type
                     is_newitem    = cs_newitem
                     iv_004        = lc_004
                     it_item_scale = it_scale
                    IMPORTING
                     et_return     = et_return ).

* ---------------------------------------------------------------------------
* Inclui o período com o preço de validade 31.12.9999
* ---------------------------------------------------------------------------
    add_new_period_unlimite( EXPORTING
                              is_newitem    = cs_newitem
                              iv_op_type    = iv_op_type
                              is_record     = is_record
                              iv_data_fim   = iv_data_fim
                              iv_data_in    = iv_data_in
                              iv_004        = lc_004
                              it_item_scale = it_old_scale
                             CHANGING
                              ct_return     = et_return ).


  ENDMETHOD.


  METHOD add_new_period_unlimite.

    DATA lt_ykonh TYPE zclsd_gestao_preco_exclusao=>ty_lt_ykonh.
    DATA lt_ykonp TYPE zclsd_gestao_preco_exclusao=>ty_lt_ykonp.

    DATA lt_bapicondct TYPE ty_lt_bapicondct.
    DATA lt_bapicondhd TYPE ty_lt_bapicondhd.
    DATA lt_bapicondit TYPE ty_lt_bapicondit.
    DATA lt_bapicondqs TYPE ty_lt_bapicondqs_2.

    DATA(lv_data_in) = data_calculation( iv_data = iv_data_fim iv_sinal = '+' ).

*    DATA(ls_new)  = is_record.
*    ls_new-knumh  = is_newitem-knumh + '1'.
*    ls_new-knumh  = |{ ls_new-knumh ALPHA = IN  }|.

    fill_bapi( EXPORTING
               iv_data_in   = lv_data_in
               iv_data_fim  = is_record-datbi
               is_record    = is_record
               iv_op_type   = iv_op_type
               iv_operation = iv_004
               it_item_scale = it_item_scale
               IMPORTING
               et_bapicondct = lt_bapicondct
               et_bapicondhd = lt_bapicondhd
               et_bapicondit = lt_bapicondit
               et_bapicondqs = lt_bapicondqs ).


    call_bapi( IMPORTING
                 et_return = ct_return
               CHANGING
                 ct_bapicondit = lt_bapicondit
                 ct_bapicondhd = lt_bapicondhd
                 ct_bapicondct = lt_bapicondct
                 ct_bapicondqs = lt_bapicondqs ).

    busca_condicoes( EXPORTING
                     is_record = is_record
                    IMPORTING
                     et_ykonh = lt_ykonh
                     et_ykonp = lt_ykonp ).

    atualiza_modificacoes( EXPORTING
                            is_record     = is_record
                            iv_valid_from = iv_data_in
                           CHANGING
                            ct_ykonp = lt_ykonp
                            ct_ykonh = lt_ykonh ).


    commit_work( ct_return ).


  ENDMETHOD.


  METHOD add_new_period.

    DATA lt_bapicondct TYPE ty_lt_bapicondct.
    DATA lt_bapicondhd TYPE ty_lt_bapicondhd.
    DATA lt_bapicondit TYPE ty_lt_bapicondit.
    DATA lt_bapicondqs TYPE ty_lt_bapicondqs_2.

    DATA lt_ykonh TYPE zclsd_gestao_preco_exclusao=>ty_lt_ykonh.
    DATA lt_ykonp TYPE zclsd_gestao_preco_exclusao=>ty_lt_ykonp.

    fill_bapi( EXPORTING
               iv_data_in    = iv_data_in
               iv_data_fim   = iv_data_fim
               is_record     = is_newitem
               iv_op_type    = iv_op_type
               iv_operation  = iv_004
               it_item_scale = it_item_scale
               IMPORTING
               et_bapicondct = lt_bapicondct
               et_bapicondhd = lt_bapicondhd
               et_bapicondit = lt_bapicondit
               et_bapicondqs = lt_bapicondqs ).

    call_bapi( IMPORTING
                et_return = et_return
              CHANGING
                ct_bapicondit = lt_bapicondit
                ct_bapicondhd = lt_bapicondhd
                ct_bapicondct = lt_bapicondct
                ct_bapicondqs = lt_bapicondqs ).


    busca_condicoes( EXPORTING
                is_record = is_newitem
               IMPORTING
                et_ykonh = lt_ykonh
                et_ykonp = lt_ykonp ).

    atualiza_modificacoes( EXPORTING
                            is_record     = is_newitem
                            iv_valid_from = iv_data_in
                           CHANGING
                            ct_ykonp = lt_ykonp
                            ct_ykonh = lt_ykonh ).

    commit_work( et_return ).

  ENDMETHOD.


  METHOD modify_data_to_period.

    DATA lt_bapicondct TYPE ty_lt_bapicondct.
    DATA lt_bapicondhd TYPE ty_lt_bapicondhd.
    DATA lt_bapicondit TYPE ty_lt_bapicondit.
    DATA lt_bapicondqs TYPE ty_lt_bapicondqs_2.



    DATA(lv_data_fim) = data_calculation( iv_data = iv_data_in iv_sinal = '-' ).

    fill_bapi( EXPORTING
               iv_data_in   = is_record-datab
               iv_data_fim  = lv_data_fim
               is_record    = is_record
               iv_op_type   = iv_op_type
               iv_operation = '005'
               it_item_scale = it_item_scale
               IMPORTING
               et_bapicondct = lt_bapicondct
               et_bapicondhd = lt_bapicondhd
               et_bapicondit = lt_bapicondit
               et_bapicondqs = lt_bapicondqs ).

    call_bapi( IMPORTING
                 et_return = et_return
               CHANGING
                 ct_bapicondit = lt_bapicondit
                 ct_bapicondhd = lt_bapicondhd
                 ct_bapicondct = lt_bapicondct
                 ct_bapicondqs = lt_bapicondqs ).

    commit_work( et_return ).

  ENDMETHOD.
ENDCLASS.
