class ZCLSD_XNFE_EMAIL_B2B definition
  public
  final
  create public .

public section.

  interfaces /XNFE/IF_EX_EMAIL_B2B .
  interfaces IF_BADI_INTERFACE .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_XNFE_EMAIL_B2B IMPLEMENTATION.


  METHOD /xnfe/if_ex_email_b2b~get_email.
    RETURN.
  ENDMETHOD.


  METHOD /xnfe/if_ex_email_b2b~get_email_incte.
    RETURN.
  ENDMETHOD.


  METHOD /xnfe/if_ex_email_b2b~get_email_innfe.
    RETURN.
  ENDMETHOD.


  METHOD /xnfe/if_ex_email_b2b~get_email_outcte.
    RETURN.
  ENDMETHOD.


  METHOD /xnfe/if_ex_email_b2b~get_email_outnfe.

    CALL FUNCTION 'ZFMSD_NFE_B2B_OUT' " GAP 526
      EXPORTING
        is_outnfehd  = is_outnfehd
        iv_scenario  = iv_scenario
      IMPORTING
        ev_commparam = ev_commparam.

  ENDMETHOD.
ENDCLASS.
