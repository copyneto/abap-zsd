"Name: \PR:SAPLJ_1B_NFE\FO:BLOCK_R\SE:END\EI
ENHANCEMENT 0 ZEISD_QUEBRA_LOTE_INFADPROD.
* LSCHEPP - SD - 8000007517 - CORE 3 -<infAdProd> sem mens reemb xml - 16.05.2023 Início
  CLEAR char_string.

  LOOP AT wk_item_text
    INTO ls_item_text
    WHERE docnum = wk_item-docnum
      AND itmnum = wk_item-itmnum
      AND textid = cl_j_1bnf_longtext=>gc_item_product.
    IF ls_item_text-text IS NOT INITIAL.
      CONCATENATE char_string ls_item_text-text
        INTO char_string
        SEPARATED BY space.
    ENDIF.
  ENDLOOP.

  y_infadprod = char_string.
* LSCHEPP - SD - 8000007517 - CORE 3 -<infAdProd> sem mens reemb xml - 16.05.2023 Fim
ENDENHANCEMENT.
