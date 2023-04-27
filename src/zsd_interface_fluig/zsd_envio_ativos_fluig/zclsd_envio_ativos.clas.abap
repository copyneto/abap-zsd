CLASS zclsd_envio_ativos DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS:
      get_data
        IMPORTING
          is_input TYPE zclsd_mt_consulta_ativo,

      envio_fluig
        EXPORTING
          es_output TYPE zclsd_mt_envia_ativo.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: gs_input  TYPE zclsd_mt_consulta_ativo,
          gs_output TYPE zclsd_mt_envia_ativo.

    METHODS:
      process_data.

ENDCLASS.



CLASS ZCLSD_ENVIO_ATIVOS IMPLEMENTATION.


  METHOD get_data.

    MOVE-CORRESPONDING is_input TO gs_input.

  ENDMETHOD.


  METHOD process_data.

    CONSTANTS: lc_vbbp TYPE tdobject VALUE 'VBBP',
               lc_z010 TYPE tdid VALUE 'Z010'.

    DATA: lv_name   TYPE thead-tdname,
          lv_lppnet TYPE j_1blppnet.

    DATA lt_lines  TYPE tline_tab.

    DATA(lv_matnr) = |{ gs_input-mt_consulta_ativo-matnr ALPHA = IN  }|.
    DATA(lv_sernr) = |{ gs_input-mt_consulta_ativo-sernr ALPHA = IN  }|.


    SELECT COUNT(*)
      FROM ztca_param_val
      WHERE modulo = 'SD'
        AND chave1 = 'FLUIG'
        AND chave2 = 'ANLA'
        AND low = abap_true.
    IF sy-subrc IS NOT INITIAL.

      SELECT SINGLE invnr,
             sernr,
             equnr,
             elief,
             matnr,
             b_werk,
             b_lager
          INTO @DATA(ls_data)
          FROM v_equi_eqbs_sml
           WHERE matnr   = @lv_matnr
             AND b_werk  = @gs_input-mt_consulta_ativo-b_werk
             AND b_lager = @gs_input-mt_consulta_ativo-b_lager
             AND sernr   = @lv_sernr.
      IF sy-subrc = 0.

        SELECT SINGLE lppnet,
                      matnr,
                      bwkey
            INTO @DATA(ls_j_1blpp)
            FROM j_1blpp
            WHERE matnr = @ls_data-matnr
            AND bwkey   = @ls_data-b_werk.

        gs_output-mt_envia_ativo-invnr   = ls_data-invnr.

        IF ls_j_1blpp IS NOT INITIAL.
          gs_output-mt_envia_ativo-lppnet  = ls_j_1blpp-lppnet.
        ENDIF.

        gs_output-mt_envia_ativo-sernr   = ls_data-sernr.
        gs_output-mt_envia_ativo-equnr   = ls_data-equnr.
        gs_output-mt_envia_ativo-elief   = ls_data-elief.
        gs_output-mt_envia_ativo-matnr   = ls_data-matnr.
        gs_output-mt_envia_ativo-b_werk  = ls_data-b_werk.
        gs_output-mt_envia_ativo-b_lager = ls_data-b_lager.

      ENDIF.
    ELSE.

*      SELECT SINGLE *
*        FROM anla
*        WHERE invnr = @gs_input-mt_consulta_ativo-sernr
*          AND aktiv IS NOT INITIAL
*          AND deakt IS INITIAL
*          INTO @DATA(ls_anla).

      SELECT SINGLE anln1
        FROM anla
        WHERE invnr = @gs_input-mt_consulta_ativo-sernr
          AND aktiv IS NOT INITIAL
          AND deakt IS INITIAL
          INTO @DATA(lv_anln1).

      IF sy-subrc IS INITIAL.

*        SELECT COUNT(*)
*              FROM ztca_param_val
*              WHERE modulo = 'SD'
*                AND chave1 = 'FLUIG'
*                AND chave2 = 'ANLA'
*                AND low = abap_true.
*        IF sy-subrc IS NOT INITIAL.

*          gs_output-mt_envia_ativo-invnr   = ls_anla-anln1.
        gs_output-mt_envia_ativo-invnr   = lv_anln1.

        SELECT SINGLE invnr,
             sernr,
             equnr,
             elief,
             matnr,
             b_werk,
             b_lager
          INTO @ls_data
          FROM v_equi_eqbs_sml
           WHERE matnr   = @lv_matnr
             AND b_werk  = @gs_input-mt_consulta_ativo-b_werk
             AND b_lager = @gs_input-mt_consulta_ativo-b_lager
             AND sernr   = @lv_sernr.
        IF sy-subrc = 0.

          SELECT SINGLE lppnet,
                        matnr,
                        bwkey
              INTO @ls_j_1blpp
              FROM j_1blpp
              WHERE matnr = @ls_data-matnr
              AND bwkey   = @ls_data-b_werk.


          IF ls_j_1blpp IS NOT INITIAL.
            gs_output-mt_envia_ativo-lppnet  = ls_j_1blpp-lppnet.
          ENDIF.

          gs_output-mt_envia_ativo-sernr   = ls_data-sernr.
          gs_output-mt_envia_ativo-equnr   = ls_data-equnr.
          gs_output-mt_envia_ativo-elief   = ls_data-elief.
          gs_output-mt_envia_ativo-matnr   = ls_data-matnr.
          gs_output-mt_envia_ativo-b_werk  = ls_data-b_werk.
          gs_output-mt_envia_ativo-b_lager = ls_data-b_lager.

        ELSE.

          SELECT SINGLE ordemvenda, ordemvendaitem, numero_nf, valor_liquido
           FROM zi_sd_invoiceinfo_ativo_fluig
            WHERE numero_serie = @lv_sernr
              AND centro       = @gs_input-mt_consulta_ativo-b_werk
                      INTO @DATA(ls_ativo_fluig).


          IF sy-subrc IS INITIAL.

            SELECT SINGLE invnr,
               sernr,
               equnr,
               elief,
               matnr,
               b_werk,
               b_lager
            INTO @ls_data
            FROM v_equi_eqbs_sml
             WHERE matnr   = @lv_matnr
               AND b_werk  = @gs_input-mt_consulta_ativo-b_werk
               AND sernr   = @lv_sernr.

*            IF sy-subrc IS INITIAL.
            gs_output-mt_envia_ativo-sernr   = gs_input-mt_consulta_ativo-sernr.
            gs_output-mt_envia_ativo-matnr   = gs_input-mt_consulta_ativo-matnr.
            gs_output-mt_envia_ativo-equnr   = ls_data-equnr.
            gs_output-mt_envia_ativo-posnr   = ls_ativo_fluig-ordemvendaitem.
            gs_output-mt_envia_ativo-lppnet  = ls_ativo_fluig-valor_liquido.
            gs_output-mt_envia_ativo-b_werk  = ls_data-b_werk.
            gs_output-mt_envia_ativo-b_lager = ls_data-b_lager.

            IF ls_ativo_fluig-ordemvenda IS NOT INITIAL.
              gs_output-mt_envia_ativo-vbeln = ls_ativo_fluig-ordemvenda .
            ELSE.
              gs_output-mt_envia_ativo-vbeln =  '0000000000'.
            ENDIF.

            IF ls_ativo_fluig-numero_nf IS NOT INITIAL.
              gs_output-mt_envia_ativo-nfnum = ls_ativo_fluig-numero_nf.
            ELSE.
              gs_output-mt_envia_ativo-nfnum = '00000000000'.
            ENDIF.

*            ENDIF.
          ELSE.

            SELECT SINGLE obknr
              FROM objk
              INTO @DATA(lv_obknr)
              WHERE matnr EQ @lv_matnr
                AND sernr EQ @lv_sernr
                AND taser EQ 'SER02'.
            IF sy-subrc EQ 0.
              SELECT SINGLE sdaufnr, posnr
                FROM ser02
                INTO @DATA(ls_ser02)
                WHERE obknr EQ @lv_obknr.
              IF sy-subrc EQ 0.
                SELECT COUNT( * )
                  FROM vbak
                  WHERE vbeln EQ @ls_ser02-sdaufnr
                    AND bsark EQ 'CARG'.
                IF sy-subrc EQ 0.

                  lv_name = |{ ls_ser02-sdaufnr }{ ls_ser02-posnr }|.

                  CALL FUNCTION 'READ_TEXT'
                    EXPORTING
                      id                      = lc_z010
                      language                = sy-langu
                      name                    = lv_name
                      object                  = lc_vbbp
                    TABLES
                      lines                   = lt_lines
                    EXCEPTIONS
                      id                      = 1
                      language                = 2
                      name                    = 3
                      not_found               = 4
                      object                  = 5
                      reference_check         = 6
                      wrong_access_to_archive = 7
                      OTHERS                  = 8.

                  LOOP AT lt_lines ASSIGNING FIELD-SYMBOL(<fs_lines>).
                    DATA(lv_nfe) = <fs_lines>-tdline+26(8).
                    SPLIT <fs_lines>-tdline AT '/' INTO DATA(lv_chave) DATA(lv_valor).
                  ENDLOOP.

                  CONDENSE lv_valor NO-GAPS.
                  REPLACE ALL OCCURRENCES OF ',' IN lv_valor WITH '.'.
                  lv_lppnet = lv_valor.

                  SELECT SINGLE invnr,
                     sernr,
                     equnr,
                     elief,
                     matnr,
                     b_werk,
                     b_lager
                  INTO @ls_data
                  FROM v_equi_eqbs_sml
                   WHERE matnr   = @lv_matnr
                     AND b_werk  = @gs_input-mt_consulta_ativo-b_werk
                     AND sernr   = @lv_sernr.

                  gs_output-mt_envia_ativo-invnr   = ls_data-invnr.
                  gs_output-mt_envia_ativo-sernr   = gs_input-mt_consulta_ativo-sernr.
                  gs_output-mt_envia_ativo-matnr   = gs_input-mt_consulta_ativo-matnr.
                  gs_output-mt_envia_ativo-equnr   = ls_data-equnr.
                  gs_output-mt_envia_ativo-lppnet  = lv_lppnet.
                  gs_output-mt_envia_ativo-b_werk  = gs_input-mt_consulta_ativo-b_werk.
                  gs_output-mt_envia_ativo-b_lager = gs_input-mt_consulta_ativo-b_lager.
                  gs_output-mt_envia_ativo-vbeln   = ls_ser02-sdaufnr.
                  gs_output-mt_envia_ativo-posnr   = ls_ser02-posnr.
                  gs_output-mt_envia_ativo-nfnum   = lv_nfe.

                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

      ELSE.

        SELECT SINGLE obknr
          FROM objk
          INTO @lv_obknr
          WHERE matnr EQ @lv_matnr
            AND sernr EQ @lv_sernr
            AND taser EQ 'SER02'.
        IF sy-subrc EQ 0.
          SELECT SINGLE sdaufnr, posnr
            FROM ser02
            INTO @ls_ser02
            WHERE obknr EQ @lv_obknr.
          IF sy-subrc EQ 0.
            SELECT COUNT( * )
              FROM vbak
              WHERE vbeln EQ @ls_ser02-sdaufnr
                AND bsark EQ 'CARG'.
            IF sy-subrc EQ 0.

              lv_name = |{ ls_ser02-sdaufnr }{ ls_ser02-posnr }|.

              CALL FUNCTION 'READ_TEXT'
                EXPORTING
                  id                      = lc_z010
                  language                = sy-langu
                  name                    = lv_name
                  object                  = lc_vbbp
                TABLES
                  lines                   = lt_lines
                EXCEPTIONS
                  id                      = 1
                  language                = 2
                  name                    = 3
                  not_found               = 4
                  object                  = 5
                  reference_check         = 6
                  wrong_access_to_archive = 7
                  OTHERS                  = 8.

              LOOP AT lt_lines ASSIGNING <fs_lines>.
                lv_nfe = <fs_lines>-tdline+26(8).
                SPLIT <fs_lines>-tdline AT '/' INTO lv_chave lv_valor.
              ENDLOOP.

              CONDENSE lv_valor NO-GAPS.
              REPLACE ALL OCCURRENCES OF ',' IN lv_valor WITH '.'.
              lv_lppnet = lv_valor.

              SELECT SINGLE invnr,
                 sernr,
                 equnr,
                 elief,
                 matnr,
                 b_werk,
                 b_lager
              INTO @ls_data
              FROM v_equi_eqbs_sml
               WHERE matnr   = @lv_matnr
                 AND b_werk  = @gs_input-mt_consulta_ativo-b_werk
                 AND sernr   = @lv_sernr.

              gs_output-mt_envia_ativo-invnr   = ls_data-invnr.
              gs_output-mt_envia_ativo-sernr   = gs_input-mt_consulta_ativo-sernr.
              gs_output-mt_envia_ativo-matnr   = gs_input-mt_consulta_ativo-matnr.
              gs_output-mt_envia_ativo-equnr   = ls_data-equnr.
              gs_output-mt_envia_ativo-lppnet  = lv_lppnet.
              gs_output-mt_envia_ativo-b_werk  = gs_input-mt_consulta_ativo-b_werk.
              gs_output-mt_envia_ativo-b_lager = gs_input-mt_consulta_ativo-b_lager.
              gs_output-mt_envia_ativo-vbeln   = ls_ser02-sdaufnr.
              gs_output-mt_envia_ativo-posnr   = ls_ser02-posnr.
              gs_output-mt_envia_ativo-nfnum   = lv_nfe.

            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD envio_fluig.

    process_data( ).

    MOVE-CORRESPONDING gs_output TO es_output.

  ENDMETHOD.
ENDCLASS.
