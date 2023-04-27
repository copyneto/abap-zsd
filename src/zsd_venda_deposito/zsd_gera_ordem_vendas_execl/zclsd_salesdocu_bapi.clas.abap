class ZCLSD_SALESDOCU_BAPI definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_BADI_SD_SALESDOCU_BAPI .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_SALESDOCU_BAPI IMPLEMENTATION.


  METHOD if_badi_sd_salesdocu_bapi~move_extensionex.
    CHECK ct_extensionex IS NOT INITIAL.
  ENDMETHOD.


  METHOD if_badi_sd_salesdocu_bapi~move_extensionin.

    LOOP AT it_extensionin ASSIGNING FIELD-SYMBOL(<fs_extensionin>).

      CHECK <fs_extensionin>-structure = 'BAPE_VBAP'.

      READ TABLE ct_vbapkom  ASSIGNING FIELD-SYMBOL(<fs_vbapkom>) INDEX sy-tabix.
      IF sy-subrc = 0.
        <fs_vbapkom>-kostl = <fs_extensionin>-valuepart1.
      ENDIF.

      READ TABLE ct_vbapkomx ASSIGNING FIELD-SYMBOL(<fs_vbapkomx>) INDEX sy-tabix.
      IF sy-subrc = 0.
        <fs_vbapkomx>-kostl = abap_true.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
