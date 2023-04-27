interface ZCLSD_II_SI_RECEBE_ALTERACAO_O
  public .


  methods SI_RECEBE_ALTERACAO_ORDEM_VEND
    importing
      !INPUT type ZCLSD_MT_ALTERAR_ORDEM_VENDA_I
    raising
      ZCLSD_CX_FMT_ALTERACAO_ORDEM_V .
endinterface.
