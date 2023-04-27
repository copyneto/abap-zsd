*&---------------------------------------------------------------------*
*&  Include           ZSDI_GNRE004_TOP
*&---------------------------------------------------------------------*

*--------------------------------------------------------------------*
* Tabelas Internas e Work Area
*-----------------------------------------------------------------------
TABLES: sscrfields.

"Estrutura com os campos utilizados na tela de seleção
DATA: BEGIN OF gs_screen_params,
        credat    TYPE j_1bnfdoc-credat,      "Data de criação
        nf_credat TYPE ze_gnre_nf_credat,     "Data de criação
        dtpgto    TYPE ztsd_gnret001-dtpgto,  "Data de pagamento
        docnum    TYPE j_1bnfdoc-docnum,      "Nº documento
        nfenum    TYPE j_1bnfdoc-nfenum,      "Nº documento nove posições
        series    TYPE j_1bnfdoc-series,      "Séries
        vbeln_va  TYPE vbeln_va,              "Ordem de venda
        bukrs     TYPE j_1bnfdoc-bukrs,       "Empresa
        branch    TYPE j_1bnfdoc-branch,      "Local de negócios
        cgc       TYPE j_1bnfdoc-cgc,         "Code CGC
        regio     TYPE j_1bnfdoc-regio,       "Região
        step      TYPE ztsd_gnret001-step,    "Etapa GNRE
        hkont     TYPE bseg-hkont,            "Conta Contábil
        matnr     TYPE mara-matnr,            "Material
        matkl     TYPE mara-matkl,            "Grupo de Mercadorias
      END OF gs_screen_params.
