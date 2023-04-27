class ZCLSD_MONITOR_ECOMMERCE_URL definition
  public
  final
  create public .

public section.

  interfaces IF_SADL_EXIT .
  interfaces IF_SADL_EXIT_CALC_ELEMENT_READ .
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



CLASS ZCLSD_MONITOR_ECOMMERCE_URL IMPLEMENTATION.


  METHOD IF_SADL_EXIT_CALC_ELEMENT_READ~CALCULATE.

    DATA: lt_calculated_data TYPE STANDARD TABLE OF ZC_SD_MONITOR_APP,
          lt_parameters      TYPE tihttpnvp,
          lt_docflow         TYPE tdt_docflow.

    lt_calculated_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_calculated_data ASSIGNING FIELD-SYMBOL(<fs_data>).


      " SalesOrder
      APPEND VALUE #( name  = gc_values-vbak_vbeln
                      value = <fs_data>-SalesOrder )  TO lt_parameters.

      <fs_data>-url_va03 = cl_lsapi_manager=>create_flp_url( object     = gc_values-salesorder
                                                             action     = gc_values-display
                                                             parameters = lt_parameters ).
      REFRESH lt_parameters.

      " Remessa
      APPEND VALUE #( name  = gc_values-likp_vbeln
                      value = <fs_data>-OutboundDelivery ) TO lt_parameters.

      <fs_data>-url_vl03n = cl_lsapi_manager=>create_flp_url( object     = gc_values-returnsdelivery
                                                              action     = gc_values-displayinwebgui
                                                              parameters = lt_parameters ).
      REFRESH lt_parameters.



      " BillingDocument
      APPEND VALUE #( name  = gc_values-vbrk_vbeln
                      value = <fs_data>-billingdocument ) TO lt_parameters.

      <fs_data>-url_vf03 = cl_lsapi_manager=>create_flp_url( object     = gc_values-billingdocument
                                                             action     = gc_values-displaybillingdocument
                                                             parameters = lt_parameters ).
      REFRESH lt_parameters.

      " NotaFiscal
      APPEND VALUE #( name  = gc_values-j_1bdydoc_docnum
                      value = <fs_data>-notafiscal ) TO lt_parameters.

      <fs_data>-url_j1b3n = cl_lsapi_manager=>create_flp_url( object     = gc_values-notafiscal
                                                              action     = gc_values-notadisplay
                                                              parameters = lt_parameters ).
      REFRESH lt_parameters.

      "OrdemFrete
      APPEND VALUE #( name  = gc_values-freightorder
                      value = <fs_data>-FreightOrder ) TO lt_parameters.

      <fs_data>-url_frete = cl_lsapi_manager=>create_flp_url( object     = gc_values-fgorder
                                                              action     = gc_values-displayroad
                                                              parameters = lt_parameters ).
      REFRESH lt_parameters.




    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_calculated_data ).

  ENDMETHOD.


  METHOD IF_SADL_EXIT_CALC_ELEMENT_READ~GET_CALCULATION_INFO.
    RETURN.
  ENDMETHOD.
ENDCLASS.
