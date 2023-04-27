interface ZCLSD_II_SI_GRAVAR_DADOS_REPRO
  public .


  methods SI_GRAVAR_DADOS_REPROCESSAR_IN
    importing
      !INPUT type ZCLSD_MT_DADOS_REPROCESSAR
    raising
      ZCLSD_CX_FMT_DADOS_REPROCESSAR .
endinterface.
