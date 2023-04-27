*&---------------------------------------------------------------------*
*& Include          ZSDI_DEDUCAO_PIS_COFINS_BASE
*&---------------------------------------------------------------------*
  "Constantes
  CONSTANTS: lc_kappl     TYPE komk-kappl       VALUE 'V',
             lc_h         TYPE char1            VALUE 'H',
             lc_m         TYPE char1            VALUE 'M',
             lc_zst1      TYPE komv_index-kschl VALUE 'ZST1',
             lc_icmi      TYPE komv_index-kschl VALUE 'ICMI',
             lc_ibrx      TYPE komv_index-kschl VALUE 'IBRX',
             lc_bx23      TYPE komv_index-kschl VALUE 'BX23',
             lc_zfec      TYPE komv_index-kschl VALUE 'ZFEC',
             lc_va01      TYPE sy-tcode         VALUE 'VA01',
             lc_va02      TYPE sy-tcode         VALUE 'VA02',
             lc_va03      TYPE sy-tcode         VALUE 'VA03',
             lc_vf01      TYPE sy-tcode         VALUE 'VF01',
             lc_vf02      TYPE sy-tcode         VALUE 'VF02',
             lc_vf03      TYPE sy-tcode         VALUE 'VF03',
             lc_vf04      TYPE sy-tcode         VALUE 'VF04',
             lc_vkm1      TYPE sy-tcode         VALUE 'VKM1',
             lc_icms_dest TYPE dfies-fieldname  VALUE 'ICMS_DEST_PART_AMT',
             lc_icms_fcp  TYPE dfies-fieldname  VALUE 'ICMS_FCP_PARTILHA_AMT',
             lc_tabname   TYPE ddobjname        VALUE 'ZTSD_PISCONFIS',
             lc_icms_amt  TYPE dfies-fieldname  VALUE 'ICMS_AMT',
             lc_z001      TYPE komv_index-kschl VALUE 'Z001'.

  "Types
  TYPES: BEGIN OF ty_pisconfis,
           bukrs                 TYPE ztsd_pisconfis-bukrs,
           data_dev              TYPE ztsd_pisconfis-data_dev,
           data_fim              TYPE ztsd_pisconfis-data_fim,
           icms_amt              TYPE ztsd_pisconfis-icms_amt,
           icms_fcp_amt          TYPE ztsd_pisconfis-icms_fcp_amt,
           icms_dest_part_amt    TYPE ztsd_pisconfis-icms_dest_part_amt,
           icms_fcp_partilha_amt TYPE ztsd_pisconfis-icms_fcp_partilha_amt,
         END OF ty_pisconfis.

  "Tabelas
  DATA: lt_dfies TYPE TABLE OF dfies,
        lt_komv  TYPE TABLE OF komv_index.

  DATA: ls_komv1 TYPE komv_index.

  "Estruturas
  DATA: ls_pisconfis TYPE ty_pisconfis,
        ls_dfies     TYPE dfies,
        ls_komv      TYPE komv_index,
        ls_komv_aux  TYPE komv_index.

  "Variaveis
  DATA: lv_vbtyp             TYPE tvak-vbtyp,
        lv_erdat             TYPE vbrk-erdat,
        lv_vbelv             TYPE vbelv,
        lv_base_aux          TYPE kwert,
        lv_orig_part_amt     TYPE cl_j_1b_icms_partilha=>mty_tax,
        lv_dest_part_amt     TYPE cl_j_1b_icms_partilha=>mty_tax,
        lv_icms_fcp_amt      TYPE cl_j_1b_icms_partilha=>mty_tax,
        lv_fcp_partilha_amt  TYPE cl_j_1b_icms_partilha=>mty_tax,
        lv_orig_part_base    TYPE cl_j_1b_icms_partilha=>mty_tax,
        lv_dest_part_base    TYPE cl_j_1b_icms_partilha=>mty_tax,
        lv_fcp_partilha_base TYPE cl_j_1b_icms_partilha=>mty_tax,
        lv_orig_part_exc     TYPE cl_j_1b_icms_partilha=>mty_tax,
        lv_dest_part_exc     TYPE cl_j_1b_icms_partilha=>mty_tax,
        lv_fcp_partilha_ebas TYPE cl_j_1b_icms_partilha=>mty_tax.

  "Field Symbols
  FIELD-SYMBOLS: <fs_field> TYPE any,
                 <fs_value> TYPE any,
                 <fs_xkomv> LIKE lt_komv,
                 <fs_zieme> TYPE vbap-zieme.

  "Objetos
  DATA(lo_calc_icms_partilha) = NEW zclsd_gnre_calc_icms_partilha( ).
*  clear: ev_base.
  IF ms_komv_frm-kschl = lc_ibrx.

*    IF sy-tcode EQ lc_va01 OR sy-tcode EQ lc_va02 OR sy-tcode EQ lc_va03 OR sy-tcode EQ lc_vf01 OR sy-tcode EQ lc_vf02 OR sy-tcode EQ lc_vf03 OR sy-tcode EQ lc_vf04.

    ASSIGN ('(SAPLV61A)XKOMV[]') TO <fs_xkomv>.
    ASSIGN ('(SAPFV45P)VBAP-ZIEME') TO <fs_zieme>.

*      IF <fs_xkomv> IS ASSIGNED AND <fs_zieme> IS ASSIGNED.

*    DATA(lt_xkomv) = <fs_xkomv>[].
*    SORT lt_xkomv[] BY kschl kmein.
*    READ TABLE lt_xkomv ASSIGNING FIELD-SYMBOL(<fs_komv>) WITH KEY kschl = lc_icmi BINARY SEARCH.
*
*    IF sy-subrc EQ 0 AND NOT <fs_komv>-kwert IS INITIAL.
*      ev_base = <fs_komv>-kwert.
*    ENDIF.

*     ENDIF.
*    ENDIF.

*    IF iv_val_incl_icms_ipi EQ iv_val_incl_icms.
*      ev_base = iv_val_incl_icms.
*    ELSE.
*      ev_base = iv_val_incl_icms_ipi.
*    ENDIF.

    lo_calc_icms_partilha->calculate(
     EXPORTING
      is_komk         = ms_komk
      is_komp         = ms_komp
      it_komv         = mt_komv
     CHANGING
      cv_orig_partilha_amount = lv_orig_part_amt
      cv_dest_partilha_amount = lv_dest_part_amt
      cv_fcp_partilha_amount  = lv_fcp_partilha_amt
      cv_orig_partilha_base   = lv_orig_part_base
      cv_dest_partilha_base   = lv_dest_part_base
      cv_fcp_partilha_base    = lv_fcp_partilha_base
      cv_orig_partilha_ebase  = lv_orig_part_exc
      cv_dest_partilha_ebase  = lv_dest_part_exc
      cv_fcp_partilha_ebase   = lv_fcp_partilha_ebas   ).

  ENDIF.


*  DO 1 TIMES.

  "Verifica se é um cenário de vendas
  IF ms_komk-kappl = lc_kappl.

    IF ms_komk-auart IS NOT INITIAL.

      "Seleciona a categoria do documento SD
      SELECT SINGLE vbtyp
       INTO lv_vbtyp
        FROM tvak
         WHERE auart EQ ms_komk-auart.

      "Verifica se o documento é uma devolução
      IF lv_vbtyp EQ lc_h.
        "Busca o documento de fatura
        lv_vbelv = ms_komp-vgbel.

      ENDIF.

    ELSEIF ms_komk-fkart IS NOT INITIAL.

      SELECT COUNT(*) UP TO 1 ROWS
       FROM vbak
        WHERE vbeln EQ ms_komp-aubel
          AND vbtyp EQ lc_h.

      IF sy-subrc IS INITIAL.
        "Busca o documento de fatura
        SELECT precedingdocument UP TO 1 ROWS
         INTO @lv_vbelv
          FROM i_sddocumentmultilevelprocflow
           WHERE subsequentdocument         EQ @ms_komp-aubel
             AND subsequentdocumentitem     EQ @ms_komp-aupos
             AND subsequentdocumentcategory EQ @lc_h
             AND precedingdocumentcategory  EQ @lc_m.
        ENDSELECT.

      ENDIF.

    ENDIF.

    IF lv_vbelv IS NOT INITIAL.
      "Busca data da fatura
      SELECT SINGLE erdat
       FROM vbrk
        INTO lv_erdat
         WHERE vbeln EQ lv_vbelv.

      IF sy-subrc IS NOT INITIAL.
        lv_erdat = sy-datum.
      ENDIF.

    ELSE.
      lv_erdat = sy-datum.
    ENDIF.

    CLEAR: lv_vbelv.

    "Condições para dedução da base PIS
    SELECT SINGLE bukrs
                  data_dev
                  data_fim
                  icms_amt
                  icms_fcp_amt
                  icms_dest_part_amt
                  icms_fcp_partilha_amt
     INTO ls_pisconfis
     FROM ztsd_pisconfis
     WHERE  bukrs    EQ ms_komk-bukrs
      AND ( data_dev LE lv_erdat
      AND   data_fim GE lv_erdat ).

    IF sy-subrc IS INITIAL.

*      lt_komv[] = mt_komv[].
*      SORT lt_komv[] BY kposn kschl.
*      READ TABLE lt_komv INTO ls_komv WITH KEY kposn = ms_komp-kposn
*                                               kschl = lc_ibrx BINARY SEARCH.
*      IF sy-subrc IS INITIAL.

*        lv_base_aux = ls_komv-kwert.

*        READ TABLE lt_komv INTO ls_komv_aux WITH KEY kposn = ms_komp-kposn
*                                                     kschl = lc_zfec BINARY SEARCH.
*
*        IF sy-subrc IS INITIAL AND ( ev_base GT ls_komv-kwert ).
*          ADD ls_komv_aux-kwert TO lv_base_aux.
*        ENDIF.

      "Significa que a base ainda não foi ajustada
      IF ms_komv_frm-kschl EQ lc_ibrx.
        ev_base = iv_val_incl_icms.
        "Para o desenvolvimento ficar dinâmico, a função abaixo recupera os campos da tabela
        "para serem usados como parametro para buscar as informações na MS_TAX_RESULT.
        CALL FUNCTION 'DDIF_FIELDINFO_GET'
          EXPORTING
            tabname        = lc_tabname
          TABLES
            dfies_tab      = lt_dfies
          EXCEPTIONS
            not_found      = 1
            internal_error = 2
            OTHERS         = 3.

        IF sy-subrc IS INITIAL .

          IF lv_dest_part_amt IS INITIAL.
            lv_dest_part_amt = ms_tax_result-icms_dest_part_amt.
          ENDIF.

          IF lv_fcp_partilha_amt IS INITIAL.
            lv_fcp_partilha_amt = ms_tax_result-icms_fcp_partilha_amt.
          ENDIF.

          IF lv_icms_fcp_amt IS INITIAL.
            lv_icms_fcp_amt = ms_tax_result-icms_fcp_amt.
          ENDIF.
          LOOP AT lt_dfies INTO ls_dfies.

            ASSIGN COMPONENT ls_dfies-fieldname OF STRUCTURE ls_pisconfis TO <fs_field>.

            IF <fs_field> IS ASSIGNED AND <fs_field> EQ abap_on.

              ASSIGN COMPONENT ls_dfies-fieldname OF STRUCTURE ms_tax_result TO <fs_value>.

              IF <fs_value> IS ASSIGNED.

                CASE ls_dfies-fieldname.

                  WHEN lc_icms_dest .

                    IF ls_pisconfis-icms_dest_part_amt IS NOT INITIAL.

                      ev_base = ev_base - lv_dest_part_amt.

                    ENDIF.

                  WHEN lc_icms_fcp.

                    IF ls_pisconfis-icms_fcp_partilha_amt IS NOT INITIAL.

                      ev_base = ev_base - lv_fcp_partilha_amt - lv_icms_fcp_amt.

                    ENDIF.

                  WHEN lc_icms_amt .

                    IF ls_pisconfis-icms_amt IS NOT INITIAL.
                      ev_base = ev_base - iv_icms_amount.
                    ENDIF.

                ENDCASE.

              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
*      ENDIF.
    ENDIF.
  ENDIF.

* Modificar a base de cálculo de PIS e COFINS, para o processo Farelo, em caso de venda com desconto

*  CLEAR: lt_komv, ls_komv1.
*  CHECK ms_komk-kappl = lc_kappl.
** Checar se a condição do desconto do farelo foi encontrada
*  MOVE mt_komv[] TO lt_komv[].
*  READ TABLE lt_komv INTO ls_komv1 WITH KEY kposn = ms_komp-kposn
*                                            kschl = lc_z001 BINARY SEARCH.
*  CHECK sy-subrc IS INITIAL AND NOT ls_komv1 IS INITIAL.
** Modificar a base de cálculo
*   ev_base = ev_base + ls_komv1-kwert.

*  ENDDO.
