*&---------------------------------------------------------------------*
*& Include          ZSDI_REF_DEVOL
*&---------------------------------------------------------------------*

DATA lv_vgbel TYPE vbak-vgbel.

* Referencia da devolução no documento contabil
SELECT COUNT( * ) BYPASSING BUFFER
  FROM tvak
  WHERE auart = cvbrk-fkart
    AND vbtyp = 'H' .
IF sy-subrc = 0.
  SELECT SINGLE vgbel
        INTO lv_vgbel
        FROM vbak
        WHERE vbeln = cvbrp-aubel.
  IF sy-subrc = 0.
    LOOP AT xaccit ASSIGNING FIELD-SYMBOL(<fs_item1>) WHERE posnr = '0000000001' .
      SELECT SINGLE gjahr INTO <fs_item1>-rebzj FROM bkpf WHERE bukrs = cvbrk-bukrs AND belnr = lv_vgbel.
      <fs_item1>-rebzg = lv_vgbel.
*      <fs_item1>-rebzj = cvbrk-fkdat(4).
      <fs_item1>-rebzz = '001'.
    ENDLOOP.
  ENDIF.
ENDIF.
