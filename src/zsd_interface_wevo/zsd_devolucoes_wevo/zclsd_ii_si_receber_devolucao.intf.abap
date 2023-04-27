interface ZCLSD_II_SI_RECEBER_DEVOLUCAO
  public .


  methods SI_RECEBER_DEVOLUCAO_MATERIAL
    importing
      !INPUT type ZCLSD_MT_DEVOLUCAO_MATERIAL
    raising
      ZCLSD_CX_FMT_DEVOLUCAO_MATERIA .
endinterface.
