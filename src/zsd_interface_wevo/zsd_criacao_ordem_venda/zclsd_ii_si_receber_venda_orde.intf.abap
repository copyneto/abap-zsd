interface ZCLSD_II_SI_RECEBER_VENDA_ORDE
  public .


  methods SI_RECEBER_VENDA_ORDEM_INB
    importing
      !INPUT type ZCLSD_MT_VENDA_ORDEM
    raising
      ZSD_CX_FMT_VENDA_ORDEM .
endinterface.
