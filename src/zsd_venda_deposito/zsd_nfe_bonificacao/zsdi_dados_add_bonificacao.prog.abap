***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Gravar os dados adicionais para a NF-e de bonificação  *
*** AUTOR    : FLÁVIA LEITE –[META]                                   *
*** FUNCIONAL: JANA CASTILHOS –[META]                                 *
*** DATA     : 27.10.2021                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
*&---------------------------------------------------------------------*
*& Include          ZSDI_DADOS_ADD_BONIFICACAO
*&---------------------------------------------------------------------*
*

   TYPES: ty_t_nfetx TYPE TABLE OF j_1bnfftx .
   FIELD-SYMBOLS: <fs_nfetx_tab> TYPE ty_t_nfetx.

   ASSIGN ('(SAPLJ1BG)WNFFTX[]') TO <fs_nfetx_tab>.
   IF NOT <fs_nfetx_tab> IS ASSIGNED.
     ASSIGN ('(SAPLJ1BF)WA_NF_FTX[]') TO <fs_nfetx_tab>.
   ENDIF.


   IF <fs_nfetx_tab> IS ASSIGNED.

     NEW zclsd_dados_add_bonificacao( it_nflin    = it_nflin
                                      is_vbrk     = is_vbrk
                                      it_vbrp     = it_vbrp )->executar(
                            CHANGING  ct_add_info = <fs_nfetx_tab>
                                      cs_header   = es_header ).
   ENDIF.
