"Name: \PR:SAPMV45A\FO:USEREXIT_SAVE_DOCUMENT_PREPARE\SE:BEGIN\EI
ENHANCEMENT 0 ZEISD_SAVE_DOCUMENT_PREPARE.

  INCLUDE zsdi_ckpt_devolucao_costcenter IF FOUND.

  INCLUDE zsdi_valida_rfb IF FOUND.

  INCLUDE zsdi_verifica_costcenter_arq IF FOUND.

  INCLUDE zsdi_valida_devolucao IF FOUND.

  INCLUDE zsdi_valida_qtd_excedente IF FOUND.

  INCLUDE zsdi_tratar_devolucao_st_rs IF FOUND.

  INCLUDE zsdi_subst_prod_costcenter IF FOUND.

  INCLUDE zsdi_verifica_dupli_ov_cafet IF FOUND.

  INCLUDE zsdi_wevo_order IF FOUND.

ENDENHANCEMENT.
