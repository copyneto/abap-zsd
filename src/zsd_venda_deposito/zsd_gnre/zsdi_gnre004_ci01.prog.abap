*&---------------------------------------------------------------------*
*& Include          ZSDI_GNRE004_CI01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  Include           ZGNRE004CI01
*&---------------------------------------------------------------------*

CLASS lcl_gnre_report IMPLEMENTATION.

  METHOD create_instance.
    ro_instance = NEW lcl_gnre_report( ).
  ENDMETHOD.

  METHOD main.

    TRY.
        select_data( ).

        process_data( ).

        show_data( ).

      CATCH zcxsd_gnre_automacao INTO DATA(lr_cx_gnre_automacao).
        lr_cx_gnre_automacao->display( ).

    ENDTRY.

  ENDMETHOD.

  METHOD select_data.

    DATA: lr_consumo TYPE RANGE OF ztsd_gnret001-consumo.

    IF s_credat[] IS INITIAL AND s_nfcdat[] IS INITIAL AND
       s_dtpgto[] IS INITIAL AND s_docnum[] IS INITIAL.
      "Favor informar ao menos uma das datas ou Nº documento (Spool).
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_inform_a_date.
    ENDIF.

    lr_consumo = COND #( WHEN p_cfinal = abap_true THEN
                           VALUE #( ( sign   = 'I'
                                      option = 'EQ'
                                      low    = 'X'  ) )
                         WHEN p_contri = abap_true THEN
                           VALUE #( ( sign   = 'I'
                                      option = 'EQ'
                                      low    = ''   ) )
                         ELSE
                           VALUE #( ) ).

    SELECT DISTINCT
           j_1bnfdoc~docnum
           j_1bnflin~itmnum
           j_1bnfdoc~nfenum
           j_1bnfdoc~series
           j_1bnfdoc~nftype
           j_1bnfdoc~branch
           j_1bnfdoc~docdat
           j_1bnfdoc~pstdat
           j_1bnfdoc~credat
           j_1bnfdoc~parid
           j_1bnfdoc~name1
           j_1bnfdoc~regio
           j_1bnfdoc~ort01
           j_1bnfdoc~cgc
           j_1bnfdoc~cpf
           j_1bnfdoc~stains
           j_1bnflin~refkey
           j_1bnflin~refitm
           j_1bnflin~matnr
           j_1bnflin~maktx
           j_1bnflin~matkl
           j_1bnflin~cean
           j_1bnflin~nbm
           j_1bnflin~matorg
           j_1bnflin~cfop
           j_1bnflin~menge
           j_1bnflin~meins
           j_1bnflin~nfnett
           j_1bnflin~nfnet
           j_1bnflin~nfdis
           j_1bnflin~nffre
           j_1bnflin~netoth
* LSCHEPP - 8000006081 - GAP47 Relatório GNRE gerencial - 02.03.2023 Início
           j_1bnflin~p_mvast
* LSCHEPP - 8000006081 - GAP47 Relatório GNRE gerencial - 02.03.2023 Fim
           j_1bnfe_active~regio
           j_1bnfe_active~nfyear
           j_1bnfe_active~nfmonth
           j_1bnfe_active~stcd1
           j_1bnfe_active~model
           j_1bnfe_active~serie
           j_1bnfe_active~nfnum9
           j_1bnfe_active~docnum9
           j_1bnfe_active~cdv
      FROM ztsd_gnret001
      INNER JOIN j_1bnfdoc
        ON ( j_1bnfdoc~docnum = ztsd_gnret001~docnum )
      INNER JOIN j_1bnfe_active
        ON ( j_1bnfe_active~docnum = j_1bnfdoc~docnum )
      INNER JOIN j_1bnflin
        ON ( j_1bnflin~docnum = j_1bnfdoc~docnum )
      INTO TABLE gt_nf_doc_lin
      WHERE ztsd_gnret001~docnum    IN s_docnum
        AND ztsd_gnret001~step      IN s_step
        AND ztsd_gnret001~consumo   IN lr_consumo
        AND ztsd_gnret001~guiacompl =  abap_false
        AND ztsd_gnret001~credat    IN s_credat
        AND ztsd_gnret001~bukrs     IN s_bukrs
        AND ztsd_gnret001~branch    IN s_branc
        AND ztsd_gnret001~dtpgto    IN s_dtpgto
* LSCHEPP - 8000006080 - GAP47 Relatório GNRE gerencial - 02.03.2023 Início
        AND j_1bnfdoc~parid         NE '2000000000' "Cliente Ecommerce
* LSCHEPP - 8000006080 - GAP47 Relatório GNRE gerencial - 02.03.2023 Fim
        AND j_1bnfdoc~credat        IN s_nfcdat
        AND j_1bnfdoc~series        IN s_serie
        AND j_1bnfdoc~nfenum        IN s_nfenum
        AND j_1bnfdoc~regio         IN s_regio
        AND j_1bnfdoc~cgc           IN s_cgc
        AND j_1bnflin~matnr         IN s_matnr
        AND j_1bnflin~matkl         IN s_matkl.

* LSCHEPP - 8000006080 - GAP47 Relatório GNRE gerencial - 02.03.2023 Início
    SELECT DISTINCT
           j_1bnfdoc~docnum
           j_1bnflin~itmnum
           j_1bnfdoc~nfenum
           j_1bnfdoc~series
           j_1bnfdoc~nftype
           j_1bnfdoc~branch
           j_1bnfdoc~docdat
           j_1bnfdoc~pstdat
           j_1bnfdoc~credat
           j_1bnfnad~parid
           j_1bnfnad~name1
           j_1bnfnad~regio
           j_1bnfnad~ort01
           j_1bnfnad~cgc
           j_1bnfnad~cpf
           j_1bnfnad~stains
           j_1bnflin~refkey
           j_1bnflin~refitm
           j_1bnflin~matnr
           j_1bnflin~maktx
           j_1bnflin~matkl
           j_1bnflin~cean
           j_1bnflin~nbm
           j_1bnflin~matorg
           j_1bnflin~cfop
           j_1bnflin~menge
           j_1bnflin~meins
           j_1bnflin~nfnett
           j_1bnflin~nfnet
           j_1bnflin~nfdis
           j_1bnflin~nffre
           j_1bnflin~netoth
* LSCHEPP - 8000006081 - GAP47 Relatório GNRE gerencial - 02.03.2023 Início
           j_1bnflin~p_mvast
* LSCHEPP - 8000006081 - GAP47 Relatório GNRE gerencial - 02.03.2023 Fim
           j_1bnfe_active~regio
           j_1bnfe_active~nfyear
           j_1bnfe_active~nfmonth
           j_1bnfe_active~stcd1
           j_1bnfe_active~model
           j_1bnfe_active~serie
           j_1bnfe_active~nfnum9
           j_1bnfe_active~docnum9
           j_1bnfe_active~cdv
      FROM ztsd_gnret001
      INNER JOIN j_1bnfdoc
        ON ( j_1bnfdoc~docnum = ztsd_gnret001~docnum )
      INNER JOIN j_1bnfe_active
        ON ( j_1bnfe_active~docnum = j_1bnfdoc~docnum )
      INNER JOIN j_1bnflin
        ON ( j_1bnflin~docnum = j_1bnfdoc~docnum )
      INNER JOIN j_1bnfnad
        ON ( j_1bnfnad~docnum = j_1bnfdoc~docnum
             AND j_1bnfnad~parvw = 'AG' )
      APPENDING TABLE gt_nf_doc_lin
      WHERE ztsd_gnret001~docnum    IN s_docnum
        AND ztsd_gnret001~step      IN s_step
        AND ztsd_gnret001~consumo   IN lr_consumo
        AND ztsd_gnret001~guiacompl =  abap_false
        AND ztsd_gnret001~credat    IN s_credat
        AND ztsd_gnret001~bukrs     IN s_bukrs
        AND ztsd_gnret001~branch    IN s_branc
        AND ztsd_gnret001~dtpgto    IN s_dtpgto
        AND j_1bnfdoc~parid         EQ '2000000000' "Cliente Ecommerce
        AND j_1bnfdoc~credat        IN s_nfcdat
        AND j_1bnfdoc~series        IN s_serie
        AND j_1bnfdoc~nfenum        IN s_nfenum
        AND j_1bnfdoc~regio         IN s_regio
        AND j_1bnfdoc~cgc           IN s_cgc
        AND j_1bnflin~matnr         IN s_matnr
        AND j_1bnflin~matkl         IN s_matkl.
* LSCHEPP - 8000006080 - GAP47 Relatório GNRE gerencial - 02.03.2023 Fim

* LSCHEPP - 8000006080 - GAP47 Relatório GNRE gerencial - 02.03.2023 Início
*    IF sy-subrc IS NOT INITIAL.
    IF gt_nf_doc_lin IS INITIAL.
* LSCHEPP - 8000006080 - GAP47 Relatório GNRE gerencial - 02.03.2023 Fim

      "Nenhum registro encontrado.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_data_not_found.
    ENDIF.

    "Obtêm os dados do cálculo ZSUB
    SELECT *
      FROM ztsd_gnret004
      INTO TABLE gt_zgnret004
      FOR ALL ENTRIES IN gt_nf_doc_lin
      WHERE docnum  = gt_nf_doc_lin-docnum
        AND itmnum  = gt_nf_doc_lin-itmnum.

    SORT gt_zgnret004 BY docnum itmnum.

    "Obtêm os dados do cálculo da Partilha ICMS
    SELECT *
      FROM ztsd_gnret019
      INTO TABLE gt_zgnret019
      FOR ALL ENTRIES IN gt_nf_doc_lin
      WHERE vbeln = gt_nf_doc_lin-vbeln
        AND posnr = gt_nf_doc_lin-posnr.

    IF gt_zgnret004 IS INITIAL AND gt_zgnret019 IS INITIAL.

      "Nenhum registro encontrado.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_data_not_found.
    ENDIF.

    SELECT j_1bnfstx~docnum
           j_1bnfstx~itmnum
           j_1bnfstx~taxtyp
           j_1bnfstx~base
           j_1bnfstx~rate
           j_1bnfstx~taxval
           j_1bnfstx~taxgrp
           j_1baj~subdivision
      FROM j_1bnfstx
      INNER JOIN j_1baj
        ON ( j_1baj~taxtyp = j_1bnfstx~taxtyp )
      INTO TABLE gt_nf_stx
      FOR ALL ENTRIES IN gt_nf_doc_lin
      WHERE docnum = gt_nf_doc_lin-docnum
        AND itmnum = gt_nf_doc_lin-itmnum.

    SORT gt_nf_stx BY docnum itmnum.

  ENDMETHOD.

  METHOD process_data.

    DATA: ls_outtab LIKE LINE OF gt_outtab.

    LOOP AT gt_nf_doc_lin ASSIGNING FIELD-SYMBOL(<fs_s_nf_doc_lin>).

      FREE: ls_outtab.
      ls_outtab = CORRESPONDING #( <fs_s_nf_doc_lin>
                                     MAPPING
                                       matnr_nf = matnr
                                       matkl_nf = matkl
                                       maktx_nf = maktx
                                       meins_nf = meins ).

      CONCATENATE <fs_s_nf_doc_lin>-regio_a
                  <fs_s_nf_doc_lin>-nfyear
                  <fs_s_nf_doc_lin>-nfmonth
                  <fs_s_nf_doc_lin>-stcd1
                  <fs_s_nf_doc_lin>-model
                  <fs_s_nf_doc_lin>-serie_a
                  <fs_s_nf_doc_lin>-nfnum9
                  <fs_s_nf_doc_lin>-docnum9
                  <fs_s_nf_doc_lin>-cdv
             INTO ls_outtab-acckey.

      READ TABLE gt_nf_stx WITH KEY docnum = <fs_s_nf_doc_lin>-docnum
                                    itmnum = <fs_s_nf_doc_lin>-itmnum
                                  TRANSPORTING NO FIELDS
                                  BINARY SEARCH.

      IF sy-subrc IS INITIAL.

        LOOP AT gt_nf_stx ASSIGNING FIELD-SYMBOL(<fs_s_nf_stx>) FROM sy-tabix.

          IF <fs_s_nf_stx>-docnum <> <fs_s_nf_doc_lin>-docnum
          OR <fs_s_nf_stx>-itmnum <> <fs_s_nf_doc_lin>-itmnum.
            EXIT.
          ENDIF.


          CASE <fs_s_nf_stx>-taxtyp.
            WHEN 'ICAP'.
              ls_outtab-icap_taxval = <fs_s_nf_stx>-taxval.
            WHEN 'ICEP'.
              ls_outtab-icep_taxval = <fs_s_nf_stx>-taxval.
            WHEN 'ICSP'.
              ls_outtab-icsp_taxval = <fs_s_nf_stx>-taxval.
* LSCHEPP - 8000006081 - GAP47 Relatório GNRE gerencial - 02.03.2023 Início
            WHEN 'ICFP'.
              READ TABLE gt_zgnret004 ASSIGNING FIELD-SYMBOL(<fs_s_zgnret004>) WITH KEY docnum = <fs_s_nf_doc_lin>-docnum
                                                                                        itmnum = <fs_s_nf_doc_lin>-itmnum
                                                                                        taxtyp = 'ICFP'.
              IF sy-subrc EQ 0 AND
                <fs_s_zgnret004>-mva IS INITIAL.
                <fs_s_zgnret004>-mva = <fs_s_nf_doc_lin>-p_mvast.
              ENDIF.
            WHEN 'ICS3'.
              READ TABLE gt_zgnret004 ASSIGNING <fs_s_zgnret004> WITH KEY docnum = <fs_s_nf_doc_lin>-docnum
                                                                          itmnum = <fs_s_nf_doc_lin>-itmnum
                                                                          taxtyp = 'ICS3'.
              IF sy-subrc EQ 0 AND
                <fs_s_zgnret004>-mva IS INITIAL.
                <fs_s_zgnret004>-mva = <fs_s_nf_doc_lin>-p_mvast.
              ENDIF.
* LSCHEPP - 8000006081 - GAP47 Relatório GNRE gerencial - 02.03.2023 Fim
          ENDCASE.

          IF <fs_s_nf_stx>-taxgrp = 'ICMS' AND <fs_s_nf_stx>-subdivision IS INITIAL.

            ls_outtab-icms_base   = ls_outtab-icms_base   + <fs_s_nf_stx>-base  .
            ls_outtab-icms_taxval = ls_outtab-icms_taxval + <fs_s_nf_stx>-taxval.

            IF <fs_s_nf_stx>-taxval < 0.
              ls_outtab-icms_rate = ls_outtab-icms_rate - <fs_s_nf_stx>-rate.
            ELSE.
              ls_outtab-icms_rate = ls_outtab-icms_rate + <fs_s_nf_stx>-rate.
            ENDIF.

          ELSEIF <fs_s_nf_stx>-taxgrp = 'IPI'.

            ls_outtab-ipi_base   = ls_outtab-ipi_base   + <fs_s_nf_stx>-base  .
            ls_outtab-ipi_taxval = ls_outtab-ipi_taxval + <fs_s_nf_stx>-taxval.

            IF <fs_s_nf_stx>-taxval < 0.
              ls_outtab-ipi_rate = ls_outtab-ipi_rate - <fs_s_nf_stx>-rate.
            ELSE.
              ls_outtab-ipi_rate = ls_outtab-ipi_rate + <fs_s_nf_stx>-rate.
            ENDIF.

          ENDIF.

        ENDLOOP.

* LSCHEPP - 8000006080 - GAP47 Relatório GNRE gerencial - 02.03.2023 Início
        ADD ls_outtab-ipi_taxval TO ls_outtab-nfnett.
* LSCHEPP - 8000006080 - GAP47 Relatório GNRE gerencial - 02.03.2023 Fim

      ENDIF.

      "Obtêm o cálculo da Partilha ICMS
      ASSIGN gt_zgnret019[ vbeln = <fs_s_nf_doc_lin>-vbeln
                           posnr = <fs_s_nf_doc_lin>-posnr ] TO FIELD-SYMBOL(<fs_s_zgnret019>).
      IF sy-subrc IS INITIAL.
        MOVE-CORRESPONDING <fs_s_zgnret019> TO ls_outtab.
        APPEND ls_outtab TO gt_outtab.
      ELSE.

        READ TABLE gt_zgnret004 WITH KEY docnum = <fs_s_nf_doc_lin>-docnum
                                         itmnum = <fs_s_nf_doc_lin>-itmnum
                                         TRANSPORTING NO FIELDS
                                         BINARY SEARCH.

        IF sy-subrc IS INITIAL.
          "Obtem o cálculo ZSUB
          LOOP AT gt_zgnret004 ASSIGNING <fs_s_zgnret004> FROM sy-tabix.

            IF <fs_s_zgnret004>-docnum  <> <fs_s_nf_doc_lin>-docnum
            OR <fs_s_zgnret004>-itmnum  <> <fs_s_nf_doc_lin>-itmnum.
              EXIT.
            ENDIF.

            MOVE-CORRESPONDING <fs_s_zgnret004> TO ls_outtab.
            APPEND ls_outtab TO gt_outtab.
          ENDLOOP.

        ENDIF.

      ENDIF.

    ENDLOOP.

    IF gt_outtab IS INITIAL.

      "Nenhum registro encontrado.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_data_not_found.
    ENDIF.

  ENDMETHOD.

  METHOD show_data.

    DATA: lo_columns          TYPE REF TO cl_salv_columns_table,
          lo_display_settings TYPE REF TO cl_salv_display_settings,
          lo_layout           TYPE REF TO cl_salv_layout,
          lo_functions        TYPE REF TO cl_salv_functions_list,
          lo_selections       TYPE REF TO cl_salv_selections,
          ls_key              TYPE salv_s_layout_key.

    TRY.
        cl_salv_table=>factory(
          IMPORTING
            r_salv_table = go_alv_grid    " Basis Class Simple ALV Tables
          CHANGING
            t_table      = gt_outtab
        ).

        lo_functions = go_alv_grid->get_functions( ).
        lo_functions->set_all( ).

        lo_display_settings = go_alv_grid->get_display_settings( ).
        lo_display_settings->set_striped_pattern( 'X' ).

        lo_layout = go_alv_grid->get_layout( ).
        ls_key-report = sy-repid.
        ls_key-handle = 'ALV1'.
        lo_layout->set_key( ls_key ).
        lo_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).

        lo_selections = go_alv_grid->get_selections( ).
        lo_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).

        lo_columns = go_alv_grid->get_columns( ).
        lo_columns->set_optimize( ).

        TRY.
            lo_columns->get_column( 'CGC' )->set_edit_mask( '==ALPZE' ).
            lo_columns->get_column( 'CPF' )->set_edit_mask( '==ALPZE' ).
          CATCH cx_salv_not_found.
        ENDTRY.

        go_alv_grid->display( ).

      CATCH cx_salv_msg.    "
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
