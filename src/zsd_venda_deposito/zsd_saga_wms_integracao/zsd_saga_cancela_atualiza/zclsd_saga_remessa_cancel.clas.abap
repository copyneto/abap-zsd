CLASS zclsd_saga_remessa_cancel DEFINITION
  PUBLIC
  INHERITING FROM zclsd_saga_remessa
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS zifsd_saga_integracoes~build REDEFINITION.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclsd_saga_remessa_cancel IMPLEMENTATION.

  METHOD zifsd_saga_integracoes~build.

    super->zifsd_saga_integracoes~build( ).

    gs_proxy-mt_cancelar_atualizar_remessa-ztipocomand = 6.

  ENDMETHOD.

ENDCLASS.
