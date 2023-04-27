
CLASS lcl_gera_gnre DEFINITION.
  PUBLIC SECTION.
    METHODS execute
      IMPORTING
        it_nflin                 TYPE j_1bnflin_tab
      RETURNING
        VALUE(rt_return_message) TYPE bapiret2_t.

  PRIVATE SECTION.
    CONSTANTS:
      BEGIN OF lc_exec_mode,
        show_screen TYPE ctu_mode VALUE 'A',
        only_errors TYPE ctu_mode VALUE 'E',
        background  TYPE ctu_mode VALUE 'N',
        backgr_dbug TYPE ctu_mode VALUE 'P',
      END OF lc_exec_mode,

      BEGIN OF lc_update_type,
        local        TYPE ctu_update VALUE 'L',
        synchronous  TYPE ctu_update VALUE 'S',
        asynchronous TYPE ctu_update VALUE 'A',
      END OF lc_update_type,

      lc_transaction TYPE tcode VALUE 'ZSDI133'.

    METHODS fill_batch_input
      IMPORTING
        iv_PROGRAM      TYPE bdcdata-program  OPTIONAL
        iv_DYNPRO       TYPE bdcdata-dynpro   OPTIONAL
        iv_DYNBEGIN     TYPE bdcdata-dynbegin OPTIONAL
        iv_FNAM         TYPE bdcdata-fnam     OPTIONAL
        iv_FVAL         TYPE any              OPTIONAL
      RETURNING
        VALUE(ro_refme) TYPE REF TO lcl_gera_gnre.

    METHODS run_batch_input_tcode
      IMPORTING
        iv_transaction           TYPE tcode
        iv_MODE                  TYPE ctu_mode   DEFAULT lc_exec_mode-background
        iv_UPDATE                TYPE ctu_update DEFAULT lc_update_type-synchronous
      RETURNING
        VALUE(rt_return_message) TYPE bapiret2_tab.

    METHODS set_bdcreturn_to_bapiret2
      IMPORTING
        it_bdc_message           TYPE tab_bdcmsgcoll
      RETURNING
        VALUE(rt_return_message) TYPE bapiret2_tab.

    DATA lt_bdc_data TYPE tab_bdcdata.
ENDCLASS.

CLASS lcl_gera_gnre IMPLEMENTATION.
  METHOD execute.
    CHECK it_nflin IS NOT INITIAL.

    me->fill_batch_input(
        iv_program  = 'SAPMZSDI133'
        iv_dynpro   = '0100'
        iv_dynbegin = abap_true
    )->fill_batch_input(
        iv_fnam     = 'BDC_OKCODE'
        iv_fval     = '=%00210100000265092'
    )->fill_batch_input(
        iv_fnam     = 'BDC_SUBSCR'
        iv_fval     = 'SAPMZSDI133                             0110TABSTRIP_0100_SCA'
    )->fill_batch_input(
        iv_fnam     = 'BDC_SUBSCR'
        iv_fval     = 'SAPMZSDI133                             1010SUBSCREEN_1010'
    )->fill_batch_input(
        iv_fnam     = 'BDC_CURSOR'
        iv_fval     = 'S_DOCNUM-LOW'
    )->fill_batch_input(
        iv_program  = 'SAPLALDB'
        iv_dynpro   = '3000'
        iv_dynbegin = abap_true
    )->fill_batch_input(
        iv_fnam     = 'BDC_OKCODE'
        iv_fval     = '/EDELA'
    )->fill_batch_input(
        iv_program  = 'SAPLALDB'
        iv_dynpro   = '3000'
        iv_dynbegin = abap_true
    ).

    DATA(lv_index) = 0.
    LOOP AT it_nflin INTO DATA(ls_nflin).
      ADD 1 TO lv_index.
      IF ( lv_index LE 8 ).
        me->fill_batch_input(
            iv_fnam     = |RSCSEL_255-SLOW_I({ CONV numc2( lv_index ) })|
            iv_fval     = ls_nflin-docnum
        ).
      ELSE.
        me->fill_batch_input(
            iv_fnam     = 'BDC_CURSOR'
            iv_fval     = 'RSCSEL_255-SLOW_I(08)'
        )->fill_batch_input(
            iv_fnam     = 'BDC_OKCODE'
            iv_fval     = '=P+'
        )->fill_batch_input(
            iv_program  = 'SAPLALDB'
            iv_dynpro   = '3000'
            iv_dynbegin = abap_true
        )->fill_batch_input(
            iv_fnam     = |RSCSEL_255-SLOW_I({ CONV numc2( lv_index ) })|
            iv_fval     = ls_nflin-docnum
        ).
      ENDIF.
    ENDLOOP.

    me->fill_batch_input(
        iv_fnam     = 'BDC_OKCODE'
        iv_fval     = '=ACPT'
    )->fill_batch_input(
        iv_program  = 'SAPLSPO1'
        iv_dynpro   = '0100'
        iv_dynbegin = abap_true
    )->fill_batch_input(
        iv_fnam     = 'BDC_OKCODE'
        iv_fval     = '=NO'
    ).

    me->run_batch_input_tcode(
      EXPORTING
        iv_transaction    = lc_transaction
      RECEIVING
        rt_return_message = rt_return_message
    ).
  ENDMETHOD.

  METHOD fill_batch_input.
    DATA ls_bdc_data TYPE bdcdata.

    DATA(lv_value) = CONV bdcdata-fval( iv_fval ).
    CONDENSE lv_value.

    IF ( iv_dynbegin  = abap_true ).
      ls_bdc_data-program  = iv_program.
      ls_bdc_data-dynbegin = iv_dynbegin.
      ls_bdc_data-dynpro   = iv_dynpro.

    ELSE.
      ls_bdc_data-fnam = iv_fnam.
      ls_bdc_data-fval = lv_value.
    ENDIF.

    APPEND ls_bdc_data TO me->lt_bdc_data.
    ro_refme = me.
  ENDMETHOD.

  METHOD run_batch_input_tcode.
    DATA lt_bdc_message TYPE tab_bdcmsgcoll.

    CALL TRANSACTION iv_transaction
    USING   me->lt_bdc_data
    MODE   iv_mode
    UPDATE iv_update
    MESSAGES INTO lt_bdc_message.

    rt_return_message = me->set_bdcreturn_to_bapiret2( lt_bdc_message ).
  ENDMETHOD.

  METHOD set_bdcreturn_to_bapiret2.
    CALL FUNCTION 'CONVERT_BDCMSGCOLL_TO_BAPIRET2'
      TABLES
        imt_bdcmsgcoll = it_bdc_message
        ext_return     = rt_return_message.
  ENDMETHOD.

ENDCLASS.
