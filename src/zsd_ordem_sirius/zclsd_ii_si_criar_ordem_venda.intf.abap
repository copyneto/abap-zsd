interface ZCLSD_II_SI_CRIAR_ORDEM_VENDA
  public .


  methods SI_CRIAR_ORDEM_VENDA_IN
    importing
      !INPUT type ZCLSD_MT_CRIACAO
    raising
      ZCLSD_CX_FMT_CRIACAO .
endinterface.
