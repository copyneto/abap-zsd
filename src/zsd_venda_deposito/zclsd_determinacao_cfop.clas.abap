CLASS zclsd_determinacao_cfop DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
    "! Executa dados em memória início função de determinação CFOP
    "! @parameter is_cfop_parameters | Estrutura Determ.CFOP p/saídas de material e os devoluções respectiv
      entrada_funcao_determinac_cfop
        IMPORTING
          is_cfop_parameters TYPE j_1bap,

    "! Executa dados em memória final função de determinação CFOP
    "! @parameter is_cfop_parameters | Estrutura Determ.CFOP p/saídas de material e os devoluções respectiv
      saida_funcao_determinacao_cfop
        IMPORTING
          is_cfop_parameters TYPE j_1bap,

    "! Recupera dados em memória para regra de determinação BX40 e BX41
    "! @parameter iv_vbap_posnr  | Item do documento de vendas VBAP
    "! @parameter iv_xvbap_posnr | Item do documento de vendas XVBAP
    "! @parameter is_komk        | Estrutura - Determinação de preço - cabeçalho comunicação
    "! @parameter it_komv        | Tabela Registro de condição de comunicação p/determinação de preço
    "! @parameter rv_cfop        | Código e extensão CFOP
      determinacao_cfop_bx40_bx41
        IMPORTING
          iv_vbap_posnr  TYPE posnr_va
          iv_xvbap_posnr TYPE posnr_va
          is_komk        TYPE komk
          it_komv        TYPE komv_t
        RETURNING
          VALUE(rv_cfop) TYPE j_1bcfop.
ENDCLASS.



CLASS ZCLSD_DETERMINACAO_CFOP IMPLEMENTATION.


  METHOD entrada_funcao_determinac_cfop.
    DATA:
      lt_cfop_parameters TYPE STANDARD TABLE OF zssd_determina_cfop,
      ls_cfop_parameters TYPE zssd_determina_cfop.


    IMPORT lt_cfop_parameters TO lt_cfop_parameters FROM MEMORY ID 'LT_CFOP_PARAMETERS'.

    ASSIGN ('(SAPLJ1BJ)VBAP-POSNR') TO FIELD-SYMBOL(<fs_posnr>).
    IF sy-subrc = 0.
      READ TABLE lt_cfop_parameters ASSIGNING FIELD-SYMBOL(<fs_cfop_parameters>)
                                    WITH KEY posnr = <fs_posnr>. "#EC CI_STDSEQ
      IF sy-subrc <> 0.
        MOVE-CORRESPONDING is_cfop_parameters TO ls_cfop_parameters.
        ls_cfop_parameters-posnr = <fs_posnr>.
        APPEND ls_cfop_parameters TO lt_cfop_parameters.
      ELSE.
        MOVE-CORRESPONDING is_cfop_parameters TO <fs_cfop_parameters>.
      ENDIF.

      EXPORT lt_cfop_parameters FROM lt_cfop_parameters TO MEMORY ID 'LT_CFOP_PARAMETERS'.

    ENDIF.
  ENDMETHOD.


  METHOD saida_funcao_determinacao_cfop.
    DATA:
      lt_cfop_parameters TYPE STANDARD TABLE OF zssd_determina_cfop,
      ls_cfop_parameters TYPE zssd_determina_cfop.


    IMPORT lt_cfop_parameters TO lt_cfop_parameters FROM MEMORY ID 'LT_CFOP_PARAMETERS'.

    ASSIGN ('(SAPLJ1BJ)VBAP-POSNR') TO FIELD-SYMBOL(<fs_posnr>).
    IF sy-subrc = 0.
      READ TABLE lt_cfop_parameters ASSIGNING FIELD-SYMBOL(<fs_cfop_parameters>)
                                    WITH KEY posnr = <fs_posnr>. "#EC CI_STDSEQ
      IF sy-subrc <> 0.
        MOVE-CORRESPONDING is_cfop_parameters TO ls_cfop_parameters.
        ls_cfop_parameters-posnr = <fs_posnr>.
        APPEND ls_cfop_parameters TO lt_cfop_parameters.
      ELSE.
        MOVE-CORRESPONDING is_cfop_parameters TO <fs_cfop_parameters>.
      ENDIF.

      EXPORT lt_cfop_parameters FROM lt_cfop_parameters TO MEMORY ID 'LT_CFOP_PARAMETERS'.

    ENDIF.
  ENDMETHOD.


  METHOD determinacao_cfop_bx40_bx41.
    DATA:
      ls_cfop_parameters_funcao TYPE j_1bap,
      lv_spcsto                 TYPE j_1bap-spcsto,
      lt_cfop_parameters        TYPE STANDARD TABLE OF zssd_determina_cfop,
      ls_cfop_parameters        TYPE zssd_determina_cfop.


    IMPORT lt_cfop_parameters TO lt_cfop_parameters FROM MEMORY ID 'LT_CFOP_PARAMETERS'.
    IF sy-subrc = 0.

      READ TABLE lt_cfop_parameters INTO ls_cfop_parameters WITH KEY posnr = iv_vbap_posnr. "#EC CI_STDSEQ
      IF sy-subrc > 0.
        CLEAR ls_cfop_parameters_funcao.
      ELSE.
        MOVE-CORRESPONDING ls_cfop_parameters TO ls_cfop_parameters_funcao.
      ENDIF.

      IF ls_cfop_parameters_funcao IS NOT INITIAL.

        LOOP AT it_komv INTO DATA(ls_komv) WHERE ( kschl = 'BX41' OR kschl = 'BX40' OR kschl = 'ZTAM' ) "#EC CI_LOOP_INTO_WA
                                             AND kposn = iv_xvbap_posnr. "#EC CI_STDSEQ
        ENDLOOP.
        IF sy-subrc = 0.
          IF ls_komv-kwert IS INITIAL.
            lv_spcsto = ''.
          ELSE.
            lv_spcsto = '01'.
          ENDIF.
        ELSE.
          lv_spcsto = ''.
        ENDIF.
        ls_cfop_parameters_funcao-spcsto = lv_spcsto.

        CALL FUNCTION 'J_1B_NF_CFOP_2_DETERMINATION'
          EXPORTING
            cfop_parameters = ls_cfop_parameters_funcao
            version         = '4'
            i_region        = is_komk-regio
            i_land1         = is_komk-land1
            i_date          = sy-datum
          IMPORTING
            cfop            = rv_cfop
          EXCEPTIONS
            cfop_not_found  = 1
            OTHERS          = 2.
        IF sy-subrc = 0.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
