*&---------------------------------------------------------------------*
*& Include          ZSDI_ADD_KIT_BON_INFCPL
*&---------------------------------------------------------------------*

 READ TABLE it_vbrp ASSIGNING FIELD-SYMBOL(<fs_vgbel>) INDEX 1.
 IF <fs_vgbel> IS ASSIGNED.
   SELECT dockit
   FROM zi_sd_kit_bon_cont1
   INTO @DATA(lv_dockit)
   UP TO 1 ROWS
   WHERE vbeln = @<fs_vgbel>-vgbel.
   ENDSELECT.

   IF lv_dockit IS NOT INITIAL.

     lt_nfetx = <fs_nfetx_tab>.

     SORT lt_nfetx BY seqnum DESCENDING.

     lv_seq = VALUE #( lt_nfetx[ 1 ]-seqnum DEFAULT 0 ).
     lv_linnum = VALUE #( lt_nfetx[ 1 ]-linnum DEFAULT 0 ).

     lv_texto = |{ TEXT-f66 } { lv_dockit }|.

     IF <fs_nfetx_tab> IS ASSIGNED.
       ADD 1 TO lv_seq.
       APPEND VALUE j_1bnfftx( seqnum = lv_seq linnum = lv_linnum message = lv_texto ) TO <fs_nfetx_tab>.
       cs_header-infcpl = |{ cs_header-infcpl }  { lv_texto }|.
     ENDIF.

     CLEAR: lv_texto.

   ENDIF.
 ENDIF.
