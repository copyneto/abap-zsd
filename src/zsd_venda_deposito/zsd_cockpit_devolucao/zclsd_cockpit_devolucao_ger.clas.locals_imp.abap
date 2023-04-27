CLASS lcl_geradevolucao DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS gerarov FOR MODIFY
      IMPORTING keys FOR ACTION geradevolucao~gerarov.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR geradevolucao RESULT result .

*    METHODS authorityCreate FOR VALIDATE ON SAVE
*      IMPORTING keys FOR GeraDevolucao~authorityCreate.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR geradevolucao RESULT result.

    METHODS calcular FOR MODIFY
      IMPORTING keys FOR ACTION geradevolucao~calcular.

    METHODS verificamodificao FOR VALIDATE ON SAVE
      IMPORTING keys FOR geradevolucao~verificamodificao.

    DATA gv_update TYPE abap_bool.

ENDCLASS.

CLASS lcl_geradevolucao IMPLEMENTATION.

  METHOD gerarov.

* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZDEV_DEVOL' FOR USER sy-uname
      ID 'ACTVT' FIELD '01'.    "Criar

    IF sy-subrc IS INITIAL.
* ---------------------------------------------------------------------------
* Recupera informações do cabeçalho
* ---------------------------------------------------------------------------
      READ ENTITIES OF  zi_sd_cockpit_devolucao_gerdev IN LOCAL MODE
         ENTITY geradevolucao BY \_refval ALL FIELDS WITH  CORRESPONDING #( keys )
         RESULT DATA(lt_refvalores)
         FAILED failed.

* ---------------------------------------------------------------------------
*  Verifica se documentos de faturamento selecionados são do mesmo tipo.
* ---------------------------------------------------------------------------

      DATA(lt_refvalores_aux) = lt_refvalores[].

      SORT lt_refvalores_aux BY billingdocumenttype.
      DELETE ADJACENT DUPLICATES FROM lt_refvalores_aux COMPARING billingdocumenttype.

      DATA(lv_lines_table) = lines( lt_refvalores_aux ).

      IF lv_lines_table > 1.
        APPEND VALUE #(

                                 %msg       = new_message(
                                   id       = 'ZSD_COCKPIT_DEVOL'
                                   number   = '026'
                                   severity = CONV #( 'E' ) ) ) TO reported-refval.
      ELSE.

* ---------------------------------------------------------------------------
*  Verifica se documentos de faturamento selecionados possuem o mesmo motivo.
* ---------------------------------------------------------------------------
        DATA(lv_doc_type) = lt_refvalores[ 1 ]-billingdocumenttype.

        IF  lv_doc_type = 'Y000'.
          DATA(lt_refvalores_y000) = lt_refvalores[].

          SORT lt_refvalores_y000 BY sddocumentreason.
          DELETE ADJACENT DUPLICATES FROM lt_refvalores_y000 COMPARING sddocumentreason.

          DATA(lv_lines_y000) = lines( lt_refvalores_y000 ).
        ENDIF.

        IF lv_lines_y000 > 1.
          APPEND VALUE #(

                                   %msg       = new_message(
                                     id       = 'ZSD_COCKPIT_DEVOL'
                                     number   = '038'
                                     severity = CONV #( 'E' ) ) ) TO reported-refval.
        ELSE.
* ---------------------------------------------------------------------------
* Verifica se não há ordem criada para essa referência
* ---------------------------------------------------------------------------
          DATA(ls_refvalores) = lt_refvalores[ 1 ].

          SELECT SINGLE ordemdevolucao
          FROM zi_sd_cockpit_devolucao_gerdev
          WHERE guid = @ls_refvalores-guid
          INTO @DATA(lv_ordem).

          IF lv_ordem IS INITIAL.

* ---------------------------------------------------------------------------
* Cria dados pré lançamento automático
* ---------------------------------------------------------------------------
            DATA(lo_gera_ov) = NEW zclsd_gera_ov_devolucao(  ).
            reported-refval = VALUE #(
        FOR ls_mensagem IN lo_gera_ov->main( EXPORTING it_devolucao = CORRESPONDING #( lt_refvalores ) )
        ( %tky = VALUE #( guid = ls_refvalores-guid )
          %msg        =
            new_message(
              id       = ls_mensagem-id
              number   = ls_mensagem-number
              severity = CONV #( ls_mensagem-type )
              v1       = ls_mensagem-message_v1
              v2       = ls_mensagem-message_v2
              v3       = ls_mensagem-message_v3
              v4       = ls_mensagem-message_v4 )
        ) ) .

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
          ELSE.

            APPEND VALUE #(

                                     %msg       = new_message(
                                       id       = 'ZSD_COCKPIT_DEVOL'
                                       number   = '025'
                                       severity = CONV #( 'E' ) ) ) TO reported-refval.

          ENDIF.

        ENDIF.
      ENDIF.
** ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    ELSE.

      APPEND VALUE #(

                               %msg       = new_message(
                                 id       = 'ZSD_COCKPIT_DEVOL'
                                 number   = '001'
                                 severity = CONV #( 'E' ) ) ) TO reported-refval.

    ENDIF.


  ENDMETHOD.

  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera informações do cabeçalho
* ---------------------------------------------------------------------------
    READ ENTITIES OF  zi_sd_cockpit_devolucao_gerdev IN LOCAL MODE
       ENTITY geradevolucao BY \_refval ALL FIELDS WITH  CORRESPONDING #( keys )
       RESULT DATA(lt_refvalores)
       FAILED failed.



    result = VALUE #( FOR ls_refvalores IN lt_refvalores

            ( %tky                      = ls_refvalores-%tky


               %action-gerarov            = COND #( WHEN ls_refvalores-fatura IS NOT INITIAL
                                                   THEN if_abap_behv=>fc-o-enabled
                                                   ELSE if_abap_behv=>fc-o-disabled )


               %action-calcular            = COND #( WHEN gv_update NE abap_true
                                                     THEN if_abap_behv=>fc-o-enabled
                                                     ELSE if_abap_behv=>fc-o-disabled ) )

                                                   ).

    CLEAR: gv_update.

  ENDMETHOD.

*  METHOD authorityCreate.
*
*    CONSTANTS: lc_area TYPE string VALUE 'VALIDATE_CREATE'.
*
*    READ ENTITIES OF zi_sd_cockpit_devolucao_gerdev IN LOCAL MODE
*        ENTITY  GeraDevolucao
*        ALL FIELDS WITH CORRESPONDING #( keys )
*        RESULT DATA(lt_data).
*
*    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
*
*      IF zclsd_auth_zsdwerks=>werks_create( <fs_data>-Centro ) EQ abap_false.
*
*        APPEND VALUE #( %tky        = <fs_data>-%tky
*                        %state_area = lc_area )
*        TO reported-GeraDevolucao.
*
*        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-GeraDevolucao.
*
*        APPEND VALUE #( %tky        = <fs_data>-%tky
*                        %state_area = lc_area
*                        %msg        = NEW zcxca_authority_check(
*                                          severity = if_abap_behv_message=>severity-error
*                                          textid   = zcxca_authority_check=>gc_create )
*                        %element-centro = if_abap_behv=>mk-on )
*          TO reported-GeraDevolucao.
*      ENDIF.
*
*    ENDLOOP.
*
*  ENDMETHOD.

  METHOD get_authorizations.

    READ ENTITIES OF zi_sd_cockpit_devolucao_gerdev IN LOCAL MODE
         ENTITY geradevolucao
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_data)
         FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA lv_update TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclsd_auth_zsdwerks=>werks_update( <fs_data>-centro ).
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      APPEND VALUE #( %tky           = <fs_data>-%tky
                      %update        = lv_update
                      %assoc-_refval = lv_update )
*                      %delete = lv_delete )
             TO result.

    ENDLOOP.

  ENDMETHOD.
  METHOD calcular.
* verificando a autorização do user!
      authority-check object 'ZDEV_CALC' for user sy-uname
        id 'ACTVT' field '93'.    "Calcular

    IF sy-subrc IS INITIAL.

      DATA lt_refvalores_aux TYPE TABLE OF zi_sd_cockpit_devolucao_refval.
* ---------------------------------------------------------------------------
* Recupera informações do cabeçalho
* ---------------------------------------------------------------------------
      READ ENTITIES OF  zi_sd_cockpit_devolucao_gerdev IN LOCAL MODE
         ENTITY geradevolucao BY \_refval ALL FIELDS WITH  CORRESPONDING #( keys )
         RESULT DATA(lt_refvalores)
         FAILED failed.

* ---------------------------------------------------------------------------
* Calcula valor convertido pela unidade de venda
* ---------------------------------------------------------------------------
      DATA(ls_refvalores) = lt_refvalores[ 1 ].

      lt_refvalores_aux = CORRESPONDING #( lt_refvalores ).

      DATA(lo_calcula) = NEW zclsd_ckpt_dev_calc_valores(  ).
      reported-refval = VALUE #(
  FOR ls_mensagem IN lo_calcula->main( CHANGING ct_refvalores = lt_refvalores_aux )
  ( %tky = VALUE #( guid = ls_refvalores-guid )
    %msg        =
      new_message(
        id       = ls_mensagem-id
        number   = ls_mensagem-number
        severity = CONV #( ls_mensagem-type )
        v1       = ls_mensagem-message_v1
        v2       = ls_mensagem-message_v2
        v3       = ls_mensagem-message_v3
        v4       = ls_mensagem-message_v4 )
  ) ) .

    ELSE.

      APPEND VALUE #(

                               %msg       = new_message(
                                 id       = 'ZSD_COCKPIT_DEVOL'
                                 number   = '001'
                                 severity = CONV #( 'E' ) ) ) TO reported-refval.

    ENDIF.

  ENDMETHOD.

  METHOD verificamodificao.
    gv_update = abap_true.
  ENDMETHOD.



ENDCLASS.
