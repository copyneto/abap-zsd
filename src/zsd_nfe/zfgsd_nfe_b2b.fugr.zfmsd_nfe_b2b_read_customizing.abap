function zfmsd_nfe_b2b_read_customizing.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IV_CNPJ) TYPE  /XNFE/CNPJ_OWN
*"  EXPORTING
*"     REFERENCE(ES_B2BCUST) TYPE  ZTSD_CST_B2B_OUT
*"----------------------------------------------------------------------
  data: ls_zsdt001 type ztsd_cst_b2b_out.

*  IF iv_cnpj IS NOT INITIAL.
  select single * from ztsd_cst_b2b_out
    into @ls_zsdt001
    where cnpj = @iv_cnpj.

  if sy-subrc is initial.
    es_b2bcust = ls_zsdt001.
  else.
    select single * from ztsd_cst_b2b_out
     into ls_zsdt001
     where cnpj = space.  "Default
    if sy-subrc is initial.
      es_b2bcust = ls_zsdt001.
    endif.
  endif.
*  ENDIF.




endfunction.
