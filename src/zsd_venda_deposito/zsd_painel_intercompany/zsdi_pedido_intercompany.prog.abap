*&---------------------------------------------------------------------*
*& Include          ZSDI_PEDIDO_INTERCOMPANY
*&---------------------------------------------------------------------*

DATA: ls_input         TYPE zssd_ordem_intercompany,
      lt_text          TYPE STANDARD TABLE OF zssd_ordem_inter_text,
      lv_purchaseorder TYPE ebeln,
      ls_ped_interco   TYPE ztsd_ped_interco,
      rt_return        TYPE bapiret2_t.

DATA: lt_log TYPE STANDARD TABLE OF ztsd_interco_log.


IF likp-lfart = 'Z004' OR "intercompany
   likp-lfart = 'Z009' OR "Outras vendas consumo (tratamento para intercompany)
   likp-lfart = 'Z019'.   "Venda Ordem (tratamento para intercompany)

  IF ylikp-wbstk <> 'C'  "saída de mercadoria não finalizada

  AND xlikp-wbstk = 'C'. "saída de mercadoria em andamento

*  IF sy-ucomm = 'WABU_T'. "saída de mercadoria.

    IF xlips[] IS NOT INITIAL.

      "Valida se pedido já criado
      SELECT COUNT(*)
        FROM ztsd_ped_interco
        WHERE remessa    = xlikp-vbeln.                 "#EC CI_NOFIELD

      IF sy-subrc IS NOT INITIAL.


        "criar pedido de compra para recebimento da venda intercompany.
        SELECT *
          UP TO 1 ROWS
          FROM ztsd_intercompan
          INTO @DATA(ls_intercompan)
          FOR ALL ENTRIES IN @xlips
          WHERE processo   = '2'
          AND   salesorder = @xlips-vgbel
          .
        ENDSELECT.

        IF sy-subrc IS INITIAL.
          ls_input =  VALUE #(
            guid              = ls_intercompan-guid
            tipo_operacao     = ls_intercompan-tipooperacao
            processo          = ls_intercompan-processo
            centro_fornecedor = ls_intercompan-werks_origem
            centro_destino    = ls_intercompan-werks_destino
            centro_receptor   = ls_intercompan-werks_receptor
            deposito_destino  = ls_intercompan-lgort_destino
            deposito_origem   = ls_intercompan-lgort_origem
            tipo_frota        = ls_intercompan-tpfrete
            agente_frete      = ls_intercompan-agfrete
            placa             = ls_intercompan-ztraid
            tipo_exped        = ls_intercompan-tpexp
            cond_exped        = ls_intercompan-condexp
            motorista         = ls_intercompan-motora
            texto_nfe         = COND #( WHEN ls_intercompan-txtnf IS NOT INITIAL
                                       THEN VALUE #( BASE lt_text ( line = ls_intercompan-txtnf ) ) )
            texto_geral       = COND #( WHEN ls_intercompan-txtgeral IS NOT INITIAL
                                       THEN VALUE #( BASE lt_text ( line = ls_intercompan-txtgeral ) ) )
            org_compras       = ls_intercompan-ekorg
            grp_comp          = ls_intercompan-ekgrp
            remessa_origem    = xlikp-vbeln ).

          DATA(lo_cockpit_transf) =  NEW zclmm_cockpit_transf(  ).

          rt_return = lo_cockpit_transf->exec_po_intercompany( EXPORTING is_input         = ls_input
                                                               IMPORTING ev_purchaseorder = lv_purchaseorder ).

          LOOP AT rt_return ASSIGNING FIELD-SYMBOL(<fs_return_aux>).

            lt_log[] = VALUE #( BASE lt_log ( guid       = ls_intercompan-guid
                                              seqnr      = sy-tabix
                                              msgty      = <fs_return_aux>-type
                                              msgid      = <fs_return_aux>-id
                                              msgno      = <fs_return_aux>-number
                                              msgv1      = <fs_return_aux>-message_v1
                                              msgv2      = <fs_return_aux>-message_v2
                                              msgv3      = <fs_return_aux>-message_v3
                                              msgv4      = <fs_return_aux>-message_v4
                                              message    = <fs_return_aux>-message ) ).


          ENDLOOP.

          IF lt_log[] IS NOT INITIAL.

            MODIFY ztsd_interco_log FROM TABLE lt_log[].
            IF sy-subrc = 0.
              COMMIT WORK AND WAIT.
            ENDIF.

          ENDIF.
          IF lv_purchaseorder IS NOT INITIAL.

            ls_ped_interco-mandt      = sy-mandt.
            ls_ped_interco-guid       = ls_intercompan-guid.
            ls_ped_interco-salesorder = ls_intercompan-salesorder.
            ls_ped_interco-remessa    = xlikp-vbeln.
            ls_ped_interco-pedido     = lv_purchaseorder.
            ls_ped_interco-atualizado = abap_false.


            MODIFY ztsd_ped_interco FROM ls_ped_interco.
            CLEAR: ls_ped_interco.

          ELSE.
            IF rt_return IS NOT INITIAL.
*              DATA(ls_message) = rt_return[ type = 'E' ].
*              MESSAGE ID ls_message-id TYPE ls_message-type NUMBER ls_message-number WITH ls_message-message_v1 ls_message-message_v2 ls_message-message_v3 ls_message-message_v4.
              IF sy-batch NE abap_true.
                cl_rmsl_message=>display( rt_return ).
                MESSAGE i006(zsd) DISPLAY LIKE 'E'. "O pedido de compra não foi criado
*              ENDIF.
*              CALL SCREEN '4004'.
                PERFORM folge_gleichsetzen(saplv00f).
                fcode = 'ENT1'.
                SET SCREEN syst-dynnr.
                LEAVE SCREEN.
              ELSE.
                LOOP AT rt_return ASSIGNING FIELD-SYMBOL(<fs_return>).

                  MESSAGE ID <fs_return>-id TYPE <fs_return>-type NUMBER <fs_return>-number WITH <fs_return>-message_v1
                                                                                                 <fs_return>-message_v2
                                                                                                 <fs_return>-message_v3
                                                                                                 <fs_return>-message_v4
                                                                                                 INTO DATA(lv_msg).

                  WRITE: / lv_msg.
                  MESSAGE e006(zsd). "O pedido de compra não foi criado
*
**                  PERFORM folge_gleichsetzen(saplv00f).
**                  fcode = 'ENT1'.
**                  SET SCREEN syst-dynnr.
**                  LEAVE SCREEN.
*
                ENDLOOP.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
