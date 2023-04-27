*&---------------------------------------------------------------------*
*& Include          ZSDI_ALIDA_REMESSA
*&---------------------------------------------------------------------*
    DATA lv_msgid TYPE syst_msgid.
    DATA lv_msgty TYPE syst_msgty.
    DATA lv_msgno TYPE syst_msgno.

*Memória utilizada na EXIT 'MV50AFZ1'  na INCLUDE 'ZSDI_CONTROLE_REMESSA'
*Criada pois o APP FIORI VL02N não mantem as mensagens de sistema
    FREE MEMORY ID 'ZD_DOC_INC'.

    IF  ms_msgid = 'VU' AND
        ms_msgty = 'W'  AND
      ( ms_msgno = '013' OR
        ms_msgno = '014' OR
        ms_msgno = '019' OR
        ms_msgno = '020' ) AND
        sy-tcode = 'VL01N'.

      lv_msgid = ms_msgid.
      lv_msgty = ms_msgty.
      lv_msgno = ms_msgno.

      EXPORT: lv_msgid
              lv_msgty
              lv_msgno          TO MEMORY ID 'ZD_DOC_INC'.

    ENDIF.
