interface ZCLSD_II_SI_CONSULTA_ATIVO_INB
  public .


  methods SI_CONSULTA_ATIVO_INB
    importing
      !INPUT type ZCLSD_MT_CONSULTA_ATIVO
    exporting
      !OUTPUT type ZCLSD_MT_ENVIA_ATIVO
    raising
      ZCLSD_CX_FMT_CONSULTA_ATIVO .
endinterface.
