*&---------------------------------------------------------------------*
*& Report ZSDR_COMODLOCA_JOB_FATURAMNT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsdr_comodloca_job_faturamnt.

TABLES: vbak.

SELECTION-SCREEN BEGIN OF BLOCK a1.

  SELECT-OPTIONS: s_vbeln FOR vbak-vbeln,
                  s_dats  FOR sy-datum NO-EXTENSION.

  PARAMETERS: p_exec TYPE char1 AS CHECKBOX.

SELECTION-SCREEN END OF BLOCK a1.

*&---------------------------------------------------------------------*
*& START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM f_main.

*&---------------------------------------------------------------------*
*& FORM F_MAIN
*&---------------------------------------------------------------------*
FORM f_main.

  DATA: lt_return TYPE bapiret2_t,
        lr_vbeln  TYPE RANGE OF vbak-vbeln,
        lr_dats   TYPE RANGE OF sy-datum.

  DATA(lo_object) = NEW zclsd_faturamento_contrato( ).

  lr_vbeln = VALUE #( FOR ls_vbeln IN s_vbeln ( sign   = ls_vbeln-sign
                                                option = ls_vbeln-option
                                                low    = ls_vbeln-low
                                                high   = ls_vbeln-high ) ).

  lr_dats = VALUE #( FOR ls_dats IN s_dats ( sign   = ls_dats-sign
                                             option = ls_dats-option
                                             low    = ls_dats-low
                                             high   = ls_dats-high ) ).

  lt_return = lo_object->execute( EXPORTING ir_vbeln = lr_vbeln
                                            ir_dats  = lr_dats
                                            iv_exec  = p_exec ).

  LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).

    MESSAGE ID <fs_return>-id TYPE <fs_return>-type NUMBER <fs_return>-number WITH <fs_return>-message_v1
                                                                                   <fs_return>-message_v2
                                                                                   <fs_return>-message_v3
                                                                                   <fs_return>-message_v4
                                                                                   INTO DATA(lv_msg).

    WRITE: / lv_msg.

  ENDLOOP.

ENDFORM.
