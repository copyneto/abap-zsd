CLASS zclsd_cockpit_agenda_events DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: ty_agenda   TYPE ztsd_agenda001,
           ty_t_agenda TYPE STANDARD TABLE OF ty_agenda.

    "! Recupera arquivo layout
    "! @parameter ev_file | Arquivo em binário
    "! @parameter ev_filename | Nome do arquivo
    "! @parameter ev_mimetype | Extensão do arquivo
    "! @parameter et_return | Mensagens de retorno
    METHODS get_layout
      EXPORTING
        ev_file     TYPE xstring
        ev_filename TYPE string
        ev_mimetype TYPE string
        et_return   TYPE bapiret2_t.

    "! Realiza carga de arquivo
    "! @parameter iv_file | Arquivo em binário
    "! @parameter iv_filename | Nome do arquivo
    "! @parameter et_return | Mensagens de retorno
    METHODS upload_file
      IMPORTING iv_file     TYPE xstring
                iv_filename TYPE string
      EXPORTING et_agenda   TYPE ty_t_agenda
                et_return   TYPE bapiret2_t.

    "! Valida arquivo de carga
    "! @parameter it_file | Arquivo de carga
    "! @parameter et_agenda | Dados de agendamento Pallet
    "! @parameter et_return | Mensagens de retorno
    METHODS validate_file
      IMPORTING
        it_file   TYPE zctgsd_agenda_pallet
      EXPORTING
        et_agenda TYPE ty_t_agenda
        et_return TYPE bapiret2_t.

    "! Salva dados de carga
    "! @parameter it_agenda | Dados de agendamento Pallet
    "! @parameter et_return | Mensagens de retorno
    METHODS save_file
      IMPORTING it_agenda TYPE ty_t_agenda
      EXPORTING et_return TYPE bapiret2_t.

  PROTECTED SECTION.

  PRIVATE SECTION.

    "! Recupera próximo número GUID
    "! @parameter ev_guid | Número GUID
    "! @parameter et_return | Mensagens de retorno
    "! @parameter rv_guid | Número GUID
    METHODS get_next_guid
      EXPORTING ev_guid        TYPE sysuuid_x16
                et_return      TYPE bapiret2_t
      RETURNING VALUE(rv_guid) TYPE sysuuid_x16 .

    "! Formata as mensages de retorno
    "! @parameter ct_return | Mensagens de retorno
    METHODS format_return
      CHANGING
        !ct_return TYPE bapiret2_t.

ENDCLASS.



CLASS zclsd_cockpit_agenda_events IMPLEMENTATION.


  METHOD get_layout.

    DATA: lt_file      TYPE zctgsd_agenda_pallet,
          lv_extension TYPE char10,
          lv_mimetype  TYPE w3conttype.

    FREE: ev_file, ev_filename, ev_mimetype, et_return.

* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZPALET_LAY' FOR USER sy-uname
      ID 'ACTVT' FIELD '01'.    "Criar

    IF sy-subrc IS INITIAL.
* ----------------------------------------------------------------------
* Define nome do arquivo
* ----------------------------------------------------------------------
      ev_filename = 'layout_agenda_pallet.xlsx'.

      DATA(lo_excel) = NEW zclca_excel( iv_filename = ev_filename ).

* ----------------------------------------------------------------------
* Cria excel utilizando os campos da tabela informada
* ----------------------------------------------------------------------
      lo_excel->create_document( EXPORTING it_table  = lt_file
                                 IMPORTING ev_file   = ev_file
                                           et_return = et_return ).

      me->format_return( CHANGING ct_return = et_return ).

* ----------------------------------------------------------------------
* Recupera Mimetype
* ----------------------------------------------------------------------
      SPLIT ev_filename AT '.' INTO DATA(lv_name) lv_extension.

      CALL FUNCTION 'SDOK_MIMETYPE_GET'
        EXPORTING
          extension = lv_extension
        IMPORTING
          mimetype  = lv_mimetype.

      ev_mimetype = lv_mimetype.

    ELSE.

      et_return = VALUE #( (     type     = 'E'
                                 id       = 'ZSD_CKPT_AGENDAMENTO'
                                 number   = '017'  ) ).


      me->format_return( CHANGING ct_return = et_return ).

      RETURN.

    ENDIF.

  ENDMETHOD.


  METHOD upload_file.

    DATA: lt_file   TYPE zctgsd_agenda_pallet.

    FREE: et_return, et_agenda.

* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZPALET_ARQ' FOR USER sy-uname
      ID 'ACTVT' FIELD '01'.    "Criar

    IF sy-subrc IS INITIAL.
* ---------------------------------------------------------------------------
* Converte arquivo excel para tabela
* ---------------------------------------------------------------------------
      DATA(lo_excel) = NEW zclca_excel( iv_filename = iv_filename
                                        iv_file     = iv_file ).

      lo_excel->get_sheet( IMPORTING et_return = et_return
                           CHANGING  ct_table  = lt_file[] ).

      IF line_exists( et_return[ type = 'E' ] ).         "#EC CI_STDSEQ
        me->format_return( CHANGING ct_return = et_return ).
        RETURN.
      ENDIF.

* ---------------------------------------------------------------------------
* Prepara dados para salvar
* ---------------------------------------------------------------------------
      me->validate_file( EXPORTING it_file   = lt_file[]
                         IMPORTING et_agenda = et_agenda
                                   et_return = et_return ).

      IF line_exists( et_return[ type = 'E' ] ).         "#EC CI_STDSEQ
        me->format_return( CHANGING ct_return = et_return ).
*      RETURN.
      ENDIF.

* ---------------------------------------------------------------------------
* Salvar dados
* ---------------------------------------------------------------------------
      me->save_file( EXPORTING it_agenda = et_agenda
                     IMPORTING et_return = et_return ).

      IF line_exists( et_return[ type = 'E' ] ).         "#EC CI_STDSEQ
        RETURN.
      ENDIF.

    ELSE.

      et_return = VALUE #( (     type     = 'E'
                                 id       = 'ZSD_CKPT_AGENDAMENTO'
                                 number   = '017'  ) ).

      me->format_return( CHANGING ct_return = et_return ).

      RETURN.

    ENDIF.
  ENDMETHOD.


  METHOD validate_file.

    DATA: lt_agenda    TYPE SORTED TABLE OF ztsd_agenda001
                        WITH NON-UNIQUE KEY material lastro altura,
          lv_timestamp TYPE timestampl.

    FREE: et_agenda.

* ---------------------------------------------------------------------------
* Recupera material
* ---------------------------------------------------------------------------
    DATA(lt_file_key) = it_file[].
    SORT lt_file_key BY material.
    DELETE ADJACENT DUPLICATES FROM lt_file_key COMPARING material.

    IF lt_file_key[] IS NOT INITIAL.

      SELECT material,
             text
          FROM zi_ca_vh_material
          FOR ALL ENTRIES IN @lt_file_key
          WHERE material EQ @lt_file_key-material
          INTO TABLE @DATA(lt_material).

      IF sy-subrc EQ 0.
        SORT lt_material BY material.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera cliente
* ---------------------------------------------------------------------------
    lt_file_key = it_file[].
    SORT lt_file_key BY cliente.
    DELETE ADJACENT DUPLICATES FROM lt_file_key COMPARING cliente.

    IF lt_file_key[] IS NOT INITIAL.

      SELECT kunnr     AS cliente,
             kunnrname AS nome
          FROM zi_ca_vh_kunnr
          FOR ALL ENTRIES IN @lt_file_key
          WHERE kunnr EQ @lt_file_key-cliente
          INTO TABLE @DATA(lt_cliente).

      IF sy-subrc EQ 0.
        SORT lt_cliente BY cliente.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera registros antigos
* ---------------------------------------------------------------------------
    DATA(lt_file_aux) = it_file[].
    SORT lt_file_aux BY material cliente.
    DELETE ADJACENT DUPLICATES FROM lt_file_aux COMPARING material cliente.

    IF lt_file_aux[] IS NOT INITIAL.

      SELECT *
          FROM ztsd_agenda001
          FOR ALL ENTRIES IN @lt_file_aux
          WHERE material  EQ @lt_file_aux-material
            AND cliente   EQ @lt_file_aux-cliente
          INTO TABLE @DATA(lt_agenda_aux).

      IF sy-subrc NE 0.
        FREE lt_agenda_aux.
      ENDIF.
    ENDIF.

    lt_file_key = it_file[].
    SORT lt_file_key BY material lastro altura cliente qtd_total unidade_de_medida_pallet.
    DELETE ADJACENT DUPLICATES FROM lt_file_key COMPARING material lastro altura cliente qtd_total unidade_de_medida_pallet.

    IF lt_file_key[] IS NOT INITIAL.

      SELECT *
          FROM ztsd_agenda001
          FOR ALL ENTRIES IN @lt_file_key
          WHERE material  EQ @lt_file_key-material
            AND lastro    EQ @lt_file_key-lastro
            AND altura    EQ @lt_file_key-altura
            AND cliente   EQ @lt_file_key-cliente
            AND qtd_total EQ @lt_file_key-qtd_total
            AND unidade_de_medida_pallet EQ @lt_file_key-unidade_de_medida_pallet
          INTO TABLE @lt_agenda.

      IF sy-subrc NE 0.
        FREE lt_agenda.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida campos do arquivo de carga
* ---------------------------------------------------------------------------
    GET TIME STAMP FIELD lv_timestamp.

    et_agenda = CORRESPONDING #( it_file ).

    LOOP AT et_agenda REFERENCE INTO DATA(ls_agenda).

      DATA(lv_index) = sy-tabix.

      READ TABLE lt_agenda_aux INTO DATA(ls_agend_aux) WITH  KEY material                 = ls_agenda->material
                                                                 cliente                  = ls_agenda->cliente.
      IF sy-subrc EQ 0.
        ls_agenda->guid = ls_agend_aux-guid.
        ls_agenda->last_changed_by            = sy-uname.
        ls_agenda->last_changed_at            = lv_timestamp.
        ls_agenda->local_last_changed_at      = lv_timestamp.
        ls_agenda->created_by                 = ls_agend_aux-created_by.
        ls_agenda->created_at                 = ls_agend_aux-created_at.
      ELSE.
        ls_agenda->guid                   = me->get_next_guid( IMPORTING et_return = et_return ).
        ls_agenda->created_by             = sy-uname.
        ls_agenda->created_at             = lv_timestamp.
        ls_agenda->local_last_changed_at  = lv_timestamp.
      ENDIF.

      " Verifica se registro já existe
      READ TABLE lt_agenda INTO DATA(ls_agend) WITH  KEY material                 = ls_agenda->material
                                                         lastro                   = ls_agenda->lastro
                                                         altura                   = ls_agenda->altura
                                                         cliente                  = ls_agenda->cliente
                                                         qtd_total                = ls_agenda->qtd_total
                                                         unidade_de_medida_pallet = ls_agenda->unidade_de_medida_pallet.
      IF sy-subrc EQ 0.
        " Linha &1: Registro duplicado.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_CKPT_AGENDAMENTO' number = '015'
                                                message_v1 = lv_index ) ).
        CONTINUE.
      ELSE.
        INSERT ls_agenda->* INTO TABLE lt_agenda[].
      ENDIF.


      "Valida material
      IF ls_agenda->material IS NOT INITIAL.
        READ TABLE lt_material INTO DATA(ls_material) WITH KEY material = ls_agenda->material
                                                               BINARY SEARCH.
        IF sy-subrc NE 0.
          " Linha &1: Material &2 não existe.
          et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_CKPT_AGENDAMENTO' number = '011'
                                                  message_v1 = lv_index
                                                  message_v2 = ls_agenda->material ) ).
          CLEAR ls_material.
        ENDIF.
      ENDIF.

      " Valida cliente
      IF ls_agenda->cliente IS NOT INITIAL.
        READ TABLE lt_cliente INTO DATA(ls_cliente) WITH KEY cliente = ls_agenda->cliente
                                                             BINARY SEARCH.
        IF sy-subrc NE 0.
          " Linha &1: Cliente &2 não existe.
          et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_CKPT_AGENDAMENTO' number = '012'
                                                  message_v1 = lv_index
                                                  message_v2 = ls_agenda->cliente ) ).
          CLEAR ls_cliente.
        ENDIF.
      ENDIF.

    ENDLOOP.

    me->format_return( CHANGING ct_return = et_return ).

  ENDMETHOD.


  METHOD save_file.

* ---------------------------------------------------------------------------
* Valida se arquivo está vazio
* ---------------------------------------------------------------------------
    IF it_agenda IS INITIAL.
      " Arquivo de carga vazio.
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_CKPT_AGENDAMENTO' number = '009' ) ).
      me->format_return( CHANGING ct_return = et_return ).
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Salva os dados
* ---------------------------------------------------------------------------
    IF it_agenda IS NOT INITIAL.
      MODIFY ztsd_agenda001 FROM TABLE it_agenda.

      IF sy-subrc NE 0.
        " Falha ao salvar arquivo de carga.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_CKPT_AGENDAMENTO' number = '010' ) ).
        me->format_return( CHANGING ct_return = et_return ).
        RETURN.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_next_guid.

    FREE: ev_guid, et_return.

    TRY.
        rv_guid = ev_guid = cl_system_uuid=>create_uuid_x16_static( ).

      CATCH cx_root INTO DATA(lo_root).
        DATA(lv_message) = CONV bapi_msg( lo_root->get_longtext( ) ).
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_CKPT_AGENDAMENTO' number = '000'
                                                message_v1 = lv_message+0(50)
                                                message_v2 = lv_message+50(50)
                                                message_v3 = lv_message+100(50)
                                                message_v4 = lv_message+150(50) ) ).

        me->format_return( CHANGING ct_return = et_return ).
        RETURN.
    ENDTRY.

  ENDMETHOD.


  METHOD format_return.

    DATA: ls_return_format TYPE bapiret2.
    CONSTANTS: lc_doub  TYPE c VALUE ':'.

* ---------------------------------------------------------------------------
* Format mensagens de retorno
* ---------------------------------------------------------------------------
    LOOP AT ct_return REFERENCE INTO DATA(ls_return).

      CHECK ls_return->message IS INITIAL.

      TRY.
          CALL FUNCTION 'FORMAT_MESSAGE'
            EXPORTING
              id        = ls_return->id
              lang      = sy-langu
              no        = ls_return->number
              v1        = ls_return->message_v1
              v2        = ls_return->message_v2
              v3        = ls_return->message_v3
              v4        = ls_return->message_v4
            IMPORTING
              msg       = ls_return->message
            EXCEPTIONS
              not_found = 1
              OTHERS    = 2.

          IF sy-subrc <> 0.
            CLEAR ls_return->message.
          ENDIF.

        CATCH cx_root INTO DATA(lo_root).
          DATA(lv_message) = lo_root->get_longtext( ).
      ENDTRY.

      SPLIT ls_return->message AT lc_doub INTO DATA(lv_linha) DATA(lv_texto).
      CONDENSE lv_linha.
      CONCATENATE lv_linha lv_texto INTO ls_return->message SEPARATED BY lc_doub.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
