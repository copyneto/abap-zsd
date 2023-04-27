"! <p class="shorttext synchronized">Implementação da BADI_J1B_ICMS_PARTILHA</p>
"! Autor: Jefferson Fujii
"! <br>Data: 06/10/2021
"!
CLASS zclsd_icms_partilha_difal DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_ex_badi_j1b_icms_partilha .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLSD_ICMS_PARTILHA_DIFAL IMPLEMENTATION.


  METHOD if_ex_badi_j1b_icms_partilha~determine_icms_non_contributor.
    cv_icms_non_contributor = abap_true.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_badi_j1b_icms_partilha~determine_intrastate_icms_red.

    DATA: lt_sorted_komv TYPE TABLE OF komv_index."WITH UNIQUE KEY kschl.

*   Constantes
    CONSTANTS: lc_dinc TYPE t685-kschl      VALUE 'DINC', "Condição de determinação da partilha
               lc_isib TYPE t685-kschl      VALUE 'ISIB', "Base de cálculo SF=ST (Origem e destinos iguais)
               lc_icpe TYPE t685-kschl      VALUE 'ICPE'. "Base de cálculo SF=ST (Origem e destinos iguais)

    DATA(lt_komv) = it_komv.
    SORT lt_komv BY kschl.
    lt_sorted_komv  = lt_komv.
    SORT lt_sorted_komv BY kschl.

    TRY.
*       Detecção de Partilha
        READ TABLE lt_sorted_komv ASSIGNING FIELD-SYMBOL(<fs_komv>) WITH KEY kschl = lc_dinc BINARY SEARCH.
        IF sy-subrc = 0.
*        DATA(<fs_komv>) = VALUE #( lt_sorted_komv[ kschl = lc_dinc ] ) .
          IF <fs_komv>-kbetr EQ '0.00'.
            RETURN.
          ENDIF.
        ENDIF.

      CATCH cx_sy_itab_line_not_found INTO DATA(lo_exception).
        RETURN.
    ENDTRY.


    TRY.
*       Verificar se base destino é zero
        READ TABLE lt_sorted_komv ASSIGNING <fs_komv> WITH KEY kschl = lc_isib BINARY SEARCH.
*        <fs_komv> = VALUE #( lt_sorted_komv[ kschl = lc_isib ] ).
        IF sy-subrc = 0.
          IF <fs_komv>-kawrt EQ '0.00'
          OR <fs_komv>-kbetr GT '0.00'.
            RETURN.
          ENDIF.
        ENDIF.

      CATCH cx_sy_itab_line_not_found INTO lo_exception.
        RETURN.
    ENDTRY.

    TRY.
        READ TABLE lt_sorted_komv ASSIGNING <fs_komv> WITH KEY kschl = lc_icpe BINARY SEARCH.
*       Veririfcar se não há isenção da partilha
*        <fs_komv> = VALUE #( lt_sorted_komv[ kschl = lc_icpe ] ).
        IF sy-subrc = 0.
          IF <fs_komv>-kbetr GT '0.00'.
            RETURN.
          ENDIF.
        ENDIF.
        cv_icms_reduction = '1.000000'.

      CATCH cx_sy_itab_line_not_found INTO lo_exception.
        cv_icms_reduction = '1.000000'.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
