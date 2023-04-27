interface ZCLSD_II_SI_CRIAR_ORDEM_VENDA1
  public .


  methods SI_CRIAR_ORDEM_VENDA_IN
    importing
      !INPUT type ZCLSD_MT_CRIACAO_ORDEM_VENDA
    raising
      ZCLSD_CX_FMT_CRIACAO_ORDEM_VEN .
endinterface.
