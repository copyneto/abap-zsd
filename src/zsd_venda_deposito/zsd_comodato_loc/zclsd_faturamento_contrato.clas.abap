class ZCLSD_FATURAMENTO_CONTRATO definition
  public
  final
  create public .

public section.

  types:
    ty_r_vbeln TYPE RANGE OF vbak-vbeln .
  types:
    ty_r_dats TYPE RANGE OF sy-datum .

  methods EXECUTE
    importing
      !IR_VBELN type TY_R_VBELN
      !IR_DATS type TY_R_DATS
      !IV_EXEC type CHAR1 optional
    returning
      value(RT_BAPIRET2) type BAPIRET2_T .
protected section.
PRIVATE SECTION.

  CONSTANTS:
    BEGIN OF gc_param,
      modulo    TYPE ze_param_modulo  VALUE 'SD',
      chv1_data TYPE ze_param_chave   VALUE 'CONTRATOSFOOD',
      chv2_data TYPE ze_param_chave   VALUE 'BILLINGTYPE',
      chv3_data TYPE ze_param_chave_3 VALUE 'ERDAT',
    END OF gc_param .
  CONSTANTS:
    BEGIN OF gc_msg,
      sucess TYPE sy-msgty VALUE 'S',
      error  TYPE sy-msgty VALUE 'E',
      id     TYPE sy-msgid VALUE 'ZSD_COMODATO_LOC',
      id_vf  TYPE sy-msgid VALUE 'VF',
      msg9   TYPE sy-msgno VALUE '009',
      msg10  TYPE sy-msgno VALUE '010',
      msg12  TYPE sy-msgno VALUE '012',
      msg050 TYPE sy-msgno VALUE '050',
      msg311 TYPE sy-msgno VALUE '311',
    END OF gc_msg .

   CONSTANTS: gc_tp_macro TYPE char5 VALUE 'Macro'.

  METHODS check_data
    EXPORTING
      VALUE(ev_ok) TYPE char1
      !ev_data     TYPE numc2 .
  METHODS call_shdb_vf01
    IMPORTING
      !iv_vbeln            TYPE vbeln_va
      !iv_last_day         TYPE sy-datum
      !iv_macro            TYPE char1
    RETURNING
      VALUE(rt_bdcmsgcoll) TYPE tab_bdcmsgcoll .
ENDCLASS.



CLASS ZCLSD_FATURAMENTO_CONTRATO IMPLEMENTATION.


  METHOD call_shdb_vf01.

    DATA: lt_bdcdata TYPE STANDARD TABLE OF bdcdata.

    DATA: lv_mode   TYPE char1 VALUE 'N',
          lv_char15 TYPE char15,
          lv_dnow TYPE char15,
          lv_vbeln  TYPE vbeln_vf.

    FREE: lt_bdcdata[],
          rt_bdcmsgcoll[].


    lv_dnow = sy-datum+6(2) && '.' && sy-datum+4(2) && '.' && sy-datum(4) .

    lt_bdcdata = VALUE #( BASE lt_bdcdata ( program  = 'SAPMV60A'
                                            dynpro   = '0102'
                                            dynbegin = 'X' )

                                          ( fnam     = 'BDC_OKCODE'
                                            fval     = '=FKVS' )

                                          ( fnam     = 'KOMFK-VBELN(01)'
                                            fval     = iv_vbeln )

                                          ( fnam     = 'RV60A-FKDAT'
                                            fval     = lv_dnow ) ).

    lv_char15 = iv_last_day+6(2) && '.' && iv_last_day+4(2) && '.' && iv_last_day(4) .

    lt_bdcdata = VALUE #( BASE lt_bdcdata ( program  = 'SAPMV60A'
                                            dynpro   = '0117'
                                            dynbegin = 'X' )

                                          ( fnam     = 'BDC_OKCODE'
                                            fval     = '=FKVW' )

                                          ( fnam     = 'RV60A-SELDAT'
                                            fval     = lv_char15 ) ).

    lt_bdcdata = VALUE #( BASE lt_bdcdata ( program  = 'SAPMV60A'
                                            dynpro   = '0102'
                                            dynbegin = 'X' )

                                          ( fnam     = 'BDC_OKCODE'
                                            fval     = '=SICH' ) ).

    CALL TRANSACTION 'VF01'
               USING lt_bdcdata
                MODE lv_mode
       MESSAGES INTO rt_bdcmsgcoll.

    CLEAR lv_vbeln.
    LOOP AT rt_bdcmsgcoll ASSIGNING FIELD-SYMBOL(<fs_bdcmsgcoll>).

      IF ( <fs_bdcmsgcoll>-msgid = gc_msg-id_vf AND <fs_bdcmsgcoll>-msgnr = gc_msg-msg050 )
      OR ( <fs_bdcmsgcoll>-msgid = gc_msg-id_vf AND <fs_bdcmsgcoll>-msgnr = gc_msg-msg311 ).

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = <fs_bdcmsgcoll>-msgv1
          IMPORTING
            output = lv_vbeln.

      ENDIF.
    ENDLOOP.

    IF lv_vbeln IS NOT INITIAL
   AND iv_macro IS NOT INITIAL.

      DATA(lo_object) = NEW zclsd_cmdloc_pag_contrato( ).

      lo_object->processar( EXPORTING iv_vbeln   = lv_vbeln
                            IMPORTING ev_obj_key = DATA(lv_obj_key)
                                      et_return  = DATA(lt_return) ).

      IF lv_obj_key IS NOT INITIAL.
        rt_bdcmsgcoll = VALUE #( BASE rt_bdcmsgcoll ( msgid  = gc_msg-id
                                                      msgnr  = gc_msg-msg12
                                                      msgv1  = lv_obj_key
                                                      msgtyp = gc_msg-sucess ) ).
      ELSE.
        IF lines( lt_return[] ) GT 1.

          READ TABLE lt_return ASSIGNING FIELD-SYMBOL(<fs_return>) INDEX 2.
          IF sy-subrc IS INITIAL.
            rt_bdcmsgcoll = VALUE #( BASE rt_bdcmsgcoll ( msgid  = <fs_return>-id
                                                          msgnr  = <fs_return>-number
                                                          msgv1  = <fs_return>-message_v1
                                                          msgv2  = <fs_return>-message_v2
                                                          msgv3  = <fs_return>-message_v3
                                                          msgv4  = <fs_return>-message_v4
                                                          msgtyp = <fs_return>-type ) ).
          ENDIF.

        ELSE.
          READ TABLE lt_return ASSIGNING <fs_return> INDEX 1.
          IF sy-subrc IS INITIAL.
            rt_bdcmsgcoll = VALUE #( BASE rt_bdcmsgcoll ( msgid  = <fs_return>-id
                                                          msgnr  = <fs_return>-number
                                                          msgv1  = <fs_return>-message_v1
                                                          msgv2  = <fs_return>-message_v2
                                                          msgv3  = <fs_return>-message_v3
                                                          msgv4  = <fs_return>-message_v4
                                                          msgtyp = <fs_return>-type ) ).
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD check_data.

    DATA(lo_object) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_object->m_get_single( EXPORTING iv_modulo = gc_param-modulo
                                           iv_chave1 = gc_param-chv1_data
                                           iv_chave2 = gc_param-chv2_data
                                           iv_chave3 = gc_param-chv3_data
                                 IMPORTING ev_param  = ev_data ).

        IF sy-datum+6(2) = ev_data.
          ev_ok = abap_true.
        ENDIF.

      CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros
    ENDTRY.

  ENDMETHOD.


  METHOD execute.

    DATA: lv_last_day TYPE sy-datum.

    " Verifica se é o dia de faturar
    check_data( IMPORTING ev_ok   = DATA(lv_ok)
                          ev_data = DATA(lv_data) ).

    IF iv_exec IS NOT INITIAL.
      lv_ok = abap_true.
    ENDIF.

    IF lv_ok IS NOT INITIAL.

      DATA(lr_dats) = ir_dats.

      IF lr_dats IS INITIAL.

        CALL FUNCTION 'LAST_DAY_OF_MONTHS'
          EXPORTING
            day_in            = sy-datum
          IMPORTING
            last_day_of_month = lv_last_day
          EXCEPTIONS
            day_in_no_date    = 1
            OTHERS            = 2.

        IF sy-subrc IS INITIAL.
          lr_dats = VALUE #( BASE lr_dats ( sign   = 'I'
                                            option = 'BT'
                                            low    = sy-datum(6) && '01'
                                            high   = sy-datum(6) && '01' ) ).
        ENDIF.

      ELSE.

        IF lr_dats[ 1 ]-high IS INITIAL.
          lv_last_day = lr_dats[ 1 ]-low.
        ELSE.
          lv_last_day = lr_dats[ 1 ]-high.
        ENDIF.
      ENDIF.

      SELECT vbeln,
             fplnr,
             afdat
        FROM zi_sd_contrato_faturamento
       WHERE vbeln IN @ir_vbeln
         AND afdat IN @lr_dats
        INTO TABLE @DATA(lt_contratos).

      IF sy-subrc IS INITIAL.

        DATA(lt_contratos_fae) = lt_contratos[].

        SORT lt_contratos_fae BY vbeln.
        DELETE ADJACENT DUPLICATES FROM lt_contratos_fae COMPARING vbeln.

        SELECT salescontract,
               tpoperacao
          FROM zi_sd_cockpit_app
          JOIN vbkd ON zi_sd_cockpit_app~salescontract = vbkd~vbeln
           FOR ALL ENTRIES IN @lt_contratos_fae
         WHERE zi_sd_cockpit_app~salescontract = @lt_contratos_fae-vbeln
         AND ( zi_sd_cockpit_app~status = 'C' OR vbkd~bsark  = 'CARG')
          INTO TABLE @DATA(lt_cockpit).

        IF sy-subrc IS INITIAL.

          SORT lt_cockpit BY salescontract.
          "DELETE ADJACENT DUPLICATES FROM lt_cockpit COMPARING salescontract.

          LOOP AT lt_contratos ASSIGNING FIELD-SYMBOL(<fs_contratos>).

            READ TABLE lt_cockpit ASSIGNING FIELD-SYMBOL(<fs_cockpit>)
                                                WITH KEY salescontract = <fs_contratos>-vbeln
                                                BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              DATA(lv_macro) = COND #( WHEN <fs_cockpit>-tpoperacao EQ gc_tp_macro
                                        THEN abap_true
                                        ELSE abap_false ).

              DATA(lt_bdcmsgcoll) = call_shdb_vf01( EXPORTING iv_vbeln    = <fs_contratos>-vbeln
                                                              iv_last_day = lv_last_day
                                                              iv_macro    = lv_macro ).

              rt_bapiret2 = VALUE #( FOR ls_bdcmsgcoll IN lt_bdcmsgcoll ( type       = ls_bdcmsgcoll-msgtyp
                                                                          id         = ls_bdcmsgcoll-msgid
                                                                          number     = ls_bdcmsgcoll-msgnr
                                                                          message_v1 = ls_bdcmsgcoll-msgv1
                                                                          message_v2 = ls_bdcmsgcoll-msgv2
                                                                          message_v3 = ls_bdcmsgcoll-msgv3
                                                                          message_v4 = ls_bdcmsgcoll-msgv4 ) ).

            ENDIF.

          ENDLOOP.

        ELSE.

          rt_bapiret2 = VALUE #( BASE rt_bapiret2 ( type   = gc_msg-error
                                                    id     = gc_msg-id
                                                    number = gc_msg-msg9 ) ).
        ENDIF.

      ELSE.

        rt_bapiret2 = VALUE #( BASE rt_bapiret2 ( type   = gc_msg-error
                                                  id     = gc_msg-id
                                                  number = gc_msg-msg9 ) ).
      ENDIF.
    ELSE.

      rt_bapiret2 = VALUE #( BASE rt_bapiret2 ( type       = gc_msg-error
                                                id         = gc_msg-id
                                                number     = gc_msg-msg10
                                                message_v1 = lv_data ) ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
