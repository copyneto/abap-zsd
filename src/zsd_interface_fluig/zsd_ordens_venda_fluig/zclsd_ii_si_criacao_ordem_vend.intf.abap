interface ZCLSD_II_SI_CRIACAO_ORDEM_VEND
  public .


  methods SI_CRIACAO_ORDEM_VENDA_FLUIG_I
    importing
      !INPUT type ZCLSD_MT_CRIACAO_ORDEM_VENDA_F
    raising
      ZCLSD_CX_FMT_CRIACAO_ORDEM_VE1 .
endinterface.
