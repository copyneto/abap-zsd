CLASS zclsd_liberacao_id DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    "! ID de cadastro
    DATA gs_id               TYPE zi_sd_monitor_campanha-id.
    "! Campanha
    DATA gs_promocao        TYPE zi_sd_monitor_campanha-promocao.
    "!  Mensagens de erro
    DATA gt_mensagens        TYPE bapiret2_tab.
    "! Dados App Monitor de Campanhas Promocionais
    DATA gt_monitor          TYPE TABLE OF ztsd_sint_proces.

    "! Executa a liberação de ID
    "! @parameter iv_id        | ID de cadastro
    "! @parameter iv_promocao  | Campanha
    "! @parameter rt_mensagens | Mensagens de erro
    METHODS executar IMPORTING iv_id               TYPE ztsd_sint_proces-id
                               iv_promocao         TYPE ztsd_sint_proces-promocao
                     RETURNING
                               VALUE(rt_mensagens) TYPE  bapiret2_tab.

  PROTECTED SECTION.
  PRIVATE SECTION.

    "! Seleciona Dados
    METHODS seleciona_dados.
    "! Adiciona Dados Globais
    "! @parameter iv_id        | ID de cadastro
    "! @parameter iv_promocao  | Campanha
    METHODS add_globais
      IMPORTING
        iv_id       TYPE  ztsd_sint_proces-id
        iv_promocao TYPE  ztsd_sint_proces-promocao.
    "! Limpa campos para liberação de ID
    METHODS limpa_campos.
    "! Realiza liberação Id
    "! @parameter is_monitor | Dados App Monitor de Campanhas Promocionais
    METHODS liberacao_id
      IMPORTING
        is_monitor TYPE ztsd_sint_proces.

ENDCLASS.



CLASS zclsd_liberacao_id IMPLEMENTATION.

  METHOD executar.

    add_globais( iv_id = iv_id  iv_promocao = iv_promocao ).

    seleciona_dados(  ).

    limpa_campos( ).

    rt_mensagens = gt_mensagens.

  ENDMETHOD.

  METHOD limpa_campos.

    LOOP AT gt_monitor ASSIGNING FIELD-SYMBOL(<fs_monitor>).

      CLEAR: <fs_monitor>-doc_ov,
             <fs_monitor>-status_ov,
             <fs_monitor>-forn,
             <fs_monitor>-status_forn_sap,
             <fs_monitor>-doc_fat,
             <fs_monitor>-status_fat,
             <fs_monitor>-nr_nfe.

      liberacao_id( <fs_monitor> ).

    ENDLOOP.

  ENDMETHOD.

  METHOD liberacao_id.

    MODIFY ztsd_sint_proces FROM is_monitor.        "#EC CI_IMUD_NESTED

    IF sy-subrc = 0.
      APPEND VALUE #( id         = '00'
                      number     = '001'
                      type       = 'S'
                      message_v1 = TEXT-001
                      message_v2 = |{ TEXT-002 }| & || & |{ is_monitor-id }|
                      message_v3 = |{ TEXT-003 }| & || & |{ is_monitor-promocao }|  ) TO gt_mensagens.
    ELSE.
      APPEND VALUE #( id         = '00'
                      number     = '001'
                      type       = 'E'
                      message_v1 = TEXT-004
                      message_v2 = |{ TEXT-002 }| & || & |{ is_monitor-id }|
                      message_v3 = |{ TEXT-003 }| & || & |{ is_monitor-promocao }|  ) TO gt_mensagens.
    ENDIF.

  ENDMETHOD.




  METHOD add_globais.

    gs_id        = iv_id.
    gs_promocao  = iv_promocao.

  ENDMETHOD.


  METHOD seleciona_dados.

    SELECT * FROM ztsd_sint_proces
    INTO TABLE gt_monitor
      WHERE id       EQ gs_id
        AND promocao EQ gs_promocao.

  ENDMETHOD.

ENDCLASS.
