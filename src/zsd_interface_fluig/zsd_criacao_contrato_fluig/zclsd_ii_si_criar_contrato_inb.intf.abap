interface ZCLSD_II_SI_CRIAR_CONTRATO_INB
  public .


  methods SI_CRIAR_CONTRATO_INB
    importing
      !INPUT type ZCLSD_MT_CRIAR_CONTRATO
    raising
      ZCLSD_CX_FMT_CRIAR_CONTRATO .
endinterface.
