class ZCLSD_VALIDA_DUPILCIDADE_DEV definition
  public
  final
  create public .

public section.

  "! Metodo de verificação de duplicidade NFe
  "! @parameter IS_DEVOLUCAO | estrutura importa dados de devolução.
  "! @parameter EV_DUPLICIDADE | variavel de exportação retorno da logica dentro da classe.
  methods EXECUTE
    importing
      !IS_DEVOLUCAO type ZSSD_DUPLICIDADE_DEVOLUCAO
      !IV_DOCNUM type J_1BNFDOC-DOCNUM optional
    exporting
      !EV_DUPLICIDADE type CHAR1 .
protected section.
private section.

  methods TRATA_NFENUM
    importing
      !IV_NFENUM type J_1BNFDOC-NFENUM
    returning
      value(RV_NFENUM) type J_1BNFDOC-NFENUM .
ENDCLASS.



CLASS ZCLSD_VALIDA_DUPILCIDADE_DEV IMPLEMENTATION.


  METHOD execute.
    DATA: lt_dupli TYPE TABLE OF string,
          ls_dupli TYPE string.

    DATA(lv_nfenum) = trata_nfenum( iv_nfenum = is_devolucao-nfenum ).


    SELECT SINGLE docnum
* nftype, doctyp, direct, docdat, crenam,model,
*    series, nfnum, belnr, bukrs, branch, parvw, parid, nfenum
     FROM j_1bnfdoc
     INTO  @DATA(lv_docnum)
     WHERE doctyp  EQ '6'
     AND direct    EQ '1'
     AND series    EQ @is_devolucao-series
     AND bukrs     EQ @is_devolucao-bukrs
     AND branch    EQ @is_devolucao-branch
     AND parvw     IN ('AG', 'RE','WE' )
     AND parid     EQ @is_devolucao-parid
     AND cancel    EQ ' '
     AND nfenum    EQ @lv_nfenum.

*    LOOP AT lt_j1bnfdoc ASSIGNING FIELD-SYMBOL(<fs_j1bnfdoc>).
*      lt_dupli = lt_j1bnfdoc.
*
*      READ TABLE lt_dupli INTO ls_dupli INDEX 2.
    IF lv_docnum IS NOT INITIAL AND iv_docnum NE lv_docnum.
      ev_duplicidade = 'X'.
    ENDIF.

*    ENDLOOP.

  ENDMETHOD.


  METHOD trata_nfenum.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = iv_nfenum
      IMPORTING
        output = rv_nfenum.
  ENDMETHOD.
ENDCLASS.
