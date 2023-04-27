interface ZCLSD_II_SI_RECEBER_VENDA_CANC
  public .


  methods SI_RECEBER_VENDA_CANCELAMENTO
    importing
      !INPUT type ZCLSD_MT_VENDA_CANCELAMENTO
    raising
      ZCLSD_CX_FMT_VENDA_CANCELAMENT .
endinterface.
