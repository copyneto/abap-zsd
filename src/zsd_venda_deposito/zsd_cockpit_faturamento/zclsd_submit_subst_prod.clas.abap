CLASS zclsd_submit_subst_prod DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_keys,
        salesorder     TYPE zc_sd_substituir_custom_app-salesorder,
        salesorderitem TYPE zc_sd_substituir_custom_app-salesorderitem,
        materialatual  TYPE zc_sd_substituir_custom_app-materialatual,
        material       TYPE zc_sd_substituir_custom_app-material,
      END OF ty_keys,
      ty_t_keys TYPE SORTED TABLE OF ty_keys
      WITH UNIQUE KEY salesorder salesorderitem materialatual material,
      ty_t_keys_salesorder TYPE SORTED TABLE OF ty_keys WITH UNIQUE KEY salesorder,

      BEGIN OF ty_return,
        salesorder     TYPE zc_sd_substituir_custom_app-salesorder,
        salesorderitem TYPE zc_sd_substituir_custom_app-salesorderitem,
        materialatual  TYPE zc_sd_substituir_custom_app-materialatual,
        material       TYPE zc_sd_substituir_custom_app-material,
        messages       TYPE bapiret2_tab,
      END OF ty_return,
      ty_t_return TYPE SORTED TABLE OF ty_return
      WITH UNIQUE KEY salesorder salesorderitem materialatual material.

    METHODS:
      submit
        IMPORTING
          it_seltab        TYPE ty_rsparams OPTIONAL
          it_keys          TYPE ty_t_keys OPTIONAL
        RETURNING
          VALUE(rt_return) TYPE ty_t_return.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS ZCLSD_SUBMIT_SUBST_PROD IMPLEMENTATION.


  METHOD submit.
    DATA:
        lt_message_tot TYPE ty_t_return.
    TRY.
        EXPORT lt_keys_new = it_keys TO MEMORY ID 'ZSDR_SUBST_PROD'.
        SUBMIT zsdr_subst_prod AND RETURN.
        IMPORT  lt_message_tot = lt_message_tot FROM MEMORY ID 'ZSDR_SUBST_PROD_MSG'.
        IF sy-subrc = 0.
          rt_return = lt_message_tot. "#EC CI_CONV_OK
          FREE MEMORY ID 'ZSDR_SUBST_PROD_MSG'.
        ENDIF.
*        SUBMIT zsdr_subst_prod WITH SELECTION-TABLE it_seltab
*            AND RETURN.
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
