***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Interface SAGA WMS                                     *
*** AUTOR    : Flavia Nunes – META                                    *
*** FUNCIONAL: Cleverson Faria – META                                 *
*** DATA     : 09/03/2022                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
*&---------------------------------------------------------------------*
*& Include          ZSDI_SAGA_ENVIO_PRE_REGISTRO
*&---------------------------------------------------------------------*
    CONSTANTS: lc_modulo TYPE ztca_param_mod-modulo VALUE 'SD',
               lc_chave1 TYPE ztca_param_par-chave1 VALUE 'SAGA',
               lc_chave2 TYPE ztca_param_par-chave2 VALUE 'LFART',
               lc_chave3 TYPE ztca_param_par-chave3 VALUE ' '.

    CONSTANTS: lc_modulo_1 TYPE ztca_param_mod-modulo VALUE 'SD',
               lc_chave1_1 TYPE ztca_param_par-chave1 VALUE 'SAGA',
               lc_chave2_1 TYPE ztca_param_par-chave2 VALUE 'WERKS',
               lc_chave3_1 TYPE ztca_param_par-chave3 VALUE ' '.

    CONSTANTS: lc_modulo_2 TYPE ztca_param_mod-modulo VALUE 'SD',
               lc_chave1_2 TYPE ztca_param_par-chave1 VALUE 'SAGA',
               lc_chave2_2 TYPE ztca_param_par-chave1 VALUE 'REMESSA',
               lc_chave3_2 TYPE ztca_param_par-chave3 VALUE 'GATILHO'.

    CONSTANTS: lc_modulo_3 TYPE ztca_param_mod-modulo VALUE 'MM',
               lc_chave1_3 TYPE ztca_param_par-chave1 VALUE 'SAGA',
               lc_chave2_3 TYPE ztca_param_par-chave1 VALUE 'STO',
               lc_chave3_3 TYPE ztca_param_par-chave3 VALUE 'GATILHO'.

    CONSTANTS: lc_rem(10) TYPE c VALUE 'REMESSA',
               lc_upd_d   TYPE updkz_d VALUE 'D'.

    ">>> 8000006187:SD- Remessas não integradas no SAGA
    TYPES ty_remessas_enviadas TYPE STANDARD TABLE OF ztsd_rem_saga WITH DEFAULT KEY.
    DATA remessas_saga TYPE ty_remessas_enviadas.

    LOOP AT xlikp[] INTO DATA(remessa_sap) WHERE updkz = 'I'.

*      IF remessa-updkz NE lc_upd_d.

*    DATA(lo_object) = NEW zclsd_saga_envio_pre_registro( ).

** Seleçao dos parametros
      DATA(lo_parametros) = NEW zclca_tabela_parametros( ).

      DATA: lr_lfart      TYPE RANGE OF lfart,
            lr_werks      TYPE RANGE OF werks,
            lr_lifex_type TYPE RANGE OF /spe/de_lifex_type,
            lr_gatilho    TYPE RANGE OF ze_remessa.

      DATA: lv_chave2_2 TYPE ztca_param_par-chave2.


      CLEAR: lr_lfart , lr_werks, lr_gatilho, lv_chave2_2.

*    lv_chave2_2 = xlikp-lfart.

*Buscar Tipo de Ordem Saída
      TRY.
          lo_parametros->m_get_range(
            EXPORTING
              iv_modulo = lc_modulo
              iv_chave1 = lc_chave1
              iv_chave2 = lc_chave2
              iv_chave3 = lc_chave3
            IMPORTING
              et_range  = lr_lfart ).
        CATCH zcxca_tabela_parametros.
          "handle exception
      ENDTRY.

      IF NOT remessa_sap-lfart IN lr_lfart.

*      RETURN.
*
*    ENDIF.

*Buscar Tipo de Ordem Saída
        TRY.
            lo_parametros->m_get_range(
              EXPORTING
                iv_modulo = lc_modulo_1
                iv_chave1 = lc_chave1_1
                iv_chave2 = lc_chave2_1
                iv_chave3 = lc_chave3_1
              IMPORTING
                et_range  = lr_werks ).
          CATCH zcxca_tabela_parametros.
            "handle exception
        ENDTRY.

        IF remessa_sap-vstel IN lr_werks.

*Buscar Tipo de Ordem Saída
          TRY.
              lo_parametros->m_get_range(
                EXPORTING
                  iv_modulo = lc_modulo_2
                  iv_chave1 = lc_chave1_2
                  iv_chave2 = lc_chave2_2
                  iv_chave3 = lc_chave3_2
                IMPORTING
                  et_range  = lr_gatilho ).
            CATCH zcxca_tabela_parametros.
              "handle exception
          ENDTRY.

          IF line_exists( lr_gatilho[ low = remessa_sap-lfart ] ).

            ">>> 8000006187:SD- Remessas não integradas no SAGA
            APPEND VALUE #( remessa      = remessa_sap-vbeln
                            tipo_remessa = remessa_sap-lfart
                            centro       = remessa_sap-vstel ) TO remessas_saga.

*              IF remessa-updkz = 'I'.
*
*            CALL FUNCTION 'ZFMSD_SAGA_ENVIO_PRE_REGISTRO'
**            STARTING NEW TASK 'ENVIOPREREGISTRO'
**              IN UPDATE TASK
*              IN BACKGROUND TASK
*              EXPORTING
*                iv_remessa = xlikp-vbeln.
*
*              TRY.
*                  lo_parametros->m_get_range(
*                    EXPORTING
*                      iv_modulo = lc_modulo_3
*                      iv_chave1 = lc_chave1_3
*                      iv_chave2 = lc_chave2_3
*                      iv_chave3 = lc_chave3_3
*                    IMPORTING
*                      et_range  = lr_lifex_type ).
*                CATCH zcxca_tabela_parametros.
*                  "handle exception
*              ENDTRY.
*
*              IF NOT xlikp-spe_lifex_type IN lr_lifex_type.
*
*              CALL FUNCTION 'ZFMSD_SAGA_ENVIO_PRE_REGISTRO'
**              STARTING NEW TASK 'ENVIOPREREGISTRO'
**              IN UPDATE TASK
*                IN BACKGROUND TASK
*                EXPORTING
*                  iv_remessa = xlikp-vbeln.

*              ENDIF.
            "<<< 8000006187:SD- Remessas não integradas no SAGA
          ENDIF.
        ENDIF.
      ENDIF.
*      ENDIF.
    ENDLOOP.

    ">>> 8000006187:SD- Remessas não integradas no SAGA
    IF lines( remessas_saga ) > 0.
      CALL FUNCTION 'ZFMTM_REMESSA_SAGA'
        TABLES
          it_remessa = remessas_saga.
    ENDIF.
    "<<< 8000006187:SD- Remessas não integradas no SAGA
