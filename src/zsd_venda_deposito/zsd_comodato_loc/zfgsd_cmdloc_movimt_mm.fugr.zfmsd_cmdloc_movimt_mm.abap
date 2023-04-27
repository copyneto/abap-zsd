FUNCTION zfmsd_cmdloc_movimt_mm.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_VBAK) TYPE  TDS_XVBAK OPTIONAL
*"     VALUE(IT_VBAP) TYPE  TT_VBAPVB OPTIONAL
*"  EXPORTING
*"     VALUE(EV_MATDOC) TYPE  BAPI2017_GM_HEAD_RET-MAT_DOC
*"     VALUE(EV_DOCYEAR) TYPE  BAPI2017_GM_HEAD_RET-DOC_YEAR
*"----------------------------------------------------------------------

  DATA(lo_object) = NEW zclsd_cmdloc_devol_mercadoria( ).

  lo_object->movimento_mm( EXPORTING is_vbak     = is_vbak
                                     it_vbap     = it_vbap[]
                           IMPORTING ev_mat_doc  = ev_matdoc
                                     ev_doc_year = ev_docyear
                                     ).

ENDFUNCTION.
