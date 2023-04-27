***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Adiciona valores de impostos CST60                     *
*** AUTOR    : FLÁVIA LEITE –[META]                                   *
*** FUNCIONAL: JANA TOLEDO –[META]                                    *
*** DATA     : 11.08.2021                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
DATA(lv_taxsit) = |{ ls_items-taxsit }{ '0' }|.

IF ( ls_items-reftyp EQ gc_fat AND lv_taxsit = '60' ).
  lo_tax_values->set_tax_billing( EXPORTING is_item = ls_items iv_manual = gv_manual CHANGING cs_item = <fs_item> ).
ELSEIF ls_items-reftyp NE gc_fat AND lv_taxsit = '60' AND is_header-direct EQ 2.
  lo_tax_values->set_tax( EXPORTING is_header = is_header is_item = ls_items iv_manual = gv_manual CHANGING cs_item = <fs_item> ).
ENDIF.
