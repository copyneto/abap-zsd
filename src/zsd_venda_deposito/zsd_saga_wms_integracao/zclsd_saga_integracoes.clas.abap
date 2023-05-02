class ZCLSD_SAGA_INTEGRACOES definition
  public
  abstract
  create public .

public section.

  interfaces ZIFSD_SAGA_INTEGRACOES .

  data GS_BADI_NFE type ABAP_BOOL .
  data GS_NFENUM type J_1BNFDOC-NFENUM .

  class-methods FACTORY
    importing
      !IV_KIND type CHAR1 optional
    returning
      value(RR_SAGA) type ref to ZIFSD_SAGA_INTEGRACOES .
  methods SET_DATA
    importing
      !IV_LIKP type LIKP .
  methods CHECK_SENT
    returning
      value(RV_RETURN) type ABAP_BOOL .
  PROTECTED SECTION.

    TYPES:
      BEGIN OF ty_proxy,
        werks        TYPE werks_d,
        ztipocommand TYPE char1,
        ztipoped     TYPE char2,
        ztipoope     TYPE char1,
        vbeln        TYPE vbeln,
        nfnum        TYPE j_1bnfnum9,
        znumext      TYPE char10,
        zordemfrete  TYPE erptms_tor_id,
        zdataagenda  TYPE dats,
      END OF ty_proxy.

    DATA: gs_likp  TYPE likp,
          gs_proxy TYPE zclsd_mt_cancelar_atualizar_re.

  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLSD_SAGA_INTEGRACOES IMPLEMENTATION.


  METHOD zifsd_saga_integracoes~build.
    RETURN.
  ENDMETHOD.


  METHOD zifsd_saga_integracoes~execute.
    TRY.
        IF NOT gs_proxy-mt_cancelar_atualizar_remessa-pedidosdocliente-vbeln IS INITIAL AND
* LSCHEPP - 8000006844 - Erro Saga - EnviarCancelarAtualizarRemes - 02.05.2023 Início
           NOT gs_proxy-mt_cancelar_atualizar_remessa-ztipoped IS INITIAL.
* LSCHEPP - 8000006844 - Erro Saga - EnviarCancelarAtualizarRemes - 02.05.2023 Fim
          NEW zclsd_co_si_enviar_cancelar_at( )->si_enviar_cancelar_atualizar_r( output = gs_proxy  ).
        ENDIF.
      CATCH cx_ai_system_fault.
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD factory.

    CASE iv_kind.
      WHEN 'C'.
        rr_saga ?= NEW zclsd_saga_remessa_cancel( ).
      WHEN 'U'.
        rr_saga ?= NEW zclsd_saga_remessa_update( ).
      WHEN OTHERS.
        rr_saga ?= NEW zclsd_saga_devolv_picking( ).
    ENDCASE.

  ENDMETHOD.


  METHOD set_data.

    gs_likp = CORRESPONDING #( iv_likp ).

  ENDMETHOD.


  METHOD check_sent.

    SELECT COUNT( * )
      FROM ztsd_rem_saga
      WHERE remessa      EQ @gs_likp-vbeln
        AND enviado_saga EQ @abap_true.
    IF sy-subrc EQ 0.
      rv_return = abap_true.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
