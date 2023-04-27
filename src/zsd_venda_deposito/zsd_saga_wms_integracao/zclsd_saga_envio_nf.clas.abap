class ZCLSD_SAGA_ENVIO_NF definition
  public
  final
  create public .

public section.

  methods MAIN
    importing
      !IS_HEADER type J_1BNFDOC .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_SAGA_ENVIO_NF IMPLEMENTATION.


  METHOD main.

    DATA: ls_header TYPE zssd_envnf_saga.

    ls_header = CORRESPONDING #( is_header ).

    CALL FUNCTION 'ZFMSD_ENVIO_NF_SAGA'
      STARTING NEW TASK 'SAGA_ENV_NF'
      EXPORTING
        is_header = ls_header.

  ENDMETHOD.
ENDCLASS.
