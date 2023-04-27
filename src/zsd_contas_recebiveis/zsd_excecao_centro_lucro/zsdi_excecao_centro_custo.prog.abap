*&---------------------------------------------------------------------*
*& Include          ZSDI_EXCECAO_CENTRO_CUSTO
*&---------------------------------------------------------------------*

DATA lv_kostl TYPE kostl.

*SELECT SINGLE
*  kostl
*FROM
*  ztsd_excecao_cc
*WHERE
*  werks = @cvbrp-werks AND
*  bzirk = @cvbrk-bzirk
*INTO
*  @lv_kostl.

SELECT SINGLE kostl
  FROM ztfi_cad_cc
  WHERE gsber  = @cvbrp-gsber
    AND region = @cvbrk-bzirk
  INTO @lv_kostl.

IF sy-subrc = 0 AND lv_kostl IS NOT INITIAL.

  LOOP AT xaccit ASSIGNING FIELD-SYMBOL(<fs_xaccit>) WHERE kschl = 'ZVDO'
                                                        OR kschl = 'ZVD2'.
    <fs_xaccit>-kostl = lv_kostl.
  ENDLOOP.

*  READ TABLE xaccit ASSIGNING FIELD-SYMBOL(<fs_xaccit>) WITH KEY kschl = 'ZVDO'.
*  IF sy-subrc EQ 0.
*    <fs_xaccit>-kostl = lv_kostl.
*  ENDIF.
*
*  READ TABLE xaccit ASSIGNING <fs_xaccit> WITH KEY kschl = 'ZVD2'.
*  IF sy-subrc EQ 0.
*    <fs_xaccit>-kostl = lv_kostl.
*  ENDIF.

ELSE.

  DATA(lt_xaccit) = xaccit[].
  DELETE lt_xaccit WHERE kschl NE 'ZVDO' AND kschl NE 'ZVD2'.

  IF NOT lt_xaccit[] IS INITIAL.

    TRY.
        DATA(ls_xaccit) = lt_xaccit[ 1 ].

        SELECT SINGLE kostl
          FROM ztco_okb9
          INTO @lv_kostl
          WHERE bukrs EQ @ls_xaccit-bukrs
            AND kstar EQ @ls_xaccit-hkont
            AND gsber EQ @ls_xaccit-gsber
            AND prctr EQ @ls_xaccit-prctr.
        IF sy-subrc EQ 0.

          LOOP AT xaccit ASSIGNING <fs_xaccit> WHERE kschl = 'ZVDO'
                                                  OR kschl = 'ZVD2'.
            IF NOT lv_kostl IS INITIAL.
              <fs_xaccit>-kostl = lv_kostl.
            ENDIF.
          ENDLOOP.

        ENDIF.
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

  ENDIF.

*  READ TABLE xaccit ASSIGNING <fs_xaccit> WITH KEY kschl = 'ZVDO'.
*  IF sy-subrc EQ 0.
*    SELECT SINGLE
*      kostl
*    FROM
*      ztco_okb9
*    WHERE
*      bukrs = @<fs_xaccit>-bukrs AND
*      kstar = @<fs_xaccit>-hkont AND
*      gsber = @<fs_xaccit>-gsber AND
*      prctr = @<fs_xaccit>-prctr
*
*    INTO
*      @lv_kostl.
*
*    IF sy-subrc = 0 AND lv_kostl IS NOT INITIAL.
*      <fs_xaccit>-kostl = lv_kostl.
*    ENDIF.
*  ENDIF.
*  READ TABLE xaccit ASSIGNING <fs_xaccit> WITH KEY kschl = 'ZVD2'.
*  IF sy-subrc EQ 0.
*    SELECT SINGLE
*      kostl
*    FROM
*      ztco_okb9
*    WHERE
*      bukrs = @<fs_xaccit>-bukrs AND
*      kstar = @<fs_xaccit>-hkont AND
*      gsber = @<fs_xaccit>-gsber AND
*      prctr = @<fs_xaccit>-prctr
*
*    INTO
*      @lv_kostl.
*
*    IF sy-subrc = 0 AND lv_kostl IS NOT INITIAL.
*      <fs_xaccit>-kostl = lv_kostl.
*    ENDIF.
*  ENDIF.

ENDIF.
