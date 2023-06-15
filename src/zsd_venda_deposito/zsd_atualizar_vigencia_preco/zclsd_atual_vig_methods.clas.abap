CLASS zclsd_atual_vig_methods DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
     "! Estrutura Mensagens de retorno
      tt_return    TYPE TABLE OF bapiret2 .

    "! Chama BAPI para atualização das datas das condições de preço
    "! @parameter iv_data_in  | Data Inicio Validade
    "! @parameter iv_data_fim | Data Fim Validade
    "! @parameter is_record   | Registro selecionado no app.
    "! @parameter et_return   | Mensagens de retorno
    METHODS atualizar
      IMPORTING
        !iv_data_in  TYPE dats
        !iv_data_fim TYPE dats
        !is_record   TYPE zssd_atual_vig
      EXPORTING
        !et_return   TYPE tt_return .
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS:
    "! Constante para marcar como update
               gc_update  TYPE c VALUE 'U'.

    TYPES:
     "! Estrutura KONP da BAPI
      ty_lt_bapicondit   TYPE STANDARD TABLE OF bapicondit WITH DEFAULT KEY.
    TYPES:
     "! Estrutura KONH da BAPI
      ty_lt_bapicondhd   TYPE STANDARD TABLE OF bapicondhd WITH DEFAULT KEY.
    TYPES:
     "! Estrutura BAPI p/tabelas de condições (corresp. a COND_RECS)
      ty_lt_bapicondct   TYPE STANDARD TABLE OF bapicondct WITH DEFAULT KEY.
    TYPES:
     "! Estrutura KONP da BAPI
      ty_lt_bapicondit_1 TYPE STANDARD TABLE OF bapicondit WITH DEFAULT KEY.
    TYPES:
     "! Estrutura KONH da BAPI
      ty_lt_bapicondhd_1 TYPE STANDARD TABLE OF bapicondhd WITH DEFAULT KEY.
    TYPES:
     "! Estrutura BAPI p/tabelas de condições (corresp. a COND_RECS)
      ty_lt_bapicondct_1 TYPE STANDARD TABLE OF bapicondct WITH DEFAULT KEY.
    TYPES:
     "! KONP : Estrutura para a atualização
      ty_lt_ykonp        TYPE STANDARD TABLE OF konpdb WITH DEFAULT KEY.
    TYPES:
     "! KONH : Estrutura para a atualização
      ty_lt_ykonh        TYPE STANDARD TABLE OF konhdb WITH DEFAULT KEY.
    TYPES:
     "! KONH : Estrutura para a atualização
      ty_lt_xkonh        TYPE STANDARD TABLE OF konhdb WITH DEFAULT KEY.
    TYPES:
     "! KONP : Estrutura para a atualização
      ty_lt_xkonp        TYPE STANDARD TABLE OF konpdb WITH DEFAULT KEY.
    TYPES:
     "! KONDAT : Estrutura para a atualização
      ty_lt_ykondat      TYPE STANDARD TABLE OF vkondat WITH DEFAULT KEY.
    TYPES:
     "! KONDAT : Estrutura para a atualização
      ty_lt_xkondat      TYPE STANDARD TABLE OF vkondat WITH DEFAULT KEY.
    TYPES:
     "! KONH : Estrutura para a atualização
      ty_lt_ykonh_1      TYPE STANDARD TABLE OF konhdb WITH DEFAULT KEY.
    TYPES:
     "! KONP : Estrutura para a atualização
      ty_lt_ykonp_1      TYPE STANDARD TABLE OF konpdb WITH DEFAULT KEY.

    "! Método para buscar condições de preço
    "! @parameter is_record | Dados App Atualizar Vigência Preço
    "! @parameter et_ykonh  | KONH : Estrutura para a atualização Condições (cabeçalho)
    "! @parameter et_ykonp  | KONP : Estrutura para a atualização Condições (item)
    METHODS busca_condicoes
      IMPORTING
        is_record TYPE zssd_atual_vig
      EXPORTING
        et_ykonh  TYPE ty_lt_ykonh_1
        et_ykonp  TYPE ty_lt_ykonp_1.

    "! Método para alterar condições de preço
    "! @parameter ct_ykonp   | KONP : Estrutura para a atualização Condições (item)
    "! @parameter ct_ykonh   | KONH : Estrutura para a atualização Condições (cabeçalho)
    "! @parameter ct_xkonh   | KONH : Estrutura para a atualização Condições (cabeçalho)
    "! @parameter ct_xkonp   | KONP : Estrutura para a atualização Condições (item)
    "! @parameter ct_ykondat | Reg.condição: período de validade antigo e novo
    "! @parameter ct_xkondat | Reg.condição: período de validade antigo e novo
    METHODS altera_condicoes
      CHANGING
        ct_ykonp   TYPE zclsd_atual_vig_methods=>ty_lt_ykonp
        ct_ykonh   TYPE zclsd_atual_vig_methods=>ty_lt_ykonh
        ct_xkonh   TYPE ty_lt_xkonh
        ct_xkonp   TYPE ty_lt_xkonp
        ct_ykondat TYPE ty_lt_ykondat
        ct_xkondat TYPE ty_lt_xkondat.

    "! Método para atualizar modificacoes condições de preço
    "! @parameter is_record     | Dados App Atualizar Vigência Preço
    "! @parameter is_bapicondhd | Estrura KONH da BAPI
    "! @parameter ct_ykonp      | KONP : Estrutura para a atualização Condições (item)
    "! @parameter ct_ykonh      | KONH : Estrutura para a atualização Condições (cabeçalho)
    METHODS atualiza_modificacoes
      IMPORTING
        is_record     TYPE zssd_atual_vig
        is_bapicondhd TYPE bapicondhd
      CHANGING
        ct_ykonp      TYPE ty_lt_ykonp
        ct_ykonh      TYPE ty_lt_ykonh.

    "! Método para alterar dados e enviar na BAPI
    "! @parameter iv_004        | Parametro de alteração da BAPI
    "! @parameter iv_data_in    | Data Desde
    "! @parameter iv_data_fim   | Data Fim
    "! @parameter is_record     | Dados App Atualizar Vigência Preço
    "! @parameter ev_delete     | Flag para deleção
    "! @parameter ct_bapicondit | Estrura KONP da BAPI
    "! @parameter ct_bapicondhd | Estrura KONH da BAPI
    "! @parameter ct_bapicondct | Estrutura BAPI p/tabelas de condições (corresp. a COND_RECS)
    METHODS altera_dados_bapi
      IMPORTING
        iv_004        TYPE c
        iv_data_in    TYPE dats
        iv_data_fim   TYPE dats
        is_record     TYPE zssd_atual_vig
      EXPORTING
        ev_delete     TYPE abap_bool
      CHANGING
        ct_bapicondit TYPE ty_lt_bapicondit_1
        ct_bapicondhd TYPE ty_lt_bapicondhd_1
        ct_bapicondct TYPE ty_lt_bapicondct_1.

    "! Método para chamar a BAPI
    "! @parameter iv_delete     | Flag para deleção
    "! @parameter et_return     | Mensagem de retorno
    "! @parameter ct_bapicondit | Estrura KONP da BAPI
    "! @parameter ct_bapicondhd | Estrura KONH da BAPI
    "! @parameter ct_bapicondct | Estrutura BAPI p/tabelas de condições (corresp. a COND_RECS)
    METHODS call_bapi
      IMPORTING
        iv_delete     TYPE abap_bool
      EXPORTING
        et_return     TYPE zclsd_atual_vig_methods=>tt_return
      CHANGING
        ct_bapicondit TYPE ty_lt_bapicondit
        ct_bapicondhd TYPE ty_lt_bapicondhd
        ct_bapicondct TYPE ty_lt_bapicondct.

    "! Método para dar commit
    "! @parameter it_return | Mensagem de retorno
    METHODS commit_work
      IMPORTING
        it_return TYPE zclsd_atual_vig_methods=>tt_return.

    "! Método para atualizar tabela de log
    "! @parameter it_return | Mensagem de retorno
    METHODS update_log_bdcp2
      IMPORTING
        it_return TYPE zclsd_atual_vig_methods=>tt_return.
ENDCLASS.



CLASS ZCLSD_ATUAL_VIG_METHODS IMPLEMENTATION.


  METHOD atualizar.
    CONSTANTS: lc_a       TYPE c VALUE 'A',
               lc_817(3)  TYPE c VALUE '817',
               lc_816(3)  TYPE c VALUE '816',
               lc_v       TYPE c VALUE 'V',
               lc_c       TYPE c VALUE 'C',
               lc_zpr0(4) TYPE c VALUE 'ZPR0',
               lc_brl(3)  TYPE c VALUE 'BRL',
               lc_003(3)  TYPE c VALUE '003', "Eliminar
               lc_004(3)  TYPE c VALUE '004', "Modificar
               lc_1       TYPE c VALUE '1',
               lc_0       TYPE c VALUE '0',
               lc_01(2)   TYPE c VALUE '01',
               lc_un(2)   TYPE c VALUE 'UN'.

    DATA lt_ykonh TYPE ty_lt_ykonh.
    DATA lt_ykonp TYPE ty_lt_ykonp.

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

    ls_bapicondct-cond_usage = lc_a.
    ls_bapicondct-applicatio = lc_v.
    ls_bapicondct-cond_type  = lc_zpr0.

    IF is_record-datbi NE iv_data_fim.
      ls_bapicondct-operation  = lc_003.
      DATA(lv_delete)          = abap_true.
    ELSE.
      ls_bapicondct-operation  = lc_004.
    ENDIF.

    IF is_record-pltyp IS NOT INITIAL.
      ls_bapicondct-varkey     = |{ is_record-vtweg }{ is_record-pltyp }{ is_record-werks }{ is_record-matnr }|.
      ls_bapicondct-table_no   = lc_817.
    ELSE.
      ls_bapicondct-varkey     = |{ is_record-vtweg }{ is_record-werks }{ is_record-matnr }|.
      ls_bapicondct-table_no   = lc_816.
    ENDIF.

    IF ls_bapicondct-operation  = lc_004.
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
    APPEND ls_bapicondct TO lt_bapicondct.

    CLEAR ls_bapicondhd.
    IF is_record-datbi NE iv_data_fim.
      ls_bapicondhd-operation  = lc_003.
    ELSE.
      ls_bapicondhd-operation  = lc_004.
    ENDIF.
    ls_bapicondhd-cond_no    = is_record-knumh.
    ls_bapicondhd-created_by = sy-uname.
    ls_bapicondhd-creat_date = sy-datum.
    ls_bapicondhd-cond_usage = lc_a.

    ls_bapicondhd-applicatio = lc_v.
    ls_bapicondhd-cond_type  = lc_zpr0.
    IF is_record-pltyp IS NOT INITIAL.
      ls_bapicondhd-varkey     =  |{ is_record-vtweg }{ is_record-pltyp }{ is_record-werks }{ is_record-matnr }| .
      ls_bapicondhd-table_no   = lc_817.
    ELSE.
      ls_bapicondhd-varkey     =  |{ is_record-vtweg }{ is_record-werks }{ is_record-matnr }| .
      ls_bapicondhd-table_no   = lc_816.
    ENDIF.

    ls_bapicondhd-valid_to = ls_bapicondct-valid_to .
    ls_bapicondhd-valid_from   = ls_bapicondct-valid_from .

    APPEND ls_bapicondhd TO lt_bapicondhd.

    CLEAR ls_bapicondit.
    IF is_record-datbi NE iv_data_fim.
      ls_bapicondit-operation  = lc_003.
    ELSE.
      ls_bapicondit-operation  = lc_004.
    ENDIF.
    ls_bapicondit-cond_no        = is_record-knumh.
    ls_bapicondit-cond_count     = lc_01.
    ls_bapicondit-applicatio     = lc_v.
    ls_bapicondit-cond_type      = lc_zpr0.
    ls_bapicondit-scaletype      = lc_a.
    ls_bapicondit-scalebasin     = abap_false .
    ls_bapicondit-scale_qty      = lc_0.
    ls_bapicondit-calctypcon     = lc_c.
    ls_bapicondit-cond_value     = is_record-kbetr.
    ls_bapicondit-condcurr       = lc_brl.
    ls_bapicondit-cond_p_unt     = 1.
    ls_bapicondit-cond_unit      = lc_un.
    ls_bapicondit-conditidx_long = 1.
    ls_bapicondit-lowerlimit     = is_record-mxwrt.
    ls_bapicondit-upperlimit     = is_record-gkwrt.
    APPEND ls_bapicondit TO lt_bapicondit.



    call_bapi( EXPORTING
                 iv_delete = lv_delete
               IMPORTING
                 et_return = et_return
               CHANGING
                 ct_bapicondit = lt_bapicondit
                 ct_bapicondhd = lt_bapicondhd
                 ct_bapicondct = lt_bapicondct ).

    commit_work( et_return ).


    IF ls_bapicondct-operation  = lc_003.

      altera_dados_bapi( EXPORTING
                          iv_004      = lc_004
                          is_record   = is_record
                          iv_data_fim = iv_data_fim
                          iv_data_in  = iv_data_in
                         IMPORTING
                          ev_delete = lv_delete
                         CHANGING
                          ct_bapicondit = lt_bapicondit
                          ct_bapicondhd = lt_bapicondhd
                          ct_bapicondct = lt_bapicondct ).

      busca_condicoes( EXPORTING
                        is_record = is_record
                       IMPORTING
                        et_ykonh = lt_ykonh
                        et_ykonp = lt_ykonp ).

      call_bapi( EXPORTING
                   iv_delete = lv_delete
                 IMPORTING
                   et_return = et_return
                 CHANGING
                   ct_bapicondit = lt_bapicondit
                   ct_bapicondhd = lt_bapicondhd
                   ct_bapicondct = lt_bapicondct ).

      atualiza_modificacoes( EXPORTING
                              is_record = is_record
                              is_bapicondhd = ls_bapicondhd
                             CHANGING
                              ct_ykonp = lt_ykonp
                              ct_ykonh = lt_ykonh ).

      commit_work( et_return ).

    ENDIF.



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
        ls_xkondat-datan = is_bapicondhd-valid_from.
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

    READ TABLE ct_bapicondit ASSIGNING FIELD-SYMBOL(<fs_bapicondit>) INDEX 1.
    IF sy-subrc = 0.
      <fs_bapicondit>-operation = iv_004.
    ENDIF.

    READ TABLE ct_bapicondhd ASSIGNING FIELD-SYMBOL(<fs_bapicondhd>) INDEX 1.
    IF sy-subrc = 0.
      <fs_bapicondhd>-operation = iv_004.

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
      <fs_bapicondct>-operation = iv_004.

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

    CLEAR ev_delete.

  ENDMETHOD.


  METHOD commit_work.

    IF line_exists( it_return[ type = 'E' ] ).
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

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


  METHOD call_bapi.

    DATA lt_mem_initial TYPE STANDARD TABLE OF cnd_mem_initial.
    DATA lt_bapiknumhs TYPE STANDARD TABLE OF bapiknumhs.
    DATA lt_bapicondvs TYPE STANDARD TABLE OF bapicondvs.
    DATA lt_bapicondqs TYPE STANDARD TABLE OF bapicondqs.

    FREE et_return.
    CALL FUNCTION 'BAPI_PRICES_CONDITIONS'
      EXPORTING
        pi_physical_deletion = iv_delete
      TABLES
        ti_bapicondct        = ct_bapicondct
        ti_bapicondhd        = ct_bapicondhd
        ti_bapicondit        = ct_bapicondit
        ti_bapicondqs        = lt_bapicondqs
        ti_bapicondvs        = lt_bapicondvs
        to_bapiret2          = et_return
        to_bapiknumhs        = lt_bapiknumhs
        to_mem_initial       = lt_mem_initial
      EXCEPTIONS
        update_error         = 1
        OTHERS               = 2.


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
ENDCLASS.
