class ZCLSD_VERIFICA_ATRASOS definition
  public
  final
  create public .

public section.

    "! Método principal
    "! @parameter ir_datadoc        | Data do documento
    "! @parameter iv_medicao        | Medição
    "! @parameter iv_ordem_venda    | Ordem de venda
    "! @parameter iv_centro         | Centro
    "! @parameter rt_return         | Mensagens de erro
  methods EXECUTE
    importing
      !IR_DATADOC type TRTY_RDATE_RANGE
      !IV_MEDICAO type ZE_MED
      !IV_ORDEM_VENDA type VBELN_VA optional
      !IV_CENTRO type WERKS_D optional
    returning
      value(RT_RETURN) type BAPIRET2_T .
  PROTECTED SECTION.
private section.

  types:
    BEGIN OF ty_users,
        bname     TYPE xuser,
        objct     TYPE xuser,
        smtp_addr TYPE ad_smtpadr,
      END OF ty_users .
  types:
    BEGIN OF ty_medicao.
        INCLUDE TYPE zi_sd_clico_pedido.
    TYPES: END OF ty_medicao .
  types:
    tt_medicao TYPE TABLE OF ty_medicao .

  data GR_DATADOC type TRTY_RDATE_RANGE .
  data GV_MEDICAO type ZE_MED .
  data GV_ORDEM_VENDA type VBELN_VA .
  data GV_CENTRO type WERKS_D .
  data:
    gt_medicao TYPE  TABLE OF zi_sd_clico_pedido .
  data:
    gr_obj_auth TYPE RANGE OF xuobject .
  data:
    gt_perfil TYPE TABLE OF ust10s .
  data:
    gt_users TYPE TABLE OF ty_users .
  data GT_TEXT type SOLI_TAB .
  data GO_DOCUMENT type ref to CL_DOCUMENT_BCS .
  data GO_SEND_REQUEST type ref to CL_BCS .
  data:
    gt_sincrono        TYPE TABLE OF ztsd_atraso_just .
  data:
    gt_aprvcomercial   TYPE TABLE OF ztsd_atraso_just .
  data:
    gt_aprvcredito     TYPE TABLE OF ztsd_atraso_just .
  data:
    gt_envioremessa    TYPE TABLE OF ztsd_atraso_just .
  data:
    gt_ordemfrete      TYPE TABLE OF ztsd_atraso_just .
  data:
    gt_faturamento     TYPE TABLE OF ztsd_atraso_just .
  data:
    gt_saidaveic       TYPE TABLE OF ztsd_atraso_just .
  data:
    gt_entrega         TYPE TABLE OF ztsd_atraso_just .
  data:
    gt_slaexterno      TYPE TABLE OF ztsd_atraso_just .
  data:
    gt_slainterno      TYPE TABLE OF ztsd_atraso_just .
  data:
    gt_slageral        TYPE TABLE OF ztsd_atraso_just .
  data:
    gt_geracaorem      TYPE TABLE OF ztsd_atraso_just .
  data:
    gt_estoque         TYPE TABLE OF ztsd_atraso_just .
  data:
    gt_aprovnfe        TYPE TABLE OF ztsd_atraso_just .
  data:
    gt_impressaonfe    TYPE TABLE OF ztsd_atraso_just .
  data:
    gt_prestaconta     TYPE TABLE OF ztsd_atraso_just .
  data:
    gt_carregamento    TYPE TABLE OF ztsd_atraso_just .
  data:
    gt_ordens    TYPE  TABLE OF ztsd_atraso_just .
  data GT_RETURN type BAPIRET2_T .
  data GV_ERRO type ABAP_BOOL .

    "! Seta os dados Globais
    "! @parameter ir_datadoc        | Data do documento
    "! @parameter iv_medicao        | Medição
    "! @parameter iv_ordem_venda    | Ordem de venda
    "! @parameter iv_centro         | Centro
  methods SET_GLOBAL
    importing
      !IR_DATADOC type TRTY_RDATE_RANGE
      !IV_MEDICAO type ZE_MED
      !IV_ORDEM_VENDA type VBELN_VA optional
      !IV_CENTRO type WERKS_D optional .
    "! Seleciona os dados
    "! @parameter rv_return         | retorna Sucesso ou Erro
  methods GET_DATA
    returning
      value(RV_RETURN) type ABAP_BOOL .
    "! Separa as ordens por medição
  methods GET_ORDENS_MEDICAO .
    "! Busca os objetos de Autorização
  methods GET_OBJ_AUTH .
    "! busca os usuários e emails
  methods GET_USER .
    "! Monta email
  methods PREPARE_EMAIL .
    "! Busca texto do email
  methods GET_EMAIL_TEXT .
    "! Cria email
  methods CREATE_EMAIL .
    "! Cria request para envio do email
  methods CREATE_SEND_REQUEST .
    "! Seta o remetente
  methods SET_SENDER .
    "! seta o destinatário
  methods ADD_RECIPIENT .
    "! envia o email
  methods SEND_EMAIL .
    "! Salva na tabela Z
  methods SAVE .
    "! adiociona email
  methods ADD_EMAIL
    importing
      !IV_EMAIL type AD_SMTPADR .
ENDCLASS.



CLASS ZCLSD_VERIFICA_ATRASOS IMPLEMENTATION.


  METHOD add_email.

    TRY.

        DATA(lo_destinatarios) = cl_cam_address_bcs=>create_internet_address( iv_email ).

        go_send_request->add_recipient( i_recipient = lo_destinatarios
                                        i_express   = abap_true ).

      CATCH cx_address_bcs INTO DATA(lo_address).

          APPEND VALUE bapiret2( id = 'ZSD_CICLO_PEDIDO' number = 000 type = 'E' message_v1 = lo_address->get_text( ) ) TO gt_return.

      CATCH cx_send_req_bcs INTO DATA(lo_bcs).

          APPEND VALUE bapiret2( id = 'ZSD_CICLO_PEDIDO' number = 000 type = 'E' message_v1 = lo_bcs->get_text( ) ) TO gt_return.

    ENDTRY.

  ENDMETHOD.


  METHOD add_recipient.

    SORT gt_users BY objct.

    LOOP AT gr_obj_auth ASSIGNING FIELD-SYMBOL(<fs_obj>).

      CASE <fs_obj>-low.
        WHEN 'ZAPROVCOM'.

          IF gt_aprvcomercial[] IS NOT INITIAL.
            READ TABLE gt_users TRANSPORTING NO FIELDS WITH KEY objct = <fs_obj>-low BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              LOOP AT gt_users ASSIGNING FIELD-SYMBOL(<fs_destinatarios>) FROM sy-tabix.
                IF <fs_destinatarios>-objct <> <fs_obj>-low.
                  EXIT.
                ENDIF.
                add_email( <fs_destinatarios>-smtp_addr ).
              ENDLOOP.
            ENDIF.
          ENDIF.

        WHEN 'ZAPROVCRED'.

          IF gt_aprvcredito[] IS NOT INITIAL.
            READ TABLE gt_users TRANSPORTING NO FIELDS WITH KEY objct = <fs_obj>-low BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              LOOP AT gt_users ASSIGNING <fs_destinatarios> FROM sy-tabix.
                IF <fs_destinatarios>-objct <> <fs_obj>-low.
                  EXIT.
                ENDIF.
                add_email( <fs_destinatarios>-smtp_addr ).
              ENDLOOP.
            ENDIF.
          ENDIF.

        WHEN 'ZCRIAORFRE'.
          IF gt_ordemfrete[] IS NOT INITIAL.
            READ TABLE gt_users TRANSPORTING NO FIELDS WITH KEY objct = <fs_obj>-low BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              LOOP AT gt_users ASSIGNING <fs_destinatarios> FROM sy-tabix.
                IF <fs_destinatarios>-objct <> <fs_obj>-low.
                  EXIT.
                ENDIF.
                add_email( <fs_destinatarios>-smtp_addr ).
              ENDLOOP.
            ENDIF.
          ENDIF.
        WHEN 'ZENTREGA'.
          IF gt_entrega[] IS NOT INITIAL.
            READ TABLE gt_users TRANSPORTING NO FIELDS WITH KEY objct = <fs_obj>-low BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              LOOP AT gt_users ASSIGNING <fs_destinatarios> FROM sy-tabix.
                IF <fs_destinatarios>-objct <> <fs_obj>-low.
                  EXIT.
                ENDIF.
                add_email( <fs_destinatarios>-smtp_addr ).
              ENDLOOP.
            ENDIF.
          ENDIF.
        WHEN 'ZENVROTEIR'.
          IF gt_entrega[] IS NOT INITIAL.
            READ TABLE gt_users TRANSPORTING NO FIELDS WITH KEY objct = <fs_obj>-low BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              LOOP AT gt_users ASSIGNING <fs_destinatarios> FROM sy-tabix.
                IF <fs_destinatarios>-objct <> <fs_obj>-low.
                  EXIT.
                ENDIF.
                add_email( <fs_destinatarios>-smtp_addr ).
              ENDLOOP.
            ENDIF.
          ENDIF.
        WHEN 'ZFATURAMEN'.
          IF gt_faturamento[] IS NOT INITIAL.
            READ TABLE gt_users TRANSPORTING NO FIELDS WITH KEY objct = <fs_obj>-low BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              LOOP AT gt_users ASSIGNING <fs_destinatarios> FROM sy-tabix.
                IF <fs_destinatarios>-objct <> <fs_obj>-low.
                  EXIT.
                ENDIF.
                add_email( <fs_destinatarios>-smtp_addr ).
              ENDLOOP.
            ENDIF.
          ENDIF.
        WHEN 'ZSAIDVEICU'.
          IF gt_saidaveic[] IS NOT INITIAL.
            READ TABLE gt_users TRANSPORTING NO FIELDS WITH KEY objct = <fs_obj>-low BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              LOOP AT gt_users ASSIGNING <fs_destinatarios> FROM sy-tabix.
                IF <fs_destinatarios>-objct <> <fs_obj>-low.
                  EXIT.
                ENDIF.
                add_email( <fs_destinatarios>-smtp_addr ).
              ENDLOOP.
            ENDIF.
          ENDIF.
        WHEN 'ZGERAREMES'.
          IF gt_geracaorem[] IS NOT INITIAL.
            READ TABLE gt_users TRANSPORTING NO FIELDS WITH KEY objct = <fs_obj>-low BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              LOOP AT gt_users ASSIGNING <fs_destinatarios> FROM sy-tabix.
                IF <fs_destinatarios>-objct <> <fs_obj>-low.
                  EXIT.
                ENDIF.
                add_email( <fs_destinatarios>-smtp_addr ).
              ENDLOOP.
            ENDIF.
          ENDIF.
        WHEN 'ZSINCRON'.
          IF gt_sincrono[] IS NOT INITIAL.
            READ TABLE gt_users TRANSPORTING NO FIELDS WITH KEY objct = <fs_obj>-low BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              LOOP AT gt_users ASSIGNING <fs_destinatarios> FROM sy-tabix.
                IF <fs_destinatarios>-objct <> <fs_obj>-low.
                  EXIT.
                ENDIF.
                add_email( <fs_destinatarios>-smtp_addr ).
              ENDLOOP.
            ENDIF.
          ENDIF.
        WHEN 'ZSLA_EXTER'.
          IF gt_slaexterno[] IS NOT INITIAL.
            READ TABLE gt_users TRANSPORTING NO FIELDS WITH KEY objct = <fs_obj>-low BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              LOOP AT gt_users ASSIGNING <fs_destinatarios> FROM sy-tabix.
                IF <fs_destinatarios>-objct <> <fs_obj>-low.
                  EXIT.
                ENDIF.
                add_email( <fs_destinatarios>-smtp_addr ).
              ENDLOOP.
            ENDIF.
          ENDIF.
        WHEN 'ZSLA_GERAL'.
          IF gt_slageral[] IS NOT INITIAL.
            READ TABLE gt_users TRANSPORTING NO FIELDS WITH KEY objct = <fs_obj>-low BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              LOOP AT gt_users ASSIGNING <fs_destinatarios> FROM sy-tabix.
                IF <fs_destinatarios>-objct <> <fs_obj>-low.
                  EXIT.
                ENDIF.
                add_email( <fs_destinatarios>-smtp_addr ).
              ENDLOOP.
            ENDIF.
          ENDIF.
        WHEN 'ZSLA_INTER'.
          IF gt_slainterno[] IS NOT INITIAL.
            READ TABLE gt_users TRANSPORTING NO FIELDS WITH KEY objct = <fs_obj>-low BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              LOOP AT gt_users ASSIGNING <fs_destinatarios> FROM sy-tabix.
                IF <fs_destinatarios>-objct <> <fs_obj>-low.
                  EXIT.
                ENDIF.
                add_email( <fs_destinatarios>-smtp_addr ).
              ENDLOOP.
            ENDIF.
          ENDIF.
        WHEN 'ZESTOQUE'.
          IF gt_estoque[] IS NOT INITIAL.
            READ TABLE gt_users TRANSPORTING NO FIELDS WITH KEY objct = <fs_obj>-low BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              LOOP AT gt_users ASSIGNING <fs_destinatarios> FROM sy-tabix.
                IF <fs_destinatarios>-objct <> <fs_obj>-low.
                  EXIT.
                ENDIF.
                add_email( <fs_destinatarios>-smtp_addr ).
              ENDLOOP.
            ENDIF.
          ENDIF.
        WHEN 'ZAPROVNFE'.
          IF gt_aprovnfe[] IS NOT INITIAL.
            READ TABLE gt_users TRANSPORTING NO FIELDS WITH KEY objct = <fs_obj>-low BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              LOOP AT gt_users ASSIGNING <fs_destinatarios> FROM sy-tabix.
                IF <fs_destinatarios>-objct <> <fs_obj>-low.
                  EXIT.
                ENDIF.
                add_email( <fs_destinatarios>-smtp_addr ).
              ENDLOOP.
            ENDIF.
          ENDIF.
        WHEN 'ZIMPRESNFE'.
          IF gt_impressaonfe[] IS NOT INITIAL.
            READ TABLE gt_users TRANSPORTING NO FIELDS WITH KEY objct = <fs_obj>-low BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              LOOP AT gt_users ASSIGNING <fs_destinatarios> FROM sy-tabix.
                IF <fs_destinatarios>-objct <> <fs_obj>-low.
                  EXIT.
                ENDIF.
                add_email( <fs_destinatarios>-smtp_addr ).
              ENDLOOP.
            ENDIF.
          ENDIF.
        WHEN 'ZPRESCONTA'.
          IF gt_prestaconta[] IS NOT INITIAL.
            READ TABLE gt_users TRANSPORTING NO FIELDS WITH KEY objct = <fs_obj>-low BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              LOOP AT gt_users ASSIGNING <fs_destinatarios> FROM sy-tabix.
                IF <fs_destinatarios>-objct <> <fs_obj>-low.
                  EXIT.
                ENDIF.
                add_email( <fs_destinatarios>-smtp_addr ).
              ENDLOOP.
            ENDIF.
          ENDIF.
        WHEN 'ZCARREGAME'.
          IF gt_carregamento[] IS NOT INITIAL.
            READ TABLE gt_users TRANSPORTING NO FIELDS WITH KEY objct = <fs_obj>-low BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              LOOP AT gt_users ASSIGNING <fs_destinatarios> FROM sy-tabix.
                IF <fs_destinatarios>-objct <> <fs_obj>-low.
                  EXIT.
                ENDIF.
                add_email( <fs_destinatarios>-smtp_addr ).
              ENDLOOP.
            ENDIF.
          ENDIF.
        WHEN OTHERS.
      ENDCASE.

    ENDLOOP.

  ENDMETHOD.


  METHOD create_email.

    DATA: lv_subject TYPE SO_OBJ_DES.

    lv_subject = TEXT-001 .

    TRY.

        go_document = cl_document_bcs=>create_document( i_type    = 'RAW'
                                                        i_text    = gt_text
                                                        i_subject = lv_subject ).

      CATCH cx_document_bcs INTO DATA(lo_bcs).

         APPEND VALUE bapiret2( id = 'ZSD_CICLO_PEDIDO' number = 000 type = 'E' message_v1 = lo_bcs->get_text( ) ) to gt_return.

    ENDTRY.

  ENDMETHOD.


  METHOD create_send_request.

    TRY.

        go_send_request = cl_bcs=>create_persistent( ).
        go_send_request->set_document( go_document ).

      CATCH cx_send_req_bcs INTO DATA(lo_bcs).

        APPEND VALUE bapiret2( id = 'ZSD_CICLO_PEDIDO' number = 000 type = 'E' message_v1 = lo_bcs->get_text( ) ) TO gt_return.

    ENDTRY.

  ENDMETHOD.


  METHOD execute.

    set_global( EXPORTING ir_datadoc      = ir_datadoc
                          iv_medicao      = iv_medicao
                          iv_ordem_venda  = iv_ordem_venda
                          iv_centro       = iv_centro     ).

    IF get_data( ) = abap_true.
      get_ordens_medicao( ).
      get_user( ).
      prepare_email( ).
      IF gv_erro IS INITIAL.
        send_email(  ).
        save( ).
      ENDIF.
    ENDIF.

    rt_return[] = gt_return[].

  ENDMETHOD.


  METHOD get_data.

    DATA: lv_where TYPE string.

    IF gr_datadoc[] IS NOT INITIAL.
      lv_where = |{ text-002 }|.
    ENDIF.

    IF gv_ordem_venda IS NOT INITIAL.
      IF lv_where IS INITIAL.
        lv_where = |{ text-003 }|.
      ELSE.
        lv_where = |{ lv_where } { text-004 }|.
      ENDIF.
    ENDIF.

    IF gv_centro IS NOT INITIAL.
      IF lv_where IS INITIAL.
        lv_where = |{ text-005 }|.
      ELSE.
        lv_where = |{ lv_where } { text-006 }|.
      ENDIF.
    ENDIF.

    SELECT *
      INTO TABLE @gt_medicao
      FROM zi_sd_clico_pedido
      WHERE (lv_where).

    IF sy-subrc IS INITIAL.
      SORT gt_medicao BY salesorder salesorderdate.

      rv_return = abap_true.
    ELSE.

      APPEND VALUE bapiret2( id = 'ZSD_CICLO_PEDIDO' number = 002 type = 'E' ) TO gt_return.

    ENDIF.

  ENDMETHOD.


  METHOD get_email_text.

    DATA: lt_lines TYPE TABLE OF tline.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = 'ST'
        language                = sy-langu
        name                    = 'ZEMAIL_JUSTIF_ATRASO'
        object                  = 'TEXT'
      TABLES
        lines                   = lt_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc = 0.

      LOOP AT lt_lines ASSIGNING FIELD-SYMBOL(<fs_line>).
        APPEND <fs_line>-tdline TO gt_text.
      ENDLOOP.

    ELSE.
        APPEND VALUE bapiret2( id = 'ZSD_CICLO_PEDIDO' number = 001 type = 'E' ) TO gt_return.
        gv_erro = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD get_obj_auth.

    CASE gv_medicao.
      WHEN '001'.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = 'ZSINCRON'   )   TO gr_obj_auth.
      WHEN '002'.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = 'ZAPROVCOM'  )  TO gr_obj_auth.
      WHEN '003'.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = 'ZAPROVCRED' ) TO gr_obj_auth.
      WHEN '004'.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = 'ZENVROTEIR' ) TO gr_obj_auth.
      WHEN '005'.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = 'ZCRIAORFRE' ) TO gr_obj_auth.
      WHEN '006'.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = 'ZFATURAMEN' ) TO gr_obj_auth.
      WHEN '007'.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = 'ZSAIDVEICU' ) TO gr_obj_auth.
      WHEN '008'.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = 'ZENTREGA'   )   TO gr_obj_auth.
      WHEN '009'.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = 'ZSLA_EXTER' ) TO gr_obj_auth.
      WHEN '010'.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = 'ZSLA_INTER' ) TO gr_obj_auth.
      WHEN '011'.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = 'ZSLA_GERAL' ) TO gr_obj_auth.
      WHEN '012'.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = 'ZGERAREMES' ) TO gr_obj_auth.
      WHEN '013'.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = 'ZESTOQUE'   ) TO gr_obj_auth.
      WHEN '014'.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = 'ZAPROVNFE'  ) TO gr_obj_auth.
      WHEN '015'.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = 'ZIMPRESNFE' ) TO gr_obj_auth.
      WHEN '016'.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = 'ZPRESCONTA' ) TO gr_obj_auth.
      WHEN '017'.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = 'ZCARREGAME' ) TO gr_obj_auth.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD get_ordens_medicao.

    CASE gv_medicao.
      WHEN '001'.
        gt_sincrono = VALUE #( FOR ls_medicao IN gt_medicao
                            WHERE ( statussincronismo = TEXT-007 )
                            ( ordem_venda      = ls_medicao-salesorder
                              centro           = ls_medicao-plant
                              medicao          = gv_medicao
                              data_planejada   = ls_medicao-dataplanejadasincronismo ) ).

        APPEND LINES OF gt_sincrono TO gt_ordens.
      WHEN '002'.
        gt_aprvcomercial = VALUE #( FOR ls_medicao IN gt_medicao
                                WHERE ( statusaprvcomercial = TEXT-007 )
                                ( ordem_venda      = ls_medicao-salesorder
                                  centro           = ls_medicao-plant
                                  medicao          = gv_medicao
                                  data_planejada   = ls_medicao-dataplanejadaaprovcomercial ) ).

        APPEND LINES OF gt_aprvcomercial TO gt_ordens.
      WHEN '003'.
        gt_aprvcredito = VALUE #( FOR ls_medicao IN gt_medicao
                                WHERE ( statusaprvcredito = TEXT-007 )
                                ( ordem_venda      = ls_medicao-salesorder
                                  centro           = ls_medicao-plant
                                  medicao          = gv_medicao
                                  data_planejada   = ls_medicao-dataplanejadaaprovcredito ) ).

        APPEND LINES OF gt_aprvcredito TO gt_ordens.
      WHEN '004'.
        gt_envioremessa = VALUE #( FOR ls_medicao IN gt_medicao
                                WHERE ( statusenvioremessa = TEXT-007 )
                                ( ordem_venda      = ls_medicao-salesorder
                                  centro           = ls_medicao-plant
                                  medicao          = gv_medicao
                                  data_planejada   = ls_medicao-dataplanejadaenvioderemessa ) ).

        APPEND LINES OF gt_envioremessa TO gt_ordens.
      WHEN '005'.
        gt_ordemfrete = VALUE #( FOR ls_medicao IN gt_medicao
                                WHERE ( statusordemfrete = TEXT-007 )
                                ( ordem_venda      = ls_medicao-salesorder
                                  centro           = ls_medicao-plant
                                  medicao          = gv_medicao
                                  data_planejada   = ls_medicao-dataplanejadaordemfrete ) ).

        APPEND LINES OF gt_ordemfrete TO gt_ordens.
      WHEN '006'.
        gt_faturamento = VALUE #( FOR ls_medicao IN gt_medicao
                                WHERE ( statusfaturamento = TEXT-007 )
                                ( ordem_venda      = ls_medicao-salesorder
                                  centro           = ls_medicao-plant
                                  medicao          = gv_medicao
                                  data_planejada   = ls_medicao-dataplanejadafaturamento ) ).

        APPEND LINES OF gt_faturamento TO gt_ordens.
      WHEN '007'.
        gt_saidaveic = VALUE #( FOR ls_medicao IN gt_medicao
                                WHERE ( statussaida = TEXT-007 )
                                ( ordem_venda      = ls_medicao-salesorder
                                  centro           = ls_medicao-plant
                                  medicao          = gv_medicao
                                  data_planejada   = ls_medicao-dataplanejadasaida ) ).

        APPEND LINES OF gt_saidaveic TO gt_ordens.
      WHEN '008'.
        gt_entrega = VALUE #( FOR ls_medicao IN gt_medicao
                                WHERE ( statusentrega = TEXT-007 )
                                ( ordem_venda      = ls_medicao-salesorder
                                  centro           = ls_medicao-plant
                                  medicao          = gv_medicao
                                  data_planejada   = ls_medicao-dataplanejadaentrega ) ).

        APPEND LINES OF gt_entrega TO gt_ordens.
      WHEN '009'.
        gt_slaexterno = VALUE #( FOR ls_medicao IN gt_medicao
                                WHERE ( statuscicloexterno = TEXT-007 )
                                ( ordem_venda      = ls_medicao-salesorder
                                  centro           = ls_medicao-plant
                                  medicao          = gv_medicao
                                  data_planejada   = ls_medicao-dataplanejadacicloexterno ) ).

        APPEND LINES OF gt_slaexterno TO gt_ordens.
      WHEN '010'.
        gt_slainterno = VALUE #( FOR ls_medicao IN gt_medicao
                                WHERE ( statusciclointerno = TEXT-007 )
                                ( ordem_venda      = ls_medicao-salesorder
                                  centro           = ls_medicao-plant
                                  medicao          = gv_medicao
                                  data_planejada   = ls_medicao-dataplanejadaciclointerno ) ).

        APPEND LINES OF gt_slainterno TO gt_ordens.
      WHEN '011'.
        gt_slageral = VALUE #( FOR ls_medicao IN gt_medicao
                                WHERE ( statuscicloglobal = TEXT-007 )
                                ( ordem_venda      = ls_medicao-salesorder
                                  centro           = ls_medicao-plant
                                  medicao          = gv_medicao
                                  data_planejada   = ls_medicao-dataplanejadaciclototal ) ).

        APPEND LINES OF gt_slageral TO gt_ordens.
      WHEN '012'.
        gt_geracaorem = VALUE #( FOR ls_medicao IN gt_medicao
                                WHERE ( statusgeracaoremessa = TEXT-007 )
                                ( ordem_venda      = ls_medicao-salesorder
                                  centro           = ls_medicao-plant
                                  medicao          = gv_medicao
                                  data_planejada   = ls_medicao-dataplanejadageracaoremessa ) ).

        APPEND LINES OF gt_geracaorem TO gt_ordens.
      WHEN '013'.
*    gt_estoque = VALUE #( FOR ls_medicao IN gt_medicao
*                            WHERE ( statusestoque = text-007 )
*                            ( ordem_venda      = ls_medicao-salesorder
*                              centro           = ls_medicao-plant
*                              medicao          = gv_medicao
*                              data_planejada   = ls_medicao-?????? ) ).

        APPEND LINES OF gt_estoque TO gt_ordens.
      WHEN '014'.
        gt_aprovnfe = VALUE #( FOR ls_medicao IN gt_medicao
                                WHERE ( statusaprovacaonfe = TEXT-007 )
                                ( ordem_venda      = ls_medicao-salesorder
                                  centro           = ls_medicao-plant
                                  medicao          = gv_medicao
                                  data_planejada   = ls_medicao-dataplanejadaaprovacaonfe ) ).
        APPEND LINES OF gt_aprovnfe TO gt_ordens.
      WHEN '015'.
        gt_impressaonfe = VALUE #( FOR ls_medicao IN gt_medicao
                                WHERE ( statusimpressaonfe = TEXT-007 )
                                ( ordem_venda      = ls_medicao-salesorder
                                  centro           = ls_medicao-plant
                                  medicao          = gv_medicao
                                  data_planejada   = ls_medicao-dataplanejadaimpressaonfe ) ).

        APPEND LINES OF gt_impressaonfe TO gt_ordens.
      WHEN '016'.
        gt_prestaconta = VALUE #( FOR ls_medicao IN gt_medicao
                                WHERE ( statusprestacaocontas = TEXT-007 )
                                ( ordem_venda      = ls_medicao-salesorder
                                  centro           = ls_medicao-plant
                                  medicao          = gv_medicao
                                  data_planejada   = ls_medicao-dataplanejadapretacaodecontas ) ).

        APPEND LINES OF gt_prestaconta TO gt_ordens.
      WHEN '017'.
        gt_carregamento = VALUE #( FOR ls_medicao IN gt_medicao
                                WHERE ( statuscarregamento = TEXT-007 )
                                ( ordem_venda      = ls_medicao-salesorder
                                  centro           = ls_medicao-plant
                                  medicao          = gv_medicao
                                  data_planejada   = ls_medicao-dataplanejadacarregamento ) ).

        APPEND LINES OF gt_carregamento TO gt_ordens.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD get_user.

    get_obj_auth( ).

    SELECT a~bname
           a~objct
           c~smtp_addr
      INTO TABLE gt_users
      FROM usrbf2 AS a
      INNER JOIN usr21 AS b ON b~bname = a~bname
      INNER JOIN adr6 AS c  ON c~addrnumber = b~addrnumber
                           AND c~persnumber = b~persnumber
      WHERE objct IN gr_obj_auth[].
    IF sy-subrc IS INITIAL.
      SORT gt_users BY objct.
    ENDIF.

  ENDMETHOD.


  METHOD prepare_email.

    get_email_text( ).
    create_email( ).
    create_send_request( ).
    set_sender(  ).
    add_recipient(  ).

  ENDMETHOD.


  METHOD save.

    IF gt_ordens[] IS NOT INITIAL.
      MODIFY ztsd_atraso_just FROM TABLE gt_ordens.
      IF sy-subrc IS INITIAL.
        COMMIT WORK AND WAIT.
        APPEND VALUE bapiret2( id = 'ZSD_CICLO_PEDIDO' number = 004 type = 'S' ) TO gt_return.
      ELSE.
        APPEND VALUE bapiret2( id = 'ZSD_CICLO_PEDIDO' number = 003 type = 'E' ) TO gt_return.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD send_email.

    TRY.

        go_send_request->send( abap_true ).

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' DESTINATION 'NONE'
          EXPORTING
            wait = abap_true.

*        gv_success = abap_true.

        APPEND VALUE bapiret2( id = 'ZSD_CICLO_PEDIDO' number = 005 type = 'E' ) TO gt_return.

      CATCH cx_send_req_bcs INTO DATA(lo_bcs).

        APPEND VALUE bapiret2( id = 'ZSD_CICLO_PEDIDO' number = 000 type = 'E' message_v1 = lo_bcs->get_text( ) ) to gt_return.

    ENDTRY.

  ENDMETHOD.


  METHOD set_global.

    gr_datadoc       = ir_datadoc.
    gv_medicao       = iv_medicao.
    gv_ordem_venda   = iv_ordem_venda.
    gv_centro        = iv_centro.

  ENDMETHOD.


  METHOD set_sender.

    TRY.

        DATA(lo_sender) = cl_sapuser_bcs=>create( sy-uname ).

        go_send_request->set_sender( lo_sender ).

      CATCH cx_address_bcs INTO DATA(lo_address).

         APPEND VALUE bapiret2( id = 'ZSD_CICLO_PEDIDO' number = 000 type = 'E' message_v1 = lo_address->get_text( ) ) to gt_return.

      CATCH cx_send_req_bcs INTO DATA(lo_bcs).

         APPEND VALUE bapiret2( id = 'ZSD_CICLO_PEDIDO' number = 000 type = 'E' message_v1 = lo_bcs->get_text( ) ) to gt_return.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
