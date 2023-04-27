CLASS zclsd_saga_integracoes DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zifsd_saga_integracoes.

    CLASS-METHODS factory
      IMPORTING iv_kind        TYPE char1 OPTIONAL
      RETURNING VALUE(rr_saga) TYPE REF TO zifsd_saga_integracoes.

    METHODS: set_data IMPORTING iv_likp TYPE likp.

    DATA: gs_badi_nfe TYPE abap_bool,
          gs_nfenum type j_1bnfdoc-nfenum.


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
        IF NOT gs_proxy-mt_cancelar_atualizar_remessa-pedidosdocliente-vbeln IS INITIAL.
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
ENDCLASS.
