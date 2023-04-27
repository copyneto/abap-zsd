FUNCTION zfmsd_cockpit_remessa_ctrl_wms.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IV_VSTEL) TYPE  LIKP-VSTEL
*"     REFERENCE(IV_LPRIO) TYPE  LIKP-LPRIO
*"  CHANGING
*"     REFERENCE(CV_KOMKZ) TYPE  LIPS-KOMKZ
*"----------------------------------------------------------------------

* ---------------------------------------------------------------------------
* Recupera Parâmetros
* ---------------------------------------------------------------------------
  DATA(lo_events) = NEW zclsd_cockpit_remessa_events( ).

  lo_events->get_configuration( IMPORTING es_parameter = DATA(ls_parameter)
                                          et_return    = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Valida se parâmetro de ativação está ligado
* ---------------------------------------------------------------------------
  IF ls_parameter-exit_mv50afz3 IS INITIAL.
    RETURN.
  ENDIF.

* ---------------------------------------------------------------------------
* Valida Local de expedição
* ---------------------------------------------------------------------------
  IF ( iv_vstel IN ls_parameter-r_vstel[] AND ls_parameter-r_vstel[] IS NOT INITIAL ).
    " Atualiza Código para controle de picking dos itens
    CLEAR cv_komkz.
    RETURN.
  ENDIF.

* ---------------------------------------------------------------------------
* Valida Prioridade de remessa
* ---------------------------------------------------------------------------
  IF ( iv_lprio IN ls_parameter-r_lprio[] AND ls_parameter-r_lprio[] IS NOT INITIAL ).
    " Atualiza Código para controle de picking dos itens
    CLEAR cv_komkz.
    RETURN.
  ENDIF.

ENDFUNCTION.
