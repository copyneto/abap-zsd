*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_simulador_corretagem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS provisionar FOR MODIFY
      IMPORTING keys FOR ACTION simulador~provisionar RESULT result.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR simulador RESULT result.

ENDCLASS.

CLASS lcl_simulador_corretagem  IMPLEMENTATION.

  METHOD provisionar.

    CONSTANTS: lc_kurst     TYPE tcurr-kurst VALUE 'G',
               lc_moeda_ori TYPE tcurr-fcurr VALUE 'USD',
               lc_moeda_des TYPE tcurr-tcurr VALUE 'BRL'.

    DATA(lt_param) = keys.
    DATA: lv_data   TYPE char10,
          lv_dt_ant TYPE datum.

    " Encontrar ulima data cadastrada
    SELECT MIN( gdatu )
       FROM tcurr
       INTO @DATA(lv_gdatu)
       WHERE kurst EQ @lc_kurst
         AND fcurr EQ @lc_moeda_ori
         AND tcurr EQ @lc_moeda_des."#EC CI_BYPASS
    CHECK sy-subrc EQ 0.

    CALL FUNCTION 'CONVERSION_EXIT_INVDT_OUTPUT'
      EXPORTING
        input  = lv_gdatu
      IMPORTING
        output = lv_data.

    lv_dt_ant = |{ lv_data+6(4) }{ lv_data+3(2) }{ lv_data(2) }|.

    SELECT SINGLE ukurs
       FROM tcurr
       INTO @DATA(lv_dolar_dia)
       WHERE kurst EQ @lc_kurst
         AND fcurr EQ @lc_moeda_ori
         AND tcurr EQ @lc_moeda_des
         AND gdatu EQ @lv_gdatu.

    IF sy-subrc IS INITIAL.

      READ ENTITIES OF zi_sd_comissao_comex_prov IN LOCAL MODE ENTITY simulador
           FIELDS ( kwert netwrt )
           WITH CORRESPONDING #( keys )
           RESULT DATA(lt_keys).

      IF sy-subrc IS INITIAL.

        READ TABLE lt_param ASSIGNING FIELD-SYMBOL(<fs_param>) INDEX 1.
        IF sy-subrc IS INITIAL.

          DATA(lv_vlr_neg)    = sign( <fs_param>-%param-zajuste ).
          DATA(lv_valorajuste) = abs( <fs_param>-%param-zajuste ).

          LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_key>).
            IF sign( <fs_key>-netwrt ) EQ '1-'.
              <fs_key>-netwrt = -1.
            ELSE.
              <fs_key>-netwrt = 1.
            ENDIF.
          ENDLOOP.

          MODIFY ENTITIES OF zi_sd_comissao_comex_prov IN LOCAL MODE
             ENTITY simulador
             UPDATE FIELDS ( zdataptax zptax zstatus zdatabl zperiodo zobs zajuste prov zvalor  )
             WITH VALUE #( FOR ls_key IN lt_keys (
              %key      = ls_key-%key
              zdataptax = lv_dt_ant
              zptax     = lv_dolar_dia
              zstatus   = abap_true
              zdatabl   = <fs_param>-%param-zdatabl
              zperiodo  = <fs_param>-%param-zperiodo
              zobs      = <fs_param>-%param-zobs
              zajuste   = <fs_param>-%param-zajuste
              prov      = <fs_param>-%param-prov
              zvalor    = SWITCH #( lv_vlr_neg
                            WHEN '1-'
                                THEN ( ( ls_key-kwert * lv_dolar_dia ) - lv_valorajuste ) * ls_key-netwrt
                            WHEN  1
                                THEN ( ( ls_key-kwert * lv_dolar_dia ) + lv_valorajuste ) * ls_key-netwrt
                            ELSE
                                ( ls_key-kwert * lv_dolar_dia  ) * ls_key-netwrt
                          )
             ) )
           REPORTED DATA(lt_comex).

* ---------------------------------------------------------------------------
* Recupera status
* ---------------------------------------------------------------------------
          READ ENTITIES OF zi_sd_comissao_comex_prov IN LOCAL MODE ENTITY simulador
          FIELDS ( statuscriticality zstatus )
          WITH CORRESPONDING #( keys )
          RESULT DATA(lt_comex_get).

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
          result = VALUE #( FOR ls_comex IN lt_comex_get
                             ( %tky   = ls_comex-%tky
                               %param = ls_comex ) ).

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera status
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_sd_comissao_comex_prov IN LOCAL MODE ENTITY simulador
    FIELDS ( statuscriticality zstatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_comex).

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    result = VALUE #( FOR ls_comex IN lt_comex
                      LET lv_provisionar   =  COND #( WHEN ls_comex-zstatus = abap_false
                                                 THEN if_abap_behv=>fc-o-enabled
                                                 ELSE if_abap_behv=>fc-o-disabled  )
                      IN
                      ( %tky             = ls_comex-%tky
*                        %update          = lv_update
*                        %delete          = lv_delete
                        %action-provisionar = lv_provisionar
                      ) ).

  ENDMETHOD.

ENDCLASS.
