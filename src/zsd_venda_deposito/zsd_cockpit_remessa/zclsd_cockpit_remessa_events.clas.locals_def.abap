*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

* ===========================================================================
* Constantes globais
* ===========================================================================
  CONSTANTS:
    BEGIN OF gc_param_lifsk_gr,
      modulo TYPE ztca_param_val-modulo VALUE 'SD',
      chave1 TYPE ztca_param_val-chave1 VALUE 'ADM_FATURAMENTO',
      chave2 TYPE ztca_param_val-chave2 VALUE 'BLOQ_REMESSA',
*      chave3 TYPE ztca_param_val-chave3 VALUE 'LIB_ROTA',
      chave3 TYPE ztca_param_val-chave3 VALUE 'ANALISE',
    END OF gc_param_lifsk_gr,

    BEGIN OF gc_param_lifsk_lr,
      modulo TYPE ztca_param_val-modulo VALUE 'SD',
      chave1 TYPE ztca_param_val-chave1 VALUE 'ADM_FATURAMENTO',
      chave2 TYPE ztca_param_val-chave2 VALUE 'BLOQ_REMESSA',
*      chave3 TYPE ztca_param_val-chave3 VALUE 'ENV_ROTA',
      chave3 TYPE ztca_param_val-chave3 VALUE 'LIB_ROTA',
    END OF gc_param_lifsk_lr,

    BEGIN OF gc_param_lifsk_er,
      modulo TYPE ztca_param_val-modulo VALUE 'SD',
      chave1 TYPE ztca_param_val-chave1 VALUE 'ADM_FATURAMENTO',
      chave2 TYPE ztca_param_val-chave2 VALUE 'BLOQ_REMESSA',
      chave3 TYPE ztca_param_val-chave3 VALUE 'EM_ROTA',
    END OF gc_param_lifsk_er,

    BEGIN OF gc_param_lifsk_el,
      modulo TYPE ztca_param_val-modulo VALUE 'SD',
      chave1 TYPE ztca_param_val-chave1 VALUE 'ADM_FATURAMENTO',
      chave2 TYPE ztca_param_val-chave2 VALUE 'BLOQ_REMESSA',
      chave3 TYPE ztca_param_val-chave3 VALUE 'ELIM_REM',
    END OF gc_param_lifsk_el,

    BEGIN OF gc_param_exit_mv50afz3,
      modulo TYPE ztca_param_val-modulo VALUE 'SD',
      chave1 TYPE ztca_param_val-chave1 VALUE 'ADM_FATURAMENTO',
      chave2 TYPE ztca_param_val-chave2 VALUE 'EXIT',
      chave3 TYPE ztca_param_val-chave3 VALUE 'MV50AFZ3',
    END OF gc_param_exit_mv50afz3,

    BEGIN OF gc_param_vstel,
      modulo TYPE ztca_param_val-modulo VALUE 'SD',
      chave1 TYPE ztca_param_val-chave1 VALUE 'ADM_FATURAMENTO',
      chave2 TYPE ztca_param_val-chave2 VALUE 'WMS_CENTROS',
      chave3 TYPE ztca_param_val-chave3 VALUE '',
    END OF gc_param_vstel,

    BEGIN OF gc_param_lprio,
      modulo TYPE ztca_param_val-modulo VALUE 'SD',
      chave1 TYPE ztca_param_val-chave1 VALUE 'ADM_FATURAMENTO',
      chave2 TYPE ztca_param_val-chave2 VALUE 'FATURA_CARREGA',
      chave3 TYPE ztca_param_val-chave3 VALUE '',
    END OF gc_param_lprio,

    BEGIN OF gc_param_block_rm72,
      modulo TYPE ztca_param_val-modulo VALUE 'SD',
      chave1 TYPE ztca_param_val-chave1 VALUE 'ADM_FATURAMENTO',
      chave2 TYPE ztca_param_val-chave2 VALUE 'BLOQ_DF_TM2001_02_06',
    END OF gc_param_block_rm72,

    BEGIN OF gc_param_block_rm74,
      modulo TYPE ztca_param_val-modulo VALUE 'SD',
      chave1 TYPE ztca_param_val-chave1 VALUE 'ADM_FATURAMENTO',
      chave2 TYPE ztca_param_val-chave2 VALUE 'BLOQ_DF_AGUARDA',
    END OF gc_param_block_rm74,

    BEGIN OF gc_authority,
      release_to_routing TYPE activ_auth VALUE '01',    " Liberar para Roteirização
      send_to_routing    TYPE activ_auth VALUE '02',    " Enviar para Roteirização
      set_delivery_block TYPE activ_auth VALUE '03',    " Definir bloqueio de Remessa
      rmv_delivery_block TYPE activ_auth VALUE '04',    " Retirar bloqueio de Remessa
      delete_delivery    TYPE activ_auth VALUE '05',    " Eliminar Remessa
      check_param        TYPE activ_auth VALUE '06',    " Verificar Parâmetros
    END OF gc_authority.
