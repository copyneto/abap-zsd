*&---------------------------------------------------------------------*
*& Include ZSDI_AGRUPA_MATERIAIS
*&---------------------------------------------------------------------*

***DATA(lt_obj_item) = CONV j_1bnflin_tab( obj_item[] ).
***DATA(lt_obj_item_tax) = CONV j_1bnfstx_tab( obj_item_tax[] ).
***
***zclsd_agrupa_materiais=>execute(
***                           EXPORTING
***                             is_obj_header   = obj_header
***                           CHANGING
***                             ct_obj_item     = lt_obj_item
***                             ct_obj_item_tax = lt_obj_item_tax ).
***
***IF lines( obj_item[] ) NE lines( lt_obj_item ).
***  obj_item[]     = lt_obj_item.
***  obj_item_tax[] = lt_obj_item_tax.
***ENDIF.
