CLASS zclsd_gnre_badi_acc_document DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_ex_acc_document .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclsd_gnre_badi_acc_document IMPLEMENTATION.


  METHOD if_ex_acc_document~change.

    DATA: ls_gnree007 TYPE zssd_gnree007.

    LOOP AT c_extension2 ASSIGNING FIELD-SYMBOL(<fs_s_extension2>) WHERE structure  = gc_s_bseg-structure
                                                                     AND valuepart1 = gc_s_bseg-valuepart1.

      ASSIGN c_accit[ posnr = <fs_s_extension2>-valuepart2 ] TO FIELD-SYMBOL(<fs_s_accit_aux>).
      IF sy-subrc IS INITIAL.
        <fs_s_accit_aux>-bupla = <fs_s_extension2>-valuepart3.
      ENDIF.

    ENDLOOP.

    "Preenche os campos do cabeçalho
    LOOP AT c_extension2 ASSIGNING <fs_s_extension2> WHERE structure  = gc_s_gnre007-structure
                                                       AND valuepart1 IS INITIAL.
      EXIT.
    ENDLOOP.
    IF sy-subrc IS INITIAL.

      ls_gnree007 = <fs_s_extension2>-valuepart2.

      IF ls_gnree007-tcode IS NOT INITIAL.
        c_acchd-tcode = ls_gnree007-tcode.
      ENDIF.

    ENDIF.

    "Preenche os campos do item
    LOOP AT c_extension2 ASSIGNING <fs_s_extension2> WHERE structure  = gc_s_gnre007-structure
                                                       AND valuepart1 IS NOT INITIAL.

      ASSIGN c_accit[ posnr = <fs_s_extension2>-valuepart1 ] TO FIELD-SYMBOL(<fs_s_accit>).
      IF sy-subrc IS INITIAL.

        ls_gnree007 = <fs_s_extension2>-valuepart2.

        IF ls_gnree007-bschl IS NOT INITIAL.
          <fs_s_accit>-bschl = ls_gnree007-bschl.
        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD if_ex_acc_document~fill_accit.
    RETURN.
  ENDMETHOD.

ENDCLASS.
