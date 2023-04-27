*&---------------------------------------------------------------------*
*& Include          ZSDI_GNRE_CALC_ICMS_PARTILHA
*&---------------------------------------------------------------------*

IF ms_komv_frm-kschl = 'IBRX'.

  NEW zclsd_gnre_calc_icms_partilha( )->calculate(
     EXPORTING
       is_komk                 = is_komk
       is_komp                 = is_komp
       it_komv                 = it_komv
*       in_tax_result           = ms_tax_result
     CHANGING
       cv_orig_partilha_amount = ms_tax_result-icms_orig_part_amt
       cv_dest_partilha_amount = ms_tax_result-icms_dest_part_amt
       cv_fcp_partilha_amount  = ms_tax_result-icms_fcp_partilha_amt
       cv_orig_partilha_base   = ms_tax_result-icms_orig_part_base
       cv_dest_partilha_base   = ms_tax_result-icms_dest_part_base
       cv_fcp_partilha_base    = ms_tax_result-icms_fcp_partilha_base
       cv_orig_partilha_ebase  = ms_tax_result-icms_orig_part_exc
       cv_dest_partilha_ebase  = ms_tax_result-icms_dest_part_exc
       cv_fcp_partilha_ebase   = ms_tax_result-icms_fcp_partilha_ebas
   ).

ENDIF.
