*&---------------------------------------------------------------------*
*& Include          ZSDI_FILL_PAYMENT_OUT
*&---------------------------------------------------------------------*
    CONSTANTS: lc_indpag1 TYPE char1 VALUE '1',
               lc_indpag0 TYPE char1 VALUE '0',
               lc_doctyp6 TYPE char1 VALUE '6',
               lc_doctyp3 TYPE char1 VALUE '3',
               lc_doctyp2 TYPE char1 VALUE '2',
               lc_finnfe3 TYPE char1 VALUE '3',
               lc_finnfe4 TYPE char1 VALUE '4',
               lc_itmtyp  TYPE char2 VALUE '22'.


    DATA ls_payment TYPE j_1bnfe_s_badi_payment_400.

    IF NOT is_vbrk-zlsch IS INITIAL AND ct_payment IS INITIAL.

      SELECT SINGLE tpag INTO @DATA(lv_tpag)
      FROM ztsd_formas_pag
      WHERE zlsch = @is_vbrk-zlsch.

      IF sy-subrc EQ 0.

        ls_payment-counter = 1.
        ls_payment-docnum  = is_header-docnum.
        ls_payment-t_pag   = lv_tpag.
        ls_payment-mandt   = sy-mandt.
        ls_payment-v_pag   = is_header-nftot.

        " Ind pagamento - Tags XML referente ao prazo de cobrança
        DATA ls_t052 TYPE t052.
        SELECT SINGLE * FROM t052
          INTO ls_t052
          WHERE zterm EQ is_vbrk-zterm.

        IF ( ls_t052-xsplt EQ abap_true OR ls_t052-ztag1 GT 0 ).
          ls_payment-ind_pag = lc_indpag1.
        ELSEIF ( ls_t052-ztag1 EQ 0 AND ( ls_t052-zfael GT 0 OR ls_t052-zstg1 GT 0 ) ).
          ls_payment-ind_pag = lc_indpag1.
        ELSE.
          ls_payment-ind_pag = lc_indpag0.
        ENDIF.
      ENDIF.
    ELSE.
***RICEF: Ini.188E01
*Informações de pagamento
      DATA(lt_fat) = it_nflin.
      SORT lt_fat BY reftyp.
      READ TABLE it_nflin TRANSPORTING NO FIELDS WITH KEY reftyp = gc_fat BINARY SEARCH.
      IF sy-subrc = 0.
*      SELECT SINGLE zlsch
*        FROM vbrk
*        INTO @DATA(lv_zlsch)
*        WHERE vbeln  = @ls_payment-docnum.
*
*      IF sy-subrc = 0.

        SELECT SINGLE tpag
          FROM ztsd_formas_pag
          INTO @DATA(lv_z_formas_pag)
          WHERE zlsch = @space.
        IF sy-subrc = 0.
          ls_payment-counter = 1.
          ls_payment-t_pag   = lv_z_formas_pag.
          ls_payment-v_pag   = is_header-nftot.
          ls_payment-ind_pag = lc_indpag0.
        ENDIF.

      ENDIF.
***RICEF: End.188E01
    ENDIF.

    IF ls_payment-ind_pag = lc_indpag1
   AND ls_payment-t_pag   = '90'.
      CLEAR ls_payment-v_pag.
    ENDIF.

* LSCHEPP - 8000006738 - Forma e valor de pagamento - 27.04.2023 Início
    IF is_vbrk-blart EQ 'RX'. "Cenários SD que não geram receita - Bonificação
      ls_payment-t_pag = '90'.
      CLEAR ls_payment-v_pag.
    ENDIF.
* LSCHEPP - 8000006738 - Forma e valor de pagamento - 27.04.2023 Fim

    "Default Forma de pagamento 90
    IF ls_payment IS INITIAL.

      ls_payment-counter = 1.
      ls_payment-t_pag   = gc_nenhum_pag.
      ls_payment-ind_pag = lc_indpag1.

      CLEAR: ls_payment-v_pag.

    ENDIF.

    SELECT SINGLE *
   FROM j_1bnfepayment
   INTO @DATA(ls_pay)
   WHERE docnum EQ @is_header-docnum.

    IF NOT ls_pay IS INITIAL.
      CLEAR: ls_payment.
    ENDIF.

    IF is_header-nftot IS NOT INITIAL.

      LOOP AT it_nflin ASSIGNING FIELD-SYMBOL(<fs_items>).

        SELECT SINGLE finnfe FROM j_1bagn
          INTO @DATA(lv_finnfe)
          WHERE cfop = @<fs_items>-cfop.

        IF lv_finnfe = lc_finnfe3.
          EXIT.
        ENDIF.

      ENDLOOP.

      IF is_header-doctyp = lc_doctyp6 OR
         is_header-doctyp = lc_doctyp3 OR
         lv_finnfe = lc_finnfe3        OR
         lv_finnfe = lc_finnfe4. "Devolução ou Correção
        ls_payment-t_pag = gc_nenhum_pag.
        CLEAR ls_payment-v_pag.
      ENDIF.

      DATA(lt_nflin) = it_nflin.
      SORT lt_nflin BY itmtyp.
      READ TABLE lt_nflin ASSIGNING FIELD-SYMBOL(<fs_nflin>) WITH KEY itmtyp = lc_itmtyp BINARY SEARCH.
      IF sy-subrc = 0. " Embalagem
        ls_payment-t_pag = gc_nenhum_pag.
        CLEAR ls_payment-v_pag.
      ENDIF.

      APPEND ls_payment TO ct_payment.

    ELSE.

      IF is_header-doctyp = lc_doctyp2. "NF Complementar
        ls_payment-t_pag = gc_outros.
        CLEAR ls_payment-v_pag.

        APPEND ls_payment TO ct_payment.
      ELSE.
        ls_payment = VALUE j_1bnfe_s_badi_payment_400( mandt   = sy-mandt
                                            docnum  = is_header-docnum
                                            counter = 1
                                            t_pag   = gc_nenhum_pag ).
        CLEAR ls_payment-v_pag.
        APPEND ls_payment TO ct_payment.
      ENDIF.

    ENDIF.


    CHECK ls_payment IS NOT INITIAL AND ct_payment IS INITIAL.
    APPEND ls_payment TO ct_payment.
