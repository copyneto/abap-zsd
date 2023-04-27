class ZCLSD_BADI_SD_APM definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_BADI_SD_APM .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_BADI_SD_APM IMPLEMENTATION.


  METHOD if_badi_sd_apm~get_sdoc_rejection_reason.
    RETURN.
  ENDMETHOD.
ENDCLASS.
