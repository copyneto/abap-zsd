***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Enhancement verificar a permissão para estorno         *
*** AUTOR    : FLÁVIA LEITE –[META]                                   *
*** FUNCIONAL: JANA CASTILHO –[META]                                  *
*** DATA     : 20.09.2021                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
CHECK it_cancel_alv IS NOT INITIAL.

SELECT docnum, direct, pstdat, entrad
FROM j_1bnfdoc
INTO TABLE @DATA(lt_doc)
FOR ALL ENTRIES IN @it_cancel_alv
WHERE docnum EQ @it_cancel_alv-docnum.

SELECT SINGLE usuario
FROM ztsd_incl_user
INTO @DATA(lv_name)
WHERE usuario EQ @sy-uname.

LOOP AT lt_doc ASSIGNING FIELD-SYMBOL(<fs_doc>).
  IF <fs_doc>-direct = 2 OR ( <fs_doc>-direct = 1 AND <fs_doc>-entrad = abap_true ).
    CHECK <fs_doc>-pstdat+4(2) NE sy-datum+4(2) AND lv_name IS INITIAL .
    MESSAGE ID 'ZSD' TYPE 'I' NUMBER '009' DISPLAY LIKE 'E'.
    LEAVE TO SCREEN 100.
  ENDIF.
ENDLOOP.
