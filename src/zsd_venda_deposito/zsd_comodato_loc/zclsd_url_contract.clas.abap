CLASS zclsd_url_contract DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLSD_URL_CONTRACT IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    CONSTANTS: lc_param_doc  TYPE ihttpnam VALUE 'SalesContract', "NO_TEXT"
               lc_object     TYPE char30   VALUE 'SalesContract',
               lc_action     TYPE char60   VALUE 'display',
               lc_object_nf  TYPE char30   VALUE 'NotaFiscal',
               lc_action_nf  TYPE char60   VALUE 'monitor',
               lc_nf_doc     TYPE ihttpnam VALUE 'DOCNUM-LOW',
               lc_nf_dat     TYPE ihttpnam VALUE 'DATE0-LOW',
               lc_nf_buk     TYPE ihttpnam VALUE 'BUKRS-LOW',
               lc_object_ov  TYPE char30   VALUE 'SalesDocument',
               lc_action_ov  TYPE char60   VALUE 'display',
               lc_prm1_ov    TYPE ihttpnam VALUE 'VBAK-VBELN',
               lc_object_rm  TYPE char30   VALUE 'OutboundDelivery',
               lc_action_rm  TYPE char60   VALUE 'displayInWebGUI',
               lc_prm1_rm    TYPE ihttpnam VALUE 'OutboundDelivery',
               lc_object_ft  TYPE char30   VALUE 'BillingDocument',
               lc_action_ft  TYPE char60   VALUE 'displayBillingDocument',
               lc_prm1_ft    TYPE ihttpnam VALUE 'BillingDocument',
               lc_object_nfs TYPE char30   VALUE 'NotaFiscal',
               lc_action_nfs TYPE char60   VALUE 'display',
               lc_prm1_nfs   TYPE ihttpnam VALUE 'BR_NFeNumber',
               lc_prm2_nfs   TYPE ihttpnam VALUE 'BR_NotaFiscal'.

    CHECK NOT it_original_data IS INITIAL.

    DATA lt_calculated_data TYPE STANDARD TABLE OF zc_sd_cockpit_app WITH DEFAULT KEY.

    MOVE-CORRESPONDING it_original_data TO lt_calculated_data.

    DATA(lt_calculated_aux) = lt_calculated_data[].

    SORT lt_calculated_aux BY docnumnfesaida
                              docnumentrada.

    DELETE ADJACENT DUPLICATES FROM lt_calculated_aux COMPARING docnumnfesaida
                                                                docnumentrada.

    IF lt_calculated_aux[] IS NOT INITIAL.
      SELECT docnum,
             bukrs
        FROM j_1bnfdoc
         FOR ALL ENTRIES IN @lt_calculated_aux
       WHERE docnum = @lt_calculated_aux-docnumentrada
        INTO TABLE @DATA(lt_doc_entrada).

      IF sy-subrc IS INITIAL.
        SORT lt_doc_entrada BY docnum.
      ENDIF.

      SELECT docnum,
             bukrs
        FROM j_1bnfdoc
         FOR ALL ENTRIES IN @lt_calculated_aux
       WHERE docnum = @lt_calculated_aux-docnumnfesaida
        INTO TABLE @DATA(lt_doc_saida).

      IF sy-subrc IS INITIAL.
        SORT lt_doc_saida BY docnum.
      ENDIF.
    ENDIF.

    DATA(lt_parameters) = VALUE tihttpnvp( ).

    LOOP AT lt_calculated_data ASSIGNING FIELD-SYMBOL(<fs_calculated>).

      FREE: lt_parameters[].

      IF <fs_calculated>-salescontract IS NOT INITIAL.

        FREE: lt_parameters[].
        APPEND VALUE #( name  = lc_param_doc
                        value = <fs_calculated>-salescontract ) TO lt_parameters.

        <fs_calculated>-url_va43 = cl_lsapi_manager=>create_flp_url( object     = lc_object
                                                                     action     = lc_action
                                                                     parameters = lt_parameters ).
      ENDIF.

      IF <fs_calculated>-docnumentrada IS NOT INITIAL.

        READ TABLE lt_doc_entrada ASSIGNING FIELD-SYMBOL(<fs_entrada>)
                                                WITH KEY docnum = <fs_calculated>-docnumentrada
                                                BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          FREE: lt_parameters[].
          APPEND VALUE #( name = lc_nf_doc
                          value = <fs_calculated>-docnumentrada ) TO lt_parameters.

          APPEND VALUE #( name = lc_nf_dat
                          value = space ) TO lt_parameters.

          APPEND VALUE #( name = lc_nf_buk
                          value = <fs_entrada>-bukrs ) TO lt_parameters.

          <fs_calculated>-url_entrad = cl_lsapi_manager=>create_flp_url( object     = lc_object_nf
                                                                         action     = lc_action_nf
                                                                         parameters = lt_parameters ).
        ENDIF.

      ENDIF.

      IF <fs_calculated>-docnumnfesaida IS NOT INITIAL.

        READ TABLE lt_doc_saida ASSIGNING FIELD-SYMBOL(<fs_saida>)
                                              WITH KEY docnum = <fs_calculated>-docnumnfesaida
                                              BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          FREE: lt_parameters[].
          APPEND VALUE #( name = lc_nf_doc
                          value = <fs_calculated>-docnumnfesaida ) TO lt_parameters.

          APPEND VALUE #( name = lc_nf_dat
                          value = space ) TO lt_parameters.

          APPEND VALUE #( name = lc_nf_buk
                          value = <fs_saida>-bukrs ) TO lt_parameters.

          <fs_calculated>-url_saida = cl_lsapi_manager=>create_flp_url( object     = lc_object_nf
                                                                        action     = lc_action_nf
                                                                        parameters = lt_parameters ).
        ENDIF.
      ENDIF.

      IF <fs_calculated>-ordemvenda IS NOT INITIAL.

        FREE: lt_parameters[].
        APPEND VALUE #( name  = lc_prm1_ov
                        value = <fs_calculated>-ordemvenda ) TO lt_parameters.

        <fs_calculated>-url_orven = cl_lsapi_manager=>create_flp_url( object     = lc_object_ov
                                                                      action     = lc_action_ov
                                                                      parameters = lt_parameters ).
      ENDIF.

      IF <fs_calculated>-remessa IS NOT INITIAL.

        FREE: lt_parameters[].
        APPEND VALUE #( name  = lc_prm1_rm
                        value = <fs_calculated>-remessa ) TO lt_parameters.

        <fs_calculated>-url_remes = cl_lsapi_manager=>create_flp_url( object     = lc_object_rm
                                                                      action     = lc_action_rm
                                                                      parameters = lt_parameters ).
      ENDIF.

      IF <fs_calculated>-docfatura IS NOT INITIAL.

        FREE: lt_parameters[].
        APPEND VALUE #( name  = lc_prm1_ft
                        value = <fs_calculated>-docfatura ) TO lt_parameters.

        <fs_calculated>-url_fatura = cl_lsapi_manager=>create_flp_url( object     = lc_object_ft
                                                                       action     = lc_action_ft
                                                                       parameters = lt_parameters ).
      ENDIF.

      IF <fs_calculated>-nfesaida IS NOT INITIAL.

        FREE: lt_parameters[].
        APPEND VALUE #( name  = lc_prm1_nfs
                        value = <fs_calculated>-nfesaida ) TO lt_parameters.

        APPEND VALUE #( name  = lc_prm2_nfs
                        value = <fs_calculated>-docnumnfesaida ) TO lt_parameters.

        <fs_calculated>-url_nfesaid = cl_lsapi_manager=>create_flp_url( object     = lc_object_nfs
                                                                        action     = lc_action_nfs
                                                                        parameters = lt_parameters ).
      ENDIF.

    ENDLOOP.

    MOVE-CORRESPONDING lt_calculated_data TO ct_calculated_data.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    RETURN.
  ENDMETHOD.
ENDCLASS.
