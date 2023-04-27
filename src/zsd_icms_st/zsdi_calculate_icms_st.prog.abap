*&---------------------------------------------------------------------*
*& Include ZSDI_CALCULATE_ICMS_ST
*&---------------------------------------------------------------------*

  DATA lv_basest TYPE mty_taxamount.
  DATA lv_base1  TYPE mty_taxamount.
  DATA lv_base2  TYPE mty_taxamount.

  CLEAR: lv_basest, lv_base1.

  DO 1 TIMES.
    " Relevante apenas para processos SD
    CHECK ms_komk-kappl = 'V'.
    " Checar se é interno no Mato Grosso do Sul e o preço mínimo maior que a base
    CHECK ( ms_komp-txreg_sf = 'MS' AND ms_komp-txreg_st = 'MS'
*          OR  ms_komp-txreg_sf = 'MT' AND ms_komp-txreg_st = 'MT'
          )
    AND lv_effective_min > lv_base
    AND lv_min GT '0.000000' AND NOT iv_basered1 IS INITIAL.
    " Base reduzida do ICMS ST é 41,18 e não 58,82
    lv_base1 = '1.000000' - iv_basered1.
    " Modificar a base fazendo a redução
    lv_basest   =  ( lv_min * lv_base1 ).
    IF lv_basest GT '0.000000'.
      ev_base = lv_basest.
    ENDIF.
  ENDDO.

  DO 1 TIMES.
    " Relevante apenas para processos SD
    CHECK ms_komk-kappl = 'V'.
    " Checar se é interno no Mato Grosso e o preço mínimo
*      CHECK  ms_komp-txreg_sf = 'MT' AND ms_komp-txreg_st = 'MT'
    CHECK  ms_komp-txreg_st = 'MT'
    AND lv_effective_min GT '0.000000' .
    " Compara qual a maior base
    lv_base1 = '1.000000' - iv_basered1.
    lv_base1 = ( lv_min * lv_base1 ).
    lv_base2 = '1.000000' - iv_basered1.
    lv_base2 = ( lv_base * lv_base2 ).

    IF lv_base1 GT '0.000000'  AND lv_base1 GT lv_base2 .
      ev_base = lv_base1.
      ev_amount = lv_base1 * iv_rate.
      ev_amount = ev_amount - lv_val_icms.
    ENDIF.
  ENDDO.

  DO 1 TIMES.
    " Relevante apenas para processos SD
    CHECK ms_komk-kappl EQ 'V' AND lv_effective_min GT '0.000000' .
    DATA(lv_perc_difal) = CONV ztsd_icmsdif-porcentagem( 0 ).

    SELECT SINGLE porcentagem
      FROM ztsd_icmsdif
      INTO lv_perc_difal
     WHERE uf_emis   EQ ms_komp-txreg_sf
       AND uf_rece   EQ ms_komp-txreg_st
       AND matnr     EQ ms_komp-matnr
       AND date_from LE ms_komk-prsdt
       AND date_to   GE ms_komk-prsdt.

    IF sy-subrc IS NOT INITIAL.
      SELECT SINGLE porcentagem
        FROM ztsd_icmsdif
        INTO lv_perc_difal
       WHERE uf_emis   EQ ms_komp-txreg_sf
         AND uf_rece   EQ ms_komp-txreg_st
         AND matkl     EQ ms_komp-matkl
         AND date_from LE ms_komk-prsdt
         AND date_to   GE ms_komk-prsdt.
    ENDIF.

    CHECK lv_perc_difal IS NOT INITIAL.

    DATA(lv_baseMA) = CONV mty_taxamount( ms_tax_data-net_amount + ( ms_tax_data-net_amount * ms_tax_data-ipirate ) ).
    lv_baseMA = ( lv_baseMA * ( lv_perc_difal / 100 ) ).

    IF lv_baseMA > lv_min.
      lv_base1 = ms_tax_data-net_amount + ( ms_tax_data-net_amount * ms_tax_data-ipirate ).
      lv_base1 = lv_base1 + ( lv_base1 * ( ms_tax_data-subtribsurcharge ) ).
    ENDIF.

    "Verificar se existe redução de base)
    IF iv_basered1 GT '0.000000'.
      lv_base2 = 1000000 - iv_basered1.
      lv_base1 = ( lv_base1 * lv_base2 ).
    ENDIF.

    IF lv_base1 GT '0.000000'.
      ev_base = lv_base1.
      lv_base1 = lv_base1 * iv_rate.

* Calculate ICMS value to compare with
      IF ms_tax_control-usage <> mc_consum.
*   Apply SubTrib ICMS base reduction
        lv_val_icms =
        iv_icms_amount * ( 1 - ms_tax_data-subtribicms ).
      ELSE.
        lv_val_icms = iv_icms_amount.
      ENDIF.

* SubTrib value is difference between the two ICMS amounts
      ev_amount = lv_base1 - lv_val_icms.

      CLEAR lv_minimum_price_used.
      cl_j1b_modbcst_determination=>get_instance( )->determine_modbcst( iv_calc_method = ms_tax_data-subtribsurtype "2652169
                                                                    iv_surcharge_rate_filled = lv_surcharge_rate_filled "2652169
                                                                    iv_minimum_price_used = lv_minimum_price_used "2652169
                                                                    iv_docnumber = mv_document_source "2923600
                                                                    iv_item_number = mv_document_item_source ).
    ENDIF.

  ENDDO.
