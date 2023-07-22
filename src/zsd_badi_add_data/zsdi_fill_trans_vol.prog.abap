
*&---------------------------------------------------------------------*
*& Include          ZSDI_FILL_TRANS_VOL
*&---------------------------------------------------------------------*

    CONSTANTS: lc_uf(7)    TYPE c VALUE '9999999',
               lc_ex(2)    TYPE c VALUE 'EX',
               lc_j1b1n    TYPE sytcode VALUE 'J1B1N',
               lc_direct   TYPE char1 VALUE '1',
               lc_direct_2 TYPE char1 VALUE '2',
               lc_esp      TYPE char6 VALUE 'VOL',
               lc_count    TYPE char1 VALUE '1',
               lc_frete    TYPE char1 VALUE '1'.

    CONSTANTS: BEGIN OF lc_param,
                 modulo TYPE ztca_param_par-modulo VALUE 'SD',
                 chave1 TYPE ztca_param_par-chave1 VALUE 'UNIDADE_EXPORTACAO',
               END OF lc_param.

    DATA lt_especie TYPE RANGE OF j_1b_trans_vol_type.

    FIELD-SYMBOLS <fs_wnfdoc> TYPE j_1bnfdoc.
    ASSIGN ('(SAPLJ1BF)WA_NF_DOC') TO <fs_wnfdoc>.

    IF is_header-shpunt IS INITIAL AND is_header-anzpk IS NOT INITIAL.
      IF <fs_wnfdoc> IS ASSIGNED.
        <fs_wnfdoc>-shpunt     = lc_esp.
      ENDIF.
    ELSEIF is_header-shpunt IS INITIAL.
      IF <fs_wnfdoc> IS ASSIGNED.
        <fs_wnfdoc>-shpunt     = lc_esp.
      ENDIF.
    ENDIF.

    IF is_header-anzpk IS INITIAL.
      IF <fs_wnfdoc> IS ASSIGNED.
        <fs_wnfdoc>-anzpk     = gv_total_menge.
      ENDIF.
    ENDIF.

    DATA(lo_param) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 20.07.2023

    TRY.
        lo_param->m_get_range( EXPORTING iv_modulo = lc_param-modulo
                                         iv_chave1 = lc_param-chave1
                               IMPORTING et_range  = lt_especie ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.

    READ TABLE cs_transvol ASSIGNING FIELD-SYMBOL(<fs_transvol>)
                                    INDEX 1.
    IF sy-subrc <> 0.
      APPEND INITIAL LINE TO cs_transvol ASSIGNING <fs_transvol>.
    ENDIF.

    SELECT SINGLE land1 FROM lfa1 INTO @DATA(lv_land1)
    WHERE lifnr EQ @is_header-parid.

* Tratativa para Importação
    IF ( lv_land1 NE gc_land AND lv_land1 IS NOT INITIAL ) AND
         is_header-direct EQ lc_direct.

      <fs_transvol>-docnum  = is_header-docnum.
      <fs_transvol>-pesob   = is_header-brgew.
      <fs_transvol>-pesol   = is_header-ntgew.
      <fs_transvol>-marca   = is_header-shpmrk.
*      <fs_transvol>-nvol    = is_header-shpnum.
      <fs_transvol>-nvol    = is_header-brgew.
      CONDENSE <fs_transvol>-nvol NO-GAPS.
      <fs_transvol>-counter = lc_count.

      IF is_header-anzpk IS INITIAL.
        <fs_transvol>-qvol      = gv_total_menge.
      ELSE.
        <fs_transvol>-qvol    = is_header-anzpk.
      ENDIF.

      TRY.
          DATA(lv_especie) = lt_especie[ low = is_header-shpunt ]-high.
          <fs_transvol>-esp = lv_especie.
        CATCH cx_sy_itab_line_not_found.
          IF is_header-shpunt IS INITIAL.
            <fs_transvol>-esp = TEXT-t03.
          ELSE.
            <fs_transvol>-esp = is_header-shpunt.
          ENDIF.
      ENDTRY.

*      IF is_header-shpunt IS INITIAL.
*        <fs_transvol>-esp      = lc_esp.
*      ELSE.
*        <fs_transvol>-esp     = is_header-shpunt.
*      ENDIF.

      ASSIGN cs_header TO FIELD-SYMBOL(<fs_header>).
      <fs_header>-uf1 = lc_ex.
      <fs_header>-placa = lc_uf. " setando a placa para 9999999

    ENDIF.

    "Modelo do Frete
    IF is_header-modfrete IS INITIAL OR
       is_header-inco1 IS INITIAL.
      ASSIGN cs_header TO FIELD-SYMBOL(<fs_header_aux>).
      <fs_header_aux>-modfrete = lc_frete.
    ENDIF.

* LSCHEPP - Ajuste de peso para embalamento - 24.05.2022 Início
    IF <fs_transvol> IS ASSIGNED.

      DATA(lt_vgbel) = VALUE shp_vgbel_range_t( FOR ls_data IN it_vbrp
                                                             ( sign   = 'I'
                                                               option = 'EQ'
                                                               low    = |{ ls_data-vgbel ALPHA = IN }| ) ) .
      SORT lt_vgbel.
      DELETE ADJACENT DUPLICATES FROM lt_vgbel COMPARING ALL FIELDS.

      IF NOT lt_vgbel IS INITIAL.
        SELECT SUM( brgew ), SUM( ntgew )
          FROM vekp
          INTO ( @DATA(lv_pesob), @DATA(lv_pesol) )
          WHERE vpobjkey IN @lt_vgbel.
        IF sy-subrc EQ 0.
          IF NOT lv_pesob IS INITIAL AND NOT lv_pesol IS INITIAL.
            <fs_transvol>-pesob = lv_pesob.
            <fs_transvol>-nvol  = lv_pesob.
            CONDENSE <fs_transvol>-nvol NO-GAPS.
* LSCHEPP - SD - 8000007193 - Peso liquido e bruto no DANFE (paletes) - 10.05.2023 Início
            lv_pesol = is_header-ntgew.
* LSCHEPP - SD - 8000007193 - Peso liquido e bruto no DANFE (paletes) - 10.05.2023 Fim
            <fs_transvol>-pesol = lv_pesol.
            IF <fs_wnfdoc> IS ASSIGNED.
              <fs_wnfdoc>-brgew      = lv_pesob.
              <fs_wnfdoc>-vol_transp = lv_pesob.
              <fs_wnfdoc>-ntgew      = lv_pesol.
            ENDIF.
          ELSE.
            IF <fs_wnfdoc> IS ASSIGNED.
              <fs_transvol>-pesob = <fs_wnfdoc>-brgew.
              <fs_transvol>-nvol  = <fs_wnfdoc>-brgew.
              CONDENSE <fs_transvol>-nvol NO-GAPS.
              <fs_transvol>-pesol = <fs_wnfdoc>-ntgew.
            ELSE.
              <fs_transvol>-pesob = is_header-brgew.
              <fs_transvol>-nvol  = is_header-brgew.
              CONDENSE <fs_transvol>-nvol NO-GAPS.
              <fs_transvol>-pesol = is_header-ntgew.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

      IF is_header-anzpk IS INITIAL.
        <fs_transvol>-qvol      = gv_total_menge.
        <fs_transvol>-nvol      = <fs_transvol>-pesob.
        CONDENSE <fs_transvol>-nvol NO-GAPS.
      ELSE.
        <fs_transvol>-qvol    = is_header-anzpk.
        <fs_transvol>-nvol    = <fs_transvol>-pesob.
        CONDENSE <fs_transvol>-nvol NO-GAPS.
      ENDIF.

      IF NOT is_header-shpunt IS INITIAL.
        DATA(lv_shpunt) = is_header-shpunt.
      ELSE.
        DATA(lt_item) = it_nflin.
        DELETE ADJACENT DUPLICATES FROM lt_item COMPARING meins.
        DATA(lv_lines) = lines( lt_item ).
        IF lv_lines > 1.
          lv_shpunt = TEXT-t03.
        ELSE.
          TRY.
              lv_shpunt = lt_item[ 1 ]-meins.
            CATCH cx_sy_itab_line_not_found.
          ENDTRY.
        ENDIF.
      ENDIF.

      "Conversão Peso Líquido e Peso Bruto
      INCLUDE zsdi_convert_pesol_pesob IF FOUND.

      TRY.
          lv_especie = lt_especie[ low = lv_shpunt ]-high.
          <fs_transvol>-esp = lv_especie.
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

*      IF is_header-shpunt IS INITIAL.
*        <fs_transvol>-esp      = lc_esp.
*      ELSE.
*        <fs_transvol>-esp     = is_header-shpunt.
*      ENDIF.

    ENDIF.
* LSCHEPP - Ajuste de peso para embalamento - 24.05.2022 Fim

* BCOSTA -  Ajustes saídas MM - 09.11.2022 Inicio
    IF <fs_transvol> IS ASSIGNED AND is_header-direct EQ lc_direct_2.

      FIELD-SYMBOLS <fs_nflin> TYPE ANY TABLE.

      DATA lt_nflin TYPE TABLE OF j_1bnflin.

      ASSIGN ('(SAPLJ1BF)WA_NF_LIN[]') TO <fs_nflin>.

      IF <fs_nflin> IS ASSIGNED.

        lt_nflin[] = <fs_nflin>.

        READ TABLE lt_nflin INTO DATA(ls_nflin) INDEX 1.

        IF ls_nflin-reftyp NE 'BI'.

          IF is_header-nfesrv EQ abap_false.
            CLEAR cs_header-cnae_bupla.
            ASSIGN ('(SAPLJ1BF)WA_NF_DOC-MUNINS') TO FIELD-SYMBOL(<fs_munins>).
            IF <fs_munins> IS  ASSIGNED.
              CLEAR <fs_munins>.
            ENDIF.
            ASSIGN ('(SAPLJ1BF)WA_NF_DOC-IM_BUPLA') TO FIELD-SYMBOL(<fs_im_bupla>).
            IF <fs_im_bupla> IS  ASSIGNED.
              CLEAR <fs_im_bupla>.
            ENDIF.
          ENDIF.

          <fs_transvol>-pesob = is_header-brgew.
          <fs_transvol>-nvol  = is_header-brgew.
          CONDENSE <fs_transvol>-nvol NO-GAPS.
          <fs_transvol>-pesol = is_header-ntgew.

        ENDIF.

      ENDIF.

    ENDIF.
* BCOSTA -  Ajustes saídas MM - 09.11.2022 Fim

    LOOP AT cs_transvol ASSIGNING <fs_transvol>.
      CONDENSE: <fs_transvol>-marca  NO-GAPS,
                <fs_transvol>-esp    NO-GAPS,
                <fs_transvol>-nvol   NO-GAPS,
                <fs_transvol>-nlacre NO-GAPS.
    ENDLOOP.
