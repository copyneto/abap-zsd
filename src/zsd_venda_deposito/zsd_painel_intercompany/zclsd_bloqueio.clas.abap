CLASS zclsd_bloqueio DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS execute
      IMPORTING
        !is_result       TYPE zi_sd_01_cockpit
        !iv_bloqueio     TYPE lifsk OPTIONAL
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
    CLASS-METHODS setup_messages
      IMPORTING
        !p_task TYPE clike .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS gc_erro TYPE bapi_mtype VALUE 'E' ##NO_TEXT.
    CLASS-DATA gv_wait_async TYPE abap_bool .
    CLASS-DATA gt_return TYPE bapiret2_t .
ENDCLASS.



CLASS ZCLSD_BLOQUEIO IMPLEMENTATION.


  METHOD execute.

*    SELECT SINGLE vbeln, bstnk
*    FROM vbak
*    WHERE vbeln EQ @is_result-salesorder
*    INTO @DATA(ls_vbak).
*
*    IF ls_vbak-bstnk IS INITIAL OR ls_vbak-bstnk EQ '0000000000'.
*
*      APPEND VALUE #( type = 'E' id = 'ZSD_INTERCOMPANY' number = 046  ) TO rt_return.
*
*    ELSE.


*    IF is_result-docnuv IS NOT INITIAL
      IF is_result-remessa   IS NOT INITIAL.

        CALL FUNCTION 'ZFMSD_OUTB_DELIVERY_CHANGE'
          STARTING NEW TASK 'ZSD_OUTB_DELIV'
          CALLING setup_messages ON END OF TASK
          EXPORTING
            is_header_data    = VALUE bapiobdlvhdrchg( deliv_numb = is_result-remessa dlv_block = iv_bloqueio )
            is_header_control = VALUE bapiobdlvhdrctrlchg( deliv_numb = is_result-remessa dlv_block_flg = abap_true )
            iv_delivery       = is_result-remessa.
*          iv_delivery       = CONV vbeln_vl( is_result-docnuv ).

        WAIT UNTIL gv_wait_async = abap_true.
        rt_return = gt_return.
        FREE: gv_wait_async,
              gt_return[].

*      CALL FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
*        EXPORTING
*          header_data    = VALUE bapiobdlvhdrchg( deliv_numb = is_result-forn dlv_block = iv_param )
*          header_control = VALUE bapiobdlvhdrctrlchg( deliv_numb = is_result-forn dlv_block_flg = abap_true )
*          delivery       = CONV vbeln_vl( is_result-docnuv )
*        TABLES
*          return         = rt_return.
*
*      IF NOT line_exists( rt_return[ type = gc_erro ] ).
*
*        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*          EXPORTING
*            wait = abap_true.
*
*      ENDIF.

      ENDIF.
*    ENDIF.

  ENDMETHOD.


  METHOD setup_messages.

    CASE p_task.

      WHEN 'ZSD_OUTB_DELIV'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMSD_OUTB_DELIVERY_CHANGE'
         IMPORTING
           et_return = gt_return.

        gv_wait_async = abap_true.

      WHEN OTHERS.

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
