"Name: \PR:SAPMV50A\FO:USEREXIT_BATCH_DETERMINATION\SE:BEGIN\EI
ENHANCEMENT 0 ZEISD_COCKPIT_REMESSA.
  TRY.
      CALL FUNCTION 'ZFMSD_COCKPIT_REMESSA_CTRL_WMS'
        EXPORTING
          iv_vstel       = likp-vstel
          iv_lprio       = likp-lprio
        CHANGING
          cv_komkz       = lips-komkz.

    CATCH cx_root INTO DATA(lo_root_exit).
  ENDTRY.
ENDENHANCEMENT.
