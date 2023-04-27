CLASS lcl_cockpit DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS: BEGIN OF gc_tp_opera,
                 macro TYPE char5 VALUE 'Macro',
                 micro TYPE char5 VALUE 'Micro',
               END OF gc_tp_opera,

               BEGIN OF gc_msg,
                 id     TYPE sy-msgid VALUE 'ZSD_COMODATO_LOC',
                 error  TYPE sy-msgty VALUE 'E',
                 no_006 TYPE sy-msgno VALUE '006',
                 no_008 TYPE sy-msgno VALUE '008',
               END OF gc_msg.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK cockpit.

    METHODS read FOR READ
      IMPORTING keys FOR READ cockpit RESULT result.

    METHODS entradamercadorias FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~entradamercadorias.

    METHODS feature_ctrl_method FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR cockpit RESULT result.

    METHODS devolremessa FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~devolremessa.

    METHODS message FOR MODIFY
      IMPORTING keys FOR ACTION Cockpit~message.

    METHODS get_param
      IMPORTING
        iv_key1  TYPE ztca_param_par-chave1
        iv_key2  TYPE ztca_param_par-chave2
        iv_key3  TYPE ztca_param_par-chave3
      EXPORTING
        ev_param TYPE any.



    CONSTANTS:
      "! <p class="shorttext synchronized">Constantes da tabela de Parâmetros</p>
      BEGIN OF gc_param,
        modulo     TYPE ztca_param_par-modulo VALUE 'SD',
        foods      TYPE ztca_param_par-chave1 VALUE 'CONTRATOS FOOD',
        tipos_oper TYPE ztca_param_par-chave2 VALUE 'TIPOS DE OPERAÇÃO',
        macro      TYPE ztca_param_par-chave3 VALUE 'MACRO',
      END OF gc_param.

ENDCLASS.

CLASS lcl_cockpit IMPLEMENTATION.

  METHOD feature_ctrl_method.
*    DATA lv_tipo_oper TYPE string.

    READ ENTITIES OF zi_sd_cockpit_app IN LOCAL MODE
      ENTITY cockpit
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit)
      FAILED failed.

*    get_param(
*      EXPORTING
*        iv_key1  = gc_param-foods
*        iv_key2  = gc_param-tipos_oper
*        iv_key3  = gc_param-macro
*      IMPORTING
*        ev_param = lv_tipo_oper
*    ).

*    result = VALUE #( FOR ls_cockpit IN lt_cockpit
*                      ( %tky-SalesContract = ls_cockpit-SalesContract
*                        %tky-OrdemVenda    = ls_cockpit-OrdemVenda
*                        %features-%action-entradaMercadorias = COND #( WHEN ls_cockpit-DocnumEntrada IS NOT INITIAL
*                                                                         OR lv_tipo_oper IS INITIAL
*                                                                       THEN if_abap_behv=>fc-o-disabled
*                                                                       ELSE if_abap_behv=>fc-o-enabled ) ) ).

    result = VALUE #( FOR ls_cockpit IN lt_cockpit
                      ( %tky = ls_cockpit-%tky

                        %action-entradamercadorias = COND #( WHEN ( ls_cockpit-tpoperacao    = gc_tp_opera-micro )
                                                               OR ( ls_cockpit-tpoperacao    = gc_tp_opera-macro AND
                                                                    ls_cockpit-docnumentrada <> '0000000000' )
                                                                    THEN if_abap_behv=>fc-o-disabled
                                                             ELSE if_abap_behv=>fc-o-enabled )

                        %action-devolremessa = COND #( WHEN ( ls_cockpit-tpoperacao    =  gc_tp_opera-macro AND
                                                              ( ls_cockpit-docnumentrada <> '0000000000' OR ls_cockpit-TipoOperacao = 'CARG' ) )
                                                          THEN if_abap_behv=>fc-o-enabled
                                                       ELSE if_abap_behv=>fc-o-disabled )
                      )
                    ).
  ENDMETHOD.

  METHOD lock.
    RETURN.
  ENDMETHOD.

  METHOD read.
    CHECK keys IS NOT INITIAL.

    DATA lt_vbak TYPE TABLE OF vbak.

*    SELECT * FROM zi_sd_cockpit_app as _app
*    JOIN @keys as _key ON _app~SalesContract = _key~SalesContract AND _app~Solicitacao = _key~Solicitacao
*    INTO CORRESPONDING FIELDS OF TABLE @result.

    SELECT * FROM zi_sd_cockpit_app
    FOR ALL ENTRIES IN @keys
    WHERE salescontract = @keys-salescontract
    AND solicitacao = @keys-solicitacao
*   AND   OrdemVenda    = @keys-OrdemVenda
*   and DocFatura = @keys-DocFatura
*   AND CentroDestino = @keys-CentroDestino
    INTO CORRESPONDING FIELDS OF TABLE @result.


  ENDMETHOD.

  METHOD entradamercadorias.
    DATA: lv_tipo_oper  TYPE string,
          lv_werks_dest TYPE werks_d.

    READ ENTITIES OF zi_sd_cockpit_app IN LOCAL MODE
      ENTITY cockpit
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit)
      FAILED failed.

    get_param( EXPORTING iv_key1  = gc_param-foods
                         iv_key2  = gc_param-tipos_oper
                         iv_key3  = gc_param-macro
               IMPORTING ev_param = lv_tipo_oper ).

    IF lv_tipo_oper IS INITIAL.
      APPEND VALUE #( %msg = new_message( id       = gc_msg-id
                                          number   = gc_msg-no_006
                                          severity = CONV #( gc_msg-error ) ) ) TO reported-cockpit.
    ELSE.

      IF keys[] IS NOT INITIAL.
        DATA(ls_keys) = VALUE #( keys[ 1 ] OPTIONAL ).

        lv_werks_dest    = ls_keys-%param-werks_dest.
        DATA(lv_emissor) = ls_keys-%param-emissorordem.

      ENDIF.

      IF lv_werks_dest IS NOT INITIAL.

        DATA(lo_entrada_mercadoria) = NEW zclsd_entrada_mercadoria( ).

        reported-cockpit = VALUE #( FOR ls_cockpit IN lt_cockpit
                                    FOR ls_mensagem IN lo_entrada_mercadoria->executar( iv_docnum      = ls_cockpit-docnumnfesaida
                                                                                        iv_docfatura   = ls_cockpit-docfatura
                                                                                        iv_centro      = lv_werks_dest
                                                                                        iv_centro_orig = ls_cockpit-centroorigem
                                                                                      )
                                      ( %tky = VALUE #( salescontract = ls_cockpit-salescontract )
                                        %msg = new_message( id       = ls_mensagem-id
                                                            number   = ls_mensagem-number
                                                            severity = CONV #( ls_mensagem-type )
                                                            v1       = ls_mensagem-message_v1
                                                            v2       = ls_mensagem-message_v2
                                                            v3       = ls_mensagem-message_v3
                                                            v4       = ls_mensagem-message_v4 )
                                                          ) ).

      ELSE.
        APPEND VALUE #( %msg = new_message( id       = gc_msg-id
                                            number   = gc_msg-no_008
                                            severity = CONV #( gc_msg-error ) ) ) TO reported-cockpit.
      ENDIF.

    ENDIF.
  ENDMETHOD.

  METHOD get_param.
    CONSTANTS lc_param_sd TYPE ze_param_modulo VALUE 'SD'.

    CLEAR ev_param.
    TRY.
        NEW zclca_tabela_parametros( )->m_get_single( EXPORTING iv_modulo = lc_param_sd
                                                                iv_chave1 = iv_key1
                                                                iv_chave2 = iv_key2
                                                                iv_chave3 = iv_key3
                                                      IMPORTING ev_param  = ev_param ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.
  ENDMETHOD.

  METHOD devolremessa.

    CHECK keys[] IS NOT INITIAL.

    READ ENTITIES OF zi_sd_cockpit_app IN LOCAL MODE
      ENTITY cockpit
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit)
      FAILED failed.

    DATA(lo_devol_mercadoria) = NEW zclsd_cmdloc_devol_mercadoria( ).

    reported-cockpit = VALUE #( FOR ls_cockpit IN lt_cockpit
                                FOR ls_mensagem IN lo_devol_mercadoria->funcao_devolucao( is_key = VALUE #( contrato = ls_cockpit-%key-salescontract
                                                                                                            fatura   = ls_cockpit-docfatura
                                                                                                            nfesaida = ls_cockpit-nfesaida
                                                                                                          ) )
                                  ( %tky = VALUE #( salescontract = ls_cockpit-salescontract )
                                    %msg = new_message( id       = ls_mensagem-id
                                                        number   = ls_mensagem-number
                                                        severity = CONV #( ls_mensagem-type )
                                                        v1       = ls_mensagem-message_v1
                                                        v2       = ls_mensagem-message_v2
                                                        v3       = ls_mensagem-message_v3
                                                        v4       = ls_mensagem-message_v4 )
                                                      ) ).



  ENDMETHOD.

  METHOD message.

    TYPES: BEGIN OF ty_vbuv,
             vbeln     TYPE vbuv-vbeln,
             posnr     TYPE vbuv-posnr,
             tbnam     TYPE vbuv-tbnam,
             fdnam     TYPE vbuv-fdnam,
             scrtext_m TYPE dd04t-scrtext_m,
           END OF ty_vbuv.

    DATA: lv_item_ctrl TYPE vbuv-posnr,
          lt_vbuv      TYPE STANDARD TABLE OF ty_vbuv.

    CONSTANTS: lc_msgid TYPE sy-msgid VALUE 'ZSD_LOG_PROCESSO',
               lc_n1    TYPE sy-msgno VALUE '001',
               lc_n2    TYPE sy-msgno VALUE '002',
               lc_sev   TYPE sy-msgty VALUE 'I',
               lc_lang  TYPE lang     VALUE 'P'.

    READ ENTITIES OF zi_sd_cockpit_app IN LOCAL MODE
    ENTITY Cockpit
      FIELDS ( SalesContract Solicitacao )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_chaves).

    IF lines( lt_chaves ) GT 0.


      SELECT vbelv,
             vbeln,
             vbtyp_n
        FROM vbfa
        INTO TABLE @DATA(lt_vbfa)
        FOR ALL ENTRIES IN @lt_chaves
        WHERE vbelv = @lt_chaves-SalesContract.

      IF lt_vbfa IS NOT INITIAL.

        CLEAR lt_vbuv.

        LOOP AT lt_vbfa ASSIGNING FIELD-SYMBOL(<fs_vbfa>).

          IF lt_vbuv IS INITIAL.

            IF <fs_vbfa>-vbtyp_n EQ 'O'.

              SELECT a~vbeln,
                     a~posnr,
                     a~tbnam,
                     a~fdnam,
                     c~scrtext_m
                  FROM vbuv AS a
                  INNER JOIN dd03l AS b
                    ON  a~tbnam = b~tabname
                    AND a~fdnam = b~fieldname
                  INNER JOIN dd04t AS c
                    ON b~rollname = c~rollname
                  WHERE a~vbeln = @<fs_vbfa>-vbeln
                      AND c~ddlanguage = @lc_lang
                  INTO TABLE @lt_vbuv.

            ELSEIF <fs_vbfa>-vbtyp_n EQ 'M'.

              SELECT a~vbeln,
                     a~posnr,
                     a~tbnam,
                     a~fdnam,
                     c~scrtext_m
                  FROM vbuv AS a
                  INNER JOIN dd03l AS b
                    ON  a~tbnam = b~tabname
                    AND a~fdnam = b~fieldname
                  INNER JOIN dd04t AS c
                    ON b~rollname = c~rollname
                  WHERE a~vbeln = @<fs_vbfa>-vbeln
                      AND c~ddlanguage = @lc_lang
                  INTO TABLE @lt_vbuv.

            ELSEIF <fs_vbfa>-vbtyp_n EQ 'T'.

              SELECT a~vbeln,
                     a~posnr,
                     a~tbnam,
                     a~fdnam,
                     c~scrtext_m
                  FROM vbuv AS a
                  INNER JOIN dd03l AS b
                    ON  a~tbnam = b~tabname
                    AND a~fdnam = b~fieldname
                  INNER JOIN dd04t AS c
                    ON b~rollname = c~rollname
                  WHERE a~vbeln = @<fs_vbfa>-vbeln
                      AND c~ddlanguage = @lc_lang
                  INTO TABLE @lt_vbuv.

            ELSEIF <fs_vbfa>-vbtyp_n EQ 'J'.

              SELECT a~vbeln,
                     a~posnr,
                     a~tbnam,
                     a~fdnam,
                     c~scrtext_m
                  FROM vbuv AS a
                  INNER JOIN dd03l AS b
                    ON  a~tbnam = b~tabname
                    AND a~fdnam = b~fieldname
                  INNER JOIN dd04t AS c
                    ON b~rollname = c~rollname
                  WHERE a~vbeln = @<fs_vbfa>-vbeln
                      AND c~ddlanguage = @lc_lang
                  INTO TABLE @lt_vbuv.

            ELSEIF <fs_vbfa>-vbtyp_n EQ 'H'.

              SELECT a~vbeln,
                     a~posnr,
                     a~tbnam,
                     a~fdnam,
                     c~scrtext_m
                  FROM vbuv AS a
                  INNER JOIN dd03l AS b
                    ON  a~tbnam = b~tabname
                    AND a~fdnam = b~fieldname
                  INNER JOIN dd04t AS c
                    ON b~rollname = c~rollname
                  WHERE a~vbeln = @<fs_vbfa>-vbeln
                      AND c~ddlanguage = @lc_lang
                  INTO TABLE @lt_vbuv.

            ELSEIF <fs_vbfa>-vbtyp_n EQ 'C'.

              SELECT a~vbeln,
                     a~posnr,
                     a~tbnam,
                     a~fdnam,
                     c~scrtext_m
                  FROM vbuv AS a
                  INNER JOIN dd03l AS b
                    ON  a~tbnam = b~tabname
                    AND a~fdnam = b~fieldname
                  INNER JOIN dd04t AS c
                    ON b~rollname = c~rollname
                  WHERE a~vbeln = @<fs_vbfa>-vbeln
                      AND c~ddlanguage = @lc_lang
                  INTO TABLE @lt_vbuv.

            ENDIF.

          ENDIF.

        ENDLOOP.

        IF sy-subrc IS INITIAL.

          SORT lt_vbuv BY posnr.

          CLEAR lv_item_ctrl.

          LOOP AT lt_vbuv INTO DATA(ls_vbuv).      "#EC CI_LOOP_INTO_WA

            IF lv_item_ctrl IS INITIAL OR lv_item_ctrl EQ ls_vbuv-posnr.

              APPEND VALUE #( %tky-salescontract = ls_vbuv-vbeln ) TO failed-cockpit.

              APPEND VALUE #( %tky = VALUE #( salescontract = ls_vbuv-vbeln )
                  %msg =  new_message( id       = lc_msgid
                                       number   = lc_n1
                                       severity = CONV #( lc_sev )
                                       v1       = ls_vbuv-scrtext_m ) ) TO reported-cockpit.

              lv_item_ctrl = ls_vbuv-posnr.

            ENDIF.
          ENDLOOP.
        ELSE.

          APPEND VALUE #( %msg = new_message(
                                   id       = lc_msgid
                                   number   = lc_n2
                                   severity = CONV #( lc_sev ) ) ) TO reported-cockpit.

        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_zi_sd_cockpit_app DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_zi_sd_cockpit_app IMPLEMENTATION.

  METHOD check_before_save.
    RETURN.
  ENDMETHOD.

  METHOD finalize.
    RETURN.
  ENDMETHOD.

  METHOD save.
    RETURN.
  ENDMETHOD.

ENDCLASS.
