*&---------------------------------------------------------------------*
*& Include          ZSDI_FARELO_F01
*&---------------------------------------------------------------------*

 DATA:
   ls_komv1 TYPE komv_index,
   ls_komv2 TYPE komv_index.

 DATA lv_valor TYPE fdc_tax_percentage.

 CONSTANTS:
   lc_z001 TYPE komv_index-kschl VALUE 'Z001',
   lc_bx70 TYPE komv_index-kschl VALUE 'BX70',
   lc_bx80 TYPE komv_index-kschl VALUE 'BX80',
   lc_bco1 TYPE komv_index-kschl VALUE 'BCO1',
   lc_bpi1 TYPE komv_index-kschl VALUE 'BPI1',
   lc_bx72 TYPE komv_index-kschl VALUE 'BX72',
   lc_bx82 TYPE komv_index-kschl VALUE 'BX82'.

 IF xkomv-kschl = lc_bx70 OR xkomv-kschl = lc_bx80.
   CLEAR: ls_komv1.
*
* Checar se a condição do desconto do farelo foi encontrada
   READ TABLE xkomv INTO ls_komv1 WITH KEY kposn = komp-kposn
                                           kschl = lc_z001.
   CHECK sy-subrc IS INITIAL AND NOT ls_komv1 IS INITIAL.
* Modificar a base de cálculo
   xkwert = xkwert + ls_komv1-kwert.
 ENDIF.


 IF xkomv-kschl = lc_bx72.
* Checar se a condição do desconto do farelo foi encontrada
   READ TABLE xkomv INTO ls_komv1 WITH KEY kposn = komp-kposn
                                           kschl = lc_z001.
   CHECK sy-subrc IS INITIAL AND NOT ls_komv1 IS INITIAL.
   CLEAR: ls_komv1.
   READ TABLE xkomv INTO ls_komv1 WITH KEY kposn = komp-kposn
                                           kschl = lc_bx70.
   CHECK sy-subrc IS INITIAL AND NOT ls_komv1-kwert IS INITIAL.

   READ TABLE xkomv INTO ls_komv2 WITH KEY kposn = komp-kposn
                                           kschl = lc_bco1.
   CHECK sy-subrc IS INITIAL AND NOT ls_komv2-kwert IS INITIAL.

   xkwert = ( ls_komv1-kwert * ls_komv2-kwert ) / '1000'.

 ENDIF.

 IF xkomv-kschl = lc_bx82.
* Checar se a condição do desconto do farelo foi encontrada
   READ TABLE xkomv INTO ls_komv1 WITH KEY kposn = komp-kposn
                                           kschl = lc_z001.
   CHECK sy-subrc IS INITIAL AND NOT ls_komv1 IS INITIAL.
   CLEAR: ls_komv1.
   READ TABLE xkomv INTO ls_komv1 WITH KEY kposn = komp-kposn
                                           kschl = lc_bx80.
   CHECK sy-subrc IS INITIAL AND NOT ls_komv1-kwert IS INITIAL.

   READ TABLE xkomv INTO ls_komv2 WITH KEY kposn = komp-kposn
                                           kschl = lc_bpi1.
   CHECK sy-subrc IS INITIAL AND NOT ls_komv2-kwert IS INITIAL.

   CLEAR lv_valor.
   lv_valor = ls_komv1-kwert * ls_komv2-kbetr.

   xkwert = lv_valor / '100000'.

 ENDIF.
