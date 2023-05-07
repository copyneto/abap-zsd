FUNCTION-POOL zfgsd_cockpit_faturamento.    "MESSAGE-ID ..

CONSTANTS:
  "! Constantes para tabela de parâmetros
  BEGIN OF gc_param_bloq_remessa,
    modulo TYPE ze_param_modulo VALUE 'SD',
    chave1 TYPE ztca_param_par-chave1 VALUE 'ADM_FATURAMENTO',
    chave2 TYPE ztca_param_par-chave2 VALUE 'BLOQ_REMESSA',
    chave3 TYPE ztca_param_par-chave3 VALUE 'LIB_ROTA',
  END OF gc_param_bloq_remessa.

* INCLUDE LZFGSD_COCKPIT_FATURAMENTOD...     " Local class definition
DATA gv_app_fat TYPE abap_bool VALUE abap_true.
