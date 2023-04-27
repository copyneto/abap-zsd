***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Monitor GNRE                                           *
*** AUTOR    : FLAVIA NUNES –[META]                                   *
*** FUNCIONAL: [SANDRO Chanchinski] –[META]                           *
*** DATA     : [22/04/22]                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
*&---------------------------------------------------------------------*
*& Include          ZSDI_GNRE_CALC_ICMS_PARTILHA2
*&---------------------------------------------------------------------*
  DATA: lv_icmstaxpay TYPE kna1-icmstaxpay.

  CONSTANTS: lc_naocontrib TYPE kna1-icmstaxpay VALUE 'NC',
             lc_contribsimples TYPE kna1-icmstaxpay VALUE 'CS'.

  IF ms_komp-j_1btxsdc IS NOT INITIAL.

    "Verifica se o imposto é de consumo
     SELECT taxcode
       FROM j_1btxsdc
       UP TO 1 rows
       INTO @data(lv_count)
      WHERE taxcode EQ @ms_komp-j_1btxsdc
        AND custusage EQ '2'.
       ENDSELECT.

    IF sy-subrc IS INITIAL.
      "Verifica se é consumidor final
      SELECT SINGLE
             icmstaxpay
        FROM kna1
        INTO lv_icmstaxpay
        WHERE kunnr EQ ms_komk-kunnr.

      IF lv_icmstaxpay = lc_naocontrib OR lv_icmstaxpay = lc_contribsimples.
        ms_komp-mtuse = mc_consum.
      ENDIF.

    ENDIF.
  ENDIF.
