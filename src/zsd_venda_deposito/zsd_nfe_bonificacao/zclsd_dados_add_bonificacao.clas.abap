class ZCLSD_DADOS_ADD_BONIFICACAO definition
  public
  final
  create public .

public section.

    "! Método Constructor
    "! @parameter it_nflin | Tabela dos itens da nota fiscal (J_1BNFLIN)
  methods CONSTRUCTOR
    importing
      !IT_NFLIN type J_1BNFLIN_TAB
      !IS_VBRK type VBRKVB
      !IT_VBRP type VBRP_TAB .
    "! Executa o processo de geração de dados bonificação
    "! @parameter ct_add_info | Campos de uso grátis para informações adicionais
  methods EXECUTAR
    changing
      !CT_ADD_INFO type J_1BNFFTX_TAB
      !CS_HEADER type J_1BNF_BADI_HEADER .
  PROTECTED SECTION.
private section.

  types:
    "! Types dados fatura
    BEGIN OF ty_fatura,
      docnum TYPE  j_1bnfdoc-docnum,
      nfenum TYPE  j_1bnfdoc-nfenum,
      series TYPE  j_1bnfdoc-series,
      pstdat TYPE  j_1bnfdoc-pstdat,
    END OF ty_fatura .
  types:
    BEGIN OF ty_vbak,
      vbeln TYPE vbak-vbeln,
    END OF ty_vbak .
  types:
    BEGIN OF ty_bstnk,
*             bstnk TYPE vbak-bstnk,
      ihrez TYPE vbak-ihrez,
    END OF ty_bstnk .
  types:
    tt_bstnk TYPE TABLE OF ty_bstnk .

  constants:
    "! Constantes para tabela de parâmetros
    BEGIN OF gc_parametros,
      modulo TYPE ze_param_modulo VALUE 'SD',
      chave1 TYPE ztca_param_par-chave1 VALUE 'NFE',
      chave2 TYPE ztca_param_par-chave2 VALUE 'TP_OV_BONIF',
    END OF gc_parametros .
  data:
    gt_vbak TYPE TABLE OF ty_vbak .
  data GS_VBAK type TY_VBAK .
  "!  Tabela dos itens da nota fiscal (J_1BNFLIN)
  data GT_NFLIN type J_1BNFLIN_TAB .
  "!  Tabela dos Documento de faturamento: dados de cabeçalho
  data GS_VBRK type VBRK .
  data:
"!  Tabela dos Documento de faturamento: dados de Item
    gt_vbrp      TYPE TABLE OF vbrp .
  data:
          "!  Tabela dados fatura
    gt_fatura     TYPE SORTED TABLE OF ty_fatura WITH NON-UNIQUE KEY docnum .
  data:
          "! Estrutura dados fatura
    gs_tipo_fat   TYPE RANGE OF vbrk-fkart .

  "! Seleciona Dados
  methods SELECIONA_DADOS .
  "! Seleciona tipo de faturamento na tablea de parâmetros
  methods GET_PARAM_TIPO_FAT .
  "! Converte Data
  "! @parameter is_fatura | Estrutura dados fatura
  "! @parameter rv_data   | Data Convertida
  methods CONVERTE_DATA
    importing
      !IS_FATURA type ZCLSD_DADOS_ADD_BONIFICACAO=>TY_FATURA
    returning
      value(RV_DATA) type CHAR10 .
  "! Seleciona tipo referência
  methods SELECIONA_TP_REF .
  "! Adiciona dados bonificação
  "! @parameter ct_add_info | Campos de uso grátis para informações adicionais
  methods ADD_DADOS_BONIFICACAO
    changing
      !CT_ADD_INFO type J_1BNFFTX_TAB
      !CS_HEADER type J_1BNF_BADI_HEADER .
  methods TRATA_VBAK
    importing
      !IT_VBAK type TT_BSTNK .
ENDCLASS.



CLASS ZCLSD_DADOS_ADD_BONIFICACAO IMPLEMENTATION.


  METHOD constructor.
    gt_nflin = it_nflin.
    gs_vbrk  = is_vbrk.
    gt_vbrp  = it_vbrp.
  ENDMETHOD.


  METHOD executar.

    get_param_tipo_fat(  ).

    seleciona_dados(  ).

    add_dados_bonificacao( CHANGING ct_add_info = ct_add_info cs_header = cs_header ).

  ENDMETHOD.


  METHOD add_dados_bonificacao.

    DATA(lt_nfetx) = ct_add_info.

    SORT lt_nfetx BY seqnum DESCENDING.

    DATA(lv_seq) = VALUE #( lt_nfetx[ 1 ]-seqnum DEFAULT 0 ).
    DATA(lv_linnum) = VALUE #( lt_nfetx[ 1 ]-linnum DEFAULT 0 ).

    LOOP AT  gt_fatura ASSIGNING FIELD-SYMBOL(<fs_fatura>).


      DATA(lv_data) = converte_data( <fs_fatura> ).

      ADD 1 TO lv_seq.
      APPEND VALUE j_1bnfftx( seqnum = lv_seq linnum = lv_linnum message = |{ TEXT-001 } { <fs_fatura>-nfenum }-{ <fs_fatura>-series }| ) TO ct_add_info.
      ADD 1 TO lv_linnum.
      APPEND VALUE j_1bnfftx( seqnum = lv_seq linnum = lv_linnum message = |{ TEXT-002 } { lv_data }.| ) TO ct_add_info.
      cs_header-infcpl = |{ cs_header-infcpl } { TEXT-001 } { <fs_fatura>-nfenum }-{ <fs_fatura>-series } { TEXT-002 } { lv_data }.|.
    ENDLOOP.

  ENDMETHOD.


  METHOD converte_data.

    rv_data = |{ is_fatura-pstdat+6(2) }.{ is_fatura-pstdat+4(2) }.{ is_fatura-pstdat(4) }|.

  ENDMETHOD.


  METHOD seleciona_dados.

    seleciona_tp_ref( ).

    CHECK gt_nflin IS NOT INITIAL AND line_exists( gs_tipo_fat[ low = gs_vbrk-fkart ] ) AND gt_vbrp IS NOT INITIAL. "#EC CI_STDSEQ

    SELECT vgbel
    INTO TABLE @DATA(lt_lips)
    FROM lips
    FOR ALL ENTRIES IN @gt_vbrp
    WHERE vbeln EQ @gt_vbrp-vgbel.

    IF lt_lips IS NOT INITIAL.

      SELECT ihrez"bstnk
      INTO TABLE @DATA(lt_vbak)
      FROM vbak
      FOR ALL ENTRIES IN @lt_lips
      WHERE vbeln EQ @lt_lips-vgbel.

      IF lt_vbak IS NOT INITIAL.

        trata_vbak( lt_vbak ).

        IF gt_vbak IS NOT INITIAL.
          SELECT vbeln
                   INTO TABLE @DATA(lt_remessa)
                   FROM vbfa
                   FOR ALL ENTRIES IN @gt_vbak
                   WHERE vbelv EQ @gt_vbak-vbeln
                   AND vbtyp_n EQ 'J'.

        ENDIF.
      ENDIF.

    ENDIF.


    IF lt_remessa IS NOT INITIAL.


      SELECT DISTINCT j_1bnfdoc~docnum, j_1bnfdoc~nfenum, j_1bnfdoc~series, j_1bnfdoc~pstdat
      INTO TABLE @gt_fatura
      FROM vbfa
      INNER JOIN j_1bnflin
  ON vbfa~vbeln EQ j_1bnflin~refkey
  AND j_1bnflin~reftyp = 'BI'
      INNER JOIN j_1bnfdoc
  ON j_1bnflin~docnum EQ j_1bnfdoc~docnum
      FOR ALL ENTRIES IN @lt_remessa
      WHERE vbfa~vbelv   EQ @lt_remessa-vbeln
* LSCHEPP - SD - 8000007698 - REF DA BONIFICAÇÃO GAP175 - 23.05.2023 Início
        AND j_1bnfdoc~cancel EQ @space
* LSCHEPP - SD - 8000007698 - REF DA BONIFICAÇÃO GAP175 - 23.05.2023 Fim
        AND vbfa~vbtyp_n EQ 'M'.

    ENDIF.
  ENDMETHOD.


  METHOD trata_vbak.

    LOOP AT it_vbak ASSIGNING FIELD-SYMBOL(<fs_vbak>).
*      IF <fs_vbak>-ihrez CO '0123456789'.
        gs_vbak-vbeln = <fs_vbak>-ihrez.
        UNPACK gs_vbak-vbeln TO gs_vbak-vbeln.
        APPEND gs_vbak TO gt_vbak.
*      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD seleciona_tp_ref.

    LOOP AT gt_nflin ASSIGNING FIELD-SYMBOL(<fs_nflin>).
      IF <fs_nflin>-reftyp NE 'BI'.
        DELETE gt_nflin INDEX sy-tabix.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_param_tipo_fat.

    DATA(lo_tabela_parametros) = NEW  zclca_tabela_parametros( ).

    CLEAR gs_tipo_fat.

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
      iv_modulo = gc_parametros-modulo
      iv_chave1 = gc_parametros-chave1
      iv_chave2 = gc_parametros-chave2
          IMPORTING
            et_range  = gs_tipo_fat
        ).

      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
