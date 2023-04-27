"Name: \PR:SAPLJ_1B_NFE\FO:BLOCK_G\SE:END\EI
ENHANCEMENT 0 ZEIMM_NFE_ENTREGA.
IF wk_header-direct EQ '2' AND xmlh-e_cnpj EQ xmlh-g_cnpj.
  LOOP AT wk_item ASSIGNING FIELD-SYMBOL(<fs_wk_item>).
    IF <fs_wk_item>-reftyp NE 'BI'.
      DATA(lv_reftyp) = abap_true.
    ENDIF.
  ENDLOOP.
  IF lv_reftyp EQ abap_true.
  CLEAR: xmlh-g_cnpj,
         xmlh-g_xlgr,
         xmlh-g_nro,
         xmlh-g_xcpl,
         xmlh-g_xbairro,
         xmlh-g_cmun,
         xmlh-g_xmun,
         xmlh-g_uf,
         xmlh-g_xnome,
         xmlh-g_cep,
         xmlh-g_cpais,
         xmlh-g_xpais,
         xmlh-g_fone,
         xmlh-g_ie,
         xmlh-g_email.
  ENDIF.
ENDIF.
ENDENHANCEMENT.
