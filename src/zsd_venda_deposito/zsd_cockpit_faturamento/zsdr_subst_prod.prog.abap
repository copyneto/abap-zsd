*&---------------------------------------------------------------------*
*& Report ZSDR_SUBST_PROD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsdr_subst_prod.

TABLES: vbap.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-b01.

  SELECT-OPTIONS: s_ordem    FOR vbap-vbeln,
                  s_item     FOR vbap-posnr,
                  s_mat      FOR vbap-matnr,
                  s_matual   FOR vbap-matnr.

SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

  DATA:
    lt_message_tot TYPE zclsd_submit_subst_prod=>ty_t_return,
    lt_keys_new    TYPE zclsd_submit_subst_prod=>ty_t_keys,
    lt_sub_aux     TYPE SORTED TABLE OF zc_sd_substituir_custom_app
    WITH UNIQUE KEY primary_key COMPONENTS salesorder salesorderitem materialatual material.

  IMPORT  lt_keys_new = lt_keys_new FROM MEMORY ID 'ZSDR_SUBST_PROD'.
  IF sy-subrc = 0.
    FREE MEMORY ID 'ZSDR_SUBST_PROD'.
  ENDIF.

  SELECT _sd_substituir_app~salesorder, _sd_substituir_app~salesorderitem,
  _sd_substituir_app~materialatual, _sd_substituir_app~material,
  _sd_substituir_app~classedoc, _sd_substituir_app~umpreco, _sd_substituir_app~preco
    FROM zi_sd_substituir_app AS _sd_substituir_app
    INNER JOIN @lt_keys_new AS _keys_new
     ON _sd_substituir_app~salesorder     = _keys_new~salesorder
    AND _sd_substituir_app~salesorderitem = _keys_new~salesorderitem
    AND _sd_substituir_app~material       = _keys_new~material
    AND _sd_substituir_app~materialatual  = _keys_new~materialatual
  INTO CORRESPONDING FIELDS OF TABLE @lt_sub_aux.

  DATA(lo_substituirproduto_aux) = NEW zclsd_verif_util_sub( ).

  DATA(lt_keys_new_salesorders) = CORRESPONDING zclsd_submit_subst_prod=>ty_t_keys_salesorder(
  lt_keys_new DISCARDING DUPLICATES ).
  LOOP AT lt_keys_new_salesorders ASSIGNING FIELD-SYMBOL(<fs_key_salesorder>).
    DATA(lt_sub_prod) = FILTER #( lt_sub_aux USING KEY primary_key WHERE salesorder = <fs_key_salesorder>-salesorder ).

    lo_substituirproduto_aux->gv_teste = abap_true.
    lo_substituirproduto_aux->selection_data(  it_sub_prod = CORRESPONDING #( lt_sub_prod ) ).
    DATA(lt_message_return) = lo_substituirproduto_aux->substituir_produto(
      iv_order     = <fs_key_salesorder>-salesorder
      it_sub_prod  = CORRESPONDING #( lt_sub_prod )
    ).
    APPEND VALUE #(
      salesorder     = <fs_key_salesorder>-salesorder
      salesorderitem = <fs_key_salesorder>-salesorderitem
      materialatual  = <fs_key_salesorder>-materialatual
      material       = <fs_key_salesorder>-material
      messages       = lt_message_return
      ) TO lt_message_tot.
  ENDLOOP.

  EXPORT lt_message_tot = lt_message_tot TO MEMORY ID 'ZSDR_SUBST_PROD_MSG'.


*  EXIT.
*
*  DATA lt_sub TYPE TABLE OF zc_sd_substituir_custom_app.
*
*  SELECT *
*    FROM zi_sd_substituir_app
*  WHERE salesorder     IN @s_ordem
*    AND salesorderitem IN @s_item
*    AND material       IN @s_mat
*    AND materialatual  IN @s_matual
*INTO CORRESPONDING FIELDS OF TABLE @lt_sub.
*
*  DATA(lo_substituirproduto) = NEW zclsd_verif_util_sub( ).
*
*  lo_substituirproduto->gv_teste = abap_true.
*  lo_substituirproduto->selection_data(  it_sub_prod = lt_sub ).
*
**  DATA(lt_ordem) = s_ordem[].
**  SORT lt_ordem BY low.
**  DELETE ADJACENT DUPLICATES FROM lt_ordem COMPARING low.
**  LOOP AT lt_ordem[] ASSIGNING FIELD-SYMBOL(<fs_ordens>).
*
*
*  DATA(lt_message) = lo_substituirproduto->substituir_produto( iv_order     = s_ordem[ 1 ]-low
*                                                               it_sub_prod  = lt_sub ).
*  EXPORT lt_message = lt_message TO MEMORY ID 'ZSDSUBSTITUIR_MSG'.
**  ENDLOOP.
