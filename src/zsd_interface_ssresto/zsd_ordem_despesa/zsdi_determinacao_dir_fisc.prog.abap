*&---------------------------------------------------------------------*
*& Include          ZSDI_DETERMINACAO_DIR_FISC
*&---------------------------------------------------------------------*
***********************************************************************
*** © 3corações ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Determinação dos direitos fiscais                      *
*** AUTOR : Victor Silva     – Meta                                   *
*** FUNCIONAL: Sandro Seixas – Meta                                   *
*** DATA : 24/01/2021                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO                                          *
***-------------------------------------------------------------------*
*** | |                                                               *
***********************************************************************
DATA: lv_regio       TYPE t001w-regio,
      lt_dir_fis_atv TYPE TABLE OF ztsd_dir_fis_atv.

DATA:
  lv_j_1btaxlw1 TYPE j_1btaxlw1,
  lv_j_1btaxlw2 TYPE j_1btaxlw2,
  lv_j_1btaxlw4 TYPE j_1btaxlw4,
  lv_j_1btaxlw5 TYPE j_1btaxlw5.



SELECT SINGLE regio
  INTO lv_regio
  FROM t001w
  WHERE werks EQ vbap-werks.

IF lv_regio IS NOT INITIAL.
*    SORT lt_t001w BY werks.
*
*    READ TABLE lt_t001w ASSIGNING FIELD-SYMBOL(<fs_t001w>) WITH KEY werks = vbap-werks BINARY SEARCH.

  SELECT *
    FROM ztsd_dir_fis_atv
    INTO TABLE lt_dir_fis_atv
    WHERE shipfrom EQ lv_regio
      AND auart EQ vbak-auart.

  IF lt_dir_fis_atv IS NOT INITIAL.
    SORT lt_dir_fis_atv BY shipfrom auart.
    READ TABLE lt_dir_fis_atv ASSIGNING FIELD-SYMBOL(<fs_dir_fis_atv>) WITH KEY shipfrom = lv_regio
                                                                                auart = vbak-auart BINARY SEARCH.
    IF sy-subrc = 0.
      IMPORT lv_j_1btaxlw1 FROM MEMORY ID 'Z_J_1BTAXLW1'.
      IF NOT lv_j_1btaxlw1 IS INITIAL.
        IF xvbap-j_1btaxlw1 <> lv_j_1btaxlw1.
          *vbap-j_1btaxlw1 = lv_j_1btaxlw1.
          CLEAR lv_j_1btaxlw1.
        ENDIF.
      ENDIF.
      IF <fs_dir_fis_atv>-j_1btaxlw1 IS NOT INITIAL AND
         lv_j_1btaxlw1 IS INITIAL.
        IF xvbap-j_1btaxlw1 <> *vbap-j_1btaxlw1.
          vbap-j_1btaxlw1 = xvbap-j_1btaxlw1.
          lv_j_1btaxlw1 = *vbap-j_1btaxlw1.
          EXPORT lv_j_1btaxlw1 TO MEMORY ID 'Z_J_1BTAXLW1'.
        ELSE.
          vbap-j_1btaxlw1 = <fs_dir_fis_atv>-j_1btaxlw1.
        ENDIF.
      ENDIF.

      IMPORT lv_j_1btaxlw2 FROM MEMORY ID 'Z_J_1BTAXLW2'.
      IF NOT lv_j_1btaxlw2 IS INITIAL.
        IF xvbap-j_1btaxlw2 <> lv_j_1btaxlw2.
          *vbap-j_1btaxlw2 = lv_j_1btaxlw2.
          CLEAR lv_j_1btaxlw2.
        ENDIF.
      ENDIF.
      IF <fs_dir_fis_atv>-j_1btaxlw2 IS NOT INITIAL AND
         lv_j_1btaxlw2 IS INITIAL.
        IF xvbap-j_1btaxlw2 <> *vbap-j_1btaxlw2.
          vbap-j_1btaxlw2 = xvbap-j_1btaxlw2.
          lv_j_1btaxlw2 = *vbap-j_1btaxlw2.
          EXPORT lv_j_1btaxlw2 TO MEMORY ID 'Z_J_1BTAXLW2'.
        ELSE.
          vbap-j_1btaxlw2 = <fs_dir_fis_atv>-j_1btaxlw2.
        ENDIF.
      ENDIF.

      IMPORT lv_j_1btaxlw4 FROM MEMORY ID 'Z_J_1BTAXLW4'.
      IF NOT lv_j_1btaxlw4 IS INITIAL.
        IF xvbap-j_1btaxlw4 <> lv_j_1btaxlw4.
          *vbap-j_1btaxlw4 = lv_j_1btaxlw4.
          CLEAR lv_j_1btaxlw4.
        ENDIF.
      ENDIF.
      IF <fs_dir_fis_atv>-j_1btaxlw4 IS NOT INITIAL AND
         lv_j_1btaxlw4 IS INITIAL.
        IF xvbap-j_1btaxlw4 <> *vbap-j_1btaxlw4.
          vbap-j_1btaxlw4 = xvbap-j_1btaxlw4.
          lv_j_1btaxlw4 = *vbap-j_1btaxlw4.
          EXPORT lv_j_1btaxlw4 TO MEMORY ID 'Z_J_1BTAXLW4'.
        ELSE.
          vbap-j_1btaxlw4 = <fs_dir_fis_atv>-j_1btaxlw4.
        ENDIF.
      ENDIF.

      IMPORT lv_j_1btaxlw5 FROM MEMORY ID 'Z_J_1BTAXLW5'.
      IF NOT lv_j_1btaxlw5 IS INITIAL.
        IF xvbap-j_1btaxlw5 <> lv_j_1btaxlw5.
          *vbap-j_1btaxlw5 = lv_j_1btaxlw5.
          CLEAR lv_j_1btaxlw5.
        ENDIF.
      ENDIF.
      IF <fs_dir_fis_atv>-j_1btaxlw5 IS NOT INITIAL AND
         lv_j_1btaxlw5 IS INITIAL.
        IF xvbap-j_1btaxlw5 <> *vbap-j_1btaxlw5.
          vbap-j_1btaxlw5 = xvbap-j_1btaxlw5.
          lv_j_1btaxlw5 = *vbap-j_1btaxlw5.
          EXPORT lv_j_1btaxlw5 TO MEMORY ID 'Z_J_1BTAXLW5'.
        ELSE.
          vbap-j_1btaxlw5 = <fs_dir_fis_atv>-j_1btaxlw5.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
*ENDIF.
