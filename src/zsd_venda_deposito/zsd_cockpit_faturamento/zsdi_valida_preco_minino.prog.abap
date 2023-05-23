*&---------------------------------------------------------------------*
*& Include          ZSDI_VALIDA_PRECO_MININO
*&---------------------------------------------------------------------*

    CONSTANTS: lc_modul TYPE ztca_param_mod-modulo VALUE 'SD',
               lc_chav1 TYPE ztca_param_par-chave1 VALUE 'ADM_FATURAMENTO',
               lc_chav2 TYPE ztca_param_par-chave2 VALUE 'KSCHL_MINIMO',
               lc_chav3 TYPE ztca_param_par-chave3 VALUE ''.

    CONSTANTS: lc_modul_1 TYPE ztca_param_mod-modulo VALUE 'SD',
               lc_chav1_1 TYPE ztca_param_par-chave1 VALUE 'ADM_FATURAMENTO',
               lc_chav2_1 TYPE ztca_param_par-chave2 VALUE 'KSCHL_MINIMO_COMPARA',
               lc_chav3_1 TYPE ztca_param_par-chave3 VALUE ''.

    CONSTANTS: lc_modul_2 TYPE ztca_param_mod-modulo VALUE 'SD',
               lc_chav1_2 TYPE ztca_param_par-chave1 VALUE 'ADM_FATURAMENTO',
               lc_chav2_2 TYPE ztca_param_par-chave2 VALUE 'EXIT',
               lc_chav3_2 TYPE ztca_param_par-chave3 VALUE 'MV50AFZ1'.

    CONSTANTS: lc_modul_3 TYPE ztca_param_mod-modulo VALUE 'SD',
               lc_chav1_3 TYPE ztca_param_par-chave1 VALUE 'ADM_FATURAMENTO',
               lc_chav2_3 TYPE ztca_param_par-chave2 VALUE 'PEDIDO_MINIMO',
               lc_chav3_3 TYPE ztca_param_par-chave3 VALUE 'AUART'.

** Seleçao dos parametros
    DATA(lo_parametro) = NEW zclca_tabela_parametros( ).

    DATA: lr_exit_mv50afz1 TYPE RANGE OF flag,
          lr_kschl         TYPE RANGE OF kschl,
          lr_kschl_c       TYPE RANGE OF kschl,
          lr_auart         TYPE RANGE OF auart.

    DATA: lv_som_rem_item TYPE prcd_elements-kwert.
    DATA: lv_valor_min    TYPE prcd_elements-kwert.


    CLEAR: lr_kschl  , lr_kschl_c.

    IF line_exists( xlips[ updkz = 'D' ] ).

      RETURN.

    ELSE.


*Buscar VALIDA SE A EXIT ESTÁ ATIVADA
      TRY.
          lo_parametro->m_get_range(
            EXPORTING
              iv_modulo = lc_modul_2
              iv_chave1 = lc_chav1_2
              iv_chave2 = lc_chav2_2
              iv_chave3 = lc_chav3_2
            IMPORTING
              et_range  =  lr_exit_mv50afz1  ).
        CATCH zcxca_tabela_parametros.
          "handle exception
      ENDTRY.

      IF lr_exit_mv50afz1[] IS INITIAL.
        RETURN.
      ENDIF.

      "Busca os tipos de pedidos válidos
      TRY.
          lo_parametro->m_get_range(
            EXPORTING
              iv_modulo = lc_modul_3
              iv_chave1 = lc_chav1_3
              iv_chave2 = lc_chav2_3
              iv_chave3 = lc_chav3_3
            IMPORTING
              et_range  =  lr_auart  ).
        CATCH zcxca_tabela_parametros.
          "handle exception
      ENDTRY.

      IF vbak-auart NOT IN lr_auart.
        RETURN.
      ENDIF.

*Buscar PARÂMETRO kschl
      TRY.
          lo_parametro->m_get_range(
            EXPORTING
              iv_modulo = lc_modul
              iv_chave1 = lc_chav1
              iv_chave2 = lc_chav2
              iv_chave3 = lc_chav3
            IMPORTING
              et_range  = lr_kschl ).
        CATCH zcxca_tabela_parametros.
          "handle exception
      ENDTRY.

      IF lr_kschl[] IS NOT INITIAL.

        DATA(lv_kschl) = lr_kschl[ 1 ]-low.

      ELSE.
        RETURN.
      ENDIF.

*Buscar PARÂMETROS kschl comparativo
      TRY.
          lo_parametro->m_get_range(
            EXPORTING
              iv_modulo = lc_modul_1
              iv_chave1 = lc_chav1_1
              iv_chave2 = lc_chav2_1
              iv_chave3 = lc_chav3_1
            IMPORTING
              et_range  =  lr_kschl_c  ).
        CATCH zcxca_tabela_parametros.
          "handle exception
      ENDTRY.

      IF lr_kschl_c[] IS NOT INITIAL.

        DATA(lv_kschl_c) = lr_kschl_c[ 1 ]-low.
      ELSE.
        RETURN.
      ENDIF.

      IF vbak-knumv IS NOT INITIAL.
        DATA(lv_knumv) = vbak-knumv.
      ELSE.
        lv_knumv = cvbak-knumv.
      ENDIF.

      IF vbak-vbeln IS NOT INITIAL.
        DATA(lv_vbeln) = vbak-vbeln.
      ELSE.
        lv_vbeln = cvbap-vbeln.
      ENDIF.

*Verifica Valor MÍNIMO
      IF lv_knumv IS NOT INITIAL
        AND lv_kschl IS NOT INITIAL.

        SELECT knumv, kposn, kschl, kbetr
          FROM prcd_elements
          INTO TABLE @DATA(lt_prcd)
          WHERE knumv = @lv_knumv
            AND kschl = @lv_kschl.

        IF sy-subrc IS INITIAL.
          SORT lt_prcd BY kposn ASCENDING.
          lv_valor_min = lt_prcd[ 1 ]-kbetr.

        ELSE.
          RETURN.
        ENDIF.
      ENDIF.

      CLEAR lv_som_rem_item.

*Verifica somatório de REMESSA
      IF xlips[] IS NOT INITIAL
        AND lv_kschl_c IS NOT INITIAL.

        IF line_exists( xlikp[ vbtyp = 'T' ] ).

          RETURN.

        ELSE.

          SELECT salesorder, salesorderitem, orderquantity
            FROM i_salesorderitem
            INTO TABLE @DATA(lt_sales)
            FOR ALL ENTRIES IN @xlips
            WHERE salesorder = @lv_vbeln
              AND salesorderitem = @xlips-vgpos.

          IF sy-subrc IS INITIAL.
            SORT lt_sales BY salesorderitem.
          ENDIF.

          SELECT knumv, kposn, kschl, kwert
          FROM prcd_elements
          INTO TABLE @DATA(lt_prcd_c)
          FOR ALL ENTRIES IN @xlips
          WHERE knumv = @lv_knumv
            AND kposn  = @xlips-vgpos
            AND kschl = @lv_kschl_c.

          IF sy-subrc IS INITIAL.
            SORT lt_prcd_c BY kposn.
            LOOP AT xlips ASSIGNING FIELD-SYMBOL(<fs_xlips>).
              READ TABLE lt_prcd_c ASSIGNING FIELD-SYMBOL(<fs_prcd_c>) WITH KEY kposn = <fs_xlips>-vgpos
                                                                       BINARY SEARCH.
              IF <fs_prcd_c> IS ASSIGNED.
                DATA(lv_kert) = <fs_prcd_c>-kwert.

                READ TABLE lt_sales ASSIGNING FIELD-SYMBOL(<fs_sales>) WITH KEY salesorderitem = <fs_xlips>-vgpos
                                                                        BINARY SEARCH.
                IF <fs_sales> IS ASSIGNED.
                  IF <fs_sales>-orderquantity IS NOT INITIAL.
                    DATA(lv_valor_rem_item) = CONV kwmeng( lv_kert / <fs_sales>-orderquantity ).
                    lv_som_rem_item = lv_som_rem_item + ( lv_valor_rem_item * <fs_xlips>-lfimg ).
                    CLEAR lv_valor_rem_item.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDLOOP.

            IF lv_som_rem_item < lv_valor_min.
              MESSAGE e012(zsd_cockpit_remessa) WITH lv_som_rem_item lv_valor_min.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
