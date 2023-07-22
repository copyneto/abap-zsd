CLASS zclsd_atribui_nfnum DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! Método Atribui o número de referencia do documento de fatura no número da nota fiscal
    "! @parameter is_wvbrp  | Estrutura de referência para XVBRP/YVBRP
    "! @parameter is_wvbrk  | Estrutura de referência para XVBRK/YVBRP
    "! @parameter cs_wnfdoc | Cabeçalho da nota fiscal
    METHODS executar IMPORTING is_wvbrp  TYPE vbrpvb
                               is_wvbrk  TYPE vbrkvb
                     CHANGING  cs_wnfdoc TYPE j_1bnfdoc.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS:
      "! Constante Cafeterias - Identificador de parametros fixos
      gc_idtp_docfat TYPE ze_caft_idparametro VALUE 'BA'.

    CONSTANTS:
      "! Constantes para tabela de parâmetros
      BEGIN OF gc_parametros,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'SSRESTO',
        chave2 TYPE ztca_param_par-chave2 VALUE 'FKART',
      END OF gc_parametros.


    DATA:
"!Tipo documento de faturamento
gr_fkart  TYPE RANGE OF vbrk-fkart.

    "! "Seleção dos tipos de documento de faturamento usado para processo de cafeterias
    METHODS seleciona_tp_faturamento.

    "! Seleção do numero da nota fiscal e da seria do equipamento.
    "! @parameter is_wvbrp       | Estrutura de referência para XVBRP/YVBRP
    "! @parameter rs_caft_cup_ov | Cafeterias - Doc. de vendas gerado a partir do Cupom Fiscal
    METHODS seleciona_nfe_serie
      IMPORTING
        is_wvbrp              TYPE vbrpvb
      RETURNING
        VALUE(rs_caft_cup_ov) TYPE ztsd_caft_cup_ov.

    "! Seleção das informações de autorização do cupom fiscal
    "! @parameter is_caft_cup_ov | Cafeterias - Doc. de vendas gerado a partir do Cupom Fiscal
    "! @parameter rs_caft_vend_h | Cafeterias - Informações de cabeçalho do cupom fiscal
    METHODS seleciona_info_autorizacao
      IMPORTING
        is_caft_cup_ov        TYPE ztsd_caft_cup_ov
      RETURNING
        VALUE(rs_caft_vend_h) TYPE ztsd_caft_vend_h.

    "! Atribuição dos valores de referencia
    "! @parameter is_wvbrk       | Estrutura de referência para XVBRK/YVBRP
    "! @parameter is_caft_vend_h | Cafeterias - Informações de cabeçalho do cupom fiscal
    "! @parameter cs_wnfdoc      | Cabeçalho da nota fiscal
    METHODS atribuicao_valores_referencia
      IMPORTING
        is_wvbrk       TYPE vbrkvb
        is_caft_vend_h TYPE ztsd_caft_vend_h
      CHANGING
        cs_wnfdoc      TYPE j_1bnfdoc.

ENDCLASS.



CLASS ZCLSD_ATRIBUI_NFNUM IMPLEMENTATION.


  METHOD executar.

    seleciona_tp_faturamento( ).

    CHECK gr_fkart[] IS NOT INITIAL AND is_wvbrk-fkart IN gr_fkart[].


    DATA(ls_caft_cup_ov) = seleciona_nfe_serie( is_wvbrp ).

    DATA(ls_caft_vend_h) = seleciona_info_autorizacao( ls_caft_cup_ov ).


    atribuicao_valores_referencia( EXPORTING is_wvbrk       = is_wvbrk
                                             is_caft_vend_h = ls_caft_vend_h
                                    CHANGING cs_wnfdoc      = cs_wnfdoc ).

  ENDMETHOD.


  METHOD atribuicao_valores_referencia.

    cs_wnfdoc-nfenum   = is_caft_vend_h-numcf."is_wvbrk-xblnr.
    cs_wnfdoc-docstat  = 1.
    cs_wnfdoc-shpnum   = TEXT-001 && is_caft_vend_h-numserie.
    cs_wnfdoc-model    = is_caft_vend_h-model.
    cs_wnfdoc-cod_sit  = '00'.

    CASE cs_wnfdoc-model.
      WHEN '65'.
        cs_wnfdoc-series = is_caft_vend_h-numserie.
    ENDCASE.

    cs_wnfdoc-authcod  = is_caft_vend_h-authcod.
    cs_wnfdoc-authdate = is_caft_vend_h-authdate.
    cs_wnfdoc-authtime = is_caft_vend_h-authtime.
    cs_wnfdoc-cod_sit  = '00'.

  ENDMETHOD.


  METHOD seleciona_info_autorizacao.

    SELECT SINGLE * FROM ztsd_caft_vend_h
      INTO      @rs_caft_vend_h
      WHERE numcf    = @is_caft_cup_ov-numcf
        AND numserie = @is_caft_cup_ov-numserie
        AND werks    = @is_caft_cup_ov-werks.

  ENDMETHOD.


  METHOD seleciona_nfe_serie.

    SELECT SINGLE *
      FROM ztsd_caft_cup_ov
      INTO      @rs_caft_cup_ov
      WHERE vbeln = @is_wvbrp-aubel.

  ENDMETHOD.


  METHOD seleciona_tp_faturamento.

    DATA(lo_tabela_parametros) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 21.07.2023

    CLEAR  gr_fkart.

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
      iv_modulo = gc_parametros-modulo
      iv_chave1 = gc_parametros-chave1
      iv_chave2 = gc_parametros-chave2
          IMPORTING
            et_range  =  gr_fkart
        ).

      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
