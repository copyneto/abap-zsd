*&---------------------------------------------------------------------*
*& Include          ZSDI_REGRAS_DIFAL
*&---------------------------------------------------------------------*
***********************************************************************
*** © 3corações ***
***********************************************************************
*** *
*** DESCRIÇÃO: Venda não contribuinte código de imposto C4 *
*** AUTOR : Gustavo Santos – META *
*** FUNCIONAL: Sandro Seixas – META *
*** DATA : 01.09.2021 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO *
***-------------------------------------------------------------------*
*** | | *
***********************************************************************
TYPES: BEGIN OF ty_kna1,
          kunnr TYPE kunnr,
          icmstaxpay TYPE kna1-icmstaxpay,
       END OF ty_kna1,
       BEGIN OF ty_regra_difal,
          auart     TYPE auart,
          j_1btxsdc TYPE j_1btxsdc,
       END OF ty_regra_difal.

DATA:
    ls_regra_difal TYPE ty_regra_difal,
    ls_kna1        TYPE ty_kna1.

DATA:
  lv_j_1btxsdc TYPE j_1btxsdc.

IF  vbak-auart IS NOT INITIAL.
  SELECT SINGLE auart j_1btxsdc
    INTO ls_regra_difal
    FROM ztsd_regra_difal
    WHERE auart = vbak-auart.
  IF sy-subrc IS INITIAL.
    SELECT SINGLE kunnr icmstaxpay
      INTO ls_kna1
      FROM kna1
      WHERE kunnr = vbak-kunnr.
    IF sy-subrc IS INITIAL AND ( ls_kna1-icmstaxpay = 'CS' OR
                                 ls_kna1-icmstaxpay = 'NC' ).

      IMPORT lv_j_1btxsdc FROM MEMORY ID text-900.
      IF NOT lv_j_1btxsdc IS INITIAL.
        IF xvbap-j_1btxsdc <> lv_j_1btxsdc.
          *vbap-j_1btxsdc = lv_j_1btxsdc.
          CLEAR lv_j_1btxsdc.
        ENDIF.
      ENDIF.
      IF ls_regra_difal-j_1btxsdc IS NOT INITIAL AND
         lv_j_1btxsdc IS INITIAL.
        IF xvbap-j_1btxsdc <> *vbap-j_1btxsdc.
          vbap-j_1btxsdc = xvbap-j_1btxsdc.
          lv_j_1btxsdc = *vbap-j_1btxsdc.
          EXPORT lv_j_1btxsdc TO MEMORY ID text-900.
        ELSE.
          vbap-j_1btxsdc = ls_regra_difal-j_1btxsdc.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
