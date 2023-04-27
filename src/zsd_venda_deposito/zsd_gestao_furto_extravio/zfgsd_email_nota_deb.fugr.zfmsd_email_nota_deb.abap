FUNCTION zfmsd_email_nota_deb.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_PDF) TYPE  FPCONTENT
*"     VALUE(IV_KUNAG) TYPE  VBRK-KUNAG
*"     VALUE(IV_FKART) TYPE  VBRK-FKART
*"     VALUE(IV_NF_VEN) TYPE  LOGBR_NFNUM9 OPTIONAL
*"     VALUE(IV_NUM_PED) TYPE  BSTKD OPTIONAL
*"     VALUE(IV_NF_DEB) TYPE  VBELN_VF OPTIONAL
*"     VALUE(IV_TRANSPORTER) TYPE  MD_CUSTOMER_NAME OPTIONAL
*"     VALUE(IV_BELNR) TYPE  BELNR_D OPTIONAL
*"     VALUE(IV_BUKRS) TYPE  BUKRS OPTIONAL
*"     VALUE(IV_GJAHR) TYPE  GJAHR OPTIONAL
*"  CHANGING
*"     VALUE(CV_RETURN) TYPE  CHAR1 OPTIONAL
*"----------------------------------------------------------------------

  DATA(lo_email) = NEW zclsd_adobe_nota_debito( ).

  lo_email->get_param_type_cond( ).

  lo_email->send_mail( EXPORTING iv_pdf         = iv_pdf
                                 iv_kunag       = iv_kunag
                                 iv_fkart       = iv_fkart
                                 iv_nf_ven      = iv_nf_ven
                                 iv_num_ped     = iv_num_ped
                                 iv_nf_deb      = iv_nf_deb
                                 iv_transporter = iv_transporter
                                 iv_belnr       = iv_belnr
                                 iv_bukrs       = iv_bukrs
                                 iv_gjahr       = iv_gjahr
                        CHANGING cv_return = cv_return ).

ENDFUNCTION.
