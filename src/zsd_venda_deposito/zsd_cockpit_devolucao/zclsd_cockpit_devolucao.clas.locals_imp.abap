CLASS lcl_cockpit DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS desbloquearov FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~desbloquearov.

    METHODS eliminarprelancamento FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~eliminarprelancamento.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR cockpit RESULT result.


    METHODS criarlancamento FOR DETERMINE ON SAVE
      IMPORTING keys FOR cockpit~criarlancamento.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR cockpit RESULT result.

    METHODS authoritycreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR cockpit~authoritycreate.
    METHODS desbloquearremessa FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~desbloquearremessa.
*    METHODS verificasituacao FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR cockpit~verificasituacao.

    DATA gv_update_table TYPE abap_bool.

ENDCLASS.

CLASS lcl_cockpit IMPLEMENTATION.

  METHOD authoritycreate.

    CONSTANTS lc_area TYPE string VALUE 'VALIDATE_CREATE'.

    READ ENTITIES OF zi_sd_cockpit_devolucao IN LOCAL MODE
        ENTITY cockpit
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zclsd_auth_zsdwerks=>werks_create( <fs_data>-centro ) EQ abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-cockpit.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-cockpit.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create )
                        %element-centro = if_abap_behv=>mk-on )
          TO reported-cockpit.
      ENDIF.


    ENDLOOP.

  ENDMETHOD.

  METHOD get_authorizations.

    READ ENTITIES OF zi_sd_cockpit_devolucao IN LOCAL MODE
        ENTITY cockpit
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data)
        FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclsd_auth_zsdwerks=>werks_update( <fs_data>-centro ).
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      APPEND VALUE #( %tky    = <fs_data>-%tky
                      %update = lv_update )
             TO result.

    ENDLOOP.

  ENDMETHOD.

  METHOD desbloquearov.

* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZDEV_DESBL' FOR USER sy-uname
      ID 'ACTVT' FIELD '01'.    "Criar

    IF sy-subrc IS INITIAL.

* ---------------------------------------------------------------------------
* Recupera informações do cabeçalho
* ---------------------------------------------------------------------------
      READ ENTITIES OF zi_sd_cockpit_devolucao IN LOCAL MODE ENTITY cockpit
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(lt_cockpit).


* ---------------------------------------------------------------------------
* Desbloqueia OV Devolução
* ---------------------------------------------------------------------------

      DATA(lo_desbloqueio_ov) = NEW zclsd_desbloqueia_ov_devolucao( ).
      reported-cockpit = VALUE #( FOR ls_cockpit IN lt_cockpit
        FOR ls_mensagem IN lo_desbloqueio_ov->main( EXPORTING is_ov  = ls_cockpit-ordemdevolucao )
        ( %tky = VALUE #( guid = ls_cockpit-guid )
          %msg        =
            new_message(
              id       = ls_mensagem-id
              number   = ls_mensagem-number
              severity = CONV #( ls_mensagem-type )
              v1       = ls_mensagem-message_v1
              v2       = ls_mensagem-message_v2
              v3       = ls_mensagem-message_v3
              v4       = ls_mensagem-message_v4 )
      ) ).


    ELSE.

      APPEND VALUE #(

                               %msg       = new_message(
                                 id       = 'ZSD_COCKPIT_DEVOL'
                                 number   = '001'
                                 severity = CONV #( 'E' ) ) ) TO reported-cockpit.

    ENDIF.

  ENDMETHOD.

  METHOD eliminarprelancamento.

* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZDEV_LANC' FOR USER sy-uname
      ID 'ACTVT' FIELD '06'.    "Eliminar

    IF sy-subrc IS INITIAL.

* ---------------------------------------------------------------------------
* Recupera informações do cabeçalho
* ---------------------------------------------------------------------------
      READ ENTITIES OF zi_sd_cockpit_devolucao IN LOCAL MODE ENTITY cockpit
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(lt_cockpit).

* ---------------------------------------------------------------------------
* Elimina dados pré lançamento
* ---------------------------------------------------------------------------

      DATA(lo_lancamento) = NEW zclsd_cockpit_dev_lancamento(  ).
      reported-cockpit = VALUE #( FOR ls_cockpit IN lt_cockpit
        FOR ls_mensagem IN lo_lancamento->elimina_lancamento( EXPORTING is_cockpit  = CORRESPONDING #( ls_cockpit ) )
        ( %tky = VALUE #( guid = ls_cockpit-guid )
          %msg        =
            new_message(
              id       = ls_mensagem-id
              number   = ls_mensagem-number
              severity = CONV #( ls_mensagem-type )
              v1       = ls_mensagem-message_v1
              v2       = ls_mensagem-message_v2
              v3       = ls_mensagem-message_v3
              v4       = ls_mensagem-message_v4 )
      ) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------

      gv_update_table = abap_true.

    ELSE.

      APPEND VALUE #(

                               %msg       = new_message(
                                 id       = 'ZSD_COCKPIT_DEVOL'
                                 number   = '001'
                                 severity = CONV #( 'E' ) ) ) TO reported-cockpit.

    ENDIF.

  ENDMETHOD.

  METHOD get_features.

    DATA: lv_local TYPE char10.
    DATA ls_devolucao TYPE ztsd_devolucao.
* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_sd_cockpit_devolucao IN LOCAL MODE ENTITY cockpit
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit)
      FAILED failed.

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    result = VALUE #( FOR ls_cockpit IN lt_cockpit

                    ( %tky                      = ls_cockpit-%tky

                      %action-desbloquearov     = COND #( WHEN ls_cockpit-ordemdevolucao IS NOT INITIAL
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-desbloquearremessa = COND #( WHEN ls_cockpit-remessa IS NOT INITIAL
                                                           THEN if_abap_behv=>fc-o-enabled
                                                           ELSE if_abap_behv=>fc-o-disabled )

                      %action-eliminarprelancamento = COND #( WHEN ls_cockpit-ordemdevolucao IS INITIAL
                                                              THEN if_abap_behv=>fc-o-enabled
                                                              ELSE if_abap_behv=>fc-o-disabled )

                      ) ).

* ---------------------------------------------------------------------------
* Atualiza campo Situação
* ---------------------------------------------------------------------------

    IF lt_cockpit IS NOT INITIAL.
      SELECT *
      FROM ztsd_devolucao
      FOR ALL ENTRIES IN @lt_cockpit
      WHERE guid = @lt_cockpit-guid
      INTO TABLE @DATA(lt_devolucao).
      SORT lt_devolucao BY guid.

      SELECT salesdocument, purchaseorderbycustomer
      FROM i_salesdocument
      FOR ALL ENTRIES IN @lt_cockpit
      WHERE salesdocument = @lt_cockpit-ordemdevolucao
      INTO TABLE @DATA(lt_protocorrencia).
      SORT lt_protocorrencia BY salesdocument.

      IF lt_devolucao IS NOT INITIAL.

        LOOP AT lt_cockpit ASSIGNING FIELD-SYMBOL(<fs_cockpit>).


          READ TABLE lt_protocorrencia ASSIGNING FIELD-SYMBOL(<fs_protocorrencia>) WITH KEY salesdocument = <fs_cockpit>-ordemdevolucao BINARY SEARCH.
          IF sy-subrc EQ 0 AND <fs_cockpit>-protocorrencia EQ ' '.
            READ TABLE lt_devolucao ASSIGNING FIELD-SYMBOL(<fs_devolucao>) WITH KEY guid = <fs_cockpit>-guid BINARY SEARCH.
            IF <fs_devolucao> IS ASSIGNED.
              <fs_devolucao>-prot_ocorrencia = <fs_protocorrencia>-purchaseorderbycustomer.
            ENDIF.
          ENDIF.

          IF <fs_cockpit>-situacao NE '3' AND <fs_cockpit>-situacao NE '4'
         AND <fs_cockpit>-situacao NE '5' AND <fs_cockpit>-situacao NE '6'
         AND <fs_cockpit>-situacao NE <fs_cockpit>-codsituacao.

            READ TABLE lt_devolucao ASSIGNING <fs_devolucao> WITH KEY guid = <fs_cockpit>-guid BINARY SEARCH.
            IF <fs_devolucao> IS ASSIGNED.
              <fs_devolucao>-situacao = <fs_cockpit>-codsituacao.
            ENDIF.

          ELSE.
            READ TABLE lt_devolucao TRANSPORTING NO FIELDS WITH KEY guid = <fs_cockpit>-guid BINARY SEARCH.
            IF sy-subrc = 0 AND <fs_cockpit>-protocorrencia NE ' '.
              DELETE lt_devolucao INDEX sy-tabix.
            ENDIF.
          ENDIF.

        ENDLOOP.

        IF lt_devolucao IS NOT INITIAL.
          MODIFY ztsd_devolucao FROM TABLE lt_devolucao.

          MODIFY ENTITIES OF zi_sd_cockpit_devolucao IN LOCAL MODE
          ENTITY cockpit
          UPDATE FIELDS ( situacao protocorrencia )
          WITH VALUE #( FOR ls_dados IN lt_devolucao (
          %key-guid      = ls_dados-guid
          situacao       = ls_dados-situacao
          protocorrencia = ls_dados-prot_ocorrencia ) )
          REPORTED DATA(lt_reported).

        ENDIF.

      ENDIF.
    ENDIF.



*    DATA(lt_key) = keys[].
*    SORT lt_key BY guid.
*    READ TABLE keys ASSIGNING FIELD-SYMBOL(<fs_keys>) WITH KEY guid = ' ' BINARY SEARCH.
*    IF <fs_keys> IS ASSIGNED.
*
*      SELECT SINGLE *
*          FROM ztsd_devolucao
*          INTO ls_devolucao
*          WHERE guid = <fs_keys>-guid.
*      IF ls_devolucao  IS NOT INITIAL.
*        DELETE ztsd_devolucao FROM ls_devolucao.
*      ENDIF.
*
*    ENDIF.


  ENDMETHOD.

  METHOD criarlancamento.

* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZDEV_LANC' FOR USER sy-uname
      ID 'ACTVT' FIELD '01'.    "Criar

    IF sy-subrc IS INITIAL.

      DATA: lt_return_all TYPE bapiret2_t.

* ---------------------------------------------------------------------------
* Recupera informações do cabeçalho
* ---------------------------------------------------------------------------
      READ ENTITIES OF zi_sd_cockpit_devolucao IN LOCAL MODE ENTITY cockpit
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(lt_cockpit).

      TRY.
          DATA(ls_cockpit) = lt_cockpit[ 1 ].
        CATCH cx_root.
      ENDTRY.

      SELECT SINGLE chaveacesso, dataemissao
      FROM zi_sd_vh_chave_acesso_devol
      INTO @DATA(ls_dsdos_chaveacesso)
      WHERE chaveacesso = @ls_cockpit-chaveacesso.

      IF  ls_cockpit-dtrecebimento    <= ls_cockpit-dtadministrativo
      AND ls_cockpit-dtrecebimento    >= ls_dsdos_chaveacesso-dataemissao
      AND ls_cockpit-dtadministrativo >= ls_cockpit-dtrecebimento
      AND ls_cockpit-dtrecebimento    <= sy-datum
      AND ls_cockpit-dtadministrativo <= sy-datum.
* ---------------------------------------------------------------------------
* Cria dados pré lançamento automático
* ---------------------------------------------------------------------------
        IF ls_dsdos_chaveacesso-chaveacesso IS NOT INITIAL.
          DATA(lo_lancamento) = NEW zclsd_cockpit_dev_lancamento(  ).
          DATA(lt_mensagem) = lo_lancamento->determina_lancamento( CHANGING cs_cockpit = ls_cockpit ).

          reported-cockpit = VALUE #( FOR ls_mensagem IN lt_mensagem
                             ( %tky = VALUE #( guid = ls_cockpit-guid )
                               %msg = new_message( id       = ls_mensagem-id
                                                   number   = ls_mensagem-number
                                                   severity = CONV #( ls_mensagem-type )
                                                   v1       = ls_mensagem-message_v1
                                                   v2       = ls_mensagem-message_v2
                                                   v3       = ls_mensagem-message_v3
                                                   v4       = ls_mensagem-message_v4 ) ) ).

          MODIFY ENTITIES OF zi_sd_cockpit_devolucao IN LOCAL MODE
              ENTITY cockpit
              UPDATE FIELDS ( localnegocio
                              regiao
                              ano
                              mes
                              modelo
                              digitoverific
                              nroaleatorio
                              cliente
                              nftotal
                              moedasd
                              transportadora
                              motorista
                              tipoexpedicao
                              placa
                              situacao
                              banco
                              agencia
                              conta
                              denomibanco
                              dtlancamento
                            )
              WITH VALUE #( FOR ls_dados IN lt_cockpit (
              %key = ls_dados-%key
              localnegocio    = ls_cockpit-localnegocio
              regiao          = ls_cockpit-regiao
              ano             = ls_cockpit-ano
              mes             = ls_cockpit-mes
              modelo          = ls_cockpit-modelo
              digitoverific   = ls_cockpit-digitoverific
              nroaleatorio    = ls_cockpit-nroaleatorio
              cliente         = ls_cockpit-cliente
              nftotal         = ls_cockpit-nftotal
              moedasd         = ls_cockpit-moedasd
              transportadora  = ls_cockpit-transportadora
              motorista       = ls_cockpit-motorista
              tipoexpedicao   = ls_cockpit-tipoexpedicao
              placa           = ls_cockpit-placa
              situacao        = ls_cockpit-situacao
              banco           = ls_cockpit-banco
              agencia         = ls_cockpit-agencia
              conta           = ls_cockpit-conta
              denomibanco     = ls_cockpit-denomibanco
              dtlancamento    = ls_cockpit-dtlancamento
              ) )
              REPORTED DATA(lt_reported).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------

          gv_update_table = abap_true.
        ELSE.
          APPEND VALUE #(    %msg       = new_message(
                               id       = 'ZSD_COCKPIT_DEVOL'
                               number   = '024'
                               severity = CONV #( 'E' ) ) ) TO reported-cockpit.
        ENDIF.

      ELSE.

        IF ls_cockpit-dtrecebimento > sy-datum OR ls_cockpit-dtadministrativo > sy-datum.
          APPEND VALUE #(    %msg       = new_message(
                         id       = 'ZSD_COCKPIT_DEVOL'
                         number   = '030'
                         severity = CONV #( 'E' ) ) ) TO reported-cockpit.

        ELSEIF ls_cockpit-dtadministrativo < ls_cockpit-dtrecebimento.
          APPEND VALUE #(    %msg       = new_message(
                               id       = 'ZSD_COCKPIT_DEVOL'
                               number   = '029'
                               severity = CONV #( 'E' ) ) ) TO reported-cockpit.
        ELSE.
          APPEND VALUE #( %msg       = new_message(
                            id       = 'ZSD_COCKPIT_DEVOL'
                            number   = '028'
                            severity = CONV #( 'E' ) ) ) TO reported-cockpit.
        ENDIF.

      ENDIF.

    ELSE.

      APPEND VALUE #(

                               %msg       = new_message(
                                 id       = 'ZSD_COCKPIT_DEVOL'
                                 number   = '001'
                                 severity = CONV #( 'E' ) ) ) TO reported-cockpit.

    ENDIF.

  ENDMETHOD.

*  METHOD verificasituacao.
* ---------------------------------------------------------------------------
* Recupera informações do cabeçalho
* ---------------------------------------------------------------------------
*    READ ENTITIES OF zi_sd_cockpit_devolucao IN LOCAL MODE ENTITY cockpit
*        ALL FIELDS
*        WITH CORRESPONDING #( keys )
*        RESULT DATA(lt_cockpit).
*
*    TRY.
*        DATA(ls_cockpit) = lt_cockpit[ 1 ].
*
*        IF ls_cockpit-situacao NE '3' AND ls_cockpit-situacao NE '4' AND ls_cockpit-situacao NE '5' AND ls_cockpit-situacao NE '6'.
*          APPEND VALUE #(
*
*                         %msg       = new_message(
*                           id       = 'ZSD_COCKPIT_DEVOL'
*                           number   = '018'
*                           severity = CONV #( 'E' ) ) ) TO reported-cockpit.
*        ENDIF.
*      CATCH cx_root.
*    ENDTRY.
*
*
*  ENDMETHOD.

  METHOD desbloquearremessa.
* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZDEV_DESBL' FOR USER sy-uname
      ID 'ACTVT' FIELD '01'.    "Criar

    IF sy-subrc IS INITIAL.

* ---------------------------------------------------------------------------
* Recupera informações do cabeçalho
* ---------------------------------------------------------------------------
      READ ENTITIES OF zi_sd_cockpit_devolucao IN LOCAL MODE ENTITY cockpit
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(lt_cockpit).


* ---------------------------------------------------------------------------
* Desbloqueia OV Devolução
* ---------------------------------------------------------------------------

      DATA(lo_desbloqueio_remessa) = NEW zclsd_desbloqueia_ov_devolucao( ).
      reported-cockpit = VALUE #( FOR ls_cockpit IN lt_cockpit
        FOR ls_mensagem IN lo_desbloqueio_remessa->rmv_delivery_block( iv_vbeln = ls_cockpit-remessa )
        ( %tky = VALUE #( guid = ls_cockpit-guid )
          %msg        =
            new_message(
              id       = ls_mensagem-id
              number   = ls_mensagem-number
              severity = CONV #( ls_mensagem-type )
              v1       = ls_mensagem-message_v1
              v2       = ls_mensagem-message_v2
              v3       = ls_mensagem-message_v3
              v4       = ls_mensagem-message_v4 )
      ) ).


    ELSE.

      APPEND VALUE #(

                               %msg       = new_message(
                                 id       = 'ZSD_COCKPIT_DEVOL'
                                 number   = '001'
                                 severity = CONV #( 'E' ) ) ) TO reported-cockpit.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
