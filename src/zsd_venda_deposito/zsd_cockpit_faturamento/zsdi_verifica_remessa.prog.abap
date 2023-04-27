***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Controle do valor mínimo ao salvar a remessa           *
*** AUTOR    : FLÁVIA LEITE –[META]                                   *
*** FUNCIONAL: [JANA CASTILHOS] –[META]                               *
*** DATA     : [22/12/21]                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
"Verificar valor mínimo
SELECT SINGLE kbetr
  FROM prcd_elements
  INTO @DATA(lv_kbetr)
  WHERE knumv EQ @vbak-knumv
    AND kposn EQ @space
    AND kschl EQ 'ZMIN'.

IF lv_kbetr IS NOT INITIAL.

  DATA(lt_lips) = xlips[].

  SELECT kposn, kbetr
 FROM prcd_elements
 INTO TABLE @DATA(lt_prcd)
    FOR ALL ENTRIES IN @lt_lips
 WHERE knumv EQ @vbak-knumv
   AND kposn EQ @lt_lips-vgpos
   AND kschl EQ 'ZPR0'.

  SORT lt_prcd BY kposn.
  LOOP AT lt_lips ASSIGNING FIELD-SYMBOL(<fs_lips>).

    READ TABLE lt_prcd ASSIGNING FIELD-SYMBOL(<fs_prcd>) WITH KEY kposn = <fs_lips>-vgpos BINARY SEARCH.
    IF sy-subrc = 0.
      DATA(lv_valor) = <fs_lips>-lgmng * <fs_prcd>-kbetr.

      IF lv_valor < lv_kbetr.
        MESSAGE ID 'ZSD_CKPT_FATURAMENTO' TYPE 'I' NUMBER '002'  WITH <fs_lips>-posnr DISPLAY LIKE 'E'.
        LEAVE TO SCREEN 100.
      ENDIF.

    ENDIF.

  ENDLOOP.



ENDIF.
