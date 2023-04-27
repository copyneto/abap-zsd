CLASS zclsd_canhoto_mass_imp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS imprime_canhoto_nfe
      IMPORTING
        !is_canhoto TYPE zssd_canhoto
      EXPORTING
        !et_return  TYPE bapiret2_t .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zclsd_canhoto_mass_imp IMPLEMENTATION.

  METHOD imprime_canhoto_nfe.
    CONSTANTS lc_locl TYPE string VALUE 'LOCL' ##NO_TEXT.

    DATA: lv_spoolid      TYPE rspoid.

    FREE: et_return.

* ----------------------------------------------------------------------
* Recupera impressora padrão do usuário
* ----------------------------------------------------------------------
    IF is_canhoto-printer IS INITIAL.

      SELECT SINGLE spld
        FROM usr01
        INTO @DATA(lv_dest)
        WHERE bname = @sy-uname.

      IF sy-subrc NE 0 OR lv_dest IS INITIAL.
        lv_dest = lc_locl.
      ENDIF.

* ----------------------------------------------------------------------
* Verifica se impressora solicitada existe
* ----------------------------------------------------------------------
    ELSE.

      SELECT SINGLE padest
        FROM tsp03
        INTO @lv_dest
        WHERE padest  = @is_canhoto-printer.

      IF sy-subrc NE 0.

        " Impressora &1 não existe.
        et_return[] =  VALUE #( BASE et_return ( type       = 'E'
                                                 id         = 'ZSD_IMPRESSAO_NF'
                                                 number     = gc_msg_disp
                                                 message_v1 = is_canhoto-printer ) ).
        RETURN.
      ENDIF.
    ENDIF.

* ----------------------------------------------------------------------
* Encontra Formulário
* ----------------------------------------------------------------------
    DATA: lv_formname           TYPE tdsfname,
          lv_control_parameters TYPE ssfctrlop,
          lv_output_options     TYPE ssfcompop.
    DATA: ls_ret_canhoto TYPE ssfcrescl.
    DATA: lv_funcname TYPE rs38l_fnam.

    lv_formname = 'ZSFSD_NFCANHOTO'.

    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = lv_formname
      IMPORTING
        fm_name            = lv_funcname
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.
      et_return[] =  VALUE #( BASE et_return ( type       = gc_msg_error
                                               id         = gc_msg_class
                                               number     = gc_msg_form
                                               message_v1 = lv_formname ) ).
      RETURN.
    ENDIF.

* ----------------------------------------------------------------------
* Imprime Formulário
* ----------------------------------------------------------------------
    IF is_canhoto-printer <> lc_locl.
      lv_output_options-tdimmed       = abap_true.
    ENDIF.
    lv_output_options-tddest        = is_canhoto-printer.
    lv_control_parameters-no_dialog = abap_true.
    lv_output_options-tdnewid       = abap_true.

    CALL FUNCTION lv_funcname
      EXPORTING
        control_parameters = lv_control_parameters
        output_options     = lv_output_options
        user_settings      = space
        canhotos           = is_canhoto
      IMPORTING
        job_output_info    = ls_ret_canhoto
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.
    IF sy-subrc <> 0.
      et_return[] =  VALUE #( BASE et_return ( type       = gc_msg_warnig
                                               id         = gc_msg_class
                                               number     = gc_msg_n_gera ) ).
    ELSE.

      " Doc &1: Form. &2 impresso no spool &3.
      lv_spoolid = ls_ret_canhoto-spoolids[ 1 ].
      et_return[] =  VALUE #( BASE et_return ( type       = 'S'
                                               id         = gc_msg_class
                                               number     = gc_msg_printed
                                               message_v1 = lv_formname
                                               message_v2 = lv_spoolid ) ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
