"Name: \FU:J_1B_NF_MAP_TO_XML\SE:BEGIN\EI
ENHANCEMENT 0 ZEI_SD_QUEBRA_LOTE_XML.
FIELD-SYMBOLS:
  <fs_wk_header> TYPE j_1bnfdoc.
ASSIGN ('(SAPLJ_1B_NFE)WK_HEADER') TO <fs_wk_header>.
IF <fs_wk_header> IS ASSIGNED.
  CLEAR <fs_wk_header>-ind_badi_ctrl.
ENDIF.

FIELD-SYMBOLS:
  <fs_wk_header_job> TYPE j_1bnfdoc.
ASSIGN ('(J_BNFECALLRFC)WK_HEADER') TO <fs_wk_header_job>.
IF <fs_wk_header_job> IS ASSIGNED.
  CLEAR <fs_wk_header_job>-ind_badi_ctrl.
ENDIF.

ENDENHANCEMENT.
