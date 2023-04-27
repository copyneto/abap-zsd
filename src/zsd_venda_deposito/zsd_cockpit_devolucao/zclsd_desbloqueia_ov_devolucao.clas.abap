CLASS zclsd_desbloqueia_ov_devolucao DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! Executa o desbloquei do  Documento de vendas devolução
    "! @parameter is_ov        | Documento de vendas devolução
    "! @parameter rt_mensagens | Mensagens de erro
    METHODS main
      IMPORTING
        !is_ov              TYPE ztsd_devolucao-ord_devolucao
      RETURNING
        VALUE(rt_mensagens) TYPE bapiret2_tab .
    "! Método executado após chamada da função background
    "! @parameter p_task | Parametro obrigatório do método
    METHODS task_finish
      IMPORTING
        !p_task TYPE clike .
    "! Método executado após chamada da função background
    "! @parameter p_task | Parametro obrigatório do método
    METHODS task_finish_block
      IMPORTING
        !p_task TYPE clike .

    "! Ler as mensagens geradas pelo processamento
    "! @parameter p_task |Noma da task executada
    CLASS-METHODS setup_messages
      IMPORTING
        !p_task TYPE clike.

    "! Gerencia ação para remoção de bloqueio de remessa
    "! @parameter iv_vbeln | Remessa
    "! @parameter rt_mensagens | Mensages de retorno
    METHODS rmv_delivery_block
      IMPORTING
        !iv_vbeln           TYPE likp-vbeln
      RETURNING
        VALUE(rt_mensagens) TYPE bapiret2_tab .

    "! Realiza chamada para fazer o bloqueio de remessa (commit)
    "! @parameter iv_vbeln | Remessa
    "! @parameter et_return | Mensages de retorno
    METHODS delivery_block
      IMPORTING
        !iv_vbeln  TYPE likp-vbeln
      EXPORTING
        !et_return TYPE bapiret2_t .

    "! Realiza chamada para fazer o bloqueio de remessa
    "! @parameter iv_vbeln | Remessa
    "! @parameter iv_lifsk | Bloqueio de remessa
    "! @parameter et_return | Mensages de retorno
    METHODS call_delivery_block
      IMPORTING
        !iv_vbeln  TYPE likp-vbeln
        !iv_lifsk  TYPE likp-lifsk OPTIONAL
        !iv_delete TYPE likp_del OPTIONAL
      EXPORTING
        !et_return TYPE bapiret2_t .

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA: gt_return TYPE STANDARD TABLE OF bapiret2.
    CLASS-DATA: gv_wait_async TYPE abap_bool.
    "! Estrutura VBAK
    DATA gs_order_header_in TYPE  bapisdh1.
    "! Barra de seleção: SD cabeçalho de ordem
    DATA gs_order_header_inx TYPE bapisdh1x.


    METHODS change_ov IMPORTING is_ov     TYPE ztsd_devolucao-ord_devolucao.

    METHODS get_datail IMPORTING is_ov        TYPE ztsd_devolucao-ord_devolucao.
    "! Realiza Commit Work
    METHODS commit_work.
ENDCLASS.



CLASS ZCLSD_DESBLOQUEIA_OV_DEVOLUCAO IMPLEMENTATION.


  METHOD main.

    change_ov( is_ov = is_ov ).

    rt_mensagens = gt_return.

  ENDMETHOD.


  METHOD task_finish.

    RECEIVE RESULTS FROM FUNCTION 'BAPI_SALESORDER_GETDETAILBOS'
     IMPORTING
     orderheader   = gs_order_header_in
      TABLES
        return   = gt_return.
    RETURN.

  ENDMETHOD.


  METHOD get_datail.

    DATA:lt_return    TYPE STANDARD TABLE OF bapireturn1.

    CALL FUNCTION 'BAPI_SALESORDER_GETDETAILBOS'
      STARTING NEW TASK 'BACKGROUND' CALLING task_finish ON END OF TASK
      EXPORTING
        salesdocument = is_ov
      TABLES
        return        = lt_return.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL lt_return IS NOT INITIAL.

    change_ov( is_ov = is_ov ).

  ENDMETHOD.


  METHOD change_ov.

    DATA:lt_return    TYPE STANDARD TABLE OF bapireturn1.

    CLEAR gs_order_header_in-dlv_block.
    gs_order_header_inx-updateflag  = 'U'.
    gs_order_header_inx-dlv_block   = abap_true.

    CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
      STARTING NEW TASK 'BACKGROUND' CALLING task_finish_block ON END OF TASK
      EXPORTING
        salesdocument    = is_ov
        order_header_in  = gs_order_header_in
        order_header_inx = gs_order_header_inx
      TABLES
        return           = lt_return.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL lt_return IS NOT INITIAL.

    IF line_exists( lt_return[ type = 'S' ] ).           "#EC CI_STDSEQ
      commit_work( ).
    ENDIF.

  ENDMETHOD.


  METHOD task_finish_block.
    RECEIVE RESULTS FROM FUNCTION 'BAPI_SALESORDER_CHANGE'
    TABLES
      return   = gt_return.
    RETURN.

  ENDMETHOD.


  METHOD commit_work.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ENDMETHOD.


  METHOD delivery_block.
    DATA: ls_header_data    TYPE bapiobdlvhdrchg,
          ls_header_control TYPE bapiobdlvhdrctrlchg,
          lv_delivery       TYPE vbeln_vl,
          lt_return         TYPE bapiret2_t.

* ---------------------------------------------------------------------------
* Preenche informação
* ---------------------------------------------------------------------------

    ls_header_data    = VALUE #( deliv_numb    = iv_vbeln ).

    ls_header_control = VALUE #( deliv_numb    = iv_vbeln
                                 dlv_block_flg = abap_true ).

    lv_delivery       = iv_vbeln.

* ---------------------------------------------------------------------------
* Chama BAPI para alteração da remessa
* ---------------------------------------------------------------------------
    CALL FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
      EXPORTING
        header_data    = ls_header_data
        header_control = ls_header_control
        delivery       = lv_delivery
      TABLES
        return         = lt_return.

    IF lt_return IS INITIAL.
      " Remessa &1 desbloqueada com sucesso.
      APPEND VALUE #( type = 'S'
                      id  = 'ZSD_COCKPIT_DEVOL'
                      number = 027
                      message_v1 = |{ iv_vbeln ALPHA = OUT }| ) TO et_return.
    ENDIF.

    IF NOT line_exists( lt_return[ type = 'E' ] ).
      commit_work( ).
    ELSE.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

    ENDIF.

  ENDMETHOD.


  METHOD rmv_delivery_block.
* ---------------------------------------------------------------------------
* Chama evento para Bloqueio de remessa
* ---------------------------------------------------------------------------
    me->call_delivery_block( EXPORTING iv_vbeln  = iv_vbeln
                                       iv_lifsk  = space
                             IMPORTING et_return = rt_mensagens ).
  ENDMETHOD.


  METHOD call_delivery_block.

    FREE: et_return, gv_wait_async.

* ---------------------------------------------------------------------------
* Chama evento para Bloqueio de remessa
* ---------------------------------------------------------------------------
    FREE: gt_return.

    CALL FUNCTION 'ZFMSD_COCKPIT_DEVOL_BLQ_REM'
      STARTING NEW TASK 'COCKPIT_DEVOL_BLQ_REM'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        iv_vbeln  = iv_vbeln
        iv_lifsk  = iv_lifsk
        iv_delete = iv_delete.

    WAIT UNTIL gv_wait_async = abap_true.
    et_return = gt_return.

  ENDMETHOD.


  METHOD setup_messages.

    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_COCKPIT_REMESSA_BLQ_REM'
        IMPORTING
            et_return = gt_return.

    gv_wait_async = abap_true.

  ENDMETHOD.
ENDCLASS.
