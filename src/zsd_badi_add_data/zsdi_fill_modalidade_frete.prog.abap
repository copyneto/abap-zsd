*&---------------------------------------------------------------------*
*& Include          ZSDI_FILL_MODALIDADE_FRETE
*&---------------------------------------------------------------------*
    CONSTANTS: lc_direct TYPE char1 VALUE '2',
               lc_bpkind TYPE char4 VALUE '0002',
               lc_nota1  TYPE char1 VALUE '1',
               lc_nota2  TYPE char1 VALUE '2',
               lc_funcao TYPE j_1bnfnad-parvw   VALUE 'SP',
               lc_modulo TYPE ztca_param_val-modulo VALUE 'SD'.

    TYPES: ty_nfnad TYPE TABLE OF j_1bnfnad.

    FIELD-SYMBOLS: <fs_nfnad_tab> TYPE ty_nfnad.

    DATA(ls_lin) = VALUE #( it_nflin[ 1 ] DEFAULT '').
    DATA lv_tipo_nota TYPE char1.
    IF is_header-direct = lc_direct AND  ls_lin-reftyp = gc_fat.

      ASSIGN ('(SAPLJ1BG)wnfnad[]') TO <fs_nfnad_tab>.
      IF <fs_nfnad_tab> IS ASSIGNED.

        DATA(lt_nfnad) = <fs_nfnad_tab>.
        SORT lt_nfnad BY parvw.
        READ TABLE lt_nfnad ASSIGNING FIELD-SYMBOL(<fs_nfnad>) WITH KEY parvw = lc_funcao BINARY SEARCH.

        IF sy-subrc = 0.
          SELECT SINGLE bpkind
            INTO @DATA(lv_bpkind)
            FROM but000
            WHERE partner = @<fs_nfnad>-parid.
        ENDIF.

      ENDIF.

      IF sy-subrc IS INITIAL AND lv_bpkind = lc_bpkind.
        lv_tipo_nota = lc_nota1.
      ELSE.
        lv_tipo_nota = lc_nota2.
      ENDIF.

      CHECK lv_tipo_nota IS NOT INITIAL.

      SELECT SINGLE low
        INTO @DATA(ls_param)
        FROM ztca_param_val
        WHERE modulo = @lc_modulo
          AND chave1 = @is_header-inco1
          AND chave2 = @lv_tipo_nota.
      IF sy-subrc IS INITIAL.
        cs_header-modfrete = ls_param.
      ENDIF.

    ENDIF.
