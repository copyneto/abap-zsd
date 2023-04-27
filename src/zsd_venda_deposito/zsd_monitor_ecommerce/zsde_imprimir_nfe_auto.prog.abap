*&---------------------------------------------------------------------*
*& Include          ZSDE_IMPRIMIR_NFE_AUTO
*&---------------------------------------------------------------------*
***********************************************************************
*** © 3corações ***
***********************************************************************
*** *
*** DESCRIÇÃO: Impressão automática da Danfe Simplificada*
*** AUTOR : Gustavo Santos – META *
*** FUNCIONAL: Jana Castilhos – META *
*** DATA : 05/10/2021 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO *
***-------------------------------------------------------------------*
*** | | *
***********************************************************************

SELECT SINGLE refkey
  INTO @DATA(lv_refkey)
  FROM j_1bnflin
  WHERE docnum = @i_active-docnum
    AND reftyp = 'BI'.
IF sy-subrc IS INITIAL.
  SELECT SINGLE fkart
    INTO @DATA(lv_fkart)
    FROM vbrk
    WHERE vbeln = @lv_refkey.
  IF sy-subrc IS INITIAL.

*    data: lv_break TYPE c VALUE 'X'.
*
*    DO.
*      IF lv_break = ''.
*        EXIT.
*      ENDIF.
*    ENDDO.

    SELECT SINGLE low
      INTO @DATA(lv_low)
      FROM ztca_param_val
      WHERE modulo = 'SD'
        AND chave1 = 'ECOMMERCE'
        AND chave2 = 'TIPOS_OV'
        AND low = @lv_fkart.
    IF sy-subrc IS INITIAL.

      DATA(lt_return) = NEW zclsd_imprimir_nfe( )->executar( EXPORTING iv_docnum = i_active-docnum ).

    ENDIF.
  ENDIF.

ENDIF.
