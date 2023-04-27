*&---------------------------------------------------------------------*
*& Include          ZSDI_NFE_COMPLEMENTAR
*&---------------------------------------------------------------------*
    CONSTANTS: lc_sd     TYPE ztca_param_par-modulo VALUE 'SD',
               lc_nftype TYPE ztca_param_par-chave1 VALUE 'NFTYPECOMP'.

    DATA lr_nftype TYPE RANGE OF j_1bnfdoc-nftype.

    DATA(lo_nftype) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_nftype->m_get_range(
          EXPORTING
            iv_modulo = lc_sd
            iv_chave1 = lc_nftype
          IMPORTING
            et_range  = lr_nftype ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.
** Nota complementar
    IF  is_header-nftype IN  lr_nftype.
      EV_COD_SIT = '06'.
    ENDIF.
