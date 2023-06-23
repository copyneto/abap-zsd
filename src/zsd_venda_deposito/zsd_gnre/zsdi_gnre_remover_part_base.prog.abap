*&---------------------------------------------------------------------*
*& Include ZSDI_GNRE_REMOVER_PART_BASE
*&---------------------------------------------------------------------*
  IF mv_icms_incl = ''.
    "Additional Rounding done here
    CALL METHOD get_rounding_factor
      EXPORTING
        iv_plant  = ms_komp-werks
      IMPORTING
        ev_factor = lv_factor.

    "Returns value including ISS or ICMS
    IF check_iss_active( ) = 'X'.
      ev_calc_base = ms_tax_result-iss_bas * lv_factor.
    ELSE.
      ev_calc_base = lv_factor * ( ms_komp-netwr
                   +  ms_tax_result-icms_amt
                   + ms_tax_result-iss_amt_prov
                   + ms_tax_result-iss_wta_prov
                   + ms_tax_result-iss_amt_serv
                   + ms_tax_result-iss_wta_serv
                   + ms_tax_result-pis_amt
                   + ms_tax_result-cofins_amt
*                   + ms_tax_result-icms_orig_part_amt
*                   + ms_tax_result-icms_dest_part_amt
*                   + ms_tax_result-icms_fcp_amt
*                   + ms_tax_result-icms_fcp_partilha_amt
                   - ms_tax_result-cofins_off
                   - ms_tax_result-pis_off
                   - ms_tax_result-iss_offset ).

      "For conhecimento the ICMS amount is stored in specific
      "conditions (Conhecimento ICMS and Conhecimento Sub.Trib.)
      IF check_cte_active( ) = 'X'.
        ev_calc_base = ev_calc_base + lv_factor *
                         ( ms_tax_result-conh_icm_amt
                         + ms_tax_result-conh_st_amt ).
      ENDIF.
    ENDIF.

  ELSE.
    ev_calc_base = ms_tax_data-net_amount.
  ENDIF.
