"! Classe de conversao de cnpj
CLASS zclsd_cnpj_local_negocio DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclsd_cnpj_local_negocio IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
      DATA:
      lt_devolucao    TYPE STANDARD TABLE OF ZI_SD_NOTA_FISCAIS,
      ls_address     TYPE sadr,
      ls_branch_data TYPE J_1BBRANCH,
      ls_address1    TYPE addr1_val,
      lv_cgc_number  TYPE j_1bcgc.

    lt_devolucao = CORRESPONDING #( it_original_data ).

* *--------------------------------------------------------------------
* *Recupera informações
* *--------------------------------------------------------------------
    LOOP AT lt_devolucao REFERENCE INTO DATA(ls_devolucao).

      CALL FUNCTION 'J_1B_BRANCH_READ'
        EXPORTING
          branch            = ls_devolucao->LocalNegCnpj
          company           = ls_devolucao->Empresa
        IMPORTING
          address           = ls_address
          BRANCH_RECORD     = ls_branch_data
          cgc_number        = lv_cgc_number
          ADDRESS_VALUE     = ls_address1
        EXCEPTIONS
          branch_not_found  = 1
          address_not_found = 2
          company_not_found = 3
          OTHERS            = 4.

      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      ls_devolucao->CnpjDest = lv_cgc_number.

    ENDLOOP.

* --------------------------------------------------------------------
* Transfere dados convertidos
* --------------------------------------------------------------------
    ct_calculated_data = CORRESPONDING #( lt_devolucao ).

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  INSERT CONV string( 'LOCALNEGCNPJ' ) INTO TABLE et_Requested_orig_elements[].
  INSERT CONV string( 'EMPRRESA' ) INTO TABLE et_Requested_orig_elements[].

  ENDMETHOD.

ENDCLASS.
