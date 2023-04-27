CLASS zclsd_url_imobilizados DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclsd_url_imobilizados IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~calculate.

    CONSTANTS: lc_param_doc TYPE ihttpnam VALUE 'NotaFiscal', "Nome do campo
               lc_object    TYPE char30   VALUE 'NotaFiscal',
               lc_action    TYPE char60   VALUE  'display'.

    CHECK NOT it_original_data IS INITIAL.

    DATA lt_calculated_data TYPE STANDARD TABLE OF zc_sd_relatorio_imobilizados WITH DEFAULT KEY.

    MOVE-CORRESPONDING it_original_data TO lt_calculated_data.

    DATA(lt_parameters) = VALUE tihttpnvp( ).

    LOOP AT lt_calculated_data ASSIGNING FIELD-SYMBOL(<fs_calculated>).

      FREE: lt_parameters[].


      IF <fs_calculated>-docnum IS NOT INITIAL.

        FREE: lt_parameters[].
        APPEND VALUE #( name  = lc_param_doc
                        value = <fs_calculated>-docnum ) TO lt_parameters.

        <fs_calculated>-url_docnumentrada = cl_lsapi_manager=>create_flp_url( object     = lc_object
                                                                          action     = lc_action
                                                                          parameters = lt_parameters ).


      ENDIF.

      IF <fs_calculated>-docnum_saida IS NOT INITIAL.

        FREE: lt_parameters[].
        APPEND VALUE #( name  = lc_param_doc
                        value = <fs_calculated>-docnum_saida ) TO lt_parameters.

        <fs_calculated>-url_docnumsaida = cl_lsapi_manager=>create_flp_url( object     = lc_object
                                                                          action     = lc_action
                                                                          parameters = lt_parameters ).


      ENDIF.

    ENDLOOP.

    MOVE-CORRESPONDING lt_calculated_data TO ct_calculated_data.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.
ENDCLASS.
