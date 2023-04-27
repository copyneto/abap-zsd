interface ZCLSD_II_SI_PROCESSAR_FATURA_I
  public .


  methods SI_PROCESSAR_FATURA_IN
    importing
      !INPUT type ZCLSD_MT_FATURA
    raising
      ZCLSD_CX_FMT_FATURA .
endinterface.
