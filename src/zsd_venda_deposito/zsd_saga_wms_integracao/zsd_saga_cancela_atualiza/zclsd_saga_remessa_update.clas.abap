CLASS zclsd_saga_remessa_update DEFINITION
  PUBLIC
  INHERITING FROM zclsd_saga_remessa
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS:
      zifsd_saga_integracoes~build REDEFINITION.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zclsd_saga_remessa_update IMPLEMENTATION.

  METHOD zifsd_saga_integracoes~build.

    super->zifsd_saga_integracoes~build( ).

  ENDMETHOD.

ENDCLASS.
