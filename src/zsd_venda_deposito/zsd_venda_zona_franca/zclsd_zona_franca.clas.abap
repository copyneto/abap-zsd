CLASS zclsd_zona_franca DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS:
      "! Método para tratamento de regra  Zona Franca IPI na ordem.
      "! @parameter iv_j_1btaxlw2 |  Direito fiscal: IPI
      "! @parameter iv_werks      |  Centro
      "! @parameter iv_txjcd      |  Domicílio fiscal
      "! @parameter iv_brsch      |  Chave do setor industrial
      "! @parameter iv_matkl      |  Grupo de mercadorias
      "! @parameter rv_retorno    |  Direito fiscal: IPI
      execute
        IMPORTING
          iv_j_1btaxlw2     TYPE j_1btaxlw2
          iv_werks          TYPE werks_d
          iv_txjcd          TYPE txjcd
          iv_brsch          TYPE brsch
          iv_matkl          TYPE matkl
        RETURNING
          VALUE(rv_retorno) TYPE j_1btaxlw2 .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zclsd_zona_franca IMPLEMENTATION.
  METHOD execute.
    rv_retorno = iv_j_1btaxlw2.

    "Centro - Domicílio Fiscal - Setor Industrial - Grupo de Mercadorias
    SELECT SINGLE taxlaw
      FROM ztsd_ipi
    WHERE werks = @iv_werks
      AND txjcd = @iv_txjcd
      AND brsch = @iv_brsch
      AND matkl = @iv_matkl
    INTO @DATA(lv_taxlaw).
    IF sy-subrc IS NOT INITIAL.
      "Centro - Setor Industrial - Grupo de Mercadorias
      SELECT SINGLE taxlaw
        FROM ztsd_ipi
      WHERE werks = @iv_werks
        AND txjcd = @abap_false
        AND brsch = @iv_brsch
        AND matkl = @iv_matkl
      INTO @lv_taxlaw.
      IF sy-subrc IS NOT INITIAL.
        "Centro - Domicílio Fiscal - Grupo de Mercadorias
        SELECT SINGLE taxlaw
        FROM ztsd_ipi
        WHERE werks = @iv_werks
          AND txjcd = @iv_txjcd
          AND brsch = @abap_false
          AND matkl = @iv_matkl
        INTO @lv_taxlaw.
        IF sy-subrc = 0.
          rv_retorno = lv_taxlaw.
        ENDIF.
      ELSE.
        rv_retorno = lv_taxlaw.
      ENDIF.
    ELSE.
      rv_retorno = lv_taxlaw.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
