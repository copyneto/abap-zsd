CLASS zclsd_criacao_contratos DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS:
      constructor
        IMPORTING
          is_input TYPE zclsd_mt_criar_contrato
        RAISING
          zcxsd_erro_interface.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA gs_input TYPE zclsd_mt_criar_contrato .

    METHODS process_data
      RAISING
        zcxsd_erro_interface .
    "! Raising erro
    METHODS erro
      IMPORTING
        !is_erro TYPE scx_t100key
      RAISING
        zcxsd_erro_interface .
    METHODS bapi_commit .
    METHODS call_shdb
      IMPORTING
        iv_vbeln TYPE bapivbeln-vbeln .
    METHODS get_plant
      RETURNING
        VALUE(rv_result) TYPE werks_d.
ENDCLASS.



CLASS ZCLSD_CRIACAO_CONTRATOS IMPLEMENTATION.


  METHOD constructor.
    MOVE-CORRESPONDING is_input TO gs_input.
    me->process_data( ).
  ENDMETHOD.


  METHOD process_data.

    TYPES: BEGIN OF ty_salesdocument,
             salesdocument           TYPE i_salesdocument-salesdocument,
             purchaseorderbycustomer TYPE i_salesdocument-purchaseorderbycustomer,
           END OF ty_salesdocument.

    TYPES: BEGIN OF ty_vbap,
             posnr TYPE vbap-posnr,
             vbeln TYPE vbap-vbeln,
             matnr TYPE vbap-matnr,
           END OF ty_vbap.

    DATA: lt_salesdocument            TYPE TABLE OF ty_salesdocument,
          lt_vbap                     TYPE TABLE OF ty_vbap,
          lt_return                   TYPE TABLE OF bapiret2,
          lt_contract_item_in_u       TYPE TABLE OF bapisditm,
          lt_contract_item_inx_u      TYPE TABLE OF bapisditmx,
          lt_out_contrato_in          TYPE TABLE OF bapictr,
          lt_return2                  TYPE STANDARD TABLE OF bapiret2,
          lt_item2                    TYPE STANDARD TABLE OF bapisditm,
          lt_itemx2                   TYPE STANDARD TABLE OF bapisditmx,
          lt_schd                     TYPE STANDARD TABLE OF bapischdl,
          lt_schdx                    TYPE STANDARD TABLE OF bapischdlx,
          lt_vbkd                     TYPE TABLE OF vbkd,
          lt_vbkdvb                   TYPE TABLE OF vbkdvb,
          lt_zfpla_old                TYPE TABLE OF fplavb,
          lt_zfplt_old                TYPE TABLE OF fpltvb,
          lt_zfpla_new                TYPE TABLE OF fplavb,
          lt_zfplt_new                TYPE TABLE OF fpltvb,
          lt_contract_items_in_c      TYPE TABLE OF bapisditm,
          lt_contract_partners_c      TYPE TABLE OF bapiparnr,
          lt_contract_conditions_in_c TYPE TABLE OF bapicond,
          lt_vbap_aux                 TYPE STANDARD TABLE OF ty_vbap,
          lt_doc_type                 TYPE tms_t_auart_range.

    DATA: ls_contract_header_in_u  TYPE bapisdh1,
          ls_contract_header_inx_u TYPE bapisdh1x,
          ls_output                TYPE zclsd_mt_status_contrato,
          ls_salesdocument         TYPE ty_salesdocument,
          ls_return                TYPE bapiret2,
          ls_head                  TYPE bapisdh1,
          ls_headx                 TYPE bapisdh1x,
          ls_item2                 TYPE bapisditm,
          ls_itemx2                TYPE bapisditmx,
          ls_schd                  TYPE bapischdl,
          ls_schdx                 TYPE bapischdlx,
          ls_contrato              TYPE bapictr,
          ls_parceiro              TYPE bapiparnr,
          ls_item                  TYPE bapisditm,
          ls_itemsx                TYPE bapisditmx,
          ls_condicao              TYPE bapicond,
          ls_condicaox             TYPE bapicondx,
          ls_vbkd                  TYPE vbkd,
          ls_zfpla                 TYPE fplavb,
          ls_contract_header_in_c  TYPE bapisdhd1,
          ls_contract_partners_c   TYPE bapiparnr.

    DATA: lv_salesdocument_u TYPE bapivbeln-vbeln,
          lv_order           TYPE bapivbeln-vbeln,
          lv_serie           TYPE v46r_serikom-sernr,
          lv_material        TYPE matnr,
          lv_item            TYPE char6,
          lv_tabix           TYPE sy-tabix,
          lv_tp_doc          TYPE char4,
          lv_salesdocument_c TYPE bapivbeln-vbeln,
          lv_mes             TYPE t5a4a-dlymo,
          lv_ano             TYPE t5a4a-dlyyr,
          lv_dia             TYPE t5a4a-dlydy.

    FIELD-SYMBOLS: <fs_tmcb> TYPE tmcb,
                   <fs_any>  TYPE any.

    CONSTANTS: lc_x      TYPE char1 VALUE 'X',
               lc_update TYPE char1 VALUE 'U'.

    IF gs_input-mt_criar_contrato-produtorecolhido[] IS INITIAL.

      SELECT SINGLE salesdocument,
                    purchaseorderbycustomer
        FROM i_salesdocument
        INTO @ls_salesdocument
       WHERE purchaseorderbycustomer EQ @gs_input-mt_criar_contrato-contract_header_in-purch_no_c
* LSCHEPP - 8000006883 - Interface criação Contratos - 03.05.2023 Início
         AND sddocumentcategory EQ 'G'.
* LSCHEPP - 8000006883 - Interface criação Contratos - 03.05.2023 Fim

      IF sy-subrc EQ 0.

        SELECT posnr,
               vbeln,
               matnr
          INTO TABLE @lt_vbap
          FROM vbap
         WHERE vbeln = @ls_salesdocument-salesdocument.



        ls_contract_header_in_u-po_method  = gs_input-mt_criar_contrato-contract_header_in-doc_type.
        ls_contract_header_in_u-sales_org  = gs_input-mt_criar_contrato-contract_header_in-sales_org.
        ls_contract_header_in_u-distr_chan = gs_input-mt_criar_contrato-contract_header_in-distr_chan.
        ls_contract_header_in_u-division   = '99'.
        ls_contract_header_in_u-purch_no_c = gs_input-mt_criar_contrato-contract_header_in-purch_no_c.
        ls_contract_header_in_u-po_method  = gs_input-mt_criar_contrato-contract_header_in-po_method.
        ls_contract_header_in_u-qt_valid_f = gs_input-mt_criar_contrato-contract_header_in-qt_valid_f.
        ls_contract_header_in_u-ref_1      = gs_input-mt_criar_contrato-contract_header_in-ref_1.
        ls_contract_header_in_u-ship_cond  = gs_input-mt_criar_contrato-contract_header_in-ship_cond.

        ls_contract_header_inx_u-po_method  =  lc_x.
        ls_contract_header_inx_u-sales_org  =  lc_x.
        ls_contract_header_inx_u-distr_chan =  lc_x.
        ls_contract_header_inx_u-division   =  lc_x.
        ls_contract_header_inx_u-purch_no_c =  lc_x.
        ls_contract_header_inx_u-po_method  =  lc_x.
        ls_contract_header_inx_u-qt_valid_f =  lc_x.
        ls_contract_header_inx_u-ref_1      =  lc_x.
        ls_contract_header_inx_u-updateflag =  lc_update.
        ls_contract_header_inx_u-ship_cond  =  lc_x.

        LOOP AT gs_input-mt_criar_contrato-contract_item_in ASSIGNING FIELD-SYMBOL(<fs_contract_item_in_u>).
          APPEND VALUE #( itm_number  = <fs_contract_item_in_u>-itm_number
                          material    = <fs_contract_item_in_u>-material
                          reason_rej  = <fs_contract_item_in_u>-reason_rej
                          store_loc   = <fs_contract_item_in_u>-store_loc ) TO lt_contract_item_in_u.
        ENDLOOP.

        lv_salesdocument_u = ls_salesdocument-salesdocument.

        CALL FUNCTION 'BAPI_CUSTOMERCONTRACT_CHANGE'
          EXPORTING
            salesdocument       = lv_salesdocument_u
            contract_header_in  = ls_contract_header_in_u
            contract_header_inx = ls_contract_header_inx_u
          TABLES
            return              = lt_return
            contract_item_in    = lt_contract_item_in_u.

        IF ( line_exists( lt_return[ type = 'E' ] ) ).

*          APPEND VALUE #( processado      = TEXT-003
*                          desc_processado = REDUCE string( INIT lv_concat TYPE string
*                                                            FOR ls_ret IN lt_return
*                                                           NEXT lv_concat = lv_concat && ls_ret-message && ' - ' ) ) TO ls_output-mt_status_contrato-form_fields-lista.
          APPEND VALUE #( processado      = TEXT-003
                          desc_processado = VALUE #( lt_return[ 1 ]-message OPTIONAL ) ) TO ls_output-mt_status_contrato-form_fields-lista.

        ELSE.

          me->bapi_commit(  ).

          APPEND VALUE #( processado      = TEXT-003 && ls_salesdocument-salesdocument
                          desc_processado = TEXT-002 && lv_salesdocument_u ) TO ls_output-mt_status_contrato-form_fields-lista.

        ENDIF.

        ls_output-mt_status_contrato-assignee  = gs_input-mt_criar_contrato-contract_header_in-purch_no_c.
        ls_output-mt_status_contrato-comment   = TEXT-001.
        ls_output-mt_status_contrato-ped_fluig = gs_input-mt_criar_contrato-contract_header_in-purch_no_c.

        TRY.
            NEW zclsd_co_si_status_contrato_ou( )->si_status_contrato_out( output = ls_output ).
          CATCH cx_ai_system_fault.
        ENDTRY.

      ELSE.

        ls_contract_header_in_c-po_method  = gs_input-mt_criar_contrato-contract_header_in-doc_type.
        ls_contract_header_in_c-sales_org  = gs_input-mt_criar_contrato-contract_header_in-sales_org.
        ls_contract_header_in_c-distr_chan = gs_input-mt_criar_contrato-contract_header_in-distr_chan.
        ls_contract_header_in_c-purch_no_c = gs_input-mt_criar_contrato-contract_header_in-purch_no_c.
        ls_contract_header_in_c-division   = '99'.
        ls_contract_header_in_c-po_method  = gs_input-mt_criar_contrato-contract_header_in-po_method.
        ls_contract_header_in_c-qt_valid_f = gs_input-mt_criar_contrato-contract_header_in-qt_valid_f.
        ls_contract_header_in_c-ref_1      = gs_input-mt_criar_contrato-contract_header_in-ref_1.
        ls_contract_header_in_c-doc_type   = gs_input-mt_criar_contrato-contract_header_in-doc_type.
        ls_contract_header_in_c-doc_type   = gs_input-mt_criar_contrato-contract_header_in-doc_type.
        ls_contract_header_in_c-ship_cond  = gs_input-mt_criar_contrato-contract_header_in-ship_cond.
        ls_contract_header_in_c-pmnttrms   = gs_input-mt_criar_contrato-contract_header_in-pmnttrms.
        ls_contract_header_in_c-pymt_meth  = gs_input-mt_criar_contrato-contract_header_in-pymt_meth.

        LOOP AT gs_input-mt_criar_contrato-contract_item_in ASSIGNING FIELD-SYMBOL(<fs_contract_item_in_c>).

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = <fs_contract_item_in_c>-material
            IMPORTING
              output = <fs_contract_item_in_c>-material.

          APPEND VALUE #( itm_number  = <fs_contract_item_in_c>-itm_number
                          material    = <fs_contract_item_in_c>-material
                          plant       = <fs_contract_item_in_c>-plant
                          store_loc   = <fs_contract_item_in_c>-store_loc
                          wbs_elem    = ''
                          reason_rej  = <fs_contract_item_in_c>-reason_rej ) TO lt_contract_items_in_c.

        ENDLOOP.

        LOOP AT gs_input-mt_criar_contrato-contract_partners ASSIGNING FIELD-SYMBOL(<fs_contract_partners_c>).

          IF <fs_contract_partners_c>-partn_numb_cli IS NOT INITIAL.
            APPEND VALUE #( partn_role = <fs_contract_partners_c>-partn_role_cli
                            partn_numb = <fs_contract_partners_c>-partn_numb_cli ) TO lt_contract_partners_c.
          ENDIF.

          IF <fs_contract_partners_c>-partn_numb_transp IS NOT INITIAL.
            APPEND VALUE #( partn_role = <fs_contract_partners_c>-partn_role_transp
                            partn_numb = <fs_contract_partners_c>-partn_numb_transp ) TO lt_contract_partners_c.

          ENDIF.

          IF <fs_contract_partners_c>-partn_numb_mot IS NOT INITIAL.
            APPEND VALUE #( partn_role = 'YM'
                            partn_numb = <fs_contract_partners_c>-partn_numb_mot ) TO lt_contract_partners_c.
          ENDIF.

          IF <fs_contract_partners_c>-partn_numb_merc IS NOT INITIAL.
            APPEND VALUE #( partn_role = <fs_contract_partners_c>-partn_role_merc
                            partn_numb = <fs_contract_partners_c>-partn_numb_merc ) TO lt_contract_partners_c.
          ENDIF.

        ENDLOOP.

        READ TABLE lt_contract_partners_c INTO ls_contract_partners_c INDEX 1.

*      SELECT SINGLE spart
*        FROM knvv
*        INTO ls_contract_header_in_c-division
*       WHERE kunnr = ls_contract_partners_c-partn_numb
*         AND vkorg = ls_contract_header_in_c-sales_org
*         AND vtweg = ls_contract_header_in_c-distr_chan.
        ls_contract_header_in_c-division   = '99'.

        CLEAR: ls_contract_partners_c.

        LOOP AT gs_input-mt_criar_contrato-contract_conditions_in ASSIGNING FIELD-SYMBOL(<fs_contract_conditions_c>).

          IF <fs_contract_conditions_c>-cond_value_aluguel IS NOT INITIAL.

            APPEND VALUE #( itm_number = <fs_contract_conditions_c>-itm_number
                            cond_type  = <fs_contract_conditions_c>-cond_type
                            cond_value = <fs_contract_conditions_c>-cond_value_aluguel ) TO lt_contract_conditions_in_c.
          ENDIF.

          IF <fs_contract_conditions_c>-cond_value_locacao IS NOT INITIAL.

            APPEND VALUE #( itm_number = <fs_contract_conditions_c>-itm_number
                            cond_type  = <fs_contract_conditions_c>-cond_type
                            cond_value = <fs_contract_conditions_c>-cond_value_locacao / 10 ) TO lt_contract_conditions_in_c.
          ENDIF.

          IF <fs_contract_conditions_c>-cond_value_unitario IS NOT INITIAL.

            APPEND VALUE #( itm_number = <fs_contract_conditions_c>-itm_number
                            cond_type  = <fs_contract_conditions_c>-cond_type
                            cond_value = <fs_contract_conditions_c>-cond_value_unitario / 10 ) TO lt_contract_conditions_in_c.
          ENDIF.

        ENDLOOP.

        "***DADOS DO CONTRATO
        ls_contrato-con_st_dat = gs_input-mt_criar_contrato-contract_header_in-qt_valid_f.

        lv_mes = 00.
        lv_ano = 01.
        lv_dia = 00.

        CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
          EXPORTING
            date      = gs_input-mt_criar_contrato-contract_header_in-qt_valid_f
            days      = lv_dia
            months    = lv_mes
            signum    = '+'
            years     = '99'
          IMPORTING
            calc_date = ls_contrato-con_en_dat.

        ls_contrato-val_per    = 1.
        ls_contrato-val_per_ca = '02'.
        ls_contrato-val_per_un = '4'.
        ls_contrato-canc_proc  = '0001'.

        APPEND ls_contrato TO lt_out_contrato_in.

        lv_salesdocument_c = ls_salesdocument-salesdocument.

        CALL FUNCTION 'BAPI_CONTRACT_CREATEFROMDATA'
          EXPORTING
            salesdocumentin        = lv_salesdocument_c
            contract_header_in     = ls_contract_header_in_c
          IMPORTING
            salesdocument          = lv_salesdocument_c
          TABLES
            return                 = lt_return
            contract_items_in      = lt_contract_items_in_c
            contract_partners      = lt_contract_partners_c
            contract_conditions_in = lt_contract_conditions_in_c
            contract_data_in       = lt_out_contrato_in.

        IF ( line_exists( lt_return[ type = 'E' ] ) ).

          ls_output-mt_status_contrato-assignee  = gs_input-mt_criar_contrato-contract_header_in-purch_no_c.
          ls_output-mt_status_contrato-comment   = TEXT-001.
          ls_output-mt_status_contrato-ped_fluig = gs_input-mt_criar_contrato-contract_header_in-purch_no_c.

*          APPEND VALUE #( processado      = TEXT-003 && ls_salesdocument-salesdocument
*                          desc_processado = REDUCE string( INIT lv_desc TYPE string
*                                                           FOR ls_ret  IN lt_return
*                                                           NEXT lv_desc = lv_desc && ' - ' && ls_ret-message  )
*                                                         ) TO ls_output-mt_status_contrato-form_fields-lista.

          APPEND VALUE #( processado      = TEXT-003 && ls_salesdocument-salesdocument
                          desc_processado = VALUE #( lt_return[ type = 'E' ]-message OPTIONAL ) )
                        TO ls_output-mt_status_contrato-form_fields-lista.

*        me->erro( VALUE scx_t100key( msgid = lt_return[ 1 ]-id
*                                     msgno = lt_return[ 1 ]-number
*                                     attr1 = lt_return[ 1 ]-message
*                                     attr2 = lt_return[ 1 ]-message_v1
*                                     attr3 = lt_return[ 1 ]-message_v2
*                                     attr4 = lt_return[ 1 ]-message_v3
*                                      ) ).

        ELSE.

          me->bapi_commit(  ).

          DATA(lt_item_in) = gs_input-mt_criar_contrato-contract_item_in[].
          SORT lt_item_in BY itm_number.



            "**** Criação do objeto técnico ****
            LOOP AT lt_contract_items_in_c INTO ls_item.

              READ TABLE lt_contract_partners_c INTO ls_parceiro INDEX 1.

              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                EXPORTING
                  input  = ls_item-itm_number
                IMPORTING
                  output = lv_item.

              READ TABLE lt_item_in INTO DATA(ls_produto)
                                     WITH KEY itm_number = lv_item
                                     BINARY SEARCH.

              IF sy-subrc EQ 0.


***CFARIA - 8000007544, Criação Contrato Maquina Terceiro - 158 - 18.05.2023 Início

*                IF ls_produto-tipomaquina EQ 'propria'.
                IF ls_produto-tipomaquina EQ 'propria' OR ls_produto-tipomaquina EQ 'alugada'.

***CFARIA - 8000007544, Criação Contrato Maquina Terceiro - 158 - 18.05.2023 Fim

                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = ls_produto-plaqueta
                    IMPORTING
                      output = lv_serie.

                ELSE.

                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = ls_produto-numserie
                    IMPORTING
                      output = lv_serie.

                ENDIF.
              ENDIF.

              lv_material = ls_item-material.
              lv_tp_doc   = gs_input-mt_criar_contrato-contract_header_in-doc_type.

              CALL FUNCTION 'SERNR_ADD_TO_AU'
                EXPORTING
                  sernr                 = lv_serie
                  profile               = '0006'
                  material              = lv_material
                  quantity              = '1'
                  j_vorgang             = space
                  document              = lv_salesdocument_c
                  item                  = ls_item-itm_number
                  debitor               = ls_parceiro-partn_numb
                  vbtyp                 = 'G'
                  sd_auart              = lv_tp_doc
                  sd_postyp             = lv_tp_doc
                EXCEPTIONS
                  konfigurations_error  = 1
                  serialnumber_errors   = 2
                  serialnumber_warnings = 3
                  no_profile_operation  = 4
                  OTHERS                = 5.

              IF sy-subrc EQ 0.
                CALL FUNCTION 'SERIAL_LISTE_POST_AU'.
                CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
*              EXPORTING
*                wait = lc_x.
              ENDIF.

              CLEAR: ls_item, ls_parceiro, lv_serie, lv_item.

            ENDLOOP.

            " SHDB para confirmar o Nro de Série
            call_shdb( iv_vbeln = lv_salesdocument_c ).

            " ****Criação do objeto técnico****

* LSCHEPP - 8000006993 -  Erro Criação OVs Y074 e Y075 - GAP 158 - 08.05.2023 Início
          TRY.
              NEW zclca_tabela_parametros( )->m_get_range(
                EXPORTING
                  iv_modulo = 'SD'
                  iv_chave1 = 'FLUIG'
                  iv_chave2 = 'DOC_TYPE'
                IMPORTING
                  et_range  = lt_doc_type
              ).
            CATCH zcxca_tabela_parametros.
          ENDTRY.

          IF gs_input-mt_criar_contrato-contract_header_in-doc_type IN lt_doc_type.
* LSCHEPP - 8000006993 - Erro Criação OVs Y074 e Y075 - GAP 158 - 08.05.2023 Início


            "****Criação da quantidade (divisão de remessa)****
            ls_head-collect_no  = lv_salesdocument_c.
            ls_headx-updateflag = lc_update.

            LOOP AT lt_contract_items_in_c INTO ls_item.

              ls_item2-itm_number = ls_item-itm_number.
              ls_item2-ref_doc    = lv_order.
              ls_item2-material   = ls_item-material.
              ls_item2-rnddlv_qty = '1'.
              ls_item2-target_qu  = 'UN'.

              APPEND ls_item2 TO lt_item2.
              CLEAR ls_item2.

              ls_itemx2-updateflag = lc_update.
              ls_item2-itm_number  = ls_item-itm_number.
              ls_item2-ref_doc     = lc_x.
              ls_itemx2-material   = lc_x.
              ls_itemx2-rnddlv_qty = lc_x.
              ls_itemx2-target_qu  = lc_x.
              APPEND ls_itemx2 TO lt_itemx2.
              CLEAR ls_itemx2.

              ls_schd-itm_number = ls_item-itm_number.
              ls_schd-sched_line = '1'.
              ls_schd-req_qty    = '1'.
              APPEND ls_schd TO lt_schd.
              CLEAR ls_schd.

              ls_schdx-itm_number = ls_item-itm_number.
              ls_schdx-updateflag = lc_update.
              ls_schdx-sched_line = lc_x.
              ls_schdx-req_qty    = lc_x.
              APPEND ls_schdx TO lt_schdx.
              CLEAR ls_schdx.

              CLEAR: ls_item, ls_schdx, ls_schd, ls_itemx2, ls_item2.

            ENDLOOP.

            CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
              EXPORTING
                salesdocument    = lv_salesdocument_c
                order_header_in  = ls_head
                order_header_inx = ls_headx
              TABLES
                return           = lt_return2
                order_item_in    = lt_item2
                order_item_inx   = lt_itemx2
                schedule_lines   = lt_schd
                schedule_linesx  = lt_schdx.

            READ TABLE lt_return2 WITH KEY type = 'E' TRANSPORTING NO FIELDS.

            IF sy-subrc NE 0.
              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                EXPORTING
                  wait = lc_x.

              CALL FUNCTION 'SD_SALES_DOCUMENT_INIT'
                EXPORTING
                  simulation_mode_bapi = abap_true.

              CALL FUNCTION 'SD_SALES_DOCUMENT_INIT'.

              ASSIGN ('(SAPLMCS1)TMCB') TO <fs_tmcb>.
              IF sy-subrc EQ 0.
                CLEAR <fs_tmcb>.
                UNASSIGN <fs_tmcb>.
              ENDIF.

              ASSIGN ('(SAPLV14A)KONP') TO <fs_any>.

              IF sy-subrc EQ 0.
                CLEAR <fs_any>.
                UNASSIGN <fs_any>.
              ENDIF.

              ASSIGN ('(SAPFV45P)KONP') TO <fs_any>.

              IF sy-subrc EQ 0.
                CLEAR <fs_any>.
                UNASSIGN <fs_any>.
              ENDIF.

              ASSIGN ('(SAPMV45A)STATUS_BUFF_INIT') TO <fs_any>.

              IF sy-subrc EQ 0.
                CLEAR <fs_any>.
                UNASSIGN <fs_any>.
              ENDIF.

              ASSIGN ('(SAPLVBAK)STATUS_BUFF_INIT') TO <fs_any>.

              IF sy-subrc EQ 0.
                CLEAR <fs_any>.
                UNASSIGN <fs_any>.
              ENDIF.

              ASSIGN ('(SAPLV45A)STATUS_BUFF_INIT') TO <fs_any>.

              IF sy-subrc EQ 0.
                CLEAR <fs_any>.
                UNASSIGN <fs_any>.
              ENDIF.
********************
            ENDIF.
* LSCHEPP - 8000006993 - Erro Criação OVs Y074 e Y075 - GAP 158 - 08.05.2023 Início
          ENDIF.
* LSCHEPP - 8000006993 - Erro Criação OVs Y074 e Y075 - GAP 158 - 08.05.2023 Fim
          "****Criação da quantidade (Divisão de remessa)****

          ls_output-mt_status_contrato-assignee  = gs_input-mt_criar_contrato-contract_header_in-purch_no_c.
          ls_output-mt_status_contrato-comment   = TEXT-001.
          ls_output-mt_status_contrato-ped_fluig = gs_input-mt_criar_contrato-contract_header_in-purch_no_c.

          APPEND VALUE #( processado      = TEXT-003 && ls_salesdocument-salesdocument
                          desc_processado = TEXT-004 && lv_salesdocument_c ) TO ls_output-mt_status_contrato-form_fields-lista.

        ENDIF.

        TRY.
            NEW zclsd_co_si_status_contrato_ou( )->si_status_contrato_out( output = ls_output ).
          CATCH cx_ai_system_fault.
        ENDTRY.

      ENDIF.

    ELSE.

      lt_vbap_aux = VALUE #( FOR ls_pdotudoescolhido IN gs_input-mt_criar_contrato-produtorecolhido (
                                 vbeln = CONV vbeln( |{ ls_pdotudoescolhido-salesdocument ALPHA = IN }| )
                                 posnr = ls_pdotudoescolhido-po_itm_no ) ).

      IF lt_vbap_aux[] IS NOT INITIAL.
        SELECT vbeln,
               posnr,
               werks
          FROM vbap
          FOR ALL ENTRIES IN @lt_vbap_aux
         WHERE vbeln = @lt_vbap_aux-vbeln
           AND posnr = @lt_vbap_aux-posnr
          INTO TABLE @DATA(lt_centro).
        IF sy-subrc IS INITIAL.
          SORT lt_centro BY vbeln
                            posnr.
        ENDIF.
      ENDIF.

      DATA(lt_prodescheader) = gs_input-mt_criar_contrato-produtorecolhido[].
      DATA(lt_produtoescolhido) = gs_input-mt_criar_contrato-produtorecolhido[].

      SORT lt_prodescheader BY salesdocument.
      SORT lt_produtoescolhido BY salesdocument
                                  po_itm_no.

      DELETE ADJACENT DUPLICATES FROM lt_prodescheader COMPARING salesdocument.

      LOOP AT lt_prodescheader ASSIGNING FIELD-SYMBOL(<fs_prodescheader>).

        CLEAR: lv_salesdocument_u,
               ls_contract_header_inx_u.

        FREE: lt_contract_item_in_u[],
              lt_contract_item_inx_u[].

        lv_salesdocument_u = CONV vbeln( |{ <fs_prodescheader>-salesdocument ALPHA = IN }| ).

        ls_contract_header_inx_u = VALUE bapisdh1x( updateflag = 'U' ).

        READ TABLE lt_produtoescolhido TRANSPORTING NO FIELDS
                                                     WITH KEY salesdocument = <fs_prodescheader>-salesdocument
                                                     BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          LOOP AT lt_produtoescolhido ASSIGNING FIELD-SYMBOL(<fs_produtoescolhido>) FROM sy-tabix.
            IF <fs_produtoescolhido>-salesdocument NE <fs_prodescheader>-salesdocument.
              EXIT.
            ENDIF.

            READ TABLE lt_centro ASSIGNING FIELD-SYMBOL(<fs_centro>)
                                               WITH KEY vbeln = lv_salesdocument_u
                                                        posnr = <fs_produtoescolhido>-po_itm_no
                                                        BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              DATA(lv_centro) = <fs_centro>-werks.
            ELSE.
              CLEAR lv_centro.
            ENDIF.

            APPEND VALUE #( itm_number  = CONV #( <fs_produtoescolhido>-po_itm_no )
                            material    = CONV matnr18( |{ <fs_produtoescolhido>-material ALPHA = IN }| )
                            reason_rej  = <fs_produtoescolhido>-reason_rej
                            ref_1       = gs_input-mt_criar_contrato-contract_header_in-purch_no_c
                            plant       = lv_centro ) TO lt_contract_item_in_u.

            APPEND VALUE #( itm_number  = abap_true
                            material    = abap_true
                            reason_rej  = abap_true
                            ref_1       = abap_true
                            plant       = abap_true ) TO lt_contract_item_inx_u.

          ENDLOOP.


          IF sy-subrc IS INITIAL.
            ls_contract_header_in_u-ship_cond  = gs_input-mt_criar_contrato-contract_header_in-ship_cond.
            ls_contract_header_inx_u-ship_cond  =  lc_x.
          ENDIF.

          SELECT SINGLE ihrez
          FROM vbak
          WHERE vbeln EQ @lv_salesdocument_u
          INTO @DATA(lv_ihrez). "#EC CI_SEL_NESTED

          IF lv_ihrez IS INITIAL.
            ls_contract_header_in_u-ref_1      = gs_input-mt_criar_contrato-contract_header_in-ref_1.
            ls_contract_header_inx_u-ref_1     = lc_x.
          ENDIF.


          CALL FUNCTION 'BAPI_CUSTOMERCONTRACT_CHANGE'
            EXPORTING
              salesdocument       = lv_salesdocument_u
              contract_header_in  = ls_contract_header_in_u
              contract_header_inx = ls_contract_header_inx_u
            TABLES
              return              = lt_return
              contract_item_in    = lt_contract_item_in_u
              contract_item_inx   = lt_contract_item_inx_u.

          IF ( line_exists( lt_return[ type = 'E' ] ) ).

*            APPEND VALUE #( processado      = TEXT-003
*                            desc_processado = REDUCE string( INIT lv_concat TYPE string
*                                                              FOR ls_ret IN lt_return
*                                                             NEXT lv_concat = lv_concat && ls_ret-message && ' - ' ) ) TO ls_output-mt_status_contrato-form_fields-lista.
            APPEND VALUE #( processado      = TEXT-003
                            desc_processado = VALUE #( lt_return[ 1 ]-message OPTIONAL ) ) TO ls_output-mt_status_contrato-form_fields-lista.

          ELSE.

            me->bapi_commit(  ).

            APPEND VALUE #( processado      = TEXT-003 && ls_salesdocument-salesdocument
                            desc_processado = TEXT-002 && lv_salesdocument_u ) TO ls_output-mt_status_contrato-form_fields-lista.

          ENDIF.

        ENDIF.
      ENDLOOP.

      ls_output-mt_status_contrato-assignee  = gs_input-mt_criar_contrato-contract_header_in-purch_no_c.
      ls_output-mt_status_contrato-comment   = TEXT-001.
      ls_output-mt_status_contrato-ped_fluig = gs_input-mt_criar_contrato-contract_header_in-purch_no_c.

      TRY.
          NEW zclsd_co_si_status_contrato_ou( )->si_status_contrato_out( output = ls_output ).
        CATCH cx_ai_system_fault.
      ENDTRY.

    ENDIF.

  ENDMETHOD.


  METHOD bapi_commit.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

  ENDMETHOD.


  METHOD erro.

    RAISE EXCEPTION TYPE zcxsd_erro_interface
      EXPORTING
        textid = is_erro.

  ENDMETHOD.


  METHOD call_shdb.

    DATA: lt_bdcdata    TYPE STANDARD TABLE OF bdcdata,
          lt_bdcmsgcoll TYPE STANDARD TABLE OF bdcmsgcoll.

    DATA: lv_mode TYPE char1 VALUE 'N'.

    lt_bdcdata = VALUE #( BASE lt_bdcdata ( program  = 'SAPMV45A'
                                            dynpro   = '0102'
                                            dynbegin = 'X' ) ).

    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_OKCODE'
                                            fval = '=ENT2' ) ).

    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'VBAK-VBELN'
                                            fval = iv_vbeln ) ).

    lt_bdcdata = VALUE #( BASE lt_bdcdata ( program  = 'SAPMV45A'
                                            dynpro   = '4001'
                                            dynbegin = 'X' ) ).

    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_OKCODE'
                                            fval = '=FEAZ' ) ).

    LOOP AT gs_input-mt_criar_contrato-contract_item_in ASSIGNING FIELD-SYMBOL(<fs_contract_item_in_c>).

      lt_bdcdata = VALUE #( BASE lt_bdcdata ( program  = 'SAPMSSY0'
                                              dynpro   = '0120'
                                              dynbegin = 'X' ) ).

      lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_OKCODE'
                                              fval = '=&ALL' ) ).

      lt_bdcdata = VALUE #( BASE lt_bdcdata ( program  = 'SAPMSSY0'
                                              dynpro   = '0120'
                                              dynbegin = 'X' ) ).

      lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_OKCODE'
                                              fval = '=FEBE' ) ).

      lt_bdcdata = VALUE #( BASE lt_bdcdata ( program  = 'SAPLIPW1'
                                              dynpro   = '0300'
                                              dynbegin = 'X' ) ).

      lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_OKCODE'
                                              fval = '=RWS' ) ).

    ENDLOOP.

    lt_bdcdata = VALUE #( BASE lt_bdcdata ( program  = 'SAPMV45A'
                                            dynpro   = '4001'
                                            dynbegin = 'X' ) ).

    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_OKCODE'
                                            fval = '=SICH' ) ).

    CALL TRANSACTION 'VA42'
               USING lt_bdcdata
                MODE lv_mode
       MESSAGES INTO lt_bdcmsgcoll.

  ENDMETHOD.


  METHOD get_plant.

    RETURN.
*    SELECT SINGLE werks FROM vbap
*    WHERE vbeln = @gs_input-mt_criar_contrato-produtorecolhido-salesdocument
*      AND posnr = @gs_input-mt_criar_contrato-produtorecolhido-po_itm_no
*    INTO @rv_result.

  ENDMETHOD.
ENDCLASS.
