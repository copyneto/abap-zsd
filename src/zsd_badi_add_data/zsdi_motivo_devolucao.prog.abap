*&---------------------------------------------------------------------*
*& Include ZSDI_MOTIVO_DEVOLUCAO
*&---------------------------------------------------------------------*
  CONSTANTS: BEGIN OF lc_param,
               modulo TYPE ztca_param_par-modulo VALUE 'SD',
               chave1 TYPE ztca_param_par-chave1 VALUE 'ADM DEVOLUÇÃO',
               chave2 TYPE ztca_param_par-chave2 VALUE 'MOTIVO',
             END OF lc_param.

  DATA lt_augru TYPE RANGE OF augru.


  IF is_header-doctyp EQ '6' AND
     is_header-direct EQ '1' AND
     is_header-regio  EQ 'PR' AND
     is_header-nfe    EQ abap_true.

    READ TABLE it_vbrp ASSIGNING <fs_vbrp> INDEX 1.
    IF sy-subrc EQ 0 AND NOT <fs_vbrp>-augru_auft IS INITIAL.
      DATA(lv_augru) = <fs_vbrp>-augru_auft.
    ENDIF.

    DATA(lo_param1) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 20.07.2023
    TRY.
        lo_param1->m_get_range( EXPORTING iv_modulo = lc_param-modulo
                                          iv_chave1 = lc_param-chave1
                                          iv_chave2 = lc_param-chave2
                                IMPORTING et_range  = lt_augru ).
        IF lv_augru IN lt_augru.
          cs_header-natop      = TEXT-t08.
          cs_header-infadfisco = TEXT-t09.
        ENDIF.
      CATCH zcxca_tabela_parametros.
    ENDTRY.

  ENDIF.
