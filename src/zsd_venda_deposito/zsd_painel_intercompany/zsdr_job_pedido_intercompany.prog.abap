*&---------------------------------------------------------------------*
*& Report ZSDR_JOB_PEDIDO_INTERCOMPANY
*&---------------------------------------------------------------------*
*&  Programa utilizado no processo de intercompany
*& que faz atualização de numero do pedido de compras criado
*& para recebimento da venda
*&
*& Execução feita por configuração de JOB
*&---------------------------------------------------------------------*
REPORT zsdr_job_pedido_intercompany.
*********************************************************************
* TABLES                                                            *
*********************************************************************
TABLES: ztsd_ped_interco.
*********************************************************************
* TELA DE SELEÇÃO                                                   *
*********************************************************************
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS:
   s_sales FOR ztsd_ped_interco-salesorder.

SELECTION-SCREEN END OF BLOCK b1.
**********************************************************************
* EVENTOS                                                            *
**********************************************************************

INITIALIZATION.
  "Cria instancia
  DATA(lo_cockpit_transf) =  NEW zclmm_cockpit_transf(  ).
  DATA: lt_return        TYPE bapiret2_t.

  CONSTANTS: gc_text1 TYPE c LENGTH 17 VALUE 'Ordem de vendas: ',
             gc_text2 TYPE c LENGTH 11 VALUE ' atualizada'.

**********************************************************************
* LOGICA PRINCIPAL
**********************************************************************
START-OF-SELECTION.

  IF s_sales[] IS INITIAL.

    SELECT *
      FROM ztsd_ped_interco
      INTO TABLE @DATA(lt_ped_interco)
      WHERE atualizado = @space
      .
    IF sy-subrc IS INITIAL.
      SORT lt_ped_interco BY salesorder pedido.
    ENDIF.

  ELSE.

    SELECT *
      FROM ztsd_ped_interco
      INTO TABLE lt_ped_interco
       WHERE salesorder IN s_sales
      AND atualizado = space
  .
    IF sy-subrc IS INITIAL.
      SORT lt_ped_interco BY salesorder pedido.
    ENDIF.

  ENDIF.

  LOOP AT lt_ped_interco INTO DATA(ls_ped_interco).

*    lt_return = lo_cockpit_transf->exec_so_intercompany( EXPORTING iv_salesorder              = ls_ped_interco-salesorder
*                                                                            iv_purchaseorder           = ls_ped_interco-pedido ).

    IF ls_ped_interco-salesorder IS INITIAL
    OR ls_ped_interco-pedido IS INITIAL.
      RETURN.
    ENDIF.

    DATA(ls_order_header_in) = VALUE bapisdh1(
      purch_no_c = ls_ped_interco-pedido
    ).

    DATA(ls_order_header_inx) = VALUE bapisdh1x(
      updateflag = 'U'
      purch_no_c = abap_true
    ).


    CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
      EXPORTING
        salesdocument      = ls_ped_interco-salesorder
        order_header_in    = ls_order_header_in
        order_header_inx   = ls_order_header_inx
      TABLES
        return             = lt_return.

    IF NOT line_exists( lt_return[ type = 'E' ] ).

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.

      UPDATE ztsd_ped_interco SET atualizado = abap_true
                              WHERE guid     = ls_ped_interco-guid.

      WRITE: / gc_text1, ls_ped_interco-salesorder , gc_text2 .

    ENDIF.
  ENDLOOP.













*  LOOP AT lt_sucss_msg ASSIGNING <fs_msg>.
*    MESSAGE ID <fs_msg>-id TYPE <fs_msg>-type NUMBER <fs_msg>-number
*          WITH <fs_msg>-message_v1 <fs_msg>-message_v2 <fs_msg>-message_v3 <fs_msg>-message_v4 INTO gv_message.
*    WRITE: /3 gv_message.
*  ENDLOOP.
