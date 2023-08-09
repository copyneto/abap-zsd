CLASS zclsd_retorna_devolucao_replic DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


    DATA:
         "! Cabeçalho da nota fiscal
          gs_header_nf  TYPE j_1bnfdoc.

    "! Método principal que inicia a execução da classe
    "! @parameter is_header_nf           | Cabeçalho da nota fiscal
    "! @parameter ev_saida_transferencia | Saída transferência
    METHODS executar IMPORTING is_header_nf           TYPE j_1bnfdoc
                     EXPORTING ev_saida_transferencia TYPE mseg-mblnr
                               ev_em_transferencia    TYPE mseg-mblnr
                               ev_devolucao           TYPE i_br_nfdocument-br_notafiscal.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS:
      "! Constantes para tabela de parâmetros Saída Transferência
      BEGIN OF gc_parametros_saida,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'ADM DEVOLUÇÃO',
        chave2 TYPE ztca_param_par-chave2 VALUE 'MVM_DF',
      END OF gc_parametros_saida.

    CONSTANTS:
      "! Constantes para tabela de parâmetros Em Transferência
      BEGIN OF gc_parametros_trans,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'ADM DEVOLUÇÃO',
        chave2 TYPE ztca_param_par-chave2 VALUE 'MVM_DFE',
      END OF gc_parametros_trans.

    TYPES:
      "! Types Cabeçalho do documento do material
      BEGIN OF ty_mkpf,
        mblnr TYPE mkpf-mblnr,
      END OF ty_mkpf.

    "!  Tipo de movimento Saída Transferência
    DATA gs_tp_mov_saida TYPE RANGE OF  mseg-bwart.
    "!  Tipo de movimento Em Transferência
    DATA gs_tp_mov_trans TYPE RANGE OF  mseg-bwart.
    "! Cabeçalho do documento do material
    DATA gs_mkpf TYPE ty_mkpf.
    "!  Nº documento de referência
    DATA gs_xblnr TYPE mkpf-xblnr.

    "! Seleciona os Tipos de movimentos Saída Transferência
    METHODS get_param_tp_mov_saida.
    "! Seleciona os Tipos de movimentos Em Transferência
    METHODS get_param_tp_mov_trans.

    "! Retorna Saída transferência
    "! @parameter rv_saida_transferencia | Saída transferência
    METHODS saida_transferencia
      RETURNING
        VALUE(rv_saida_transferencia) TYPE mseg-mblnr.

    "! Retorna Em transferência
    "! @parameter rv_em_transferencia | Em transferência
    METHODS em_transferencia
      RETURNING
        VALUE(rv_em_transferencia) TYPE mseg-mblnr.

    "! Retorna Devolução
    "! @parameter rv_devolucao | Devolução
    METHODS devolucao
      RETURNING
        VALUE(rv_devolucao) TYPE  i_br_nfdocument-br_notafiscal.

    "! Converte Documento
    METHODS converte_documento.

ENDCLASS.



CLASS ZCLSD_RETORNA_DEVOLUCAO_REPLIC IMPLEMENTATION.


  METHOD executar.

    gs_header_nf = is_header_nf.

    ev_saida_transferencia = saida_transferencia(  ).
    ev_em_transferencia    = em_transferencia(  ).
    ev_devolucao           = devolucao(  ).

  ENDMETHOD.


  METHOD get_param_tp_mov_saida.

    DATA(lo_tabela_parametros) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 24.07.2023

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
      iv_modulo = gc_parametros_saida-modulo
      iv_chave1 = gc_parametros_saida-chave1
      iv_chave2 = gc_parametros_saida-chave2
          IMPORTING
            et_range  = gs_tp_mov_saida
        ).


      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.


  METHOD get_param_tp_mov_trans.

    DATA(lo_tabela_parametros) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 24.07.2023

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
      iv_modulo = gc_parametros_trans-modulo
      iv_chave1 = gc_parametros_trans-chave1
      iv_chave2 = gc_parametros_trans-chave2
          IMPORTING
            et_range  = gs_tp_mov_trans
        ).


      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.


  METHOD saida_transferencia.

    converte_documento( ).

    SELECT SINGLE mblnr
    FROM mkpf
    INTO gs_mkpf
    WHERE xblnr EQ gs_xblnr
      AND budat EQ gs_header_nf-pstdat.

    CHECK gs_mkpf IS NOT INITIAL.

    SELECT SINGLE mblnr
    FROM mseg
    INTO rv_saida_transferencia
    WHERE mblnr EQ gs_mkpf
      AND bwart IN gs_tp_mov_saida.

  ENDMETHOD.


  METHOD em_transferencia.

    CHECK gs_mkpf IS NOT INITIAL.

    SELECT SINGLE mblnr
    FROM mseg
    INTO rv_em_transferencia
    WHERE mblnr EQ gs_mkpf
      AND bwart IN gs_tp_mov_trans.

  ENDMETHOD.


  METHOD devolucao.

    SELECT SINGLE br_notafiscal
      FROM  i_br_nfdocument
      INTO @rv_devolucao
      WHERE br_nftype            EQ @gs_header_nf-nftype
        AND br_nfobservationtext EQ @gs_header_nf-docnum
        AND br_nfpostingdate     EQ @gs_header_nf-pstdat.

  ENDMETHOD.


  METHOD converte_documento.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = gs_header_nf-docnum
      IMPORTING
        output = gs_xblnr.

  ENDMETHOD.
ENDCLASS.
