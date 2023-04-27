*&---------------------------------------------------------------------*
*& Report ZSDR_NOTA_DEBITO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsdr_nota_debito.

TABLES: nast.

FORM f_entry USING uv_returncode TYPE sysubrc
                   uv_screen     TYPE char1.

*  IF sy-uname = 'DMANTEIGA'.
*    data: lv_break TYPE c VALUE 'X'.
*    DO.
*      IF lv_break = ''.
*        EXIT.
*      ENDIF.
*    ENDDO.
*  ENDIF.

  DATA(lo_form) = NEW zclsd_adobe_nota_debito( ).

  DATA(ls_vbrk) = lo_form->get_vbrk_from_nast( nast ).

  uv_returncode = lo_form->execute_nast( iv_bukrs = ls_vbrk-bukrs
                                         iv_bupla = ls_vbrk-bupla
                                         iv_data  = ls_vbrk-erdat
                                         iv_fkart = ls_vbrk-fkart
                                         iv_kunag = ls_vbrk-kunag
                                         iv_vbeln = ls_vbrk-vbeln ).

ENDFORM.
