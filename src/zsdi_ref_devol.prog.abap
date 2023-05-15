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
* LSCHEPP - SD - 8000007071 - TAG LOCAL DE RETIRADA - 11.05.2023 Início
*    LOOP AT xaccit ASSIGNING FIELD-SYMBOL(<fs_item1>) WHERE posnr = '0000000001' .
    LOOP AT xaccit ASSIGNING FIELD-SYMBOL(<fs_item1>) WHERE posnr LT '0000001000' .
* LSCHEPP - SD - 8000007071 - TAG LOCAL DE RETIRADA - 11.05.2023 Fim
      SELECT SINGLE gjahr INTO <fs_item1>-rebzj FROM bkpf WHERE bukrs = cvbrk-bukrs AND belnr = lv_vgbel.
      <fs_item1>-rebzg = lv_vgbel.
*      <fs_item1>-rebzj = cvbrk-fkdat(4).
* LSCHEPP - SD - 8000007071 - TAG LOCAL DE RETIRADA - 11.05.2023 Início
*      <fs_item1>-rebzz = '001'.
      <fs_item1>-rebzz = <fs_item1>-posnr.
* LSCHEPP - SD - 8000007071 - TAG LOCAL DE RETIRADA - 11.05.2023 Fim
    ENDLOOP.
  ENDIF.
ENDIF.
