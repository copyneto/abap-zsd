
* Variáveis
*-----------------------------------------------------------------------
DATA: gv_ok_code_9000 TYPE sy-ucomm,
      gv_ok_code_9001 TYPE sy-ucomm,
      gv_ok_code_9002 TYPE sy-ucomm,
      gv_ok_code_9003 TYPE sy-ucomm,
      gv_ok_code_9004 TYPE sy-ucomm,
      gv_ok_code_9005 TYPE sy-ucomm,
      gv_ok_code_9006 TYPE sy-ucomm,
      gv_ok_code_9007 TYPE sy-ucomm,
      gv_ok_code_9008 TYPE sy-ucomm,
      gv_ok_code_9009 TYPE sy-ucomm,
      gv_ok_code_9010 TYPE sy-ucomm.

* Tabelas Internas e Work Area
*-----------------------------------------------------------------------
TABLES: sscrfields, ZSSD_GNREE011.

"Estrutura com os campos utilizados na tela de seleção
DATA: BEGIN OF gs_screen_params,
        credat    TYPE j_1bnfdoc-credat,     "Data de criação
        nf_credat TYPE datum,     "Data de criação
        dtpgto    TYPE datum,     "Data de pagamento
        docnum    TYPE j_1bnfdoc-docnum,     "Nº documento
        nfenum    TYPE j_1bnfdoc-nfenum,     "Nº documento nove posições
        series    TYPE j_1bnfdoc-series,     "Séries
        refkey    TYPE j_1bnflin-refkey,     "Ref.doc.origem
        fkart     TYPE vbrk-fkart,           "Tp.doc.faturamento
        bukrs     TYPE j_1bnfdoc-bukrs,      "Empresa
        branch    TYPE j_1bnfdoc-branch,     "Local de negócios
*        parid     TYPE j_1bnfdoc-parid,      "Identificação do parceiro
*        cgc       TYPE j_1bnfdoc-cgc,        "Code CGC
        regio     TYPE j_1bnfdoc-regio,      "Região
        num_guia  TYPE ztsd_gnret001-num_guia,   "Nº de Guia
        step      TYPE ztsd_gnret001-step,       "Etapa GNRE
        consumo   TYPE ztsd_gnret001-consumo,    "Consumidor Final
        auart     TYPE zssd_gnree001-auart,      "Tipo de documento de vendas
      END OF gs_screen_params.

DATA: gt_excluding_9000 TYPE TABLE OF sy-ucomm.

DATA: gv_ans TYPE c.
