CLASS zclsd_meio_pagamento DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclsd_meio_pagamento IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zi_sd_vh_meio_pagamento WITH DEFAULT KEY.

    lt_original_data = CORRESPONDING #( it_original_data ).


    DATA: lr_deb_conta    TYPE RANGE OF ztsd_devolucao-form_pagamento.

    DATA: lt_banco  TYPE STANDARD TABLE OF bapibus1006_bankdetails,
          lt_return TYPE STANDARD TABLE OF bapiret2.
    FIELD-SYMBOLS:<fs_dadosbanco> TYPE bapibus1006_bankdetails.

*    DATA(lt_original_data_fae) = lt_original_data.
*    DELETE ADJACENT DUPLICATES FROM lt_original_data_fae COMPARING nfe.
*    DELETE lt_original_data_fae WHERE nfe = space.       "#EC CI_STDSEQ

*    IF lt_original_data_fae IS NOT INITIAL.
*
*      TRY.
*          DATA(lv_nfe) = lt_original_data_fae[ 1 ]-nfe.
*          SELECT SINGLE chaveacesso
*            FROM ztsd_devolucao
*            INTO @DATA(lv_chaveacesso)
*            WHERE numero_nfe = @lv_nfe.
*          IF sy-subrc EQ 0.
*            SELECT SINGLE docnum
*              FROM j_1bnfe_active
*              INTO @DATA(lv_docnum)
*              WHERE regio   = @lv_chaveacesso(2)
*                AND nfyear  = @lv_chaveacesso+2(2)
*                AND nfmonth = @lv_chaveacesso+4(2)
*                AND stcd1   = @lv_chaveacesso+6(14)
*                AND model   = @lv_chaveacesso+20(2)
*                AND serie   = @lv_chaveacesso+22(3)
*                AND nfnum9  = @lv_chaveacesso+25(9)
*                AND docnum9 = @lv_chaveacesso+34(9)
*                AND cdv     = @lv_chaveacesso+43(1).
*            IF sy-subrc EQ 0.
*              SELECT nfenum, parid                      "#EC CI_NOFIELD
*              FROM j_1bnfdoc
*              INTO TABLE @DATA(lt_pard)
*              WHERE docnum = @lv_docnum.
*            ENDIF.
*          ENDIF.
*        CATCH cx_sy_itab_line_not_found.
*      ENDTRY.
*
**      SELECT nfenum, parid                              "#EC CI_NOFIELD
**      FROM j_1bnfdoc
**      INTO TABLE @DATA(lt_pard)
**      FOR ALL ENTRIES IN @lt_original_data_fae
**      WHERE nfenum = @lt_original_data_fae-nfe.
*
*
*      IF sy-subrc IS INITIAL.
*        SORT lt_pard  BY nfenum.
*      ENDIF.
*
*    ENDIF..
    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF <fs_data>-formapagtoid NE 'X'.
        CONTINUE.
      ENDIF.


*      READ TABLE lt_pard ASSIGNING FIELD-SYMBOL(<fs_parid>) WITH KEY nfenum = <fs_data>-nfe BINARY SEARCH.
*
*      IF sy-subrc IS INITIAL.

        CALL FUNCTION 'BAPI_BUPA_BANKDETAILS_GET'
          EXPORTING
            businesspartner = <fs_data>-Cliente "<fs_parid>-parid
            valid_date      = sy-datlo
          TABLES
            bankdetails     = lt_banco
            return          = lt_return.

        IF lt_return IS INITIAL.


          READ TABLE lt_banco ASSIGNING <fs_dadosbanco> INDEX 1.

          SELECT banka UP TO 1 ROWS                  "#EC CI_SEL_NESTED
          FROM bnka
          INTO @DATA(lv_denomi)
          WHERE bankl = @<fs_dadosbanco>-bank_key.
          ENDSELECT.

          <fs_data>-banco       = <fs_dadosbanco>-bank_key.
          <fs_data>-agencia     = <fs_dadosbanco>-bank_key.
          <fs_data>-conta       = <fs_dadosbanco>-bank_acct.
          <fs_data>-denomibanco = lv_denomi.

        ENDIF.
*      ENDIF.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    APPEND 'FORMAPAGTOID' TO et_requested_orig_elements.
    APPEND 'NFE' TO et_requested_orig_elements.

  ENDMETHOD.
ENDCLASS.
