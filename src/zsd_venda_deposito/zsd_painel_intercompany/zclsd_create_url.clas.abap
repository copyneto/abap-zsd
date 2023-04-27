CLASS zclsd_create_url DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: BEGIN OF gc_values,
                 p_doc_id               TYPE ihttpnam VALUE 'P_DOC_ID',
                 purchaseorder          TYPE char30   VALUE 'PurchaseOrder',
                 returnsdelivery        TYPE char30   VALUE 'ReturnsDelivery',
                 salesorder             TYPE char30   VALUE 'SalesOrder',
                 billingdocument        TYPE char30   VALUE 'BillingDocument',
                 notafiscal             TYPE char30   VALUE 'NotaFiscal',
                 display                TYPE char60   VALUE 'display',
                 zzdisplay              TYPE char60   VALUE 'zzdisplay',
                 displayinwebgui        TYPE char60   VALUE 'displayInWebGui',
                 displaybillingdocument TYPE char60   VALUE 'displayBillingDocument',
                 vbak_vbeln             TYPE ihttpnam VALUE 'VBAK-VBELN',
                 vbrk_vbeln             TYPE ihttpnam VALUE 'BillingDocument',
                 likp_vbeln             TYPE ihttpnam VALUE 'LIKP-VBELN',
                 j_1bdydoc_docnum       TYPE ihttpnam VALUE 'J_1BDYDOC-DOCNUM',
                 numerodocumento        TYPE ihttpnam VALUE 'NumeroDocumento',
                 v1                     TYPE i        VALUE 1,
                 tmfo                   TYPE vbtypl   VALUE 'TMFO',
                 freightorder           TYPE char30   VALUE 'FreightOrder',
                 displayroad            TYPE char60   VALUE 'displayRoad',
                 skip_initial_screen    TYPE char30   VALUE 'skip_initial_screen',
               END OF gc_values.

ENDCLASS.



CLASS zclsd_create_url IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_calculated_data TYPE STANDARD TABLE OF zc_sd_01_cockpit,
          lt_parameters      TYPE tihttpnvp,
          lt_docflow         TYPE tdt_docflow.

    lt_calculated_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_calculated_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      " PurchaseOrderByCustomer
      APPEND VALUE #( name  = gc_values-p_doc_id
                      value = <fs_data>-purchaseorder ) TO lt_parameters.

      <fs_data>-url_me23n = cl_lsapi_manager=>create_flp_url( object     = gc_values-purchaseorder
                                                              action     = gc_values-display
                                                              parameters = lt_parameters ).
      REFRESH lt_parameters.

      " SalesOrder
*      APPEND VALUE #( name  = gc_values-vbak_vbeln
      APPEND VALUE #( name  = gc_values-salesorder
                      value = <fs_data>-salesorder )  TO lt_parameters.

      <fs_data>-url_va03 = cl_lsapi_manager=>create_flp_url( object     = gc_values-salesorder
                                                             action     = gc_values-display
                                                             parameters = lt_parameters ).
      REFRESH lt_parameters.

      " ReturnsDelivery
      APPEND VALUE #( name  = gc_values-likp_vbeln
                      value = <fs_data>-remessa ) TO lt_parameters.

      <fs_data>-url_vl03n = cl_lsapi_manager=>create_flp_url( object     = gc_values-returnsdelivery
                                                              action     = gc_values-displayinwebgui
                                                              parameters = lt_parameters ).
      REFRESH lt_parameters.

      " InboundDelivery
      APPEND VALUE #( name  = gc_values-likp_vbeln
                      value = <fs_data>-remessaorigem ) TO lt_parameters.

      <fs_data>-url_vl03n_inb = cl_lsapi_manager=>create_flp_url( object     = gc_values-returnsdelivery
                                                                  action     = gc_values-displayinwebgui
                                                                  parameters = lt_parameters ).
      REFRESH lt_parameters.

      " BillingDocument
      APPEND VALUE #( name  = gc_values-vbrk_vbeln
                      value = <fs_data>-docfat ) TO lt_parameters.

      <fs_data>-url_vf03 = cl_lsapi_manager=>create_flp_url( object     = gc_values-billingdocument
                                                             action     = gc_values-displaybillingdocument
                                                             parameters = lt_parameters ).
      REFRESH lt_parameters.

      " NotaFiscal
      APPEND VALUE #( name  = gc_values-numerodocumento
                      value = <fs_data>-br_notafiscal ) TO lt_parameters.

      <fs_data>-url_j1b3n = cl_lsapi_manager=>create_flp_url( object     = gc_values-notafiscal
                                                              action     = gc_values-zzdisplay
                                                              parameters = lt_parameters ).
      REFRESH lt_parameters.

      " NotaFiscal
      APPEND VALUE #( name  = gc_values-numerodocumento
                      value = <fs_data>-nfentrada ) TO lt_parameters.

      <fs_data>-url_j1b3n_inb = cl_lsapi_manager=>create_flp_url( object     = gc_values-notafiscal
                                                                  action     = gc_values-zzdisplay
                                                                  parameters = lt_parameters ).
      REFRESH lt_parameters.

      " Pedido etapa 2
      APPEND VALUE #( name  = gc_values-p_doc_id
                      value = <fs_data>-correspncexternalreference ) TO lt_parameters.

      <fs_data>-url_me23_2 = cl_lsapi_manager=>create_flp_url( object     = gc_values-purchaseorder
                                                               action     = gc_values-display
                                                               parameters = lt_parameters ).
      REFRESH lt_parameters.

      lt_parameters = VALUE #(
        ( name  = gc_values-freightorder        value = <fs_data>-docnuv )
        ( name  = gc_values-skip_initial_screen value = abap_true ) ).

      <fs_data>-url_freightorder = cl_lsapi_manager=>create_flp_url( object     = gc_values-freightorder
                                                                     action     = gc_values-displayroad
                                                                     parameters = lt_parameters ).
      REFRESH lt_parameters.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_calculated_data ).


  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    RETURN.
  ENDMETHOD.
ENDCLASS.
