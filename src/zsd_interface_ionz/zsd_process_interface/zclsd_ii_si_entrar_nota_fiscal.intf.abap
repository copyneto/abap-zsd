interface ZCLSD_II_SI_ENTRAR_NOTA_FISCAL
  public .


  methods SI_ENTRAR_NOTA_FISCAL_SERVICO
    importing
      !INPUT type ZCLSD_MT_NOTA_FISCAL_SERVICO
    raising
      ZCLSD_CX_FMT_ENTRAR_NOTA_FISCA .
endinterface.
