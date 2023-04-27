FUNCTION zfmsd_envio_fatura_wevo.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_NFENUM) TYPE  J_1BNFDOC-NFENUM
*"     VALUE(IV_CODE) TYPE  J_1BNFDOC-CODE
*"     VALUE(IV_SALESDOCUMENT) TYPE
*"        I_BILLINGDOCUMENTITEMBASIC-SALESDOCUMENT
*"     VALUE(IV_BILLINGDOCUMENT) TYPE
*"        I_BILLINGDOCUMENTITEMBASIC-BILLINGDOCUMENT
*"  TABLES
*"      ET_RETURN TYPE  BAPIRET2_TAB
*"----------------------------------------------------------------------
  TRY.

      DATA(lo_wevo_envio_fatura) = NEW zclsd_co_si_envia_dados_fatura(  ).

      DATA(ls_envio_fatura) = VALUE zclsd_mt_dados_fatura(
                                        mt_dados_fatura-nfenum          = iv_nfenum
                                        mt_dados_fatura-code            = iv_code
                                        mt_dados_fatura-billingdocument = iv_billingdocument
                                        mt_dados_fatura-salesdocument   = iv_salesdocument
                              ).

      lo_wevo_envio_fatura->si_envia_dados_fatura_out( output = ls_envio_fatura ).

    CATCH cx_ai_system_fault.

      MESSAGE s000(zsd_ordem_wevo) INTO DATA(lv_message).

      et_return = VALUE #( id = 'ZSD_ORDEM_WEVO'
                           type = 'E'
                           number = '000'
                           message = lv_message
      ).

  ENDTRY.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.


ENDFUNCTION.
