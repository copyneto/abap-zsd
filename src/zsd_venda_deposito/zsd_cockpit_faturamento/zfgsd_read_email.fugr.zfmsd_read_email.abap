FUNCTION ZFMSD_READ_EMAIL.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  EFG_TAB_RANGES
*"----------------------------------------------------------------------

    DATA(lo_tabela_parametros) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 24.07.2023

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
      iv_modulo = 'SD'
      iv_chave1 = 'ADM_FATURAMENTO'
      iv_chave2 = 'EMAIL'
          IMPORTING
            et_range  = ET_RETURN
        ).

      CATCH zcxca_tabela_parametros.

    ENDTRY.



ENDFUNCTION.
