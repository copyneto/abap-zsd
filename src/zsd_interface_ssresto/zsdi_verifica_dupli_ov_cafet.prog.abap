*&---------------------------------------------------------------------*
*& Include ZSDI_VERIFICA_DUPLI_OV_CAFET
*&---------------------------------------------------------------------*
***********************************************************************
***                           © 3corações                           ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: RM SSResto - Bloqueio OV Cafeteria                     *
*** AUTOR : Victor Santos Araújo Silva – META                         *
*** FUNCIONAL: Cleverson Fabiano Agner De Faria – META                *
*** DATA : 25/07/2023                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR        | DESCRIÇÃO                             *
***-------------------------------------------------------------------*
***   /  /     |              |                                       *
***********************************************************************

CONSTANTS: lc_abstk TYPE vbak-abstk VALUE 'C',
           lc_auart TYPE vbak-auart VALUE 'Z005'.

DATA lv_vbeln TYPE vbkd-vbeln.


IF fcode NE 'LOES'. "Eliminar

  SELECT SINGLE a~vbeln
    FROM vbkd AS a
    JOIN vbak AS b
      ON a~vbeln = b~vbeln
    INTO lv_vbeln
    WHERE a~bstkd =  xvbkd-bstkd
      AND b~abstk NE lc_abstk
      AND b~auart =  lc_auart
      AND b~kunnr =  xvbak-kunnr.

  IF sy-subrc IS INITIAL AND lv_vbeln IS NOT INITIAL.

    MESSAGE ID 'ZSD_VERIF_DUPLI_OV' TYPE 'E' NUMBER '001' WITH lv_vbeln.

  ENDIF.

ENDIF.
