***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Atualiza Fatura na tabela Cadastro WEB - SAP           *
*** AUTOR    : FLÁVIA LEITE –[META]                                   *
*** FUNCIONAL: [CLEVERSON] –[META]                                    *
*** DATA     : [25/01/22]                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
DATA(lt_vbrp) = it_vbrp.
SORT lt_vbrp BY posnr.
READ TABLE lt_vbrp ASSIGNING FIELD-SYMBOL(<fs_vbrp>) WITH KEY  posnr = '000010' BINARY SEARCH.
IF sy-subrc = 0.

  SELECT SINGLE vgbel
  FROM lips
  INTO @DATA(lv_ordem)
  WHERE vbeln EQ @<fs_vbrp>-vgbel
    AND posnr EQ '00010'.

  IF sy-subrc = 0.

    SELECT *
    FROM ztsd_sint_proces
    INTO TABLE @DATA(lt_process)
    WHERE doc_ov EQ @lv_ordem
      AND forn   EQ @<fs_vbrp>-vgbel.

  ELSE.

    SELECT *
  FROM ztsd_sint_proces
  INTO TABLE @lt_process
  WHERE forn EQ @<fs_vbrp>-vgbel.

  ENDIF.

  LOOP AT lt_process ASSIGNING FIELD-SYMBOL(<fs_process>).
    <fs_process>-doc_fat    = is_vbrk-vbeln.
    <fs_process>-status_fat = '2'.
  ENDLOOP.

  IF lt_process IS NOT INITIAL.
    MODIFY ztsd_sint_proces FROM TABLE lt_process.
  ENDIF.
ENDIF.
