*&---------------------------------------------------------------------*
*& Include          ZSDI_ATO_CONCESSORIO_ADD_DATA
*&---------------------------------------------------------------------*
  DATA ls_addr1           TYPE addr1_val.

  CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
    EXPORTING
      branch            = is_header-branch
      bukrs             = is_header-bukrs
    IMPORTING
      address1          = ls_addr1
    EXCEPTIONS
      branch_not_found  = 1
      address_not_found = 2
      company_not_found = 3
      OTHERS            = 4.

  IF sy-subrc IS INITIAL.
    IF ls_addr1-region = is_header-regio.
      DATA(lv_opint) = abap_true.
    ELSE.
      lv_opint = abap_false.
    ENDIF.

    "" 1º - Busca por local de negócio X operação interna
    SELECT *
      FROM ztsd_nfe_tpato
      INTO TABLE @DATA(lt_tpato)
      WHERE branch = @is_header-branch
        AND opint  = @lv_opint.

    """ 2º - Busca por local de negócio X operação interna X cód. material
    SELECT *
      FROM ztsd_nfe_tpato
      APPENDING TABLE lt_tpato
      FOR ALL ENTRIES IN it_nflin
      WHERE branch = is_header-branch
        AND opint  = lv_opint
        AND matnr  = it_nflin-matnr.

    "" 3º - Busca por local de negócio X operação interna X Grp. de mercadorias
    """ Só será feita essa busca caso a 2º não retorne dados
    IF sy-subrc IS NOT INITIAL.
      SELECT *
        FROM ztsd_nfe_tpato
        APPENDING TABLE lt_tpato
        FOR ALL ENTRIES IN it_nflin
        WHERE branch = is_header-branch
          AND opint  = lv_opint
          AND matkl  = it_nflin-matkl.
    ENDIF.

*    SORT lt_tpato.
*    DELETE ADJACENT DUPLICATES FROM lt_tpato COMPARING ALL FIELDS.

    LOOP AT lt_tpato INTO DATA(ls_tpato).
      et_refproc = VALUE j_1bnfrefproc_tab( (
        docnum = is_header-docnum
        counter = sy-index
        nproc = ls_tpato-atcon
        indproc = '0'
        tpato = ls_tpato-tpato
      ) ).
    ENDLOOP.
  ENDIF.
