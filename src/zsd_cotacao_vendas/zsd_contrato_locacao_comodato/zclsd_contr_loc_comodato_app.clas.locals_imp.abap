CLASS lcl_contrloccom DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK contrloccom.

    METHODS read FOR READ
      IMPORTING keys FOR READ contrloccom RESULT result.

ENDCLASS.

CLASS lcl_contrloccom IMPLEMENTATION.

  METHOD lock.
   RETURN.
  ENDMETHOD.

  METHOD read.
   RETURN.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_zi_sd_contr_loc_comodato_a DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_zi_sd_contr_loc_comodato_a IMPLEMENTATION.

  METHOD check_before_save.
   RETURN.
  ENDMETHOD.

  METHOD finalize.
   RETURN.
  ENDMETHOD.

  METHOD save.
   RETURN.
  ENDMETHOD.

ENDCLASS.
