FUNCTION zfmsd_criar_ordem_frete_inter.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(EV_ORDEM_FRETE) TYPE  /SCMTMS/TOR_ID
*"     VALUE(ET_RETURN) TYPE  BAL_T_MSGR
*"  TABLES
*"      T_COCKPIT TYPE  ZCTGSD_COCKPIT
*"----------------------------------------------------------------------

  DATA: lt_remessa TYPE zcltm_process_of=>ty_tipos_remessas.

  CLEAR lt_remessa.

  "Valida se iguais

  DATA(ls_cockpit) = t_cockpit[ 1 ].

  LOOP AT t_cockpit ASSIGNING FIELD-SYMBOL(<fs_cockpit>).

    IF <fs_cockpit>-ztraid  NE ls_cockpit-ztraid
    OR <fs_cockpit>-ztrai1  NE ls_cockpit-ztrai1
    OR <fs_cockpit>-ztrai2  NE ls_cockpit-ztrai2
    OR <fs_cockpit>-ztrai3  NE ls_cockpit-ztrai3
    OR <fs_cockpit>-agfrete NE ls_cockpit-agfrete
    OR <fs_cockpit>-motora  NE ls_cockpit-motora.

      APPEND VALUE #( msgid = 'ZSD_INTERCOMPANY'
                      msgno = 035
                      msgty = 'E' ) TO et_return.
      RETURN.

    ELSE.
      APPEND VALUE #( sign = 'I'
                      option = 'EQ'
                      low = <fs_cockpit>-remessa ) TO lt_remessa.
    ENDIF.
  ENDLOOP.

  IF lt_remessa IS INITIAL.
    RETURN.
  ENDIF.

  DATA(lo_gerar_of) = NEW zcltm_process_of_intercompany( ).
  CALL METHOD lo_gerar_of->process_documents
    EXPORTING
      ir_remessas = lt_remessa
      ir_plctrk   = ls_cockpit-ztraid
      ir_plctr1   = ls_cockpit-ztrai1
      ir_plctr2   = ls_cockpit-ztrai2
      ir_plctr3   = ls_cockpit-ztrai3
      ir_tsp      = ls_cockpit-agfrete
      ir_driver   = ls_cockpit-motora
      iv_event    = 'FATURAR/CARREGAR'.     " INSERT - JWSILVA - 06.03.2023

  ev_ordem_frete = lo_gerar_of->get_freightorder( ).

  et_return = lo_gerar_of->read_log( ).

ENDFUNCTION.
