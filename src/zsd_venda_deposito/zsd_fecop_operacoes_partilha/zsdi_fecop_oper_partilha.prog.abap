***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Operações FECOP e Partilha                             *
*** AUTOR : Anderson Miazato - META                                   *
*** FUNCIONAL: Sandro Seixas Chanchinski - META                       *
*** DATA : 18.08.2021                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR              | DESCRIÇÃO                       *
***-------------------------------------------------------------------*
*** 18.08.2021 | Anderson Miazato   | Desenvolvimento inicial         *
***********************************************************************
*&---------------------------------------------------------------------*
*& Include ZSDI_FECOP_OPER_PARTILHA
*&---------------------------------------------------------------------*

NEW zclsd_fecop_operacoes_partilha(
  is_header = is_header
  it_nflin = it_nflin
  it_nfstx = it_nfstx )->execute(
  CHANGING
    cs_nfheader = es_header
    ct_nfitem   = et_item
).
