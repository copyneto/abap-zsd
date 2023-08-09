***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Enhancement para não permitir duplicidade  - Writer    *
*** AUTOR    : VICTOR ARAÚJO –[META]                                   *
*** FUNCIONAL: JANA CASTILHO –[META]                                  *
*** DATA     : 16.11.2021                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************

CONSTANTS:
  "! Constantes para tabela de parâmetros
  BEGIN OF lc_parametros,
    modulo TYPE ze_param_modulo VALUE 'SD',
    chave1 TYPE ztca_param_par-chave1 VALUE 'NFE',
    chave2 TYPE ztca_param_par-chave2 VALUE 'VALIDADUP',
  END OF lc_parametros.

DATA ls_nftype TYPE RANGE OF j_1bnftype.

DATA(lo_tabela_parametros) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 24.07.2023

CLEAR ls_nftype.

TRY.
    lo_tabela_parametros->m_get_range(
      EXPORTING
        iv_modulo = lc_parametros-modulo
        iv_chave1 = lc_parametros-chave1
        iv_chave2 = lc_parametros-chave2
      IMPORTING
        et_range  = ls_nftype
    ).

  CATCH zcxca_tabela_parametros.

ENDTRY.

IF gbobj_header-nftype IN ls_nftype.

  DATA(lo_verifica_dup) = NEW zclsd_valida_dupilcidade_dev( ).

  DATA ls_devolucao TYPE zssd_duplicidade_devolucao.
  DATA lv_duplicidade TYPE char1.

  ls_devolucao = VALUE #( bukrs  = gbobj_header-bukrs
                          branch = gbobj_header-branch
                          parid  = gbobj_header-parid
                          nfenum = gbobj_header-nfenum
                          series = gbobj_header-series ).

  " Chamar a classe passando os dados GBOBJ_HEADER
  lo_verifica_dup->execute(
    EXPORTING
      is_devolucao   =  ls_devolucao    " Estrutura para classe Validação duplicidade de devoluções
      iv_docnum      =  gbobj_header-docnum
   IMPORTING
     ev_duplicidade =   lv_duplicidade  " Código de um caractere
  ).

  IF lv_duplicidade EQ abap_true.
    MESSAGE e000(zsd_check_duplic).
  ENDIF.

ENDIF.
