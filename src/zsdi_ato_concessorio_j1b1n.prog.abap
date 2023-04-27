*&---------------------------------------------------------------------*
*& Include          ZSDI_ATO_CONCESSORIO_J1B1N
*&---------------------------------------------------------------------*
    DATA: cl_j1b1n TYPE sy-tcode VALUE 'J1B1N',
          cl_0     TYPE c        VALUE '0',
          cl_1     TYPE c        VALUE '1',
          cl_3     TYPE c        VALUE '3',
          cl_4     TYPE c        VALUE '4',
          cl_6     TYPE c        VALUE '6'.
    DATA: ls_addr1           TYPE addr1_val.

    IF sy-tcode EQ cl_j1b1n.

      IF is_header-direct EQ cl_1 AND is_header-doctyp = cl_6 AND  is_header-ind_emit = cl_0 AND  is_header-modfrete = cl_3.
        es_header-modfrete = cl_4.
      ELSEIF is_header-direct EQ cl_1 AND is_header-doctyp = cl_6 AND  is_header-ind_emit = cl_0 AND  is_header-modfrete = cl_0.
        es_header-modfrete = cl_1.
      ENDIF.

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

        """ 1º - Busca por local de negócio X operação interna
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

        """ 3º - Busca por local de negócio X operação interna X Grp. de mercadorias
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

*        SORT lt_tpato.
*        DELETE ADJACENT DUPLICATES FROM lt_tpato COMPARING ALL FIELDS.

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
    ENDIF.
