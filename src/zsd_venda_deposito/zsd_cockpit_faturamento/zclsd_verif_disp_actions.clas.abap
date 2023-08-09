CLASS zclsd_verif_disp_actions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    "! Método para realizar a Ação do botão Ação Logística
    "! @parameter IV_MATERIAL         | Material
    "! @parameter IV_CENTRO           | Centro
    "! @parameter RT_MENSAGENS        | Mensagens de erro
    METHODS acionar_logistica
      IMPORTING
        !iv_material        TYPE matnr
        !iv_centro          TYPE werks_d
        !iv_deposito        TYPE lgort_d
        !iv_status          TYPE char1 OPTIONAL
      RETURNING
        VALUE(rt_mensagens) TYPE bapiret2_tab .
    "! Método para realizar a Ação do botão Atribuir Motivo Ação
    "! @parameter IV_MATERIAL         | Material
    "! @parameter IV_CENTRO           | Centro
    "! @parameter IV_MOTIVO           | Motivo
    "! @parameter IV_ACAO             | Ação
    "! @parameter RT_MENSAGENS        | Mensagens de erro
    METHODS atribuir_motivo
      IMPORTING
        !iv_material        TYPE ztsd_solic_log-material
        !iv_centro          TYPE ztsd_solic_log-centro
        !iv_motivo          TYPE ztsd_solic_log-motivo_indisp
        !iv_acao            TYPE ztsd_solic_log-acao
      RETURNING
        VALUE(rt_mensagens) TYPE bapiret2_tab .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS get_date RETURNING VALUE(rv_date) TYPE ze_sd_date.
    DATA gt_return TYPE bapiret2_tab .
    DATA gs_atpab TYPE RANGE OF atpab.
    CONSTANTS:
      "! Constantes para tabela de parâmetros
      BEGIN OF gc_parametros,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'ADM_FATURAMENTO',
        atp    TYPE ztca_param_par-chave2 VALUE 'ATP',
        prreg  TYPE ztca_param_par-chave3 VALUE 'PRREG',
        atpab  TYPE ztca_param_par-chave3 VALUE 'ATPAB',
      END OF gc_parametros.

    "! Método para validar diponibilidade do material
    "! @parameter IV_MATERIAL         | Material
    "! @parameter IV_CENTRO           | Centro
    "! @parameter RV_RETURN           | retorno da validação
    METHODS valida_disponibilidade
      IMPORTING
        !iv_material     TYPE matnr
        !iv_centro       TYPE werks_d
        !iv_deposito     TYPE lgort_d
      RETURNING
        VALUE(rv_return) TYPE abap_bool .
    METHODS get_atpab RETURNING VALUE(rv_atpab) TYPE prreg.
ENDCLASS.



CLASS ZCLSD_VERIF_DISP_ACTIONS IMPLEMENTATION.


  METHOD acionar_logistica.

    DATA: lt_return TYPE TABLE OF bapiret2,
          lv_date   TYPE ze_sd_date.

*    IF valida_disponibilidade( EXPORTING iv_material = iv_material
*                                         iv_centro   = iv_centro
*                                         iv_deposito = iv_deposito ) = abap_false.

    IF iv_status = '1'.

      SELECT vbeln
       FROM vbap
      WHERE matnr = @iv_material
        AND werks = @iv_centro
       INTO TABLE @DATA(lt_vbap).

      IF sy-subrc IS INITIAL.

        SORT lt_vbap BY vbeln.

        DELETE ADJACENT DUPLICATES FROM lt_vbap COMPARING vbeln.

        SELECT mandt,
               data_solic,
               material,
               centro,
               ordem,
               acaolog,
               data_solic_logist,
               motivo_indisp,
               acao
          FROM ztsd_solic_log
           FOR ALL ENTRIES IN @lt_vbap
         WHERE ordem    = @lt_vbap-vbeln
           AND material = @iv_material
           AND centro   = @iv_centro
          INTO TABLE @DATA(lt_solic_log).

      ELSE.

        SELECT mandt,
               data_solic,
               material,
               centro,
               ordem,
               acaolog,
               data_solic_logist,
               motivo_indisp,
               acao
          FROM ztsd_solic_log
         WHERE material = @iv_material
           AND centro   = @iv_centro
          INTO TABLE @lt_solic_log.

      ENDIF.

      lv_date = get_date(  ).

      IF lt_vbap IS NOT INITIAL.

        SORT lt_solic_log BY ordem.
        LOOP AT lt_vbap ASSIGNING FIELD-SYMBOL(<fs_vbap>).

          READ TABLE lt_solic_log ASSIGNING FIELD-SYMBOL(<fs_solic_log>)
                                                WITH KEY ordem = <fs_vbap>-vbeln
                                                BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            <fs_solic_log>-data_solic        = sy-datum.
            <fs_solic_log>-data_solic_logist = lv_date.
*            CONTINUE.
          ELSE.

            APPEND VALUE ztsd_solic_log( material          = iv_material
                                         centro            = iv_centro
                                         ordem             = <fs_vbap>-vbeln
                                         acaolog           = abap_true
                                         data_solic        = sy-datum
                                         data_solic_logist = lv_date ) TO lt_solic_log.

          ENDIF.
        ENDLOOP.

      ELSE.

        SORT lt_solic_log BY material
                             centro.

        READ TABLE lt_solic_log ASSIGNING <fs_solic_log>
                                 WITH KEY material = iv_material
                                          centro   = iv_centro
                                          BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          <fs_solic_log>-data_solic        = sy-datum.
          <fs_solic_log>-data_solic_logist = lv_date.
*            CONTINUE.
        ELSE.

          APPEND VALUE ztsd_solic_log( material          = iv_material
                                       centro            = iv_centro
                                       ordem             = '0000000000'
                                       acaolog           = abap_true
                                       data_solic        = sy-datum
                                       data_solic_logist = lv_date ) TO lt_solic_log.

        ENDIF.
      ENDIF.

      MODIFY ztsd_solic_log FROM TABLE lt_solic_log.

*        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' DESTINATION 'NONE'
*          EXPORTING
*            wait = abap_true.

      DATA(lv_success) = NEW zclsd_acionar_logistica( )->envio_email( EXPORTING iv_storage = iv_centro
                                                                      IMPORTING  et_return = lt_return  ).

      APPEND VALUE bapiret2( id         = 'ZSD_CKPT_FATURAMENTO'
                             number     = 004
                             type       = 'S'
                             message_v1 = iv_material
                             message_v2 = iv_centro ) TO rt_mensagens.

      "SD-347-347F06 - Ciclo do Pedido
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      TRY.
          NEW zclsd_dados_ciclo_pedido( )->calculo_cockpit_faturamento( lt_vbap ).
        CATCH zcxsd_ciclo_pedido INTO DATA(lo_exception).
      ENDTRY.
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

      IF lv_success = abap_true.
        APPEND VALUE bapiret2( id         = 'ZSD_CKPT_FATURAMENTO'
                               number     = 005
                               type       = 'S'
                               message_v1 = iv_material
                               message_v2 = iv_centro ) TO rt_mensagens.

        LOOP AT lt_solic_log ASSIGNING FIELD-SYMBOL(<fs_solic_log_aux>).
          <fs_solic_log_aux>-acao = space.
          <fs_solic_log_aux>-motivo_indisp = space.
        ENDLOOP.

        MODIFY ztsd_solic_log FROM TABLE lt_solic_log.
      ELSE.
        APPEND LINES OF lt_return TO rt_mensagens.
      ENDIF.

    ELSE.
      APPEND VALUE bapiret2( id     = 'ZSD_CKPT_FATURAMENTO'
                             number = 009
                             type   = 'E' ) TO rt_mensagens.
    ENDIF.
  ENDMETHOD.


  METHOD atribuir_motivo.


    SELECT mandt,
           data_solic,
           material,
           centro,
           ordem,
           acaolog,
           data_solic_logist,
           motivo_indisp,
           acao
      INTO TABLE @DATA(lt_solic_log)
      FROM ztsd_solic_log
      WHERE material = @iv_material
      AND centro   = @iv_centro
      AND motivo_indisp = @space.

    IF sy-subrc IS INITIAL.
      SORT lt_solic_log BY ordem.
    ENDIF.

    LOOP AT lt_solic_log ASSIGNING FIELD-SYMBOL(<fs_solic_log>).

      <fs_solic_log>-motivo_indisp   = iv_motivo.
      <fs_solic_log>-acao   = iv_acao .

    ENDLOOP.

    MODIFY ztsd_solic_log FROM TABLE lt_solic_log[].

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' DESTINATION 'NONE'
      EXPORTING
        wait = abap_true.

    APPEND VALUE bapiret2( id = 'ZSD_CKPT_FATURAMENTO' number = 006 ) TO rt_mensagens.

  ENDMETHOD.


  METHOD valida_disponibilidade.

*    DATA: lt_atpcsx          TYPE TABLE OF atpcs,
*          lt_atpdsx          TYPE TABLE OF atpds,
    DATA: lv_qtdordem          TYPE mng01,
          lv_qtdremessa        TYPE mng01,
          lv_qtdestoquelivre   TYPE mng01,
          lv_gtdepositofechado TYPE mng01.
*
*    DATA(ls_atpca) = VALUE atpca( anwdg = '8'
*                                  anwdg_orig = 'A'
*                                  azerg = 'T'
*                                  rdmod = 'A'
*                                  xenqmd = 'N' ).
*
*    FREE lt_atpcsx.
*
*    APPEND VALUE atpcs( matnr = iv_material
*                        werks = iv_centro
*                        prreg = '01'
*                        chmod = '011'
*                        bdter = sy-datum
*                        xline = '1'
*                        trtyp = 'A'
*                        idxatp = '1'
*                        resmd = 'X'
*                        chkflg = 'X'
*                         ) TO lt_atpcsx.
*
*
*    CALL FUNCTION 'AVAILABILITY_CHECK_S4'
*      TABLES
*        p_atpcsx = lt_atpcsx
*        p_atpdsx = lt_atpdsx
*      CHANGING
*        p_atpca  = ls_atpca
*      EXCEPTIONS
*        error    = 1
*        OTHERS   = 2.
*
*    IF sy-subrc = 0 AND lt_atpdsx[] IS NOT INITIAL.
*
*      LOOP AT lt_atpdsx ASSIGNING FIELD-SYMBOL(<fs_atpdsx>).
*        CASE <fs_atpdsx>-delkz.
*          WHEN 'VC'.
*            lv_qtdordem = lv_qtdordem + <fs_atpdsx>-qty_o.
*          WHEN 'VJ'.
*            lv_qtdremessa = lv_qtdremessa + <fs_atpdsx>-qty_o.
*          WHEN 'WB'.
*            lv_qtdestoquelivre = lv_qtdestoquelivre + <fs_atpdsx>-qty_o.
*        ENDCASE.
*      ENDLOOP.
*
*      DATA(lv_caldisponivilidade) = lv_qtdestoquelivre - (  lv_qtdordem +  lv_qtdremessa ).
*
*      IF  lv_caldisponivilidade > 0.
*        rv_return = abap_true. "Disponível
*      ELSE.
*        rv_return = abap_false. "Indisponível
*      ENDIF.

*    ENDIF.
    DATA: lt_mdpsx      TYPE TABLE OF mdps.

    CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
      EXPORTING
        matnr                    = iv_material
        werks                    = iv_centro
      TABLES
        mdpsx                    = lt_mdpsx
      EXCEPTIONS
        material_plant_not_found = 1
        plant_not_found          = 2
        OTHERS                   = 3.

    IF sy-subrc = 0.
      LOOP AT lt_mdpsx ASSIGNING FIELD-SYMBOL(<fs_mdpsx>).
        IF <fs_mdpsx>-plaab = get_atpab(  ).
          CASE <fs_mdpsx>-delkz.
            WHEN 'VC'.
              lv_qtdordem = lv_qtdordem + <fs_mdpsx>-mng01.
            WHEN 'VJ'.
              lv_qtdremessa = lv_qtdremessa + <fs_mdpsx>-mng01.
*            WHEN 'WB'.
*              lv_qtdestoquelivre = lv_qtdestoquelivre + <fs_mdpsx>-mng01.
          ENDCASE.
        ENDIF.
      ENDLOOP.
    ENDIF.

    SELECT SINGLE labst
      FROM mard
     WHERE matnr = @iv_material
       AND werks = @iv_centro
       AND lgort = @iv_deposito
      INTO @DATA(lv_labst).

    IF sy-subrc IS INITIAL.
      lv_qtdestoquelivre = lv_labst.
    ENDIF.

    SELECT destiny_plant,
           destiny_plant_type,
           origin_plant,
           origin_plant_type
      FROM ztmm_prm_dep_fec
      INTO TABLE @DATA(lt_fechado)
     WHERE destiny_plant      = @iv_centro
       AND destiny_plant_type = '02'
       AND origin_plant_type  = '01'.

    IF  sy-subrc IS INITIAL.

      LOOP AT lt_fechado ASSIGNING FIELD-SYMBOL(<fs_fechado>).

        CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
          EXPORTING
            matnr                    = iv_material
            werks                    = <fs_fechado>-origin_plant
          TABLES
            mdpsx                    = lt_mdpsx
          EXCEPTIONS
            material_plant_not_found = 1
            plant_not_found          = 2
            OTHERS                   = 3.

        IF sy-subrc = 0.

          LOOP AT lt_mdpsx ASSIGNING FIELD-SYMBOL(<fs_mdpsx2>).
            IF <fs_mdpsx2>-plaab = get_atpab(  ).
              CASE <fs_mdpsx2>-delkz.
                WHEN 'WB'.
                  lv_gtdepositofechado  = lv_gtdepositofechado  + <fs_mdpsx2>-mng01.
              ENDCASE.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDLOOP.

    ENDIF.

    DATA(lv_caldisponivilidade) = CONV mng01( lv_qtdestoquelivre + lv_gtdepositofechado - (  lv_qtdordem +  lv_qtdremessa ) ).

    IF lv_caldisponivilidade > 0.
      rv_return = abap_true. "Disponível
    ELSE.
      rv_return = abap_false. "Indisponível
    ENDIF.

    CLEAR lt_mdpsx.

  ENDMETHOD.


  METHOD get_date.
*    DATA : lv_date      TYPE sy-datum,
*           lv_date1(10) TYPE c,
*           lv_time      TYPE sy-uzeit,
*           lv_time1(8)  TYPE c.
*
*    lv_date = sy-datum.
*
*    CONCATENATE lv_date+6(2) '.' lv_date+4(2) '.' lv_date+0(4) INTO lv_date1.
*
*    lv_time = sy-uzeit.
*
*    CONCATENATE lv_time+0(2) ':' lv_time+2(2) ':' lv_time+4(2) INTO lv_time1.
*    CONCATENATE lv_date1 lv_time1  INTO rv_date SEPARATED BY space.

    GET TIME STAMP FIELD rv_date.

  ENDMETHOD.


  METHOD get_atpab.

    DATA(lo_tabela_parametros) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 24.07.2023

    CLEAR gs_atpab.

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
      iv_modulo = gc_parametros-modulo
      iv_chave1 = gc_parametros-chave1
      iv_chave2 = gc_parametros-atp
      iv_chave3 = gc_parametros-atpab
          IMPORTING
            et_range  = gs_atpab
        ).

        READ TABLE gs_atpab ASSIGNING FIELD-SYMBOL(<fs_atpab>) INDEX 1.
        CHECK sy-subrc = 0.
        rv_atpab = <fs_atpab>-low.

      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
