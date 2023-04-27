"!<p>Classe utilizada na fórmula de valor de condição 600 para tratativa de <strong>IPI E-commerce</strong>. <br/>
"!A fórmula 600 é encontrada no include <em>RV64A600</em>, form <em>frm_kondi_wert_600</em>. <br/><br/>
"!<p><strong>Autor:</strong> Anderson Miazato - Meta</p>
"!<p><strong>Data:</strong> 12/08/2021</p>
CLASS zclsd_tratativa_ipi_st DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS:
      "! Utilizado para condição ref. a IPI taxa
      gc_ipi_taxa_imposto TYPE komv-kschl VALUE 'IPVA',
      "! Utilizado para condição ref. a IPI montante
      gc_ipi_montante     TYPE komv-kschl VALUE 'BX23'.

    TYPES:
      "! Categ. tabela para parâmetros que recebem a XKOMV
      tt_xkomv TYPE STANDARD TABLE OF komv_index.

    TYPES:
      "! Campos de taxa para conversão entre valores com casas decimais diferentes
      BEGIN OF ty_taxa,
        taxa_decimal7 TYPE p LENGTH 15 DECIMALS 7,
        taxa_decimal4 TYPE p LENGTH 15 DECIMALS 4,
      END OF ty_Taxa.

    METHODS:
      "! Construtor - inicialização de objetos
      "! @parameter it_xkomv        | Tabela de condições
      constructor
        IMPORTING it_xkomv TYPE zclsd_tratativa_ipi_st=>tt_xkomv,

      "! Executa a tratativa do IPI E-commerce
      "! @parameter iv_kzwi1        | Preço bruto do item
      "! @parameter cs_xkomv        | Condição ref. a IPI E-commerce atualizada pelo cálculo
      "! @parameter cv_xkwert       | Valor da condição ref. a IPI E-commerce atualizada pelo cálculo
      execute
        IMPORTING iv_kzwi1  TYPE komp-kzwi1
        CHANGING  cs_xkomv  TYPE komv_index
                  cv_xkwert TYPE komv-kwert.

  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA:
      "! Condição de IPI - taxa
      gs_cond_ipi_taxa_imposto TYPE komv_index,
      "! Condição de IPI - montante
      gs_cond_ipi_montante     TYPE komv_index.

    METHODS:
      "! Busca a condição IPI taxa na tabela de condições XKOMV
      "! @parameter it_xkomv      | Tabela de condições
      set_condicao_ipi_taxa
        IMPORTING it_xkomv TYPE zclsd_tratativa_ipi_st=>tt_xkomv,

      "! Recupera a condição IPI taxa
      "! @parameter rs_result     | Condição ref. a IPI obtida na XKOMV
      get_condicao_ipi_taxa
        RETURNING VALUE(rs_result) TYPE komv_index,

      "! Busca a condição IPI montante na tabela de condições XKOMV
      "! @parameter it_xkomv      | Tabela de condições
      set_condicao_ipi_montante
        IMPORTING it_xkomv TYPE zclsd_tratativa_ipi_st=>tt_xkomv,

      "! Recupera a condição IPI montante
      "! @parameter rs_result     | Condição ref. a IPI montante obtida na XKOMV
      get_condicao_ipi_montante
        RETURNING VALUE(rs_result) TYPE komv_index,

      "! Converte a taxa informada para taxa com 4 casas decimais sem arredondamento
      "! @parameter iv_rate_dec7  | Taxa com 7 casas decimais
      "! @parameter rv_result     | Taxa convertida com 4 casas decimais
      converte_para_taxa_decimal4
        IMPORTING iv_rate_dec7     TYPE ty_taxa-taxa_decimal7
        RETURNING VALUE(rv_result) TYPE ty_taxa-taxa_decimal4.

ENDCLASS.



CLASS zclsd_tratativa_ipi_st IMPLEMENTATION.

  METHOD constructor.

    me->set_condicao_ipi_montante(  it_xkomv ).

    me->set_condicao_ipi_taxa( it_xkomv ).

  ENDMETHOD.

  METHOD execute.

    DATA: lv_ipi_taxa           TYPE konv-kbetr,
          lv_ipi_ecommerce_rate TYPE p LENGTH 15 DECIMALS 7,
          lv_fator1             TYPE p LENGTH 15 DECIMALS 7,
          lv_valor1             TYPE p LENGTH 15 DECIMALS 7,
          lv_valor2             TYPE p LENGTH 15 DECIMALS 7.

    " Preço Bruto vazio: sai do processamento
    IF iv_kzwi1 IS INITIAL.
      RETURN.
    ENDIF.

    " IPI montante vazio: sai do processamento
    IF me->get_condicao_ipi_montante( )-kwert IS INITIAL.
      RETURN.
    ENDIF.

    " Recupera a taxa do IPI e converte para formato 0.00
    lv_ipi_taxa = ( me->get_condicao_ipi_taxa( )-kbetr / 1000 ).

    " Executa o cálculo reverso para chegar na taxa correta de IPI e-commerce
    lv_fator1 = lv_ipi_taxa + 1.

    lv_valor1 = ( iv_kzwi1 / lv_fator1 ).

    lv_valor2 = ( lv_valor1 / iv_kzwi1 ).

    lv_ipi_ecommerce_rate = ( ( 1 - lv_valor2 ) * 100 ) .

    " Calcula o valor da condição IPI e-commerce (em R$) a partir do preço bruto
    cv_xkwert = ( iv_kzwi1 * ( lv_ipi_ecommerce_rate / 100 ) ) * -1.

    " Converte a taxa da condição IPI e-commerce para 4 casas decimais, sem arredondar
    DATA(lv_ipi_ecomm_rate_dec4) = me->converte_para_taxa_decimal4( lv_ipi_ecommerce_rate ).

    cs_xkomv-kbetr = ( lv_ipi_ecomm_rate_dec4 * 10000 ) * -1.

  ENDMETHOD.

  METHOD set_condicao_ipi_taxa.

    DATA(lt_xkomv) = it_xkomv.

    SORT lt_xkomv BY kschl.

    READ TABLE lt_xkomv INTO me->gs_cond_ipi_taxa_imposto
      WITH KEY kschl = gc_ipi_taxa_imposto
      BINARY SEARCH.

    IF sy-subrc NE 0.
      CLEAR me->gs_cond_ipi_taxa_imposto.
    ENDIF.

  ENDMETHOD.

  METHOD get_condicao_ipi_taxa.

    rs_result = me->gs_cond_ipi_taxa_imposto.

  ENDMETHOD.

  METHOD get_condicao_ipi_montante.

    rs_result = me->gs_cond_ipi_montante.

  ENDMETHOD.

  METHOD converte_para_taxa_decimal4.

    DATA: lv_integer_char TYPE char15,
          lv_decimal_char TYPE char4.

    CONSTANTS lc_separator TYPE char1 VALUE '.'.

    DATA(lv_value_string) = CONV string( iv_rate_dec7 ).
    SPLIT lv_value_string AT lc_separator INTO lv_integer_char lv_decimal_Char.

    lv_value_string = | { lv_integer_Char } | && lc_separator && | { lv_decimal_char } |.

    CONDENSE lv_value_string NO-GAPS.
    rv_result = CONV #( lv_value_string ).

  ENDMETHOD.

  METHOD set_condicao_ipi_montante.

    DATA(lt_xkomv) = it_xkomv.

    SORT lt_xkomv BY kschl.

    READ TABLE lt_xkomv INTO me->gs_cond_ipi_montante
      WITH KEY kschl = gc_ipi_montante
      BINARY SEARCH.

    IF sy-subrc NE 0.
      CLEAR me->gs_cond_ipi_montante.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
