CLASS lcl_cockpit DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
    "! Método que realiza processo em background
    "! @parameter P_TASK        | Parâmentro standard
    METHODS task_finish
      IMPORTING
        !p_task TYPE clike .
    DATA gt_return TYPE bapiret2_t .
    DATA gv_wait_async TYPE xfeld .
  PRIVATE SECTION.

    METHODS valida_entrada FOR VALIDATE ON SAVE
      IMPORTING keys FOR cockpit~valida_entrada.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR cockpit RESULT result.

    METHODS continuarpro FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~continuarpro.

    METHODS criarfrete FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~criarfrete.

    METHODS defbloqueio FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~defbloqueio.

    METHODS retbloqueio FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~retbloqueio.

    METHODS entradamercadoria FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~entradamercadoria.

    METHODS estornarsaida FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~estornarsaida.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR cockpit RESULT result.
    METHODS validacampos FOR VALIDATE ON SAVE
      IMPORTING keys FOR cockpit~validacampos.

    METHODS continuar_processo IMPORTING is_input         TYPE zssd_ordem_intercompany
                                         is_continuar     TYPE char1
                               RETURNING VALUE(rt_return) TYPE bapiret2_t.
    METHODS valida_int4 IMPORTING is_input         TYPE zssd_ordem_intercompany
                        RETURNING VALUE(rt_result) TYPE bapiret2_t.


ENDCLASS.

CLASS lcl_cockpit IMPLEMENTATION.

  METHOD valida_entrada.

    CONSTANTS gc_param_mod         TYPE ze_param_modulo  VALUE 'SD' ##NO_TEXT.
    CONSTANTS gc_chave1            TYPE ze_param_chave   VALUE 'ADM_INTER' ##NO_TEXT.
    CONSTANTS gc_chave2_exped      TYPE ze_param_chave   VALUE 'TP_EXPED' ##NO_TEXT.
    CONSTANTS gc_chave3_frota_prop TYPE ze_param_chave_3 VALUE 'FRT_PROP' ##NO_TEXT.
    CONSTANTS gc_chave2_fr         TYPE ze_param_chave   VALUE 'FROTA_PROPRIA' ##NO_TEXT.
    CONSTANTS gc_chave3_fr         TYPE ze_param_chave_3 VALUE 'AGTE_FRT' ##NO_TEXT.
    CONSTANTS gc_fn                TYPE ze_param_chave   VALUE 'FN' ##NO_TEXT.
    CONSTANTS gc_fp                TYPE ze_param_chave_3 VALUE 'FP' ##NO_TEXT.

    DATA: lr_tpexp           TYPE RANGE OF vsarttr,
          lr_agfrt           TYPE RANGE OF kunnr,
          lv_cgc_agfrete     TYPE j_1bcgc,
          lv_cgc_agfrete_out TYPE char18,
          lv_cgc_number      TYPE j_1bcgc,
          lv_cgc_number_out  TYPE char18.

    READ ENTITIES OF zi_sd_01_cockpit IN LOCAL MODE
      ENTITY cockpit
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit)
      FAILED DATA(ls_failed).

    READ TABLE lt_cockpit INTO DATA(ls_cockpit) INDEX 1.


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

      reported-cockpit = VALUE #( BASE reported-cockpit ( %element-processo = if_abap_behv=>mk-on
                                                          %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                                                              number   = '019'
                                                                              severity = CONV #( 'E' )
                                                                              v1 = |"{ lv_tipo_operacao } ({ ls_cockpit-tipooperacao })"|
                                                                              v2 = |"{ lv_processo } ({ ls_cockpit-processo })"| ) ) ).
      RETURN.
    ENDIF.

    IF ls_cockpit-processo IS INITIAL.
      reported-cockpit = VALUE #( BASE reported-cockpit ( %element-processo = if_abap_behv=>mk-on
                                                          %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                                                              number   = '016'
                                                                              severity = CONV #( 'E' ) ) ) ).
      RETURN.
    ENDIF.

    IF ls_cockpit-werks_origem IS INITIAL.
      reported-cockpit = VALUE #( BASE reported-cockpit ( %element-werks_origem = if_abap_behv=>mk-on
                                                          %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                                                              number   = '023'
                                                                              severity = CONV #( 'E' ) ) ) ).
      RETURN.
    ENDIF.

    IF ls_cockpit-lgort_origem IS INITIAL.
      reported-cockpit = VALUE #( BASE reported-cockpit ( %element-lgort_origem = if_abap_behv=>mk-on
                                                          %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                                                              number   = '014'
                                                                              severity = CONV #( 'E' ) ) ) ).
      RETURN.
    ENDIF.

    IF ls_cockpit-werks_destino IS INITIAL.
      reported-cockpit = VALUE #( BASE reported-cockpit ( %element-werks_destino = if_abap_behv=>mk-on
                                                          %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                                                              number   = '024'
                                                                              severity = CONV #( 'E' ) ) ) ).
      RETURN.
    ENDIF.

    IF ls_cockpit-lgort_destino IS INITIAL.
      reported-cockpit = VALUE #( BASE reported-cockpit ( %element-lgort_destino = if_abap_behv=>mk-on
                                                          %msg = new_message( id       = 'ZSD_INTERCOMPANY'
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
      reported-cockpit = VALUE #( BASE reported-cockpit ( %element-lgort_origem = if_abap_behv=>mk-on
                                                          %msg = new_message( id       = 'ZSD_INTERCOMPANY'
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
      reported-cockpit = VALUE #( BASE reported-cockpit ( %element-lgort_destino = if_abap_behv=>mk-on
                                                          %msg = new_message( id       = 'ZSD_INTERCOMPANY'
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
        reported-cockpit = VALUE #( BASE reported-cockpit ( %element-werks_origem  = if_abap_behv=>mk-on
                                                            %element-werks_destino = if_abap_behv=>mk-on
                                                            %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                                                                number   = '027'
                                                                                severity = CONV #( 'E' ) ) ) ).
        RETURN.
      ENDIF.

      IF ls_cockpit-tipooperacao <> 'TRA2'.
        SELECT COUNT( * )
          FROM ztsd_centrofatdf
          UP TO 1 ROWS
          WHERE centrofaturamento EQ @ls_cockpit-werks_origem.
        IF  sy-subrc IS INITIAL.
          reported-cockpit = VALUE #( BASE reported-cockpit ( %element-werks_receptor = if_abap_behv=>mk-on
                                                              %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                                                                  number   = '050'
                                                                                  severity = CONV #( 'E' ) ) ) ).
          RETURN.
        ENDIF.

        SELECT COUNT( * )
          FROM ztsd_centrofatdf
          UP TO 1 ROWS
          WHERE centrofaturamento EQ @ls_cockpit-werks_destino.
        IF  sy-subrc IS INITIAL.
          reported-cockpit = VALUE #( BASE reported-cockpit ( %element-werks_receptor = if_abap_behv=>mk-on
                                                              %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                                                                  number   = '049'
                                                                                  severity = CONV #( 'E' ) ) ) ).
          RETURN.
        ENDIF.
      ENDIF.

      IF ls_cockpit-tipooperacao EQ 'TRA2'.
        SELECT SINGLE centrodepfechado
          FROM ztsd_centrofatdf
          INTO @DATA(lv_dep_fechado)
          WHERE centrofaturamento EQ @ls_cockpit-werks_destino.
        IF  sy-subrc IS INITIAL
        AND ls_cockpit-werks_receptor IS INITIAL.
          reported-cockpit = VALUE #( BASE reported-cockpit ( %element-werks_receptor = if_abap_behv=>mk-on
                                                              %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                                                                  number   = '028'
                                                                                  severity = CONV #( 'E' ) ) ) ).
          RETURN.
        ENDIF.

        SELECT COUNT( * ) FROM ztsd_centrofatdf UP TO 1 ROWS
          WHERE centrodepfechado EQ @ls_cockpit-werks_origem.
        IF  sy-subrc IS INITIAL.
          reported-cockpit = VALUE #( BASE reported-cockpit ( %element-werks_origem = if_abap_behv=>mk-on
                                                              %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                                                                  number   = '029'
                                                                                  severity = CONV #( 'E' )
                                                                                  v1       = TEXT-t01 ) ) ).
          RETURN.
        ENDIF.

        SELECT COUNT( * ) FROM ztsd_centrofatdf UP TO 1 ROWS
          WHERE centrodepfechado EQ @ls_cockpit-werks_destino.
        IF  sy-subrc IS INITIAL.
          reported-cockpit = VALUE #( BASE reported-cockpit ( %element-werks_destino = if_abap_behv=>mk-on
                                                              %msg = new_message( id       = 'ZSD_INTERCOMPANY'
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
            reported-cockpit = VALUE #( BASE reported-cockpit ( %element-werks_destino = if_abap_behv=>mk-on
                                                        %msg = new_message( id       = 'ZSD_INTERCOMPANY'
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

      reported-cockpit = VALUE #( BASE reported-cockpit ( %element-werks_receptor = if_abap_behv=>mk-on
                                                          %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                                                              number   = '010'
                                                                              severity = CONV #( 'E' ) ) ) ).
      RETURN.
    ENDIF.

    IF ls_cockpit-tipooperacao EQ 'INT2' .

      IF ls_cockpit-werks_receptor IS INITIAL.

        reported-cockpit = VALUE #( BASE reported-cockpit ( %element-werks_receptor = if_abap_behv=>mk-on
                                                            %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                                                                number   = '010'
                                                                                severity = CONV #( 'E' ) ) ) ).
        RETURN.
      ELSE.
        SELECT COUNT(*)
        FROM ztsd_centrofatdf
        WHERE centrofaturamento EQ ls_cockpit-werks_destino
        AND   centrodepfechado  EQ ls_cockpit-werks_receptor
        .
        IF sy-subrc IS NOT INITIAL.

          reported-cockpit = VALUE #( BASE reported-cockpit ( %element-werks_destino = if_abap_behv=>mk-on
                                                      %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                                                          number   = '040'
                                                                          severity = CONV #( 'E' )
                                                                          v1       = ls_cockpit-werks_destino ) ) ).
          RETURN.

        ENDIF.
      ENDIF.
    ENDIF.

*    IF ( ls_cockpit-tipooperacao EQ ' ' )
*    AND ls_cockpit-werks_receptor IS INITIAL.
*
*      reported-cockpit = VALUE #( BASE reported-cockpit ( %element-tipooperacao = if_abap_behv=>mk-on
*                                                          %msg = new_message( id       = 'ZSD_INTERCOMPANY'
*                                                                              number   = '011'
*                                                                              severity = CONV #( 'E' ) ) ) ).
*      RETURN.
*    ENDIF.

    IF ls_cockpit-tpfrete IS INITIAL.
      reported-cockpit = VALUE #( BASE reported-cockpit ( %element-tpfrete = if_abap_behv=>mk-on
                                                          %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                                                              number   = '025'
                                                                              severity = CONV #( 'E' ) ) ) ).
      RETURN.
    ENDIF.

    IF ls_cockpit-condexp IS INITIAL.
      reported-cockpit = VALUE #( BASE reported-cockpit ( %element-condexp = if_abap_behv=>mk-on
                                                          %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                                                              number   = '026'
                                                                              severity = CONV #( 'E' ) ) ) ).
      RETURN.
    ENDIF.

    IF ls_cockpit-tpfrete EQ '001'  " CIF
    OR ls_cockpit-tpfrete EQ '002'. " FOB

      DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 22.07.2023

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
        reported-cockpit = VALUE #( BASE reported-cockpit (
          %element-tpexp   = COND #( WHEN ls_cockpit-tpexp   IS INITIAL
                                     THEN if_abap_behv=>mk-on )
          %element-agfrete = COND #( WHEN ls_cockpit-agfrete IS INITIAL
                                     THEN if_abap_behv=>mk-on )
          %element-motora  = COND #( WHEN ls_cockpit-motora IS INITIAL
                                      AND ls_cockpit-tpexp  IN lr_tpexp
                                     THEN if_abap_behv=>mk-on )
          %element-ztraid  = COND #( WHEN ls_cockpit-ztraid  IS INITIAL
                                     THEN if_abap_behv=>mk-on )
          %msg     = new_message(
            id       = 'ZSD_INTERCOMPANY'
            number   = '008'
            severity = CONV #( 'E' ) ) ) ).
        RETURN.
      ENDIF.

*      TRY.
*          lo_param->m_get_range(
*            EXPORTING
*              iv_modulo = gc_param_mod
*              iv_chave1 = gc_chave1
*              iv_chave2 = gc_chave2_fr
*              iv_chave3 = gc_chave3_fr
*            IMPORTING
*              et_range  = lr_agfrt ).
*        CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros
*      ENDTRY.
*
*      IF ls_cockpit-tpexp = gc_fn
*      AND ls_cockpit-agfrete IN lr_agfrt.
*
*        reported-cockpit = VALUE #( BASE reported-cockpit ( %element-tpfrete = if_abap_behv=>mk-on
*                                                            %msg = new_message( id       = 'ZSD_INTERCOMPANY'
*                                                                                number   = '044'
*                                                                                severity = CONV #( 'E' ) ) ) ).
*
*      ENDIF.
*
*      IF ls_cockpit-tpexp = gc_fp
*      AND NOT ls_cockpit-agfrete IN lr_agfrt.
*
*        reported-cockpit = VALUE #( BASE reported-cockpit ( %element-tpfrete = if_abap_behv=>mk-on
*                                                            %msg = new_message( id       = 'ZSD_INTERCOMPANY'
*                                                                                number   = '045'
*                                                                                severity = CONV #( 'E' ) ) ) ).
*
*      ENDIF.

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
            reported-cockpit = VALUE #( BASE reported-cockpit ( %element-werks_origem = if_abap_behv=>mk-on
                                                                %element-tpfrete      = if_abap_behv=>mk-on
                                                                %element-agfrete      = if_abap_behv=>mk-on
                                                                %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                                                                    number   = '004'
                                                                                    severity = CONV #( 'E' )
                                                                                    v1       = lv_cgc_agfrete_out
                                                                                    v2       = lv_cgc_number_out ) ) ).
            RETURN.
          ENDIF.
        ELSE.
          IF ls_lfa1-stcd1 EQ lv_cgc_number.
            reported-cockpit = VALUE #( BASE reported-cockpit ( %element-werks_origem = if_abap_behv=>mk-on
                                                                %element-tpfrete      = if_abap_behv=>mk-on
                                                                %element-agfrete      = if_abap_behv=>mk-on
                                                                %msg = new_message( id       = 'ZSD_INTERCOMPANY'
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
            reported-cockpit = VALUE #( BASE reported-cockpit ( %element-werks_destino = if_abap_behv=>mk-on
                                                                %element-tpfrete       = if_abap_behv=>mk-on
                                                                %element-agfrete       = if_abap_behv=>mk-on
                                                                %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                                                                    number   = '006'
                                                                                    severity = CONV #( 'E' )
                                                                                    v1       = lv_cgc_agfrete_out
                                                                                    v2       = lv_cgc_number_out ) ) ).
            RETURN.
          ENDIF.
        ELSE.
          IF ls_lfa1-stcd1 EQ lv_cgc_number.
            reported-cockpit = VALUE #( BASE reported-cockpit ( %element-werks_destino = if_abap_behv=>mk-on
                                                                %element-tpfrete       = if_abap_behv=>mk-on
                                                                %element-agfrete       = if_abap_behv=>mk-on
                                                                %msg = new_message( id       = 'ZSD_INTERCOMPANY'
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
*        OR ls_cockpit-condexp IS NOT INITIAL
        OR ls_cockpit-motora  IS NOT INITIAL
        OR ls_cockpit-ztraid  IS NOT INITIAL
        OR ls_cockpit-ztrai1  IS NOT INITIAL
        OR ls_cockpit-ztrai2  IS NOT INITIAL
        OR ls_cockpit-ztrai3  IS NOT INITIAL
        OR ls_cockpit-idsaga  IS NOT INITIAL.

          reported-cockpit = VALUE #( BASE reported-cockpit (
            %element-agfrete = COND #( WHEN ls_cockpit-agfrete IS NOT INITIAL THEN if_abap_behv=>mk-on )
            %element-tpexp   = COND #( WHEN ls_cockpit-tpexp   IS NOT INITIAL THEN if_abap_behv=>mk-on )
*            %element-condexp = COND #( WHEN ls_cockpit-condexp IS NOT INITIAL THEN if_abap_behv=>mk-on )
            %element-motora  = COND #( WHEN ls_cockpit-motora  IS NOT INITIAL THEN if_abap_behv=>mk-on )
            %element-ztraid  = COND #( WHEN ls_cockpit-ztraid  IS NOT INITIAL THEN if_abap_behv=>mk-on )
            %element-ztrai1  = COND #( WHEN ls_cockpit-ztrai1  IS NOT INITIAL THEN if_abap_behv=>mk-on )
            %element-ztrai2  = COND #( WHEN ls_cockpit-ztrai2  IS NOT INITIAL THEN if_abap_behv=>mk-on )
            %element-ztrai3  = COND #( WHEN ls_cockpit-ztrai3  IS NOT INITIAL THEN if_abap_behv=>mk-on )
            %element-idsaga  = COND #( WHEN ls_cockpit-idsaga  IS NOT INITIAL THEN if_abap_behv=>mk-on )
            %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                number   = '009'
                                severity = CONV #( 'E' ) ) ) ).
          RETURN.

        ENDIF.

    ENDCASE.


    IF ls_cockpit-ztraid IS NOT INITIAL.
      SELECT COUNT(*) FROM zi_sd_vh_placas WHERE placa = @ls_cockpit-ztraid.
      IF sy-subrc <> 0.
        reported-cockpit = VALUE #(
          BASE reported-cockpit (
          %element-ztraid  = if_abap_behv=>mk-on
          %msg     = new_message(
            id       = 'ZSD_INTERCOMPANY'
            number   = '043'
            severity = CONV #( 'E' ) ) ) ).
        RETURN.
      ENDIF.
    ENDIF.
    IF ls_cockpit-tpfrete IS NOT INITIAL.
      SELECT COUNT(*) FROM zi_ca_vh_mdfrete WHERE mdfrete = @ls_cockpit-tpfrete.
      IF sy-subrc <> 0.
        reported-cockpit = VALUE #(
          BASE reported-cockpit (
          %element-tpfrete  = if_abap_behv=>mk-on
          %msg     = new_message(
            id       = 'ZSD_INTERCOMPANY'
            number   = '043'
            severity = CONV #( 'E' ) ) ) ).
        RETURN.
      ENDIF.
    ENDIF.
    IF ls_cockpit-tpexp IS NOT INITIAL.
      SELECT COUNT(*) FROM zi_ca_vh_vsart WHERE tipoexpedicao = @ls_cockpit-tpexp.
      IF sy-subrc <> 0.
        reported-cockpit = VALUE #(
          BASE reported-cockpit (
          %element-tpexp  = if_abap_behv=>mk-on
          %msg     = new_message(
            id       = 'ZSD_INTERCOMPANY'
            number   = '043'
            severity = CONV #( 'E' ) ) ) ).
        RETURN.
      ENDIF.
    ENDIF.
    IF ls_cockpit-ztrai1 IS NOT INITIAL.
      SELECT COUNT(*) FROM zi_sd_vh_placas WHERE placa = @ls_cockpit-ztrai1.
      IF sy-subrc <> 0.
        reported-cockpit = VALUE #(
          BASE reported-cockpit (
          %element-ztrai1  = if_abap_behv=>mk-on
          %msg     = new_message(
            id       = 'ZSD_INTERCOMPANY'
            number   = '043'
            severity = CONV #( 'E' ) ) ) ).
        RETURN.
      ENDIF.
    ENDIF.
    IF ls_cockpit-ztrai2 IS NOT INITIAL.
      SELECT COUNT(*) FROM zi_sd_vh_placas WHERE placa = @ls_cockpit-ztrai2.
      IF sy-subrc <> 0.
        reported-cockpit = VALUE #(
          BASE reported-cockpit (
          %element-ztrai2  = if_abap_behv=>mk-on
          %msg     = new_message(
            id       = 'ZSD_INTERCOMPANY'
            number   = '043'
            severity = CONV #( 'E' ) ) ) ).
        RETURN.
      ENDIF.
    ENDIF.
    IF ls_cockpit-ztrai3 IS NOT INITIAL.
      SELECT COUNT(*) FROM zi_sd_vh_placas WHERE placa = @ls_cockpit-ztrai3.
      IF sy-subrc <> 0.
        reported-cockpit = VALUE #(
          BASE reported-cockpit (
          %element-ztrai3  = if_abap_behv=>mk-on
          %msg     = new_message(
            id       = 'ZSD_INTERCOMPANY'
            number   = '043'
            severity = CONV #( 'E' ) ) ) ).
        RETURN.
      ENDIF.
    ENDIF.

    IF ls_cockpit-processo EQ '1'.
      IF ls_cockpit-ekorg IS INITIAL.
        reported-cockpit = VALUE #( BASE reported-cockpit ( %element-ekorg = if_abap_behv=>mk-on
                                                            %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                                                                number   = '012'
                                                                                severity = CONV #( 'E' ) ) ) ).
        RETURN.
      ENDIF.

      IF ls_cockpit-ekgrp IS INITIAL.
        reported-cockpit = VALUE #( BASE reported-cockpit ( %element-ekgrp = if_abap_behv=>mk-on
                                                            %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                                                                number   = '013'
                                                                                severity = CONV #( 'E' ) ) ) ).
        RETURN.
      ENDIF.

      IF  ls_cockpit-tipooperacao EQ 'TRA7'.
        IF ls_cockpit-remessaorigem IS INITIAL.
          reported-cockpit = VALUE #( BASE reported-cockpit ( %element-remessaorigem = if_abap_behv=>mk-on
                                                              %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                                                                  number   = '017'
                                                                                  severity = CONV #( 'E' ) ) ) ).
          RETURN.
        ENDIF.
      ENDIF.

      IF ls_cockpit-remessaorigem IS NOT INITIAL.
        SELECT SINGLE COUNT( * ) FROM likp
          WHERE vbeln EQ @ls_cockpit-remessaorigem.
        IF sy-subrc NE 0.
          reported-cockpit = VALUE #( BASE reported-cockpit ( %element-remessaorigem = if_abap_behv=>mk-on
                                                              %msg = new_message( id       = 'ZSD_INTERCOMPANY'
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

        reported-cockpit = VALUE #( BASE reported-cockpit (  %element-werks_origem  = if_abap_behv=>mk-on
                                                             %element-werks_destino = if_abap_behv=>mk-on
                                                             %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                                                                 number   = '030'
                                                                                 severity = CONV #( 'E' ) ) ) ).
        RETURN.


      ENDIF.


      IF ls_cockpit-tipooperacao EQ 'INT7'.
        IF ls_cockpit-abrvw IS INITIAL.
          reported-cockpit = VALUE #( BASE reported-cockpit ( %element-abrvw = if_abap_behv=>mk-on
                                                              %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                                                                                  number   = '039'
                                                                                  severity = CONV #( 'E' ) ) ) ).
          RETURN.
        ENDIF.
      ENDIF.

    ENDIF.



*    DATA(lo_object) = NEW zclsd_app_ordem_intercompany( ).
*    lo_object->valida_criacao( EXPORTING is_cockpit = CORRESPONDING #( ls_cockpit )
*                               IMPORTING et_message = DATA(lt_mensagem) ).
*
*    reported-cockpit = VALUE #( FOR ls_mensagem IN lt_mensagem
*      (  %msg = new_message( id       = ls_mensagem-id
*                             number   = ls_mensagem-number
*                             severity = CONV #( ls_mensagem-type )
*                             v1       = ls_mensagem-message_v1
*                             v2       = ls_mensagem-message_v2
*                             v3       = ls_mensagem-message_v3
*                             v4       = ls_mensagem-message_v4 ) ) ) .

  ENDMETHOD.

  METHOD get_authorizations.

    READ ENTITIES OF zi_sd_01_cockpit IN LOCAL MODE
       ENTITY cockpit
       ALL FIELDS WITH CORRESPONDING #( keys )
       RESULT DATA(lt_data)
       FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclsd_auth_zsdwerks=>werks_update( <fs_data>-werks_origem ).
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.

        IF zclsd_auth_zsdwerks=>werks_update( <fs_data>-werks_origem ).
          lv_delete = if_abap_behv=>auth-allowed.
        ELSE.
          lv_delete = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      APPEND VALUE #( %tky = <fs_data>-%tky
                      %update = lv_update
                      %delete = lv_delete )
             TO result.

    ENDLOOP.

  ENDMETHOD.

  METHOD continuarpro.
*    TYPES: ty_item TYPE STANDARD TABLE OF zssd_ordem_inter_items WITH DEFAULT KEY.
*
    DATA: "lt_result TYPE STANDARD TABLE OF zi_sd_01_cockpit,
          lt_text   TYPE STANDARD TABLE OF zssd_ordem_inter_text.

    READ ENTITIES OF zi_sd_01_cockpit IN LOCAL MODE ENTITY cockpit
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit)
      FAILED failed.


*    LOOP AT lt_cockpit ASSIGNING FIELD-SYMBOL(<fs_cockpit>).
*
*      IF <fs_cockpit>-tipooperacao = 'INT4'.
*
*        IF <fs_cockpit>-correspncexternalreference IS NOT INITIAL.
*          " Segunda etapa já realizada. Documento: &1
*          APPEND VALUE #( %tky = <fs_cockpit>-%tky
*                          %msg = new_message( id       = 'ZSD_INTERCOMPANY'
*                                              number   = 031
*                                              severity = CONV #( 'E' )
*                                              v1       = <fs_cockpit>-correspncexternalreference ) ) TO reported-cockpit.
*          RETURN.
*        ENDIF.
*
*        IF <fs_cockpit>-salesorder2 IS NOT INITIAL.
*          " Segunda etapa já realizada. Documento: &1
*          APPEND VALUE #( %tky     = <fs_cockpit>-%tky
*                          %msg     = new_message( id       = 'ZSD_INTERCOMPANY'
*                                                  number   = 031
*                                                  severity = CONV #( 'E' )
*                                                  v1       = <fs_cockpit>-salesorder2 ) ) TO reported-cockpit.
*          RETURN.
*        ENDIF.
*
*      ENDIF.
*
*      IF <fs_cockpit>-br_nfedocumentstatus NE '1'.
*        " NFe de saída não autorizada.
*        APPEND VALUE #( %tky     = <fs_cockpit>-%tky
*                        %msg     = new_message( id       = 'ZSD_INTERCOMPANY'
*                                                number   = 036
*                                                severity = CONV #( 'E' )
*                                                v1       = <fs_cockpit>-br_nfenumber ) ) TO reported-cockpit.
*        RETURN.
*      ENDIF.
*
*    ENDLOOP.

    reported-cockpit = VALUE #(
      FOR ls_cockpit  IN lt_cockpit
      FOR ls_mensagem IN continuar_processo(
        is_input = VALUE #(
          guid              = ls_cockpit-guid
          processo          = ls_cockpit-processo
          tipo_operacao     = ls_cockpit-tipooperacao
          centro_fornecedor = ls_cockpit-werks_origem
          centro_destino    = ls_cockpit-werks_destino
          centro_receptor   = ls_cockpit-werks_receptor
          deposito_destino  = ls_cockpit-lgort_destino
          deposito_origem   = ls_cockpit-lgort_origem
*          itens             = VALUE #( FOR ls_material IN lt_material
*                                       ( material   = ls_material-material
*                                         quantidade = ls_material-qtdsol
*                                         unidade    = ls_material-materialbaseunit ) )
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
          nota_saida       = ls_cockpit-br_notafiscal
          nfe_saida        = ls_cockpit-br_nfenumber
          nfe_status       = ls_cockpit-br_nfedocumentstatus
          acckey           = ls_cockpit-chaveacesso
          pedido1          = ls_cockpit-purchaseorder
          ordem_venda1     = ls_cockpit-salesorder
          pedido2          = ls_cockpit-correspncexternalreference
          ordem_venda2     = ls_cockpit-salesorder2
*          NOTA_ENTRADA     =
          remessa_origem   = ls_cockpit-remessaorigem )
        is_continuar = abap_true )

        ( %msg = new_message( id       = ls_mensagem-id
                              number   = ls_mensagem-number
                              severity = COND #( WHEN ls_mensagem-type = 'W' THEN CONV #( 'I' ) ELSE CONV #( ls_mensagem-type ) )
                              v1       = ls_mensagem-message_v1
                              v2       = ls_mensagem-message_v2
                              v3       = ls_mensagem-message_v3
                              v4       = ls_mensagem-message_v4 ) ) ).

  ENDMETHOD.

  METHOD criarfrete.

    DATA: lt_result TYPE STANDARD TABLE OF zi_sd_01_cockpit.

    READ ENTITIES OF zi_sd_01_cockpit IN LOCAL MODE ENTITY cockpit
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit)
      FAILED failed.



    reported-cockpit = VALUE #(
*      FOR ls_log IN NEW zclsd_process_of( )->execute(
*        VALUE #( FOR ls_result IN lt_cockpit (
*                   guid          = ls_result-guid
*                   processo      = ls_result-processo
*                   tipooperacao  = ls_result-tipooperacao
*                   werks_origem  = ls_result-werks_origem
*                   werks_destino = ls_result-werks_destino
*                   lgort_origem  = ls_result-lgort_origem
*                   lgort_destino = ls_result-lgort_destino
*                   tpfrete       = ls_result-tpfrete
*                   agfrete       = ls_result-agfrete
*                   ztraid        = ls_result-ztraid
*                   tpexp         = ls_result-tpexp
*                   condexp       = ls_result-condexp
*                   motora        = ls_result-motora
*                   txtnf         = ls_result-txtnf
*                   txtgeral      = ls_result-txtgeral ) ) )
      FOR ls_log IN NEW zclsd_criar_ordem_frete( )->executar( it_remessa = CORRESPONDING #( lt_cockpit ) )
        ( %msg = new_message( id       = ls_log-msgid
                              number   = ls_log-msgno
                              severity = CONV #( ls_log-msgty )
                              v1       = ls_log-msgv1
                              v2       = ls_log-msgv2
                              v3       = ls_log-msgv3
                              v4       = ls_log-msgv4 ) ) ).

  ENDMETHOD.

  METHOD defbloqueio.
    DATA: lt_result TYPE STANDARD TABLE OF zi_sd_01_cockpit.

    READ ENTITIES OF zi_sd_01_cockpit ENTITY cockpit
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit)
      FAILED failed.

    reported-cockpit = VALUE #(
      FOR ls_result   IN lt_cockpit
      FOR ls_mensagem IN NEW zclsd_bloqueio(  )->execute(
        is_result = VALUE zi_sd_01_cockpit( docnuv  = ls_result-docnuv
                                            remessa = ls_result-remessa   )
        iv_bloqueio = VALUE #( keys[ 1 ]-%param-delivblockreason OPTIONAL ) )
      ( %msg = new_message( id       = ls_mensagem-id
                            number   = ls_mensagem-number
                            severity = CONV #( ls_mensagem-type )
                            v1       = ls_mensagem-message_v1
                            v2       = ls_mensagem-message_v2
                            v3       = ls_mensagem-message_v3
                            v4       = ls_mensagem-message_v4 ) ) ) .
  ENDMETHOD.

  METHOD retbloqueio.
    DATA: lt_result TYPE STANDARD TABLE OF zi_sd_01_cockpit.

    READ ENTITIES OF zi_sd_01_cockpit ENTITY cockpit
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit)
      FAILED failed.

    reported-cockpit = VALUE #(
      FOR ls_result   IN lt_cockpit
      FOR ls_mensagem IN NEW zclsd_bloqueio(  )->execute(
        is_result = VALUE zi_sd_01_cockpit( docnuv = ls_result-docnuv
        remessa   = ls_result-remessa   ) )
      ( %msg = new_message( id       = ls_mensagem-id
                            number   = ls_mensagem-number
                            severity = CONV #( ls_mensagem-type )
                            v1       = ls_mensagem-message_v1
                            v2       = ls_mensagem-message_v2
                            v3       = ls_mensagem-message_v3
                            v4       = ls_mensagem-message_v4 ) ) ).

  ENDMETHOD.

  METHOD entradamercadoria.
    DATA: lt_result TYPE STANDARD TABLE OF zi_sd_01_cockpit.

    READ ENTITIES OF zi_sd_01_cockpit ENTITY cockpit
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit)
      FAILED failed.

    reported-cockpit = VALUE #(
      FOR ls_result   IN lt_cockpit
      FOR ls_mensagem IN NEW zclmm_cockpit_transf(  )->exec_entr_merc_transf(
        iv_acckey = ls_result-chaveacesso
        iv_docnum = ls_result-br_notafiscal )
      ( %msg = new_message( id       = ls_mensagem-id
                            number   = ls_mensagem-number
                            severity = CONV #( ls_mensagem-type )
                            v1       = ls_mensagem-message_v1
                            v2       = ls_mensagem-message_v2
                            v3       = ls_mensagem-message_v3
                            v4       = ls_mensagem-message_v4 ) ) ).
  ENDMETHOD.

  METHOD get_features.
    DATA: ls_result LIKE LINE OF result.

    READ ENTITIES OF zi_sd_01_cockpit IN LOCAL MODE ENTITY cockpit
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit)
      FAILED failed.


    result = VALUE #( FOR ls_cockpit IN lt_cockpit
      LET
        lv_sintese = COND #( WHEN ls_cockpit-salesorder    IS NOT INITIAL
                               OR ls_cockpit-purchaseorder IS NOT INITIAL
                             THEN if_abap_behv=>fc-f-read_only
                             ELSE if_abap_behv=>fc-f-mandatory )

        lv_transporte = COND #( WHEN ls_cockpit-salesorder    IS NOT INITIAL
                                  OR ls_cockpit-purchaseorder IS NOT INITIAL
                                THEN if_abap_behv=>fc-f-read_only )

        lv_compras = COND #( WHEN ls_cockpit-salesorder    IS NOT INITIAL
                               OR ls_cockpit-purchaseorder IS NOT INITIAL
                             THEN if_abap_behv=>fc-f-read_only )

        lv_origem = COND #( WHEN ls_cockpit-salesorder    IS NOT INITIAL
                              OR ls_cockpit-purchaseorder IS NOT INITIAL
                            THEN if_abap_behv=>fc-f-read_only )

        lv_txtnf = COND #( WHEN ls_cockpit-salesorder    IS NOT INITIAL
                             OR ls_cockpit-purchaseorder IS NOT INITIAL
                           THEN if_abap_behv=>fc-f-read_only )

        lv_txtgeral = COND #( WHEN ls_cockpit-salesorder    IS NOT INITIAL
                                OR ls_cockpit-purchaseorder IS NOT INITIAL
                              THEN if_abap_behv=>fc-f-read_only )

      IN (
        guid    = ls_cockpit-guid
        %update = COND #( WHEN ls_cockpit-salesorder    IS NOT INITIAL
                            OR ls_cockpit-purchaseorder IS NOT INITIAL
                          THEN if_abap_behv=>fc-o-disabled )
        %delete = COND #( WHEN ls_cockpit-salesorder    IS NOT INITIAL
                            OR ls_cockpit-purchaseorder IS NOT INITIAL
                          THEN if_abap_behv=>fc-o-disabled )
        %action = VALUE #(
          continuarpro = COND #( WHEN ls_cockpit-tipooperacao NE 'INT4'
                                 THEN if_abap_behv=>fc-o-disabled )

          criarfrete   = COND #( WHEN ls_cockpit-tipooperacao EQ 'INT4'
                                 THEN if_abap_behv=>fc-o-disabled )

          defbloqueio  = COND #( WHEN ls_cockpit-remessa IS INITIAL
                                 THEN if_abap_behv=>fc-o-disabled )

          retbloqueio  = COND #( WHEN ls_cockpit-deliveryblockreason IS INITIAL
                                 THEN if_abap_behv=>fc-o-disabled )

          entradamercadoria = COND #( WHEN
*          ls_cockpit-tipooperacao NE 'TRA3'
*                                       AND
                                        ls_cockpit-tipooperacao NE 'TRA8'
                                      THEN if_abap_behv=>fc-o-disabled ) )

        %field = VALUE #(

          werks_origem   = lv_sintese
          lgort_origem   = lv_sintese
          werks_destino  = lv_sintese
          lgort_destino  = lv_sintese

          werks_receptor = COND #( WHEN ls_cockpit-salesorder    IS NOT INITIAL
                                     OR ls_cockpit-purchaseorder IS NOT INITIAL
                                   THEN if_abap_behv=>fc-f-read_only )

          tpfrete        = lv_transporte
          motora         = lv_transporte
          tpexp          = lv_transporte
          condexp        = lv_transporte
          agfrete        = lv_transporte
          ztraid         = lv_transporte
          ztrai1         = lv_transporte
          ztrai2         = lv_transporte
          ztrai3         = lv_transporte
          idsaga         = lv_transporte

          ekorg          = lv_compras
          ekgrp          = lv_compras

          abrvw          = lv_compras
          remessaorigem  = lv_origem

          txtnf          = lv_txtnf
          txtgeral       = lv_txtgeral

          fracionado     = lv_sintese ) ) ).

  ENDMETHOD.

  METHOD continuar_processo.

    IF is_input-tipo_operacao EQ 'INT4'.
      rt_return = valida_int4( is_input ).
      IF line_exists( rt_return[ type = 'E' ] ).
        RETURN.
      ENDIF.

      rt_return = NEW zclmm_cockpit_transf( )->check_lanc_entr_merc( is_input-pedido1 ).
      IF line_exists( rt_return[ type = 'E' ] ).

*        rt_return = NEW zclmm_cockpit_transf( )->exec_lanc_entr_merc_grc(
*            iv_acckey = is_input-acckey
*            iv_docnum = CONV #( is_input-nota_saida ) ).
*        IF rt_return IS NOT INITIAL.
*          RETURN.
*        ENDIF.

        rt_return = NEW zclmm_cockpit_transf( )->exec_lanc_entr_merc( is_input ).
        IF line_exists( rt_return[ type = 'E' ] ).
          RETURN.
        ENDIF.

      ENDIF.

      rt_return = NEW zclmm_cockpit_transf( )->check_lanc_entr_merc( is_input-pedido1 ).
      IF line_exists( rt_return[ type = 'E' ] ).
        RETURN.
      ENDIF.

      rt_return = NEW zclmm_cockpit_transf( )->check_lanc_fat_receb( is_input-pedido1 ).
      IF line_exists( rt_return[ type = 'E' ] ).

*        rt_return = NEW zclmm_cockpit_transf( )->exec_lanc_fat_receb_grc(
*            iv_acckey = is_input-acckey
*            iv_docnum = CONV #( is_input-nota_saida ) ).
*        IF rt_return IS NOT INITIAL.
*          RETURN.
*        ENDIF.

        rt_return = NEW zclmm_cockpit_transf( )->exec_lanc_fat_receb( is_input ).
        IF line_exists( rt_return[ type = 'E' ] ).
          RETURN.
        ENDIF.

      ENDIF.

      rt_return = NEW zclmm_cockpit_transf( )->check_lanc_fat_receb( is_input-pedido1 ).
      IF line_exists( rt_return[ type = 'E' ] ).
        RETURN.
      ENDIF.

      rt_return = NEW zclmm_cockpit_transf( )->exec_2_steps( is_input ).
    ENDIF.

*    IF is_input-tipo_operacao EQ 'TRA3'
*    OR is_input-tipo_operacao EQ 'INT4'.
*      rt_return = NEW zclmm_cockpit_transf(  )->exec_2_steps( is_input ).
**    ELSE.
**      rt_return = NEW zclsd_cria_ordem_intercompany(  )->execute(
**                  is_input     = is_input
**                  is_continuar = abap_true ).
*    ENDIF.
  ENDMETHOD.


  METHOD valida_int4.

    IF is_input-pedido2 IS NOT INITIAL.
      " Segunda etapa já realizada. Documento: &1

      APPEND VALUE #( id         = 'ZSD_INTERCOMPANY'
                      number     = 031
                      type       = 'E'
                      message_v1 = is_input-pedido2 ) TO rt_result.
      RETURN.
    ENDIF.

    IF is_input-ordem_venda2 IS NOT INITIAL.
      " Segunda etapa já realizada. Documento: &1
      APPEND VALUE #( id         = 'ZSD_INTERCOMPANY'
                      number     = 031
                      type       = 'E'
                      message_v1 = is_input-ordem_venda2 ) TO rt_result.
      RETURN.
    ENDIF.


    IF is_input-nfe_status NE '1'.
      " NFe de saída não autorizada.
      APPEND VALUE #( id         = 'ZSD_INTERCOMPANY'
                      number     = 036
                      type       = 'E'
                      message_v1 = is_input-nfe_saida ) TO rt_result.
      RETURN.
    ENDIF.

  ENDMETHOD.

  METHOD validacampos.

    READ ENTITIES OF zi_sd_01_cockpit IN LOCAL MODE ENTITY cockpit
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit).


    LOOP AT  lt_cockpit ASSIGNING FIELD-SYMBOL(<fs_cockpit>).
      APPEND VALUE #(
         %tky = <fs_cockpit>-%tky
         %state_area = 'VALIDATE_SUP_LE'
         %msg = new_message(
           id       = sy-msgid
           number   = sy-msgno
           severity = CONV #( sy-msgty )
           v1       = sy-msgv1
           v2       = sy-msgv2
           v3       = sy-msgv3
           v4       = sy-msgv4
         )
         %element-ztraid = if_abap_behv=>mk-on
       )  TO reported-cockpit.
    ENDLOOP.

  ENDMETHOD.

  METHOD estornarsaida.

    CONSTANTS lc_vl09 TYPE sy-tcode VALUE 'VL09'.
    DATA lt_mesg      TYPE mesg_t.
    DATA lt_return    TYPE bapiret2_t.

    READ ENTITIES OF zi_sd_01_cockpit IN LOCAL MODE ENTITY cockpit
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_cockpit)
    FAILED failed.

    SELECT vbeln, vbtyp
    FROM likp
    FOR ALL ENTRIES IN @lt_cockpit
    WHERE vbeln EQ @lt_cockpit-remessa
    INTO TABLE @DATA(lt_remessa)
    .


    CALL FUNCTION 'ZFMSD_SAIDA_MERCADORIA_INTER'
      STARTING NEW TASK 'MERCADORIA' CALLING task_finish ON END OF TASK
      EXPORTING
        it_remessa = lt_remessa
      TABLES
        et_return  = lt_return.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL lt_return IS NOT INITIAL.


    reported-cockpit = VALUE #(
   FOR ls_return IN gt_return (
     %msg = new_message( id       = ls_return-id
                         number   = ls_return-number
                         severity = COND #( WHEN ls_return-type = 'W'
                                            THEN if_abap_behv_message=>severity-information
                                            ELSE CONV #( ls_return-type ) )
                         v1       = ls_return-message_v1
                         v2       = ls_return-message_v2
                         v3       = ls_return-message_v3
                         v4       = ls_return-message_v4 ) ) ) .

  ENDMETHOD.

  METHOD task_finish.
    DATA: lt_return TYPE bapiret2_t.

    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_SAIDA_MERCADORIA_INTER'
      TABLES
        et_return = lt_return.

    APPEND LINES OF lt_return TO gt_return.
    gv_wait_async = abap_true.
    RETURN.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_material DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS items FOR DETERMINE ON MODIFY
      IMPORTING keys FOR material~items.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR material RESULT result.

    METHODS criarinter FOR MODIFY
      IMPORTING keys FOR ACTION material~criarinter RESULT result.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR material RESULT result.

ENDCLASS.

CLASS lcl_material IMPLEMENTATION.

  METHOD items.
    READ ENTITIES OF zi_sd_01_cockpit IN LOCAL MODE
      ENTITY cockpit
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit)
      FAILED DATA(ls_failed).

    READ TABLE lt_cockpit INTO DATA(ls_cockpit) INDEX 1.

    READ ENTITIES OF zi_sd_01_cockpit IN LOCAL MODE
      ENTITY material
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_material)
      FAILED ls_failed.

    MODIFY ztsd_interc_item FROM TABLE @(
      VALUE #( FOR ls_material IN lt_material (
        guid             = ls_material-guid
        material         = ls_material-material
        materialbaseunit = ls_material-materialbaseunit
        qtdsol           = ls_material-qtdsol ) ) ).

*    MODIFY ENTITIES OF zi_sd_01_cockpit IN LOCAL MODE
*      ENTITY cockpit
*      CREATE BY \_material
*        FIELDS ( guid material qtdsol materialbaseunit )
*        WITH VALUE #( ( %key-guid = ls_cockpit-guid
*                        %target = CORRESPONDING #( lt_material ) ) )
*      MAPPED DATA(ls_mapped1)
*      REPORTED DATA(ls_reported1)
*      FAILED DATA(ls_failed1).

  ENDMETHOD.

  METHOD get_authorizations.
    RETURN.
  ENDMETHOD.

  METHOD criarinter.
    CONSTANTS lc_erro TYPE bapi_mtype VALUE 'E'.

    DATA: lt_items        TYPE TABLE OF ztsd_interc_item,
          lt_delete_items TYPE TABLE OF ztsd_interc_item,
          lt_text         TYPE STANDARD TABLE OF zssd_ordem_inter_text.

    READ ENTITIES OF zi_sd_01_cockpit
      ENTITY cockpit
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit).

    READ ENTITIES OF zi_sd_01_cockpit
      ENTITY material
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_material).

*    READ ENTITIES OF zi_sd_01_cockpit IN LOCAL MODE
*      ENTITY cockpit BY \_material
*      ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_material_scr)
*      FAILED DATA(ls_failed).


    IF line_exists( lt_material[ qtdsol = '0.000' ] ).

      APPEND VALUE #(
                       %msg = new_message( id       = 'ZSD_INTERCOMPANY'
                             number   = 032
                             severity = CONV #( 'E' ) ) ) TO reported-cockpit.

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

    IF NOT line_exists( lt_mensagem[ type = lc_erro ] ).

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


*        LOOP AT lt_material_scr ASSIGNING FIELD-SYMBOL(<fs_material_scr>).
*          lv_tabix = sy-tabix.
*
*          READ TABLE lt_material TRANSPORTING NO FIELDS
*            WITH KEY guid     = <fs_material_scr>-guid
*                     material = <fs_material_scr>-material BINARY SEARCH.
*          CHECK sy-subrc EQ 0.
*
*          DELETE lt_material_scr INDEX lv_tabix.
*        ENDLOOP.
*
*        IF lt_material_scr IS NOT INITIAL.
*          MODIFY ENTITIES OF zi_sd_01_cockpit IN LOCAL MODE
*            ENTITY material
*            DELETE FROM VALUE #( FOR ls_material_scr IN lt_material_scr (
*                                     guid = ls_material_scr-guid ) )
*            FAILED DATA(ls_failed1)
*            REPORTED DATA(ls_reported1).
*        ENDIF.

      ELSE.
        MODIFY ztsd_interc_item FROM TABLE @(
          VALUE #( FOR ls_material IN lt_material (
            guid             = ls_material-guid
            material         = ls_material-material
            materialbaseunit = ls_material-materialbaseunit
            qtdsol           = ls_material-qtdsol ) ) ).
      ENDIF.
    ENDIF.

    reported-cockpit = VALUE #(
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

    result = VALUE #( FOR ls_material IN lt_material
                       ( %tky   = ls_material-%tky
                         %param = ls_material ) ).
  ENDMETHOD.

  METHOD get_features.

    READ ENTITIES OF zi_sd_01_cockpit
      ENTITY cockpit
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit).

    READ ENTITIES OF zi_sd_01_cockpit IN LOCAL MODE
      ENTITY material
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_material).
    SORT lt_material BY guid material materialbaseunit.

*    READ ENTITIES OF zi_sd_01_cockpit IN LOCAL MODE
*  ENTITY log
*  ALL FIELDS WITH CORRESPONDING #( keys )
*  RESULT DATA(lt_log).
*    SORT lt_log BY guid seqnr.

    READ TABLE lt_cockpit INTO DATA(ls_cockpit) INDEX 1.

    result = VALUE #( FOR ls_material IN lt_material (
      guid             = ls_material-guid
      material         = ls_material-material
      materialbaseunit = ls_material-materialbaseunit
      %action  = VALUE #(
        criarinter = COND #( WHEN ls_cockpit-salesorder    IS NOT INITIAL
                               OR ls_cockpit-purchaseorder IS NOT INITIAL
                             THEN if_abap_behv=>fc-o-disabled )
      )
      %field = VALUE #(
        qtdsol = COND #( WHEN ls_cockpit-salesorder    IS NOT INITIAL
                           OR ls_cockpit-purchaseorder IS NOT INITIAL
                         THEN if_abap_behv=>fc-f-read_only )
      ) ) ).

  ENDMETHOD.

ENDCLASS.
