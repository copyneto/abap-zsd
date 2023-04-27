class ZCLSD_SAGA_REMESSA definition
  public
  inheriting from ZCLSD_SAGA_INTEGRACOES
  abstract
  create public .

public section.

  methods VALORES_BADI_NFE
    returning
      value(RV_NFENUM) type J_1BNFDOC-NFENUM .

  methods ZIFSD_SAGA_INTEGRACOES~BUILD
    redefinition .
  PROTECTED SECTION.

    DATA lt_docflow TYPE tdt_docflow.

private section.

  types:
    ty_lr_lfart TYPE RANGE OF likp-lfart .

  methods BUSCA_LFART
    returning
      value(RR_LFART) type TY_LR_LFART .
ENDCLASS.



CLASS ZCLSD_SAGA_REMESSA IMPLEMENTATION.


  METHOD zifsd_saga_integracoes~build.

    "gs_proxy-mt_cancelar_atualizar_remessa-vbeln = gs_likp-vbeln.
    gs_proxy-mt_cancelar_atualizar_remessa-werks = gs_likp-vstel.

    DATA(lt_lfart) = busca_lfart( ).

    READ TABLE lt_lfart ASSIGNING FIELD-SYMBOL(<fs_lfart>) INDEX 1.

    IF <fs_lfart> IS ASSIGNED.
      gs_proxy-mt_cancelar_atualizar_remessa-ztipoped = CONV #( <fs_lfart>-low ).
    ENDIF.
*    gs_proxy-mt_cancelar_atualizar_remessa-ztipoped = COND #( WHEN gs_likp-vbtyp = |J| THEN '5' WHEN gs_likp-vbtyp = |T| THEN '14' ELSE gs_likp-vbtyp ).

    gs_proxy-mt_cancelar_atualizar_remessa-ztipoope = COND #( WHEN gs_likp-vbtyp = |J| THEN '2' WHEN gs_likp-vbtyp = |T| THEN '1'  ELSE gs_likp-vbtyp ).

*** Flávia Leite- Chamado 8000005968 - REAGENDAMENTO
*    SELECT SINGLE nf_e, data_agendada
*      FROM ztsd_agendamento
*     WHERE remessa = @gs_likp-vbeln
**       AND nf_e = @gs_likp-xblnr
*       AND data_registro = @sy-datum
*      INTO @DATA(ls_agenda).
*
*    IF NOT sy-subrc is initial.
*
*      SELECT SINGLE nf_e, data_agendada
*   FROM ztsd_agendamento
*   WHERE remessa = @gs_likp-vbeln
*   AND nf_e = @gs_likp-xblnr
*   INTO @ls_agenda.
*
*    ENDIF.

    SELECT SINGLE docnum AS nf_e, dataagendada AS data_agendada
      FROM zi_sd_hist_agendamento
     WHERE remessa     EQ @gs_likp-vbeln
       AND agend_valid EQ @abap_true
      INTO @DATA(ls_agenda).
*** Flávia Leite - Chamado 8000005968 - REAGENDAMENTO

*    gs_proxy-nfnum = ls_agenda-nf_e.
*    gs_proxy-zdataagenda = ls_agenda-data_agendada.
*    gs_proxy-znumext = ''.

    CALL FUNCTION 'SD_DOCUMENT_FLOW_GET'
      EXPORTING
        iv_docnum  = gs_likp-vbeln
      IMPORTING
        et_docflow = lt_docflow.

    DELETE lt_docflow WHERE vbtyp_n NE |TMFO|.

    TRY.
        "gs_proxy-zordemfrete = lt_docflow[ 1 ]-docnum.
        DATA(lv_zordemfrete) = lt_docflow[ 1 ]-docnum.
      CATCH cx_root.

    ENDTRY.

    gs_proxy-mt_cancelar_atualizar_remessa-ztipocomand = 4.

    ls_agenda-nf_e = valores_badi_nfe(  ).

    DATA(lv_vbeln) = |{ gs_likp-vbeln ALPHA = OUT }|.

    gs_proxy-mt_cancelar_atualizar_remessa-pedidosdocliente = VALUE #( vbeln       = lv_vbeln
                                                                       nfnum       = ls_agenda-nf_e
                                                                       zdataagenda = ls_agenda-data_agendada
                                                                       znumext     = space
                                                                       zordemfrete = lv_zordemfrete ).

  ENDMETHOD.


  METHOD busca_lfart.

    DATA(lo_tabela_parametros_lfart) = NEW zclca_tabela_parametros( ).

    DATA lv_lfart(8) TYPE c.
    lv_lfart = gs_likp-lfart.

    CONSTANTS:
      "! Constantes para tabela de parâmetros
      BEGIN OF lc_parametros,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'SAGA',
        chave2 TYPE ztca_param_par-chave2 VALUE 'ZTIPO',
*        chave3 TYPE ztca_param_par-chave3 VALUE 'LIKP-LFART',
      END OF lc_parametros.



    TRY.
        lo_tabela_parametros_lfart->m_get_range(
    EXPORTING
            iv_modulo = lc_parametros-modulo
            iv_chave1 = lc_parametros-chave1
            iv_chave2 = lc_parametros-chave2
            iv_chave3 = lv_lfart
    IMPORTING
            et_range  =  rr_lfart
    ).

      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.


  METHOD valores_badi_nfe.
    IF gs_badi_nfe EQ abap_true.
      gs_proxy-mt_cancelar_atualizar_remessa-ztipocomand = 5.
      rv_nfenum = gs_nfenum.
    ENDIF.


  ENDMETHOD.
ENDCLASS.
