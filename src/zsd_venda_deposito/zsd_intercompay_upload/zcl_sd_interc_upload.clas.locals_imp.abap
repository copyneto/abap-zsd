CLASS lcl_IntercompanyUpload DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    TYPES: ty_table         TYPE TABLE OF ztsd_interc_upld WITH DEFAULT KEY,
           ty_t_cockpititem TYPE TABLE OF ztsd_interc_item WITH DEFAULT KEY.

    DATA: gv_guid TYPE sysuuid_x16.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK IntercompanyUpload.

    METHODS read FOR READ
      IMPORTING keys FOR READ IntercompanyUpload RESULT result.

    METHODS toValidateSave FOR MODIFY
      IMPORTING keys FOR ACTION IntercompanyUpload~toValidateSave.

    METHODS ValidateDataProcess FOR MODIFY
      IMPORTING keys FOR ACTION IntercompanyUpload~ValidateDataProcess.

    METHODS CheckAutorization FOR MODIFY
      IMPORTING keys FOR ACTION IntercompanyUpload~CheckAutorization.

    METHODS SaveData FOR MODIFY
      IMPORTING keys FOR ACTION IntercompanyUpload~SaveData.

    METHODS toProcess FOR MODIFY
      IMPORTING keys   FOR ACTION IntercompanyUpload~toProcess
      RESULT    result.

    METHODS CriarInter FOR MODIFY
      IMPORTING keys   FOR ACTION IntercompanyUpload~CriarInter
      RESULT    result.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR IntercompanyUpload RESULT result.

ENDCLASS.

CLASS lcl_IntercompanyUpload IMPLEMENTATION.

  METHOD lock.
    RETURN.
  ENDMETHOD.

  METHOD read.
    RETURN.
  ENDMETHOD.

  METHOD toValidateSave.

    "----Executa Validação
    MODIFY ENTITIES OF zi_sd_interc_upload IN LOCAL MODE
      ENTITY IntercompanyUpload
        EXECUTE validatedataprocess
        FROM CORRESPONDING #( keys )
      REPORTED DATA(lt_validate_reported).

    reported = CORRESPONDING #( DEEP lt_validate_reported ).

    IF reported-IntercompanyUpload IS NOT INITIAL.

      APPEND VALUE #( %tky = keys[ 1 ]-%tky ) TO failed-IntercompanyUpload.

    ELSE.

      "----Executa checagem de autorização
      MODIFY ENTITIES OF zi_sd_interc_upload IN LOCAL MODE
      ENTITY IntercompanyUpload
        EXECUTE checkautorization
        FROM CORRESPONDING #( keys )
      REPORTED DATA(lt_autorization_reported).

      reported = CORRESPONDING #( DEEP lt_autorization_reported ).

      IF reported-IntercompanyUpload IS NOT INITIAL.

        APPEND VALUE #( %tky = keys[ 1 ]-%tky ) TO failed-IntercompanyUpload.

      ELSE.

        "----Executa ação de salvar dados
        MODIFY ENTITIES OF zi_sd_interc_upload IN LOCAL MODE
        ENTITY IntercompanyUpload
            EXECUTE savedata
             FROM CORRESPONDING #( keys )
        REPORTED DATA(lt_save_reported).

        reported = CORRESPONDING #( DEEP lt_save_reported ).

      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD ValidateDataProcess.

    CONSTANTS gc_param_mod TYPE ze_param_modulo VALUE 'SD' ##NO_TEXT.
    CONSTANTS gc_chave1 TYPE ze_param_chave VALUE 'ADM_INTER' ##NO_TEXT.
    CONSTANTS gc_chave2_exped TYPE ze_param_chave VALUE 'TP_EXPED' ##NO_TEXT.
    CONSTANTS gc_chave3_frota_prop TYPE ze_param_chave_3 VALUE 'FRT_PROP' ##NO_TEXT.

    DATA: lr_tpexp           TYPE RANGE OF vsarttr,
          lv_cgc_agfrete     TYPE j_1bcgc,
          lv_cgc_agfrete_out TYPE char18,
          lv_cgc_number      TYPE j_1bcgc,
          lv_cgc_number_out  TYPE char18.

    "----Primeiro registro para validação
    DATA(ls_key) = keys[ 1 ].

    UNPACK ls_key-%param-Incoterms         TO ls_key-%param-Incoterms.
    UNPACK ls_key-%param-CondicaoExpedicao TO ls_key-%param-CondicaoExpedicao.
    UNPACK ls_key-%param-AgenteFrete       TO ls_key-%param-AgenteFrete.
    UNPACK ls_key-%param-Motorista         TO ls_key-%param-Motorista.
    UNPACK ls_key-%param-material          TO ls_key-%param-material.

    "----Passa valores
    DATA(ls_cockpit) = CORRESPONDING zi_sd_01_cockpit( ls_key MAPPING Processo                     = %param-processo
                                                                      TipoOperacao                 = %param-TipoOperacao
                                                                      Werks_Origem                 = %param-CentroOrigem
                                                                      Lgort_Origem                 = %param-DepositoOrigem
                                                                      Werks_Destino                = %param-CentroDestino
                                                                      Lgort_Destino                = %param-DepositoDestino
                                                                      Werks_Receptor               = %param-CentroReceptor
                                                                      Tpfrete                      = %param-Incoterms
                                                                      Tpexp                        = %param-TipoExpedicao
                                                                      CondExp                      = %param-CondicaoExpedicao
                                                                      Agfrete                      = %param-AgenteFrete
                                                                      Motora                       = %param-Motorista
                                                                      Ztraid                       = %param-Placa
                                                                      Ztrai1                       = %param-PlacaSemiReboque1
                                                                      Ztrai2                       = %param-PlacaSemiReboque2
                                                                      Ztrai3                       = %param-PlacaSemiReboque3
                                                                      IdSaga                       = %param-ID3Cargo
                                                                      ekorg                        = %param-OrganizacaoCompras
                                                                      ekgrp                        = %param-GrupoCompradores
                                                                      RemessaOrigem                = %param-RemessaTranferenciaDevolucao
                                                                      abrvw                        = %param-UtilizacaoGraoVerde
                                                                      Fracionado                   = %param-Fracionado
                                                                      "Material                     = %param-Material
                                                                      "UnidadeBase                  = %param-UnidadeBase
                                                                      "Quantidade                   = %param-Quantidade
                                                                       ).


    IF  ls_cockpit-processo        EQ '1'  " Transferência entre centros
    AND ls_cockpit-tipooperacao(3) NE 'TRA'

    OR  ls_cockpit-processo        EQ '2'  " Intercompany
    AND ls_cockpit-tipooperacao(3) NE 'INT'
    AND ls_cockpit-tipooperacao    NE 'TRA3'.

      SELECT SINGLE FROM zi_sd_vh_tpoper
        FIELDS nome
        WHERE tpoper EQ @ls_cockpit-tipooperacao
        INTO @DATA(lv_tipo_operacao).

      SELECT SINGLE FROM zi_sd_vh_processo
        FIELDS text
        WHERE processo = @ls_cockpit-processo
        INTO @DATA(lv_processo).

      reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                                    %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                        number   = '019'
                                                                                        severity = CONV #( 'E' )
                                                                                        v1 = |"{ lv_tipo_operacao } ({ ls_cockpit-tipooperacao })"|
                                                                                        v2 = |"{ lv_processo } ({ ls_cockpit-processo })"| ) ) ).
      RETURN.

    ENDIF.

    IF ls_cockpit-processo IS INITIAL.

      reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                                    %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                        number   = '016'
                                                                                        severity = CONV #( 'E' ) ) ) ).
      RETURN.

    ENDIF.

    IF ls_cockpit-werks_origem IS INITIAL.

      reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                                    %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                        number   = '023'
                                                                                        severity = CONV #( 'E' ) ) ) ).
      RETURN.

    ENDIF.

    IF ls_cockpit-lgort_origem IS INITIAL.

      reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                                    %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                        number   = '014'
                                                                                        severity = CONV #( 'E' ) ) ) ).
      RETURN.

    ENDIF.

    IF ls_cockpit-werks_destino IS INITIAL.

      reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                                    %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                        number   = '024'
                                                                                        severity = CONV #( 'E' ) ) ) ).
      RETURN.

    ENDIF.

    IF ls_cockpit-lgort_destino IS INITIAL.

      reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                                    %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                        number   = '015'
                                                                                        severity = CONV #( 'E' ) ) ) ).
      RETURN.

    ENDIF.

    SELECT werks, lgort
        FROM  t001l
    WHERE werks EQ @ls_cockpit-werks_origem
      AND   lgort EQ @ls_cockpit-lgort_origem
      INTO TABLE @DATA(lt_werks1).

    IF sy-subrc IS NOT INITIAL.

      reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                                    %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                        number   = '042'
                                                                                        severity = CONV #( 'E' )
                                                                                        v1      = ls_cockpit-lgort_origem
                                                                                        v2      = ls_cockpit-werks_origem ) ) ).
      RETURN.

    ENDIF.

    SELECT werks, lgort
        FROM  t001l
    WHERE werks EQ @ls_cockpit-werks_destino
      AND   lgort EQ @ls_cockpit-lgort_destino
      INTO TABLE @DATA(lt_werks2).

    IF sy-subrc IS NOT INITIAL.

      reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                                    %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                        number   = '041'
                                                                                        severity = CONV #( 'E' )
                                                                                        v1      = ls_cockpit-lgort_destino
                                                                                        v2      = ls_cockpit-werks_destino ) ) ).
      RETURN.

    ENDIF.

    IF ls_cockpit-processo = '1'. " Transferência entre centros

      SELECT SINGLE werks,
                    j_1bbranch,
                    adrnr
        FROM t001w
        INTO @DATA(ls_t001w_origem)
        WHERE werks EQ @ls_cockpit-werks_origem.

      IF sy-subrc NE 0.
        RETURN.
      ENDIF.


      SELECT bukrs,
             branch
        FROM j_1bbranch
        INTO TABLE @DATA(lt_1bbranch_origem)
        WHERE branch EQ @ls_t001w_origem-j_1bbranch.

      IF sy-subrc NE 0.
        RETURN.
      ENDIF.

      SELECT SINGLE werks,
                    j_1bbranch,
                    adrnr
        FROM t001w
        INTO @DATA(ls_t001w_destino)
        WHERE werks EQ @ls_cockpit-werks_destino.

      IF sy-subrc NE 0.
        RETURN.
      ENDIF.


      SELECT bukrs,
             branch
        FROM j_1bbranch
        INTO TABLE @DATA(lt_1bbranch_destino)
        WHERE branch EQ @ls_t001w_destino-j_1bbranch.

      IF sy-subrc NE 0.
        RETURN.
      ENDIF.

      READ TABLE lt_1bbranch_origem  INTO DATA(ls_origem)  INDEX 1.
      READ TABLE lt_1bbranch_destino INTO DATA(ls_destino) INDEX 1.

      IF ls_origem-bukrs NE ls_destino-bukrs.

        reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                                      %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                          number   = '027'
                                                                                          severity = CONV #( 'E' ) ) ) ).
        RETURN.

      ENDIF.

      IF ls_cockpit-tipooperacao EQ 'TRA2'.

        SELECT SINGLE centrodepfechado
          FROM ztsd_centrofatdf
          INTO @DATA(lv_dep_fechado)
          WHERE centrofaturamento EQ @ls_cockpit-werks_destino.

        IF  sy-subrc IS INITIAL
        AND ls_cockpit-werks_receptor IS INITIAL.

          reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload ( "%element-werks_receptor = if_abap_behv=>mk-on
                                                                        %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                            number   = '028'
                                                                                            severity = CONV #( 'E' ) ) ) ).
          RETURN.

        ENDIF.

        SELECT COUNT( * ) FROM ztsd_centrofatdf UP TO 1 ROWS
          WHERE centrodepfechado EQ @ls_cockpit-werks_origem.

        IF  sy-subrc IS INITIAL.

          reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                                        %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                            number   = '029'
                                                                                            severity = CONV #( 'E' )
                                                                                            v1       = TEXT-t01 ) ) ).
          RETURN.

        ENDIF.

        SELECT COUNT( * ) FROM ztsd_centrofatdf UP TO 1 ROWS
          WHERE centrodepfechado EQ @ls_cockpit-werks_destino.

        IF  sy-subrc IS INITIAL.

          reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                                        %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                            number   = '029'
                                                                                            severity = CONV #( 'E' )
                                                                                            v1       = TEXT-t02 ) ) ).
          RETURN.

        ENDIF.




        IF ls_cockpit-werks_receptor IS NOT INITIAL.

          SELECT COUNT(*)
          FROM ztsd_centrofatdf
          WHERE centrofaturamento EQ ls_cockpit-werks_destino
          AND   centrodepfechado  EQ ls_cockpit-werks_receptor.

          IF sy-subrc IS NOT INITIAL.

            reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                                        %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                            number   = '040'
                                                                                            severity = CONV #( 'E' )
                                                                                            v1       = ls_cockpit-werks_destino ) ) ).
            RETURN.

          ENDIF.

        ENDIF.

      ENDIF.

    ENDIF.

    IF ( ls_cockpit-tipooperacao EQ 'INT4' )
    AND ls_cockpit-werks_receptor IS INITIAL.

      reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                                      %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                          number   = '010'
                                                                                          severity = CONV #( 'E' ) ) ) ).
      RETURN.
    ENDIF.

    IF ls_cockpit-tipooperacao EQ 'INT2' .

      IF ls_cockpit-werks_receptor IS INITIAL.

        reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                                      %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                          number   = '010'
                                                                                          severity = CONV #( 'E' ) ) ) ).
        RETURN.

      ELSE.

        SELECT COUNT(*)
        FROM ztsd_centrofatdf
        WHERE centrofaturamento EQ ls_cockpit-werks_destino
          AND centrodepfechado  EQ ls_cockpit-werks_receptor.

        IF sy-subrc IS NOT INITIAL.

          reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                                      %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                          number   = '040'
                                                                                          severity = CONV #( 'E' )
                                                                                          v1       = ls_cockpit-werks_destino ) ) ).
          RETURN.

        ENDIF.

      ENDIF.

    ENDIF.

    IF ls_cockpit-tpfrete IS INITIAL.

      reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                                      %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                          number   = '025'
                                                                                          severity = CONV #( 'E' ) ) ) ).
      RETURN.

    ENDIF.

    IF ls_cockpit-condexp IS INITIAL.

      reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                                      %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                          number   = '026'
                                                                                          severity = CONV #( 'E' ) ) ) ).
      RETURN.

    ENDIF.

    IF ls_cockpit-tpfrete EQ '001'  " CIF
    OR ls_cockpit-tpfrete EQ '002'. " FOB

      DATA(lo_param) = NEW zclca_tabela_parametros( ).

      TRY.
          lo_param->m_get_range(
            EXPORTING
              iv_modulo = gc_param_mod
              iv_chave1 = gc_chave1
              iv_chave2 = gc_chave2_exped
              iv_chave3 = gc_chave3_frota_prop
            IMPORTING
              et_range  = lr_tpexp ).
        CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros
      ENDTRY.


      IF ls_cockpit-tpexp   IS INITIAL
      OR ls_cockpit-agfrete IS INITIAL
      OR ( ls_cockpit-motora IS INITIAL
       AND ls_cockpit-tpexp  IN lr_tpexp )
      OR ls_cockpit-ztraid  IS INITIAL.

        reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
          %msg     = new_message(
            id       = 'ZSD_INTERC_UPLD'
            number   = '008'
            severity = CONV #( 'E' ) ) ) ).

        RETURN.

      ENDIF.

      SELECT SINGLE lifnr,
                    stcd1
        FROM lfa1
        WHERE lifnr = @ls_cockpit-agfrete
        INTO @DATA(ls_lfa1).

      lv_cgc_agfrete = ls_lfa1-stcd1.

      WRITE lv_cgc_agfrete TO lv_cgc_agfrete_out.

      CLEAR lv_cgc_number.

      DATA(lv_werks) = COND #( WHEN ls_cockpit-tpfrete = '001' THEN ls_cockpit-werks_origem
                               WHEN ls_cockpit-tpfrete = '002' THEN ls_cockpit-werks_destino
                               ELSE space ).

      IF lv_werks IS NOT INITIAL.

        SELECT SINGLE werks,
                      j_1bbranch,
                      adrnr
          FROM t001w
          INTO @DATA(ls_t001w)
          WHERE werks EQ @lv_werks.

        IF sy-subrc NE 0.
          RETURN.
        ENDIF.

        SELECT bukrs,
               branch
          FROM j_1bbranch
          INTO TABLE @DATA(lt_1bbranch)
          WHERE branch EQ @ls_t001w-j_1bbranch.

        IF sy-subrc NE 0.
          RETURN.
        ENDIF.

        READ TABLE lt_1bbranch INTO DATA(ls_1bbranch) INDEX 1.

        CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
          EXPORTING
            branch            = ls_1bbranch-branch
            bukrs             = ls_1bbranch-bukrs
          IMPORTING
            cgc_number        = lv_cgc_number
          EXCEPTIONS
            branch_not_found  = 1
            address_not_found = 2
            company_not_found = 3
            OTHERS            = 4.

        IF sy-subrc EQ 0.

          WRITE lv_cgc_number TO lv_cgc_number_out.

        ENDIF.

      ENDIF.

    ENDIF.

    CASE ls_cockpit-tpfrete.
      WHEN '001'. " CIF

        IF  ls_cockpit-tpexp IN lr_tpexp
        AND lr_tpexp IS NOT INITIAL.

          IF ls_lfa1-stcd1 NE lv_cgc_number.

            reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                                %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                    number   = '004'
                                                                                    severity = CONV #( 'E' )
                                                                                    v1       = lv_cgc_agfrete_out
                                                                                    v2       = lv_cgc_number_out ) ) ).
            RETURN.

          ENDIF.

        ELSE.

          IF ls_lfa1-stcd1 EQ lv_cgc_number.

            reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                                %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                    number   = '005'
                                                                                    severity = CONV #( 'E' )
                                                                                    v1       = lv_cgc_agfrete_out
                                                                                    v2       = lv_cgc_number_out ) ) ).
            RETURN.

          ENDIF.

        ENDIF.

      WHEN '002'. " FOB

        IF  ls_cockpit-tpexp IN lr_tpexp
        AND lr_tpexp IS NOT INITIAL.

          IF ls_lfa1-stcd1 NE lv_cgc_number.

            reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                                %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                    number   = '006'
                                                                                    severity = CONV #( 'E' )
                                                                                    v1       = lv_cgc_agfrete_out
                                                                                    v2       = lv_cgc_number_out ) ) ).
            RETURN.

          ENDIF.

        ELSE.

          IF ls_lfa1-stcd1 EQ lv_cgc_number.

            reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                                %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                    number   = '007'
                                                                                    severity = CONV #( 'E' )
                                                                                    v1       = lv_cgc_agfrete_out
                                                                                    v2       = lv_cgc_number_out ) ) ).
            RETURN.

          ENDIF.

        ENDIF.

      WHEN '003'. " Sem Frete

        IF ls_cockpit-agfrete IS NOT INITIAL
        OR ls_cockpit-tpexp   IS NOT INITIAL
        OR ls_cockpit-motora  IS NOT INITIAL
        OR ls_cockpit-ztraid  IS NOT INITIAL
        OR ls_cockpit-ztrai1  IS NOT INITIAL
        OR ls_cockpit-ztrai2  IS NOT INITIAL
        OR ls_cockpit-ztrai3  IS NOT INITIAL
        OR ls_cockpit-idsaga  IS NOT INITIAL.

          reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
            %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                number   = '009'
                                severity = CONV #( 'E' ) ) ) ).
          RETURN.

        ENDIF.

    ENDCASE.

    IF ls_cockpit-ztraid IS NOT INITIAL.

      SELECT COUNT(*) FROM zi_sd_vh_placas WHERE placa = @ls_cockpit-ztraid.

      IF sy-subrc <> 0.

        reported-IntercompanyUpload = VALUE #(
          BASE reported-IntercompanyUpload (
          %msg     = new_message(
            id       = 'ZSD_INTERC_UPLD'
            number   = '043'
            severity = CONV #( 'E' )
            v1       = TEXT-t03
            v2       = |{ ls_cockpit-ztraid }| ) ) ).

        RETURN.

      ENDIF.

    ENDIF.

    IF ls_cockpit-tpfrete IS NOT INITIAL.

      SELECT COUNT(*) FROM zi_ca_vh_mdfrete WHERE mdfrete = @ls_cockpit-tpfrete.

      IF sy-subrc <> 0.

        reported-IntercompanyUpload = VALUE #(
          BASE reported-IntercompanyUpload (
          %msg     = new_message(
            id       = 'ZSD_INTERC_UPLD'
            number   = '043'
            severity = CONV #( 'E' )
            v1       = TEXT-t04
            v2       = |{ ls_cockpit-tpfrete }| ) ) ).

        RETURN.

      ENDIF.

    ENDIF.

    IF ls_cockpit-tpexp IS NOT INITIAL.

      SELECT COUNT(*) FROM zi_ca_vh_vsart WHERE tipoexpedicao = @ls_cockpit-tpexp.

      IF sy-subrc <> 0.

        reported-IntercompanyUpload = VALUE #(
          BASE reported-IntercompanyUpload (
          %msg     = new_message(
            id       = 'ZSD_INTERC_UPLD'
            number   = '043'
            severity = CONV #( 'E' )
            v1       = TEXT-t05
            v2       = |{ ls_cockpit-Tpexp }| ) ) ).

        RETURN.

      ENDIF.

    ENDIF.

    IF ls_cockpit-ztrai1 IS NOT INITIAL.

      SELECT COUNT(*) FROM zi_sd_vh_placas WHERE placa = @ls_cockpit-ztrai1.

      IF sy-subrc <> 0.

        reported-IntercompanyUpload = VALUE #(
          BASE reported-IntercompanyUpload (
          %msg     = new_message(
            id       = 'ZSD_INTERC_UPLD'
            number   = '043'
            severity = CONV #( 'E' )
            v1       = TEXT-t06
            v2       = |{ ls_cockpit-Ztrai1 }| ) ) ).

        RETURN.

      ENDIF.

    ENDIF.

    IF ls_cockpit-ztrai2 IS NOT INITIAL.

      SELECT COUNT(*) FROM zi_sd_vh_placas WHERE placa = @ls_cockpit-ztrai2.

      IF sy-subrc <> 0.

        reported-IntercompanyUpload = VALUE #(
          BASE reported-IntercompanyUpload (
          %msg     = new_message(
            id       = 'ZSD_INTERC_UPLD'
            number   = '043'
            severity = CONV #( 'E' )
            v1       = TEXT-t07
            v2       = |{ ls_cockpit-ztrai2 }| ) ) ).

        RETURN.

      ENDIF.

    ENDIF.

    IF ls_cockpit-ztrai3 IS NOT INITIAL.

      SELECT COUNT(*) FROM zi_sd_vh_placas WHERE placa = @ls_cockpit-ztrai3.

      IF sy-subrc <> 0.

        reported-IntercompanyUpload = VALUE #(
          BASE reported-IntercompanyUpload (
          %msg     = new_message(
            id       = 'ZSD_INTERC_UPLD'
            number   = '043'
            severity = CONV #( 'E' )
            v1       = TEXT-t08
            v2       = |{ ls_cockpit-ztrai3 }| ) ) ).

        RETURN.

      ENDIF.

    ENDIF.

    IF ls_cockpit-processo EQ '1'.

      IF ls_cockpit-ekorg IS INITIAL.

        reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                            %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                number   = '012'
                                                                                severity = CONV #( 'E' ) ) ) ).

        RETURN.

      ENDIF.

      IF ls_cockpit-ekgrp IS INITIAL.

        reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                            %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                number   = '013'
                                                                                severity = CONV #( 'E' ) ) ) ).

        RETURN.

      ENDIF.

      IF  ls_cockpit-tipooperacao EQ 'TRA7'.

        IF ls_cockpit-remessaorigem IS INITIAL.

          reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                              %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                  number   = '017'
                                                                                  severity = CONV #( 'E' ) ) ) ).
          RETURN.

        ENDIF.

      ENDIF.

      IF ls_cockpit-remessaorigem IS NOT INITIAL.

        SELECT SINGLE COUNT( * ) FROM likp
          WHERE vbeln EQ @ls_cockpit-remessaorigem.

        IF sy-subrc NE 0.

          reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                              %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                  number   = '018'
                                                                                  severity = CONV #( 'E' )
                                                                                  v1       = ls_cockpit-remessaorigem ) ) ).
          RETURN.

        ENDIF.

      ENDIF.

    ENDIF.

    IF ls_cockpit-processo EQ '2'. "Intercompany

      DATA(lo_transf) = NEW zclmm_cockpit_transf( ).
      DATA(lv_return) = lo_transf->valida_centro( EXPORTING iv_centro1 = ls_cockpit-werks_origem
                                                            iv_centro2 = ls_cockpit-werks_destino ).


      IF lv_return IS NOT INITIAL.

        reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                             %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                 number   = '030'
                                                                                 severity = CONV #( 'E' ) ) ) ).
        RETURN.


      ENDIF.


      IF ls_cockpit-tipooperacao EQ 'INT7'.

        IF ls_cockpit-abrvw IS INITIAL.

          reported-IntercompanyUpload = VALUE #( BASE reported-IntercompanyUpload (
                                                              %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                                                                  number   = '039'
                                                                                  severity = CONV #( 'E' ) ) ) ).

          RETURN.

        ENDIF.

      ENDIF.

    ENDIF.

    DATA(lt_cockpititem) = VALUE ty_t_cockpititem( FOR ls_itm IN keys ( material          = ls_itm-%param-material
                                                                        materialbaseunit  = ls_itm-%param-unidadebase
                                                                        qtdsol            = ls_itm-%param-quantidade ) ).

    IF line_exists( lt_cockpititem[ qtdsol = '0.000' ] ). "#EC CI_STDSEQ

      APPEND VALUE #( %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                          number   = 032
                                          severity = CONV #( 'E' ) ) ) TO reported-IntercompanyUpload.

      RETURN.

    ELSEIF line_exists( lt_cockpititem[ material = '' ] ). "#EC CI_STDSEQ

      APPEND VALUE #( %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                            number   = 047
                                            severity = CONV #( 'E' ) ) ) TO reported-IntercompanyUpload.

      RETURN.

    ELSEIF line_exists( lt_cockpititem[ materialbaseunit = '' ] ). "#EC CI_STDSEQ

      APPEND VALUE #( %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                            number   = 048
                                            severity = CONV #( 'E' ) ) ) TO reported-IntercompanyUpload.

      RETURN.

    ENDIF.

  ENDMETHOD.

  METHOD CheckAutorization.

    DATA(ls_key) = keys[ 1 ].

    IF NOT zclsd_auth_zsdwerks=>werks_update( ls_key-%param-centroorigem ).

      "----Sem autorização para executar ação.
      APPEND VALUE #( %msg = new_message(
                               id       = 'ZSD_INTERC_UPLD'
                               number   = 047
                               severity = if_abap_behv_message=>severity-error
                             ) ) TO reported-IntercompanyUpload.

      RETURN.

    ENDIF.

  ENDMETHOD.

  METHOD SaveData.

    DATA(lv_times) = VALUE timestamp(  ).

    GET TIME STAMP FIELD lv_times.

    "----Primeiro registro para validação
    DATA(ls_key) = keys[ 1 ].

    "----Passa valores
    TRY.

        UNPACK ls_key-%param-Incoterms         TO ls_key-%param-Incoterms.
        UNPACK ls_key-%param-CondicaoExpedicao TO ls_key-%param-CondicaoExpedicao.
        UNPACK ls_key-%param-AgenteFrete       TO ls_key-%param-AgenteFrete.
        UNPACK ls_key-%param-Motorista         TO ls_key-%param-Motorista.

        DATA(ls_cockpit) = VALUE ztsd_intercompan(  guid                         = NEW cl_system_uuid( )->if_system_uuid~create_uuid_x16( )
                                                    Processo                     = ls_key-%param-processo
                                                    TipoOperacao                 = ls_key-%param-TipoOperacao
                                                    Werks_Origem                 = ls_key-%param-CentroOrigem
                                                    Lgort_Origem                 = ls_key-%param-DepositoOrigem
                                                    Werks_Destino                = ls_key-%param-CentroDestino
                                                    Lgort_Destino                = ls_key-%param-DepositoDestino
                                                    Werks_Receptor               = ls_key-%param-CentroReceptor
                                                    Tpfrete                      = ls_key-%param-Incoterms
                                                    Tpexp                        = ls_key-%param-TipoExpedicao
                                                    CondExp                      = ls_key-%param-CondicaoExpedicao
                                                    Agfrete                      = ls_key-%param-AgenteFrete
                                                    Motora                       = ls_key-%param-Motorista
                                                    Ztraid                       = ls_key-%param-Placa
                                                    Ztrai1                       = ls_key-%param-PlacaSemiReboque1
                                                    Ztrai2                       = ls_key-%param-PlacaSemiReboque2
                                                    Ztrai3                       = ls_key-%param-PlacaSemiReboque3
                                                    IdSaga                       = ls_key-%param-ID3Cargo
                                                    ekorg                        = ls_key-%param-OrganizacaoCompras
                                                    ekgrp                        = ls_key-%param-GrupoCompradores
                                                    remessa_origem               = ls_key-%param-RemessaTranferenciaDevolucao
                                                    abrvw                        = ls_key-%param-UtilizacaoGraoVerde
                                                    Fracionado                   = ls_key-%param-Fracionado
                                                    created_by                   = sy-uname
                                                    created_at                   = lv_times
                                                    last_changed_by              = sy-uname
                                                    last_changed_at              = lv_times
                                                    local_last_changed_at        = lv_times ).

      CATCH cx_uuid_error INTO DATA(lo_uuid_error).

    ENDTRY.

    MODIFY ztsd_intercompan FROM ls_cockpit.

    DATA(lt_cockpititem) = VALUE ty_t_cockpititem( FOR ls_itm IN keys ( guid              = ls_cockpit-guid
                                                                        material          = ls_itm-%param-material
                                                                        materialbaseunit  = ls_itm-%param-unidadebase
                                                                        qtdsol            = ls_itm-%param-quantidade ) ).

    MODIFY ztsd_interc_item FROM TABLE lt_cockpititem.

    gv_guid = ls_cockpit-guid.

    "----Salva Log
    TRY.

        DATA(lt_table) = VALUE ty_table(  ).

        APPEND VALUE #( guid           = gv_guid
                        werks          = ls_key-%param-centroorigem
                        file_directory = ls_key-%param-filedirectory
                        created_date   = sy-datum
                        created_time   = sy-uzeit
                        created_user   = sy-uname ) TO lt_table.

        MODIFY ztsd_interc_upld FROM TABLE lt_table.

      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    "----Faz conversão do guid para leitura
    DATA(lv_guid) = cl_soap_wsrmb_helper=>convert_uuid_raw_to_hyphened( gv_guid ).

    "----Guid
    APPEND VALUE #( %msg  = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                   text     = |{ lv_guid }| )
                  ) TO reported-IntercompanyUpload.

  ENDMETHOD.

  METHOD toProcess.

    "----Executa criar intercompny
    MODIFY ENTITIES OF zi_sd_interc_upload IN LOCAL MODE
    ENTITY IntercompanyUpload
      EXECUTE criarinter
      FROM CORRESPONDING #( keys )
    REPORTED DATA(lt_criarinter_reported)
    FAILED DATA(lt_criarinter_failed).

    reported = CORRESPONDING #( DEEP lt_criarinter_reported ).
    failed   = CORRESPONDING #( DEEP lt_criarinter_failed ).

  ENDMETHOD.

  METHOD CriarInter.

    CONSTANTS lc_erro TYPE bapi_mtype VALUE 'E'.

    DATA: lt_items        TYPE TABLE OF ztsd_interc_item,
          lt_delete_items TYPE TABLE OF ztsd_interc_item,
          lt_text         TYPE STANDARD TABLE OF zssd_ordem_inter_text.

    gv_guid = keys[ 1 ]-Guid.

    SELECT FROM zi_sd_01_cockpit
     FIELDS *
     WHERE Guid = @gv_guid
     INTO TABLE @DATA(lt_cockpit).

    SELECT FROM ztsd_interc_item
    FIELDS *
    WHERE Guid = @gv_guid
    INTO TABLE @DATA(lt_material).

    IF line_exists( lt_material[ qtdsol = '0.000' ] ).   "#EC CI_STDSEQ

      APPEND VALUE #(
                       %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                             number   = 032
                             severity = CONV #( 'E' ) ) ) TO reported-IntercompanyUpload.

      APPEND VALUE #( %tky = keys[ 1 ]-%tky ) TO failed-IntercompanyUpload.

      RETURN.

    ENDIF.

    READ TABLE lt_cockpit INTO DATA(ls_cockpit) INDEX 1.
    SORT lt_material BY guid material materialbaseunit.

    CASE ls_cockpit-processo.

      WHEN '2'. " Intercompany

        DATA(lt_mensagem) = NEW zclsd_cria_ordem_intercompany(  )->execute(
          is_input =  VALUE #(
            guid              = ls_cockpit-guid
            tipo_operacao     = ls_cockpit-tipooperacao
            processo          = ls_cockpit-processo
            centro_fornecedor = ls_cockpit-werks_origem
            centro_destino    = ls_cockpit-werks_destino
            centro_receptor   = ls_cockpit-werks_receptor
            deposito_destino  = ls_cockpit-lgort_destino
            deposito_origem   = ls_cockpit-lgort_origem
            itens             = VALUE #( FOR ls_material IN lt_material
                                         ( material   = ls_material-material
                                           quantidade = ls_material-qtdsol
                                           unidade    = ls_material-materialbaseunit ) )
            modalidade_frete = ls_cockpit-tpfrete
            agente_frete     = ls_cockpit-agfrete
            placa            = ls_cockpit-ztraid
            tipo_exped       = ls_cockpit-tpexp
            cond_exped       = ls_cockpit-condexp
            motorista        = ls_cockpit-motora
            texto_nfe        = COND #( WHEN ls_cockpit-txtnf IS NOT INITIAL
                                       THEN VALUE #( BASE lt_text ( line = ls_cockpit-txtnf ) ) )
            texto_geral      = COND #( WHEN ls_cockpit-txtgeral IS NOT INITIAL
                                       THEN VALUE #( BASE lt_text ( line = ls_cockpit-txtgeral ) ) )
            org_compras      = ls_cockpit-ekorg
            abrvw            = ls_cockpit-abrvw
            grp_comp         = ls_cockpit-ekgrp
            remessa_origem   = ls_cockpit-remessaorigem )
          is_continuar = abap_false ).

      WHEN '1'. " Transferência entre centros

        lt_mensagem = NEW zclmm_cockpit_transf(  )->exec_transf(
          is_input =  VALUE #(
            guid              = ls_cockpit-guid
            tipo_operacao     = ls_cockpit-tipooperacao
            processo          = ls_cockpit-processo
            centro_fornecedor = ls_cockpit-werks_origem
            centro_destino    = ls_cockpit-werks_destino
            centro_receptor   = ls_cockpit-werks_receptor
            deposito_destino  = ls_cockpit-lgort_destino
            deposito_origem   = ls_cockpit-lgort_origem
            itens             = VALUE #( FOR ls_material IN lt_material
                                         ( material   = ls_material-material
                                           quantidade = ls_material-qtdsol
                                           unidade    = ls_material-materialbaseunit ) )
            modalidade_frete = ls_cockpit-tpfrete
            agente_frete     = ls_cockpit-agfrete
            placa            = ls_cockpit-ztraid
            tipo_exped       = ls_cockpit-tpexp
            cond_exped       = ls_cockpit-condexp
            motorista        = ls_cockpit-motora
            texto_nfe        = COND #( WHEN ls_cockpit-txtnf IS NOT INITIAL
                                       THEN VALUE #( BASE lt_text ( line = ls_cockpit-txtnf ) ) )
            texto_geral      = COND #( WHEN ls_cockpit-txtgeral IS NOT INITIAL
                                       THEN VALUE #( BASE lt_text ( line = ls_cockpit-txtgeral ) ) )
            org_compras      = ls_cockpit-ekorg
            grp_comp         = ls_cockpit-ekgrp
            abrvw            = ls_cockpit-abrvw
            remessa_origem   = ls_cockpit-remessaorigem )
          is_continuar = abap_false ).

    ENDCASE.

    IF NOT line_exists( lt_mensagem[ type = lc_erro ] ). "#EC CI_STDSEQ

      SELECT FROM ztsd_interc_item
        FIELDS guid,
               material,
               materialbaseunit,
               qtdsol
        WHERE guid = @ls_cockpit-guid
        ORDER BY guid, material, materialbaseunit
        INTO CORRESPONDING FIELDS OF TABLE @lt_items.

      IF sy-subrc EQ 0.

        LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<fs_item>).

          READ TABLE lt_material TRANSPORTING NO FIELDS
            WITH KEY guid             = <fs_item>-guid
                     material         = <fs_item>-material
                     materialbaseunit = <fs_item>-materialbaseunit BINARY SEARCH.
          CHECK sy-subrc NE 0.

          APPEND <fs_item> TO lt_delete_items.

        ENDLOOP.

        IF lt_delete_items IS NOT INITIAL.

          DELETE ztsd_interc_item FROM TABLE @lt_delete_items.

        ENDIF.

      ELSE.

        MODIFY ztsd_interc_item FROM TABLE @(
          VALUE #( FOR ls_material IN lt_material (
            guid             = ls_material-guid
            material         = ls_material-material
            materialbaseunit = ls_material-materialbaseunit
            qtdsol           = ls_material-qtdsol ) ) ).

      ENDIF.

    ELSE.

      APPEND VALUE #( %tky = keys[ 1 ]-%tky ) TO failed-IntercompanyUpload.

    ENDIF.

    reported-IntercompanyUpload = VALUE #(
      FOR ls_mensagem IN lt_mensagem (
        %msg = new_message( id       = ls_mensagem-id
                            number   = ls_mensagem-number
                            severity = COND #( WHEN ls_mensagem-type = 'W'
                                               THEN if_abap_behv_message=>severity-information
                                               ELSE CONV #( ls_mensagem-type ) )
                            v1       = ls_mensagem-message_v1
                            v2       = ls_mensagem-message_v2
                            v3       = ls_mensagem-message_v3
                            v4       = ls_mensagem-message_v4 ) ) ) .

  ENDMETHOD.

  METHOD get_features.
    RETURN.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_ZI_INTERC_UPLOAD DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_ZI_INTERC_UPLOAD IMPLEMENTATION.

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
