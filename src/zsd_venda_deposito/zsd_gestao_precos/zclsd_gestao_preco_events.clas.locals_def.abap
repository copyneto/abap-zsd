*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

* ===========================================================================
* Constantes globais
* ===========================================================================

CONSTANTS:

  BEGIN OF gc_tipo_operacao,
    inclusao       TYPE char01 VALUE 'I',
    alteracao      TYPE char01 VALUE 'U',
    exclusao       TYPE char01 VALUE 'E',
    troca_umb      TYPE char01 VALUE 'T',
    aumento        TYPE char01 VALUE 'A',
    rebaixa        TYPE char01 VALUE 'R',

    inclusao_a817  TYPE ztsd_preco_i-operation_type VALUE 'IA817',
    inclusao_a816  TYPE ztsd_preco_i-operation_type VALUE 'IA816',
    inclusao_a627  TYPE ztsd_preco_i-operation_type VALUE 'IA627',
    inclusao_a626  TYPE ztsd_preco_i-operation_type VALUE 'IA626',
    alteracao_a817 TYPE ztsd_preco_i-operation_type VALUE 'UA817',
    alteracao_a816 TYPE ztsd_preco_i-operation_type VALUE 'UA816',
    alteracao_a627 TYPE ztsd_preco_i-operation_type VALUE 'UA627',
    alteracao_a626 TYPE ztsd_preco_i-operation_type VALUE 'UA626',
    exclusao_a817  TYPE ztsd_preco_i-operation_type VALUE 'EA817',
    exclusao_a816  TYPE ztsd_preco_i-operation_type VALUE 'EA816',
    exclusao_a627  TYPE ztsd_preco_i-operation_type VALUE 'EA627',
    exclusao_a626  TYPE ztsd_preco_i-operation_type VALUE 'EA626',
    troca_umb_a817 TYPE ztsd_preco_i-operation_type VALUE 'TA817',
    troca_umb_a816 TYPE ztsd_preco_i-operation_type VALUE 'TA816',
    troca_umb_a627 TYPE ztsd_preco_i-operation_type VALUE 'TA627',
    troca_umb_a626 TYPE ztsd_preco_i-operation_type VALUE 'TA626',
    aumento_a817   TYPE ztsd_preco_i-operation_type VALUE 'AA817',
    aumento_a816   TYPE ztsd_preco_i-operation_type VALUE 'AA816',
    aumento_a627   TYPE ztsd_preco_i-operation_type VALUE 'AA627',
    aumento_a626   TYPE ztsd_preco_i-operation_type VALUE 'AA626',
    rebaixa_a817   TYPE ztsd_preco_i-operation_type VALUE 'RA817',
    rebaixa_a816   TYPE ztsd_preco_i-operation_type VALUE 'RA816',
    rebaixa_a627   TYPE ztsd_preco_i-operation_type VALUE 'RA627',
    rebaixa_a626   TYPE ztsd_preco_i-operation_type VALUE 'RA626',

  END OF gc_tipo_operacao,

  BEGIN OF gc_param_kschl_zpr0,
    modulo TYPE ztca_param_val-modulo VALUE 'SD' ##NO_TEXT,
    chave1 TYPE ztca_param_val-chave1 VALUE 'GESTAO_PRECO' ##NO_TEXT,
    chave2 TYPE ztca_param_val-chave2 VALUE 'TP_COND_PRECO' ##NO_TEXT,
    chave3 TYPE ztca_param_val-chave3 VALUE 'KSCHL' ##NO_TEXT,
  END OF gc_param_kschl_zpr0,

  BEGIN OF gc_param_kschl_zvmc,
    modulo TYPE ztca_param_val-modulo VALUE 'SD' ##NO_TEXT,
    chave1 TYPE ztca_param_val-chave1 VALUE 'GESTAO_PRECO' ##NO_TEXT,
    chave2 TYPE ztca_param_val-chave2 VALUE 'TP_COND_MINIMO' ##NO_TEXT,
    chave3 TYPE ztca_param_val-chave3 VALUE 'KSCHL' ##NO_TEXT,
  END OF gc_param_kschl_zvmc,

  BEGIN OF gc_param_kschl_zalt,
    modulo TYPE ztca_param_val-modulo VALUE 'SD' ##NO_TEXT,
    chave1 TYPE ztca_param_val-chave1 VALUE 'GESTAO_PRECO' ##NO_TEXT,
    chave2 TYPE ztca_param_val-chave2 VALUE 'TP_COND_INVASAO' ##NO_TEXT,
    chave3 TYPE ztca_param_val-chave3 VALUE 'KSCHL' ##NO_TEXT,
  END OF gc_param_kschl_zalt,

  BEGIN OF gc_preco,
    cond_no      TYPE knumh VALUE '$000000001',
    aplicacao_sd TYPE kappl VALUE 'V',
  END OF gc_preco,

  BEGIN OF gc_criticalidade,
    branco   TYPE i VALUE 0,
    vermelho TYPE i VALUE 1,
    amarelo  TYPE i VALUE 2,
    verde    TYPE i VALUE 3,
  END OF gc_criticalidade,

  BEGIN OF gc_operacao,
    eliminar   TYPE msgfn VALUE '003',
    modificar  TYPE msgfn VALUE '004',
    substituir TYPE msgfn VALUE '005',
    original   TYPE msgfn VALUE '009',
    esperar    TYPE msgfn VALUE '023',
    reenviar   TYPE msgfn VALUE '018',
  END OF gc_operacao,

  BEGIN OF gc_tipo_escala,
    possivel       TYPE stfkz VALUE ' ',
    escala_inicial TYPE stfkz VALUE 'A',
    escala_ate     TYPE stfkz VALUE 'B',
    nao_utilizado  TYPE stfkz VALUE 'C',
    intervalo_ate  TYPE stfkz VALUE 'D',
  END OF gc_tipo_escala,

  BEGIN OF gc_regra_calc_cond,
    quantidade TYPE krech VALUE 'C',
  END OF gc_regra_calc_cond.

* ===========================================================================
* Tipos globais
* ===========================================================================

TYPES:
  ty_t_usr21_key TYPE STANDARD TABLE OF usr21-bname,

  BEGIN OF ty_usr21,
    bname      TYPE usr21-bname,
    persnumber TYPE usr21-persnumber,
    name_text  TYPE adrp-name_text,
  END OF ty_usr21,

  ty_t_usr21 TYPE SORTED TABLE OF ty_usr21
             WITH NON-UNIQUE KEY bname,

  BEGIN OF ty_t001w,
    werks TYPE t001w-werks,
    name1 TYPE t001w-name1,
  END OF ty_t001w,

  ty_t_t001w TYPE SORTED TABLE OF ty_t001w
             WITH NON-UNIQUE KEY werks,

  ty_a817    TYPE a817,

  ty_t_a817  TYPE SORTED TABLE OF ty_a817
             WITH NON-UNIQUE KEY vtweg pltyp matnr werks,

  ty_a816    TYPE a816,

  ty_t_a816  TYPE SORTED TABLE OF ty_a816
            WITH NON-UNIQUE KEY vtweg werks matnr,

  BEGIN OF ty_tvtw,
    vtweg TYPE tvtw-vtweg,
  END OF ty_tvtw,

  ty_t_tvtw TYPE SORTED TABLE OF ty_tvtw
            WITH NON-UNIQUE KEY vtweg,

  BEGIN OF ty_t189,
    pltyp TYPE t189-pltyp,
  END OF ty_t189,

  ty_t_t189 TYPE SORTED TABLE OF ty_t189
            WITH NON-UNIQUE KEY pltyp,

  BEGIN OF ty_mara,
    matnr TYPE mara-matnr,
    meins TYPE mara-meins,
    meinh TYPE marm-meinh,
  END OF ty_mara,

  ty_t_mara TYPE SORTED TABLE OF ty_mara
            WITH NON-UNIQUE KEY matnr,

  ty_a627   TYPE a627,

  ty_t_a627 TYPE SORTED TABLE OF ty_a627
            WITH NON-UNIQUE KEY kunnr ,
  "WITH NON-UNIQUE KEY werks pltyp,

  ty_a626   TYPE a626,

  ty_t_a626 TYPE SORTED TABLE OF ty_a626
            WITH NON-UNIQUE KEY  vtweg werks matnr,

  BEGIN OF ty_mbew,
    matnr TYPE mbew-matnr,
    bwkey TYPE mbew-bwkey,
    bwtar TYPE mbew-bwtar,
    lfgja TYPE mbew-lfgja,
    lfmon TYPE mbew-lfmon,
    stprs TYPE mbew-stprs,
  END OF ty_mbew,

  ty_t_mbew TYPE SORTED TABLE OF ty_mbew
             WITH NON-UNIQUE KEY matnr bwkey,


  BEGIN OF ty_marm ,
    matnr TYPE marm-matnr,
    meinh TYPE marm-meinh,
    umrez TYPE marm-umrez,
    ean11 TYPE marm-ean11,
  END OF ty_marm,

  ty_t_marm TYPE TABLE OF ty_marm,

  BEGIN OF ty_knvv ,
    kunnr TYPE knvv-kunnr,
    vtweg TYPE knvv-vtweg,
    pltyp TYPE knvv-pltyp,
  END OF ty_knvv,

  ty_t_knvv TYPE SORTED TABLE OF ty_knvv
             WITH NON-UNIQUE KEY vtweg pltyp,

  BEGIN OF ty_konp,
    knumh    TYPE konp-knumh,
    kopos    TYPE konp-kopos,
    kbetr    TYPE konp-kbetr,
    konwa    TYPE konp-konwa,
    kmein    TYPE konp-kmein,
    mxwrt    TYPE konp-mxwrt,
    gkwrt    TYPE konp-gkwrt,
    loevm_ko TYPE konp-loevm_ko,
  END OF ty_konp,

  ty_t_konp      TYPE SORTED TABLE OF ty_konp
                 WITH NON-UNIQUE KEY knumh,

  ty_t_knumh_key TYPE STANDARD TABLE OF konp-knumh.
