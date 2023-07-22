CLASS lcl_nfs DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK nfs.

    METHODS read FOR READ
      IMPORTING keys FOR READ nfs RESULT result.

    METHODS imprimir FOR MODIFY
      IMPORTING keys FOR ACTION NFs~imprimir.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR nfs RESULT result.
    METHODS get_printer
      RETURNING
        VALUE(rv_print) TYPE zc_sd_nf_imp_massa_printer.

ENDCLASS.

CLASS lcl_nfs IMPLEMENTATION.


  METHOD lock.
    RETURN.
  ENDMETHOD.

  METHOD read.
    RETURN.
  ENDMETHOD.

  METHOD imprimir.

    DATA: lt_return_all TYPE bapiret2_t.

* ---------------------------------------------------------------------------
* Imprime cada formulário
* ---------------------------------------------------------------------------
    DATA(lo_impressao) = zclsd_nf_mass_download=>get_instance( ).   " CHANGE - JWSILVA - 14.07.2023

    LOOP AT keys INTO DATA(ls_keys).               "#EC CI_LOOP_INTO_WA

      lo_impressao->imprime_pdf(
        EXPORTING
          iv_docnum     = ls_keys-Docnum
          iv_doctype    = sy-index
          is_parameters = get_printer( )"ls_keys-%param
        IMPORTING
          et_return   = DATA(lt_return)
      ).

      INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].

    ENDLOOP.

* ---------------------------------------------------------------------------
*Retorna mensagens de erro
* ---------------------------------------------------------------------------
    LOOP AT lt_return_all INTO DATA(ls_return_all).

      APPEND VALUE #( %msg = new_message( id       = ls_return_all-id
                                          number   = ls_return_all-number
                                          v1       = ls_return_all-message_v1
                                          v2       = ls_return_all-message_v2
                                          v3       = ls_return_all-message_v3
                                          v4       = ls_return_all-message_v4
                                          severity = CONV #( ls_return_all-type ) )
                       )
        TO reported-nfs.

    ENDLOOP.
  ENDMETHOD.

  METHOD get_features.

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    result = VALUE #( FOR ls_keys IN keys
                      ( %tky             = ls_keys-%tky
                        %action-imprimir = if_abap_behv=>fc-o-enabled
                      ) ).

  ENDMETHOD.


  METHOD get_printer.

    SELECT SINGLE spld FROM usr01
    WHERE bname =  @sy-uname
         AND spld IS NOT INITIAL
     INTO @rv_print.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_zi_sd_nf_imp_massa DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_zi_sd_nf_imp_massa IMPLEMENTATION.

  METHOD check_before_save.
    RETURN.
  ENDMETHOD.

  METHOD finalize.
    RETURN.
  ENDMETHOD.

  METHOD save.
    RETURN.
  ENDMETHOD.

ENDCLASS.
