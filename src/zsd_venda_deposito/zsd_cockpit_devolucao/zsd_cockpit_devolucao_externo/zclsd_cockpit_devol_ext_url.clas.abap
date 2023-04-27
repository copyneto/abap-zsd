CLASS zclsd_cockpit_devol_ext_url DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.


    CONSTANTS: BEGIN OF gc_values,
                 returnsdelivery        TYPE char30   VALUE 'ReturnsDelivery',
                 salesorder             TYPE char30   VALUE 'SalesDocument',
                 billingdocument        TYPE char30   VALUE 'BillingDocument',
                 fgorder                TYPE char30   VALUE 'FreightOrder',
                 notafiscal             TYPE char30   VALUE 'NotaFiscal',
                 display                TYPE char60   VALUE 'display',
                 notadisplay            TYPE char60   VALUE 'zzdisplay',
                 displayinwebgui        TYPE char60   VALUE 'displayInWebGui',
                 displaybillingdocument TYPE char60   VALUE 'displayBillingDocument',
                 displayroad            TYPE char60   VALUE 'displayRoad',
                 vbak_vbeln             TYPE ihttpnam VALUE 'VBAK-VBELN',
                 vbrk_vbeln             TYPE ihttpnam VALUE 'BillingDocument',
                 freightorder           TYPE ihttpnam VALUE 'FreightOrder',
                 likp_vbeln             TYPE ihttpnam VALUE 'LIKP-VBELN',
                 j_1bdydoc_docnum       TYPE ihttpnam VALUE 'NumeroDocumento',
               END OF gc_values.

ENDCLASS.



CLASS zclsd_cockpit_devol_ext_url IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_calculated_data TYPE STANDARD TABLE OF zc_sd_cockpit_devolucao_ext,
          lt_parameters      TYPE tihttpnvp,
          lt_docflow         TYPE tdt_docflow.

    lt_calculated_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_calculated_data ASSIGNING FIELD-SYMBOL(<fs_data>).


      " SalesOrder
      APPEND VALUE #( name  = gc_values-vbak_vbeln
                      value = <fs_data>-ordem )  TO lt_parameters.

      <fs_data>-url_va03 = cl_lsapi_manager=>create_flp_url( object     = gc_values-salesorder
                                                             action     = gc_values-display
                                                             parameters = lt_parameters ).
      REFRESH lt_parameters.

      " Remessa
      APPEND VALUE #( name  = gc_values-likp_vbeln
                      value = <fs_data>-remessa ) TO lt_parameters.

      <fs_data>-url_vl03n = cl_lsapi_manager=>create_flp_url( object     = gc_values-returnsdelivery
                                                              action     = gc_values-displayinwebgui
                                                              parameters = lt_parameters ).
      REFRESH lt_parameters.



      " BillingDocument
      APPEND VALUE #( name  = gc_values-vbrk_vbeln
                      value = <fs_data>-fatura ) TO lt_parameters.

      <fs_data>-url_vf03 = cl_lsapi_manager=>create_flp_url( object     = gc_values-billingdocument
                                                             action     = gc_values-displaybillingdocument
                                                             parameters = lt_parameters ).
      REFRESH lt_parameters.

      " NotaFiscal
      APPEND VALUE #( name  = gc_values-j_1bdydoc_docnum
                      value = <fs_data>-docnum ) TO lt_parameters.

      <fs_data>-url_j1b3n = cl_lsapi_manager=>create_flp_url( object     = gc_values-notafiscal
                                                              action     = gc_values-notadisplay
                                                              parameters = lt_parameters ).
      REFRESH lt_parameters.
*
*      "OrdemFrete
*      APPEND VALUE #( name  = gc_values-freightorder
*                      value = <fs_data>-freightorder ) TO lt_parameters.
*
*      <fs_data>-url_frete = cl_lsapi_manager=>create_flp_url( object     = gc_values-fgorder
*                                                              action     = gc_values-displayroad
*                                                              parameters = lt_parameters ).
*      REFRESH lt_parameters.




    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_calculated_data ).

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    RETURN.
  ENDMETHOD.
ENDCLASS.

