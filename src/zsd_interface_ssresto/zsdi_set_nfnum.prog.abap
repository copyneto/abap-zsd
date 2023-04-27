***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO:  Atribui o número de referencia do documento de fatura *
***             no número da nota fiscal                              *
*** AUTOR    : FLÁVIA LEITE –[META]                                   *
*** FUNCIONAL: [CLEVERSON] –[META]                                    *
*** DATA     : [03/01/22]                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
*
*  IF sy-subrc = 0.
*    MOVE-CORRESPONDING wbaa TO ctaa.
*  ENDIF.
  FIELD-SYMBOLS <fs_doc_ssresto> TYPE j_1bnfdoc.
  DATA(lo_atribui_nfnum) = NEW zclsd_atribui_nfnum( ).

  READ TABLE it_vbrp ASSIGNING FIELD-SYMBOL(<fs_vbrp_ssresto>) INDEX 1.
  IF sy-subrc = 0.

    ASSIGN ('(SAPLJ1BG)WNFDOC') TO <fs_doc_ssresto>.
    IF <fs_doc_ssresto> IS ASSIGNED.

      lo_atribui_nfnum->executar(
        EXPORTING
          is_wvbrp  = <fs_vbrp_ssresto>
          is_wvbrk  = is_vbrk
        CHANGING
          cs_wnfdoc = <fs_doc_ssresto> ).

    ENDIF.
  ENDIF.
