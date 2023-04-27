FUNCTION zfmsd_salesorder.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_VBAK) TYPE  VBAK
*"     VALUE(IS_VBKD) TYPE  VBKD
*"  TABLES
*"      IT_VBAP STRUCTURE  VBAP
*"----------------------------------------------------------------------
  DATA: lt_vbap  TYPE TABLE OF vbap,
*        lv_param TYPE TABLE OF ztca_param_val.
        lr_param TYPE TABLE OF ztca_param_val.

  DATA(lo_param) = NEW zclca_tabela_parametros( ).

  TRY.

      lo_param->m_get_range(
            EXPORTING
            iv_modulo = 'SD'
            iv_chave1 = 'SIRIUS'
            iv_chave2 = 'AUART'
           IMPORTING
*            et_range  = lv_param  ).
            et_range  = lr_param  ).

    CATCH zcxca_tabela_parametros.

  ENDTRY.

*  IF lv_param IS NOT INITIAL.

*    DATA(lv_string) = VALUE char50( lv_param[ 1 ]-low ).
*
*    CONDENSE lv_string NO-GAPS.
*
*    SPLIT lv_string AT ',' INTO TABLE DATA(lt_auart).


*  IF line_exists( lt_auart[ table_line = is_vbak-auart ] ). "#EC CI_STDSEQ
  IF lr_param IS NOT INITIAL.
    IF line_exists( lr_param[ low = is_vbak-auart ] ).

      DATA(lo_send_sirius) = NEW zclsd_ordem_venda(  ).

      lo_send_sirius->execute_out(
      EXPORTING
       is_vbak = is_vbak
       is_vbkd = is_vbkd
       it_vbap = it_vbap[]
       ).

    ENDIF.

  ENDIF.

ENDFUNCTION.
