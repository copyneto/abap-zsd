*&---------------------------------------------------------------------*
*& Include          ZSDI_RELEASE_OV
*&---------------------------------------------------------------------*


    SELECT * FROM ztsd_sint_proces
     INTO TABLE @DATA(lt_process)
     WHERE doc_ov EQ @vbak-vbeln.

    IF sy-subrc EQ 0.

      LOOP AT lt_process ASSIGNING FIELD-SYMBOL(<fs_process>).
        <fs_process>-forn            = likp-vbeln.
        <fs_process>-status_forn_sap = '2'.
      ENDLOOP.

      MODIFY ztsd_sint_proces FROM TABLE lt_process.

    ENDIF.
