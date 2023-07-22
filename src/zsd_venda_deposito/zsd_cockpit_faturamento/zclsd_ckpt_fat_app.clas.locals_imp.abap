CLASS lcl_cockpitfaturamento DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    ##NO_TEXT
    CONSTANTS:
      BEGIN OF gc_status,
        pendente(9)  TYPE c VALUE 'Pendente',
        concluida(9) TYPE c VALUE 'Concluída',
      END OF gc_status.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK cockpitfaturamento.

    METHODS read FOR READ
      IMPORTING keys FOR READ cockpitfaturamento RESULT result.

    METHODS gerarremessa FOR MODIFY
      IMPORTING keys FOR ACTION cockpitfaturamento~gerarremessa.

    METHODS consultardisponibilidade FOR MODIFY
      IMPORTING keys FOR ACTION cockpitfaturamento~consultardisponibilidade.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR cockpitfaturamento RESULT result.


ENDCLASS.

CLASS lcl_cockpitfaturamento IMPLEMENTATION.

  METHOD lock.
    RETURN.
  ENDMETHOD.

  METHOD read.

    CHECK keys IS NOT INITIAL.
    SELECT * FROM zi_sd_ckpt_fat_app
    FOR ALL ENTRIES IN @keys
    WHERE salesorder = @keys-salesorder
*      AND SalesOrderItem = '000010'
    INTO CORRESPONDING FIELDS OF TABLE @result.

  ENDMETHOD.

  METHOD gerarremessa.
    DATA lt_return_context TYPE TABLE OF bapiret2.

* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZGER_REMES' FOR USER sy-uname
      ID 'ACTVT' FIELD '01'.    "Criar

    IF NOT sy-subrc IS INITIAL.
      APPEND VALUE #(
        %msg     = new_message(
        id       = 'ZSD_CKPT_FATURAMENTO'
        number   = '001'
        severity = CONV #( 'E' ) ) ) TO reported-cockpitfaturamento.
      RETURN.
    ENDIF.

*    READ ENTITIES OF zi_sd_ckpt_fat_app IN LOCAL MODE
*    ENTITY cockpitfaturamento
*      FIELDS ( salesorder ) WITH CORRESPONDING #( keys )
*    RESULT DATA(lt_cockpit)
*    FAILED failed.

    SELECT doc~vbeln, cliente~kunnr
    FROM vbpa AS doc
    INNER JOIN @keys AS chaves
    ON doc~vbeln = chaves~salesorder
    INNER JOIN kna1 AS cliente
    ON cliente~kunnr = doc~kunnr
    WHERE doc~parvw  = 'AG'
    INTO TABLE  @DATA(lt_cockpit).

*    SORT lt_cockpit BY SalesOrder SalesOrderItem.
*    DELETE lt_cockpit WHERE SalesOrderItem <> '000010'. "#EC CI_STDSEQ

    LOOP AT lt_cockpit ASSIGNING FIELD-SYMBOL(<fs_cockpit>).
      DATA(lo_gera_remesa) = NEW zclsd_ckpt_fat_gera_remessa( ).
      CALL METHOD lo_gera_remesa->main
        EXPORTING
          iv_ordem_venda = <fs_cockpit>-vbeln "<fs_cockpit>-salesorder
          iv_cliente     = <fs_cockpit>-kunnr "<fs_cockpit>-customer
        RECEIVING
          rt_return      = DATA(lt_return).

      APPEND VALUE #( %state_area = 'GERARREMESSA' )
        TO reported-cockpitfaturamento.

      APPEND LINES OF lt_return TO lt_return_context.
    ENDLOOP.

    SORT lt_return_context BY parameter.

    reported-cockpitfaturamento = VALUE #( FOR ls_message IN lt_return_context (
        %msg     = new_message(
        id       = ls_message-id
        number   = ls_message-number
        v1       = ls_message-message_v1
        v2       = ls_message-message_v2
        v3       = ls_message-message_v3
        v4       = ls_message-message_v4
        severity = CONV #( ls_message-type )
*        severity = CONV #( 'I' )
    ) ) ).
  ENDMETHOD.

  METHOD consultardisponibilidade.
    RETURN.
  ENDMETHOD.

*  METHOD recusarordem.
*    RETURN.
*  ENDMETHOD.

  METHOD get_features.

    SELECT _chaves~salesorder,
           _chaves~salesorderitem,
           _salesorder~totalcreditcheckstatus,
           _salesorder~deliveryblockreason,
           _salesorder~overalldeliverystatus
    FROM i_salesorder AS _salesorder
    INNER JOIN @keys AS _chaves
     ON _salesorder~salesorder = _chaves~salesorder
    INTO TABLE @DATA(lt_cockpit).

    LOOP AT lt_cockpit ASSIGNING FIELD-SYMBOL(<fs_cockpit>).

      IF ( <fs_cockpit>-totalcreditcheckstatus <> 'B' AND
           <fs_cockpit>-totalcreditcheckstatus <> 'C' ) AND   "= gc_status-concluida
           <fs_cockpit>-deliveryblockreason    IS INITIAL AND "= gc_status-concluida
           <fs_cockpit>-overalldeliverystatus  <> 'C'.
        DATA(lv_gerarremessa_action) = if_abap_behv=>fc-o-enabled.
      ELSE.
        lv_gerarremessa_action = if_abap_behv=>fc-o-disabled.
      ENDIF.

      APPEND VALUE #(
        %tky = VALUE #( salesorder = <fs_cockpit>-salesorder
                        salesorderitem = <fs_cockpit>-salesorderitem )
        %features-%action-gerarremessa = lv_gerarremessa_action
      ) TO result.
    ENDLOOP.

*    DATA lv_gerarremessa_action TYPE if_abap_behv=>t_xflag.
*    DATA lv_recusaordem_action  TYPE if_abap_behv=>t_xflag.

*    READ ENTITIES OF zi_sd_ckpt_fat_app IN LOCAL MODE
*    ENTITY cockpitfaturamento
*      FIELDS ( salesorder ) WITH CORRESPONDING #( keys )
*    RESULT DATA(lt_cockpit)
*    FAILED failed.
*
*    LOOP AT lt_cockpit ASSIGNING FIELD-SYMBOL(<fs_cockpit>).
*
*      IF <fs_cockpit>-statustotalcreditcheckstatus EQ gc_status-concluida
*     AND <fs_cockpit>-statusdeliveryblockreason    EQ gc_status-concluida
*     AND <fs_cockpit>-overalldeliverystatus        NE 'C'.
*        lv_gerarremessa_action = if_abap_behv=>fc-o-enabled.
*      ELSE.
*        lv_gerarremessa_action = if_abap_behv=>fc-o-disabled.
*
*      ENDIF.
*
*      APPEND VALUE #(
*        %tky = <fs_cockpit>-%key
*        %features-%action-gerarremessa = lv_gerarremessa_action
*      ) TO result.
*    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_zi_sd_ckpt_fat_app DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_zi_sd_ckpt_fat_app IMPLEMENTATION.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD finalize.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

ENDCLASS.
