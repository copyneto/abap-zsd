CLASS zcxsd_gnre_automacao DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_message .

    TYPES:
      ty_t_errors TYPE TABLE OF REF TO zcxsd_gnre_automacao WITH DEFAULT KEY .

    CONSTANTS:
      BEGIN OF gc_sd_gnre_automacao,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '000',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV3',
      END OF gc_sd_gnre_automacao .
    CONSTANTS:
      BEGIN OF gc_nf_in_process,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_nf_in_process .
    CONSTANTS:
      BEGIN OF gc_nf_is_not_valid,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_nf_is_not_valid .
    CONSTANTS:
      BEGIN OF gc_nf_is_not_in_process,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_nf_is_not_in_process .
    CONSTANTS:
      BEGIN OF gc_nf_not_found,
        msgid TYPE symsgid VALUE '8B',
        msgno TYPE symsgno VALUE '106',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_nf_not_found .
    CONSTANTS:
      BEGIN OF gc_error_on_persist_data_on_db,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_error_on_persist_data_on_db .
    CONSTANTS:
      BEGIN OF gc_for_step_reproc_is_not_all,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_for_step_reproc_is_not_all .
    CONSTANTS:
      BEGIN OF gc_docguia_not_found,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '009',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_docguia_not_found .
    CONSTANTS:
      BEGIN OF gc_step_not_allowed_for_print,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '010',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_step_not_allowed_for_print .
    CONSTANTS:
      BEGIN OF gc_for_tp_guia_form_not_found,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '011',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_for_tp_guia_form_not_found .
    CONSTANTS:
      BEGIN OF gc_step_not_allow_for_guia_man,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '012',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_step_not_allow_for_guia_man .
    CONSTANTS:
      BEGIN OF gc_empty_fields,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '013',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_empty_fields .
    CONSTANTS:
      BEGIN OF gc_ldig_guia_lt_48,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '014',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_ldig_guia_lt_48 .
    CONSTANTS:
      BEGIN OF gc_step_not_allow_for_man_pay,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '015',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_step_not_allow_for_man_pay .
    CONSTANTS:
      BEGIN OF gc_icms_fcp_not_informed,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '016',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_icms_fcp_not_informed .
    CONSTANTS:
      BEGIN OF gc_taxtyp_not_valid_for_group,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '017',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_taxtyp_not_valid_for_group .
    CONSTANTS:
      BEGIN OF gc_operation_w_substitute_insc,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '018',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_operation_w_substitute_insc .
    CONSTANTS:
      BEGIN OF gc_not_able_to_determ_tpguia,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '019',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_not_able_to_determ_tpguia .
    CONSTANTS:
      BEGIN OF gc_for_taxtyp_reven_not_found,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '020',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_for_taxtyp_reven_not_found .
    CONSTANTS:
      BEGIN OF gc_nf_not_authorized,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '021',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_nf_not_authorized .
    CONSTANTS:
      BEGIN OF gc_nf_blocked,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '022',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_nf_blocked .
    CONSTANTS:
      BEGIN OF gc_parameters_not_found,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '024',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_parameters_not_found .
    CONSTANTS:
      BEGIN OF gc_user_not_allowed_for_print,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '026',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_user_not_allowed_for_print .
    CONSTANTS:
      BEGIN OF gc_invalid_due_date,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '027',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_invalid_due_date .
    CONSTANTS:
      BEGIN OF gc_inform_a_date,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '028',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_inform_a_date .
    CONSTANTS:
      BEGIN OF gc_interval_number_not_found,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '029',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_interval_number_not_found .
    CONSTANTS:
      BEGIN OF gc_nf_guia_step_not_allo_print,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '030',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_nf_guia_step_not_allo_print .
    CONSTANTS:
      BEGIN OF gc_step_not_allow_for_disable,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '032',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_step_not_allow_for_disable .
    CONSTANTS:
      BEGIN OF gc_data_not_found,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_data_not_found .
    DATA gv_msgv1 TYPE msgv1 .
    DATA gv_msgv2 TYPE msgv2 .
    DATA gv_msgv3 TYPE msgv3 .
    DATA gv_msgv4 TYPE msgv4 .
    DATA gt_errors TYPE ty_t_errors .
    DATA gt_bapi_return TYPE bapiret2_t .




    METHODS constructor
      IMPORTING
        iv_textid      LIKE if_t100_message=>t100key OPTIONAL
        iv_previous    LIKE previous OPTIONAL
        iv_msgv1       TYPE msgv1 OPTIONAL
        iv_msgv2       TYPE msgv2 OPTIONAL
        iv_msgv3       TYPE msgv3 OPTIONAL
        iv_msgv4       TYPE msgv4 OPTIONAL
        it_errors      TYPE zcxsd_gnre_automacao=>ty_t_errors OPTIONAL
        it_bapi_return TYPE bapiret2_t OPTIONAL.

    METHODS display
      IMPORTING
        !iv_using_write TYPE abap_bool DEFAULT abap_false .
    METHODS get_bapi_return
      RETURNING
        VALUE(rs_return) TYPE bapiret2_t .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcxsd_gnre_automacao IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.

    super->constructor( previous = previous ).

    me->gv_msgv1 = iv_msgv1.
    me->gv_msgv2 = iv_msgv2.
    me->gv_msgv3 = iv_msgv3.
    me->gv_msgv4 = iv_msgv4.
    me->gt_errors = it_errors.
    me->gt_bapi_return = it_bapi_return.

    CLEAR me->textid.
*    IF textid IS INITIAL.
*      if_t100_message~t100key = if_t100_message=>default_textid.
*    ELSE.
    if_t100_message~t100key = iv_textid.
*    ENDIF.

  ENDMETHOD.


  METHOD display.

    DATA(lt_return) = get_bapi_return( ).

    IF iv_using_write = abap_true.

      LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
        WRITE: |-- { <fs_return>-type } { <fs_return>-id } { <fs_return>-number } { <fs_return>-message }|.
      ENDLOOP.

    ELSE.

      IF lines( lt_return ) = 1.

        ASSIGN lt_return[ 1 ] TO <fs_return>.

        MESSAGE ID     <fs_return>-id
                TYPE   'S'
                NUMBER <fs_return>-number
                WITH   <fs_return>-message_v1
                       <fs_return>-message_v2
                       <fs_return>-message_v3
                       <fs_return>-message_v4
                DISPLAY LIKE <fs_return>-type.

      ELSE.

        DELETE lt_return WHERE id IS INITIAL.

        CALL FUNCTION 'FB_MESSAGES_DISPLAY_POPUP'
          EXPORTING
            it_return       = lt_return
          EXCEPTIONS
            no_messages     = 1
            popup_cancelled = 2
            OTHERS          = 3.
        IF sy-subrc IS NOT INITIAL.
          "error
          DATA(lv_dummy) = abap_true.
        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD get_bapi_return.

    IF if_t100_message~t100key <> if_t100_message~default_textid.

      APPEND INITIAL LINE TO rs_return ASSIGNING FIELD-SYMBOL(<fs_return>).

      <fs_return>-type       = 'E'.
      <fs_return>-id         = if_t100_message~t100key-msgid.
      <fs_return>-number     = if_t100_message~t100key-msgno.
      <fs_return>-message_v1 = gv_msgv1.
      <fs_return>-message_v2 = gv_msgv2.
      <fs_return>-message_v3 = gv_msgv3.
      <fs_return>-message_v4 = gv_msgv4.

      MESSAGE ID     <fs_return>-id
              TYPE   <fs_return>-type
              NUMBER <fs_return>-number
              WITH   <fs_return>-message_v1
                     <fs_return>-message_v2
                     <fs_return>-message_v3
                     <fs_return>-message_v4
              INTO   <fs_return>-message.

    ENDIF.

    APPEND LINES OF gt_bapi_return TO rs_return.

    LOOP AT gt_errors ASSIGNING FIELD-SYMBOL(<fs_exception>).

      APPEND LINES OF <fs_exception>->get_bapi_return( ) TO rs_return.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
