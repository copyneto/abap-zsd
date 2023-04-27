CLASS zclsd_ckpt_agend_conv DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS:
      "! Constantes para tabela de parâmetros
      BEGIN OF gc_parametros,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'ADM_AGENDAMENTO',
        chave2 TYPE ztca_param_par-chave2 VALUE 'IMPOSTO_TOTAL_NFE',
        chave3 TYPE ztca_param_par-chave3 VALUE '',
      END OF gc_parametros.

    DATA: gr_tax TYPE RANGE OF j_1btaxgrp.

ENDCLASS.



CLASS zclsd_ckpt_agend_conv IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zc_sd_ckpt_agen_item_app WITH DEFAULT KEY.

    lt_original_data = CORRESPONDING #( it_original_data ).

    SELECT chaveordemremessa, chavedinamica, salesorder, salesorderitem, remessa, total_nfe
    FROM zi_sd_ckpt_agen_item_app
    FOR ALL ENTRIES IN @lt_original_data
    WHERE chaveordemremessa = @lt_original_data-chaveordemremessa
    AND   chavedinamica     = @lt_original_data-chavedinamica
    AND   salesorder        = @lt_original_data-salesorder
    AND   salesorderitem    = @lt_original_data-salesorderitem
    INTO TABLE @DATA(lt_remessa).


    IF sy-subrc IS INITIAL.

      SORT lt_remessa BY chaveordemremessa chavedinamica salesorder salesorderitem.

      DATA(lt_dados) = lt_remessa[].
      SORT lt_dados BY remessa salesorderitem.
      DELETE ADJACENT DUPLICATES FROM lt_dados COMPARING remessa salesorderitem.

      IF lt_dados[] IS NOT INITIAL.



        SELECT a~salesorder, a~item, a~docnum, a~docnumitm, a~total_nfe, b~taxgroup, b~br_nfitemtaxamount
        FROM zi_sd_ckpt_agend_ciclo( p_tipo = 'M' ) AS a
        LEFT OUTER JOIN i_br_nftax AS b ON a~docnum = b~br_notafiscal
                                       AND a~docnumitm =   b~br_notafiscalitem
        FOR ALL ENTRIES IN @lt_dados
        WHERE   a~salesorder = @lt_dados-remessa
          AND   a~item       = @lt_dados-salesorderitem
        INTO TABLE @DATA(lt_data)
        .

        IF sy-subrc IS INITIAL.

      SORT lt_data BY salesorder item.

        ENDIF.
      ENDIF.
    ENDIF.

    DATA(lo_param) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_param->m_get_range( EXPORTING iv_modulo = gc_parametros-modulo
                                         iv_chave1 = gc_parametros-chave1
                                         iv_chave2 = gc_parametros-chave2
                                         iv_chave3 = gc_parametros-chave3
                               IMPORTING et_range  = gr_tax ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_original_data>).

      READ TABLE lt_remessa INTO DATA(ls_remessa) WITH KEY chaveordemremessa = <fs_original_data>-chaveordemremessa
                                                           chavedinamica     = <fs_original_data>-chavedinamica
                                                           salesorder        = <fs_original_data>-salesorder
                                                           salesorderitem    = <fs_original_data>-salesorderitem
                                                           BINARY SEARCH.

      IF sy-subrc IS INITIAL.

        <fs_original_data>-total = ls_remessa-total_nfe.

        READ TABLE  lt_data TRANSPORTING NO FIELDS WITH KEY salesorder = ls_remessa-remessa
                                                            item       = ls_remessa-salesorderitem
                                                                                   BINARY SEARCH.

        IF sy-subrc IS INITIAL.
          LOOP AT lt_data INTO DATA(ls_data)  FROM sy-tabix.
            IF ls_data-salesorder <> ls_remessa-remessa
            OR ls_data-item <> ls_remessa-salesorderitem.
              EXIT.
            ENDIF.
            IF ls_data-taxgroup IN gr_tax.

              <fs_original_data>-total = <fs_original_data>-total + ls_data-br_nfitemtaxamount.
            ENDIF.
            CLEAR: ls_data-br_nfitemtaxamount.
          ENDLOOP.
        ENDIF.
        CLEAR: ls_remessa-total_nfe.
      ENDIF.
    ENDLOOP.


    ct_calculated_data = CORRESPONDING #(  lt_original_data ).

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    RETURN.
  ENDMETHOD.


ENDCLASS.
