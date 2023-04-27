*&---------------------------------------------------------------------*
*&  Include           ZGNRE004CD01
*&---------------------------------------------------------------------*

CLASS lcl_gnre_report DEFINITION
                      FINAL
                      CREATE PRIVATE.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_s_nf_doc_lin,
        docnum  TYPE j_1bnfdoc-docnum,
        itmnum  TYPE j_1bnflin-itmnum,
        nfenum  TYPE j_1bnfdoc-nfenum,
        series  TYPE j_1bnfdoc-series,
        nftype  TYPE j_1bnfdoc-nftype,
        branch  TYPE j_1bnfdoc-branch,
        docdat  TYPE j_1bnfdoc-docdat,
        pstdat  TYPE j_1bnfdoc-pstdat,
        credat  TYPE j_1bnfdoc-credat,
        parid   TYPE j_1bnfdoc-parid,
        name1   TYPE j_1bnfdoc-name1,
        regio   TYPE j_1bnfdoc-regio,
        ort01   TYPE j_1bnfdoc-ort01,
        cgc     TYPE j_1bnfdoc-cgc,
        cpf     TYPE j_1bnfdoc-cpf,
        stains  TYPE j_1bnfdoc-stains,
        vbeln   TYPE ztsd_gnret019-vbeln,
        posnr   TYPE ztsd_gnret019-posnr,
        matnr   TYPE j_1bnflin-matnr,
        maktx   TYPE j_1bnflin-maktx,
        matkl   TYPE j_1bnflin-matkl,
        cean    TYPE j_1bnflin-cean,
        nbm     TYPE j_1bnflin-nbm,
        matorg  TYPE j_1bnflin-matorg,
        cfop    TYPE j_1bnflin-cfop,
        menge   TYPE j_1bnflin-menge,
        meins   TYPE j_1bnflin-meins,
        nfnett  TYPE j_1bnflin-nfnett,
        nfnet   TYPE j_1bnflin-nfnet,
        nfdis   TYPE j_1bnflin-nfdis,
        nffre   TYPE j_1bnflin-nffre,
        netoth  TYPE j_1bnflin-netoth,
* LSCHEPP - 8000006081 - GAP47 Relatório GNRE gerencial - 02.03.2023 Início
        p_mvast TYPE j_1bnflin-p_mvast,
* LSCHEPP - 8000006081 - GAP47 Relatório GNRE gerencial - 02.03.2023 Fim
        regio_a TYPE j_1bnfe_active-regio,
        nfyear  TYPE j_1bnfe_active-nfyear,
        nfmonth TYPE j_1bnfe_active-nfmonth,
        stcd1   TYPE j_1bnfe_active-stcd1,
        model   TYPE j_1bnfe_active-model,
        serie_a TYPE j_1bnfe_active-serie,
        nfnum9  TYPE j_1bnfe_active-nfnum9,
        docnum9 TYPE j_1bnfe_active-docnum9,
        cdv     TYPE j_1bnfe_active-cdv,
      END OF ty_s_nf_doc_lin,

      ty_tt_nf_doc_lin TYPE TABLE OF ty_s_nf_doc_lin WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_nf_stx,
        docnum      TYPE j_1bnfstx-docnum,
        itmnum      TYPE j_1bnfstx-itmnum,
        taxtyp      TYPE j_1bnfstx-taxtyp,
        base        TYPE j_1bnfstx-base,
        rate        TYPE j_1bnfstx-rate,
        taxval      TYPE j_1bnfstx-taxval,
        taxgrp      TYPE j_1bnfstx-taxgrp,
        subdivision TYPE j_1baj-subdivision,
      END OF ty_s_nf_stx,

      ty_tt_nf_stx TYPE TABLE OF ty_s_nf_stx WITH DEFAULT KEY.

    CLASS-METHODS create_instance
      RETURNING
        VALUE(ro_instance) TYPE REF TO lcl_gnre_report.
    METHODS main.

  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA: gt_nf_doc_lin TYPE ty_tt_nf_doc_lin,
          gt_nf_stx     TYPE ty_tt_nf_stx,
          gt_zgnret004  TYPE TABLE OF ztsd_gnret004,
          gt_zgnret019  TYPE TABLE OF ztsd_gnret019,
          gt_outtab     TYPE TABLE OF zssd_gnree010,
          go_alv_grid   TYPE REF TO cl_salv_table.

    METHODS select_data
      RAISING
        zcxsd_gnre_automacao.
    METHODS process_data
      RAISING
        zcxsd_gnre_automacao.
    METHODS show_data
      RAISING
        zcxsd_gnre_automacao.

ENDCLASS.
