FUNCTION zfmsd_gerar_boleto.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_PROCESS) TYPE  ZSFI_BOLETO_PROCESS OPTIONAL
*"     VALUE(IS_PARAM) TYPE  SSFCTRLOP OPTIONAL
*"     VALUE(IT_KEY) TYPE  ZCTGFI_POST_KEY
*"  EXPORTING
*"     VALUE(EV_PDF_FILE) TYPE  XSTRING
*"  TABLES
*"      ET_RETURN TYPE  BAPIRET2_T
*"      ET_OTF TYPE  TSFOTF OPTIONAL
*"----------------------------------------------------------------------


  DATA(lo_gerar_boleto) = NEW zclfi_gerar_boleto( is_process = is_process
                                                  is_param   = is_param ).

  lo_gerar_boleto->process(
    EXPORTING
      it_key      = it_key
    IMPORTING
      ev_pdf_file = ev_pdf_file
      et_return   = DATA(lt_return) ).

  et_otf[]    = lo_gerar_boleto->gt_otf[].
  et_return[] = lt_return[].



ENDFUNCTION.
