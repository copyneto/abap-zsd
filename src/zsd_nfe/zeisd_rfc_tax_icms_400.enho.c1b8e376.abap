"Name: \PR:SAPLJ_1B_NFE\FO:MAP_TAX\SE:END\EI
ENHANCEMENT 0 ZEISD_RFC_TAX_ICMS_400.
* LSCHEPP - Tratativa Consignação - 05.07.2022 Início
IF wk_header-direct EQ '2' AND
   wk_header-fatura EQ abap_true.
  IF NOT gt_rfc_tax_icms_400[] IS INITIAL.
    DELETE gt_rfc_tax_icms_400 WHERE cst = space.
  ENDIF.
ENDIF.
* LSCHEPP - Tratativa Consignação - 05.07.2022 Fim
ENDENHANCEMENT.
