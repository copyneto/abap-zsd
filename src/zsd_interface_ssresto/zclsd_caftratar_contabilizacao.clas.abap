CLASS zclsd_caftratar_contabilizacao DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA:
          "!Tipo documento de faturamento
           gr_fkart  TYPE RANGE OF vbrk-fkart.

    TYPES:
      "! Types Interface com contabilidade: informação sobre item
      ty_accit       TYPE TABLE OF  accit,
      "! Types Interface com contabilidade: informação sobre moeda
      ty_acccr       TYPE TABLE OF  acccr,
      "! Types Interface com a contabilidade: contabilidade financeira CtaO
      ty_accfi       TYPE TABLE OF  accfi,
      "! Types Cafeterias - Movimentação de Pagamento do cupom fiscal
      ty_caft_vend_p TYPE TABLE OF  ztsd_caft_vend_p,
      "! Types  Cafeterias - Tipo de condição de pgmt. c/ conta contábil
      ty_caft_tpcond TYPE TABLE OF  ztsd_caft_tpcond.

    "! Executa atualização dos valores de contabilização
    "! @parameter is_cvbrk  | Documento de faturamento: dados de cabeçalho
    "! @parameter is_cvbrp  | Estrutura de referência para XVBRP/YVBRP
    "! @parameter ct_xaccit | Interface com contabilidade: informação sobre item
    "! @parameter ct_xaccfi | Interface com a contabilidade: contabilidade financeira CtaO
    "! @parameter ct_xacccr | Interface com contabilidade: informação sobre moeda
    METHODS executar IMPORTING is_cvbrk  TYPE vbrk
                               is_cvbrp  TYPE vbrpvb
                     CHANGING  ct_xaccit TYPE ty_accit
                               ct_xaccfi TYPE ty_accfi
                               ct_xacccr TYPE ty_acccr.
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS:
      "! Constante Cafeterias - Identificador de parametros fixos
      gc_idtp_docfat TYPE ze_caft_idparametro VALUE 'BA',
      "! Constante Cafeterias - Tipo de condição de pgmt. legado
      gc_outros      TYPE ze_tpcondlegado VALUE 0,
      "! Constante Cafeterias - Tipo de condição de pgmt. legado
      gc_taxas       TYPE ze_tpcondlegado VALUE 255.

    CONSTANTS:
      "! Constantes para tabela de parâmetros
      BEGIN OF gc_parametros,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'SSRESTO',
        chave2 TYPE ztca_param_par-chave2 VALUE 'FKART',
      END OF gc_parametros.



    DATA:
      "! Número Lançamento
      gv_num_lanc TYPE i,
      "! Número Item
      gv_posnr    TYPE i,
      "! Nº atribuição
      gv_zuonr    TYPE dzuonr,
      "! Montante em moeda do documento
      gv_wrbtr    TYPE wrbtr.

    "! Interface com contabilidade: informação sobre item
    DATA gs_xaccit_old TYPE accit.
    "! Interface com contabilidade: informação sobre moeda
    DATA gs_xacccr_old TYPE acccr.
    "! Cafeterias - Tipo de condição de pgmt. c/ conta contábil
    DATA gs_caft_tpcond TYPE ztsd_caft_tpcond.

    "! "Seleção dos tipos de documento de faturamento usado para processo de cafeterias
    METHODS seleciona_tp_faturamento.

    "! Selecionar o cupom fiscal e o número da série
    "! @parameter is_cvbrp       |  Estrutura de referência para XVBRP/YVBRP
    "! @parameter rs_caft_cup_ov |  Cafeterias - Doc. de vendas gerado a partir do Cupom Fiscal
    METHODS seleciona_cupom_fiscal
      IMPORTING
        is_cvbrp              TYPE vbrpvb
      RETURNING
        VALUE(rs_caft_cup_ov) TYPE ztsd_caft_cup_ov.

    "! Seleciona as formas de pagamento do cupom fiscal
    "! @parameter is_caft_cup_ov | Cafeterias - Doc. de vendas gerado a partir do Cupom Fiscal
    "! @parameter et_caft_vend_p | Cafeterias - Movimentação de Pagamento do cupom fiscal
    METHODS seleciona_forma_pag
      IMPORTING
        is_caft_cup_ov TYPE ztsd_caft_cup_ov
      EXPORTING
        et_caft_vend_p TYPE ty_caft_vend_p.

    "! Selecionar as contas dos lançamentos financeiros
    "! @parameter it_zcaft_venda_p | Cafeterias - Movimentação de Pagamento do cupom fiscal
    "! @parameter et_caft_tpcond   | Cafeterias - Tipo de condição de pgmt. c/ conta contábil
    METHODS selecionar_conta_lancam
      IMPORTING
        it_zcaft_venda_p TYPE ty_caft_vend_p
      EXPORTING
        et_caft_tpcond   TYPE ty_caft_tpcond.

    "! Ler a linha de lançamento que deve receber o valor por forma de pagamento do cupom fiscal
    "! @parameter is_cvbrk  | Documento de faturamento: dados de cabeçalho
    "! @parameter is_cvbrp  | Estrutura de referência para XVBRP/YVBRP
    "! @parameter ct_xaccit | Interface com contabilidade: informação sobre item
    "! @parameter ct_xacccr | Interface com contabilidade: informação sobre moeda
    METHODS recebe_valor_meio_pag
      IMPORTING
        is_cvbrk  TYPE vbrk
        is_cvbrp  TYPE vbrpvb
      CHANGING
        ct_xaccit TYPE zclsd_caftratar_contabilizacao=>ty_accit
        ct_xacccr TYPE zclsd_caftratar_contabilizacao=>ty_acccr.

    "! "Atribuição de valores para contabilizar pagamento
    "! @parameter it_caft_tpcond   | Cafeterias - Tipo de condição de pgmt. c/ conta contábil
    "! @parameter is_zcaft_venda_p | Cafeterias - Movimentação de Pagamento do cupom fiscal
    METHODS contabilizar_pag
      IMPORTING
        it_caft_tpcond   TYPE ty_caft_tpcond
        is_zcaft_venda_p TYPE ztsd_caft_vend_p.

    "! "Atribuição de valores para contabilizar taxa de cartão
    "! @parameter it_caft_tpcond   | Cafeterias - Tipo de condição de pgmt. c/ conta contábil
    "! @parameter is_zcaft_venda_p | Cafeterias - Movimentação de Pagamento do cupom fiscal
    METHODS contabilizar_taxa_cartao
      IMPORTING
        it_caft_tpcond   TYPE ty_caft_tpcond
        is_zcaft_venda_p TYPE ztsd_caft_vend_p.

    "! Atualiza contabilização
    "! @parameter ct_xaccit | Interface com contabilidade: informação sobre item
    "! @parameter ct_xaccfi | Interface com a contabilidade: contabilidade financeira CtaO
    "! @parameter ct_xacccr | Interface com contabilidade: informação sobre moeda
    METHODS atualiza_contabilizacao
      CHANGING
        ct_xaccit TYPE zclsd_caftratar_contabilizacao=>ty_accit
        ct_xaccfi TYPE zclsd_caftratar_contabilizacao=>ty_accfi
        ct_xacccr TYPE zclsd_caftratar_contabilizacao=>ty_acccr.

    "! Atualização com os valores pagos e formas de pagamento do cupom fiscal
    "! @parameter it_zcaft_venda_p | Cafeterias - Movimentação de Pagamento do cupom fiscal
    "! @parameter it_caft_tpcond   | Cafeterias - Tipo de condição de pgmt. c/ conta contábil
    "! @parameter ct_xaccit | Interface com contabilidade: informação sobre item
    "! @parameter ct_xaccfi | Interface com a contabilidade: contabilidade financeira CtaO
    "! @parameter ct_xacccr | Interface com contabilidade: informação sobre moeda
    METHODS atualiza_valores
      IMPORTING
        it_zcaft_venda_p TYPE ty_caft_vend_p
        it_caft_tpcond   TYPE ty_caft_tpcond
      CHANGING
        ct_xaccit        TYPE zclsd_caftratar_contabilizacao=>ty_accit
        ct_xaccfi        TYPE zclsd_caftratar_contabilizacao=>ty_accfi
        ct_xacccr        TYPE zclsd_caftratar_contabilizacao=>ty_acccr.

ENDCLASS.



CLASS ZCLSD_CAFTRATAR_CONTABILIZACAO IMPLEMENTATION.


  METHOD executar.

    seleciona_tp_faturamento( ).

    CHECK ( gr_fkart[] IS NOT INITIAL AND is_cvbrk-fkart IN gr_fkart[] ) AND
            is_cvbrp IS NOT INITIAL.


    DATA(ls_caft_cup_ov)   = seleciona_cupom_fiscal( is_cvbrp ).

    seleciona_forma_pag( EXPORTING is_caft_cup_ov = ls_caft_cup_ov
                         IMPORTING et_caft_vend_p = DATA(lt_zcaft_venda_p) ).


    IF lt_zcaft_venda_p[] IS NOT INITIAL.

      selecionar_conta_lancam( EXPORTING it_zcaft_venda_p = lt_zcaft_venda_p
                               IMPORTING et_caft_tpcond   = DATA(lt_caft_tpcond) ).

      recebe_valor_meio_pag( EXPORTING
                              is_cvbrk = is_cvbrk
                              is_cvbrp = is_cvbrp
                             CHANGING
                              ct_xaccit = ct_xaccit
                              ct_xacccr = ct_xacccr ).

      atualiza_valores( EXPORTING
                         it_zcaft_venda_p = lt_zcaft_venda_p
                         it_caft_tpcond = lt_caft_tpcond
                        CHANGING
                         ct_xaccit = ct_xaccit
                         ct_xaccfi = ct_xaccfi
                         ct_xacccr = ct_xacccr ).

    ENDIF.


  ENDMETHOD.


  METHOD atualiza_valores.


    LOOP AT it_zcaft_venda_p ASSIGNING FIELD-SYMBOL(<fs_zcaft_venda_p>).

      CLEAR gv_zuonr.

      IF <fs_zcaft_venda_p>-vl_taxa IS NOT INITIAL.
        gv_num_lanc = 2.
      ELSE.
        gv_num_lanc = 1.
      ENDIF.

      DO gv_num_lanc TIMES."#EC CI_NESTED.

        gv_posnr = gv_posnr + 1.

        IF sy-index = 1.

          contabilizar_pag( it_caft_tpcond = it_caft_tpcond is_zcaft_venda_p = <fs_zcaft_venda_p> ).

        ELSEIF sy-index = 2.

          contabilizar_taxa_cartao( it_caft_tpcond = it_caft_tpcond is_zcaft_venda_p = <fs_zcaft_venda_p> ).

        ELSE.
          EXIT.
        ENDIF.

        atualiza_contabilizacao( CHANGING ct_xaccit = ct_xaccit
                                          ct_xaccfi = ct_xaccfi
                                          ct_xacccr = ct_xacccr ).

        CLEAR gs_caft_tpcond.

      ENDDO.


    ENDLOOP.

  ENDMETHOD.


  METHOD atualiza_contabilizacao.

    APPEND INITIAL LINE TO ct_xaccit ASSIGNING FIELD-SYMBOL(<fs_xaccit>).
    <fs_xaccit> = CORRESPONDING #( gs_xaccit_old ).
    <fs_xaccit>-hkont = gs_caft_tpcond-saknr.
    <fs_xaccit>-zuonr = gv_zuonr.

    APPEND INITIAL LINE TO ct_xacccr ASSIGNING FIELD-SYMBOL(<fs_xacccr>).
    <fs_xacccr> = CORRESPONDING #( gs_xacccr_old ).
    <fs_xacccr>-posnr = gs_xaccit_old-posnr.
    <fs_xacccr>-wrbtr = gv_wrbtr.
    <fs_xacccr>-skfbt = gv_wrbtr.

    IF gv_posnr NE 1.
      APPEND INITIAL LINE TO ct_xaccfi ASSIGNING FIELD-SYMBOL(<fs_xaccfi>).

      <fs_xaccfi>-posnr = gv_posnr.
      <fs_xaccit>-posnr = gv_posnr.
      <fs_xacccr>-posnr = gv_posnr.
    ENDIF.

  ENDMETHOD.


  METHOD contabilizar_taxa_cartao.

    READ TABLE it_caft_tpcond INTO gs_caft_tpcond WITH KEY tipopag = gc_taxas BINARY SEARCH.

    gv_wrbtr = is_zcaft_venda_p-vl_taxa.

  ENDMETHOD.


  METHOD contabilizar_pag.

    DATA(lt_caft_tpcond) = it_caft_tpcond.
    SORT lt_caft_tpcond BY tipopag.
    READ TABLE lt_caft_tpcond INTO gs_caft_tpcond  WITH KEY tipopag = is_zcaft_venda_p-tipopag BINARY SEARCH.

    IF sy-subrc IS NOT INITIAL OR gs_caft_tpcond-saknr IS INITIAL.
      READ TABLE lt_caft_tpcond INTO gs_caft_tpcond WITH KEY tipopag = gc_outros BINARY SEARCH.
    ENDIF.

    "Determinação do texto de atribuição
    IF is_zcaft_venda_p-codaut IS NOT INITIAL.
      gv_zuonr = gs_caft_tpcond-prefixo && '-' && is_zcaft_venda_p-codaut.
    ELSE.
      gv_zuonr = gs_caft_tpcond-prefixo.
    ENDIF.

    "Determinar o valor do lançamento
    gv_wrbtr = is_zcaft_venda_p-netwr - is_zcaft_venda_p-vl_taxa.

  ENDMETHOD.


  METHOD recebe_valor_meio_pag.

    READ TABLE ct_xaccit INTO gs_xaccit_old WITH KEY vbeln = is_cvbrk-vbeln. "#EC CI_STDSEQ
    IF sy-subrc IS INITIAL.

      SELECT SINGLE bstnk
        FROM vbak
        INTO gs_xaccit_old-xblnr
        WHERE vbeln = is_cvbrp-vgbel.

      DELETE ct_xaccit INDEX sy-tabix.

    ENDIF.

    READ TABLE ct_xacccr INTO gs_xacccr_old WITH KEY posnr = gs_xaccit_old-posnr. "#EC CI_STDSEQ
    IF sy-subrc IS INITIAL.
      DELETE ct_xacccr INDEX sy-tabix.
    ENDIF.

  ENDMETHOD.


  METHOD selecionar_conta_lancam.

    SELECT * FROM ztsd_caft_tpcond
      INTO TABLE et_caft_tpcond
      FOR ALL ENTRIES IN it_zcaft_venda_p
      WHERE tipopag EQ it_zcaft_venda_p-tipopag
         OR tipopag EQ gc_outros
         OR tipopag EQ gc_taxas.                   "#EC CI_NO_TRANSFORM  "#EC CI_FAE_NO_LINES_OK

    SORT et_caft_tpcond BY tipopag.

  ENDMETHOD.


  METHOD seleciona_cupom_fiscal.

    SELECT SINGLE * FROM ztsd_caft_cup_ov
      INTO  @rs_caft_cup_ov
*      WHERE vbeln = @is_cvbrp-vgbel.
      WHERE vbeln = @is_cvbrp-aubel.

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


  METHOD seleciona_forma_pag.

    SELECT * FROM ztsd_caft_vend_p
      INTO TABLE et_caft_vend_p
      WHERE numcf    EQ is_caft_cup_ov-numcf
        AND numserie EQ is_caft_cup_ov-numserie
        AND werks    EQ is_caft_cup_ov-werks.

  ENDMETHOD.
ENDCLASS.
