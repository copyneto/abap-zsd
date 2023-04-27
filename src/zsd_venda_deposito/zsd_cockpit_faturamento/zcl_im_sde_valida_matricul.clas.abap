CLASS zcl_im_sde_valida_matricul DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_ex_le_shp_delivery_proc .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_im_sde_valida_matricul IMPLEMENTATION.


  METHOD if_ex_le_shp_delivery_proc~change_delivery_header.

    RETURN.

*    DATA lv_cl    TYPE c.
*    DATA lv_clear TYPE c.
*
*    IMPORT: lv_clear TO lv_cl         FROM MEMORY ID 'ZD_CLEAR_MSG'.
*    FREE MEMORY ID 'ZD_CLEAR_MSG'.
*    IF lv_cl IS NOT INITIAL.
*
*      IF  sy-msgid = 'VU' AND
*          sy-msgty = 'E'  AND
*        ( sy-msgno = '013' OR
*          sy-msgno = '014' OR
*          sy-msgno = '019' OR
*          sy-msgno = '020' ) AND
*          sy-tcode = 'VL01N' AND
*          sy-ucomm = 'SICH_T'
*        .
*        sy-msgty = 'W'.
*
*      ENDIF.
*    ENDIF.

  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~change_delivery_item.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~change_fcode_attributes.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~change_field_attributes.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~check_item_deletion.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~delivery_deletion.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~delivery_final_check.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~document_number_publish.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~fill_delivery_header.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~fill_delivery_item.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~initialize_delivery.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~item_deletion.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~publish_delivery_item.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~read_delivery.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~save_and_publish_before_output.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~save_and_publish_document.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~save_document_prepare.
    RETURN.
  ENDMETHOD.
ENDCLASS.
