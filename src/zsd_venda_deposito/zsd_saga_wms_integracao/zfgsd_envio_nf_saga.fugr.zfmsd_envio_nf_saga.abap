FUNCTION zfmsd_envio_nf_saga.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_HEADER) TYPE  ZSSD_ENVNF_SAGA
*"----------------------------------------------------------------------

  TYPES: ty_receb TYPE STANDARD TABLE OF ztmm_wms_receb WITH DEFAULT KEY.

  CONSTANTS: BEGIN OF lc_parametro,
               modulo TYPE ze_param_modulo       VALUE 'SD',
               chave1 TYPE ztca_param_par-chave1 VALUE 'SAGA',
               chave2 TYPE ztca_param_par-chave2 VALUE 'WERKS',
               v100   TYPE j_1bstatuscode        VALUE '100',
             END OF lc_parametro,

             lc_direct2 TYPE j_1bdirect VALUE '2'.

  DATA: lr_vstel TYPE RANGE OF j_1bnfdoc-vstel.

  DATA: lo_proxy TYPE REF TO zclsd_saga_remessa.

  CHECK is_header-direct = lc_direct2.

  IF is_header-code EQ lc_parametro-v100.

    DATA(lo_tabela_parametros_vstel) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 24.07.2023

    WAIT UP TO 10 SECONDS.

    TRY.
        lo_tabela_parametros_vstel->m_get_range( EXPORTING iv_modulo = lc_parametro-modulo
                                                           iv_chave1 = lc_parametro-chave1
                                                           iv_chave2 = lc_parametro-chave2
                                                 IMPORTING et_range  =  lr_vstel ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.

    SELECT refkey
      FROM j_1bnflin
     WHERE docnum = @is_header-docnum
      INTO @DATA(lv_refkey)
        UP TO 1 ROWS.
    ENDSELECT.

    IF sy-subrc IS INITIAL.

      SELECT root_vbeln AS vbeln,
             vbtyp_v,
             vbelv
        FROM v_vbfa_p1
       WHERE vbeln   = @lv_refkey(10)
         AND vbtyp_v = 'J'
         AND vbelv   IS NOT INITIAL
        INTO @DATA(ls_vbfa)
          UP TO 1 ROWS.
      ENDSELECT.

      IF sy-subrc IS INITIAL.

        SELECT SINGLE vbeln,
                      vstel,
                      vbtyp,
                      xblnr,
                      lfart
          FROM likp
         WHERE vbeln = @ls_vbfa-vbelv
          INTO @DATA(ls_likp).

        IF sy-subrc IS NOT INITIAL.
          RETURN.
        ENDIF.

      ENDIF.
    ENDIF.

    LOOP AT lr_vstel ASSIGNING FIELD-SYMBOL(<fs_vstel>).

      IF <fs_vstel>-low EQ is_header-vstel.

        lo_proxy ?= zclsd_saga_integracoes=>factory( iv_kind = |U| ).

        lo_proxy->gs_badi_nfe = abap_true.
        lo_proxy->gs_nfenum   = is_header-nfenum.
        lo_proxy->set_data( iv_likp = CORRESPONDING #( ls_likp ) ).

        lo_proxy->zifsd_saga_integracoes~build( ).
        lo_proxy->zifsd_saga_integracoes~execute( ).

        IF sy-subrc EQ 0.
          COMMIT WORK.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDIF.

ENDFUNCTION.
