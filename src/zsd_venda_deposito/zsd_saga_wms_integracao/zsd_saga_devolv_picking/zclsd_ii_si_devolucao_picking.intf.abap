interface ZCLSD_II_SI_DEVOLUCAO_PICKING
  public .


  methods SI_DEVOLUCAO_PICKING_REMESSA_I
    importing
      !INPUT type ZCLSD_MT_DEVOLUCAO_PICKING_REM
    raising
      ZCLSD_CX_FMT_DEVOLUCAO_PICKING .
endinterface.
