CLASS zclsd_saga_envio_pre_registro DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS envio_registro
      IMPORTING
        !iv_ordemfrete TYPE ze_ordemfrete OPTIONAL
        !iv_remessa    TYPE vbeln
      EXPORTING
        !et_return     TYPE bapiret2_t .
  PROTECTED SECTION.
private section.

  types:
    BEGIN OF ty_likp,
      vbeln TYPE likp-vbeln,
      erdat TYPE likp-erdat,
      vstel TYPE likp-vstel,
      vkorg TYPE likp-vkorg,
      lfart TYPE likp-lfart,
      wadat TYPE likp-wadat,
      lifsk TYPE likp-lifsk,
      lprio TYPE likp-lprio,
      kunnr TYPE likp-kunnr,
      kunag TYPE likp-kunag,
      anzpk TYPE likp-anzpk,
      vtwiv TYPE likp-vtwiv,
      werks TYPE likp-werks,
    END OF ty_likp .
  types:
    BEGIN OF ty_knvv,
      kunnr TYPE knvv-kunnr,
      vkorg TYPE knvv-vkorg,
      vtweg TYPE knvv-vtweg,
      kvgr5 TYPE knvv-kvgr5,
    END OF ty_knvv .
  types:
    BEGIN OF ty_vbpa,
      vbeln TYPE vbpa-vbeln,
      parvw TYPE vbpa-parvw,
      adrnr TYPE vbpa-adrnr,
    END OF ty_vbpa .
  types:
    BEGIN OF ty_vbak,
      vbeln TYPE vbak-vbeln,
      xblnr TYPE vbak-xblnr,
    END OF ty_vbak .
  types:
    BEGIN OF ty_adrc,
      addrnumber TYPE adrc-addrnumber,
      date_from  TYPE adrc-date_from,
      city1      TYPE adrc-city1,
      city2      TYPE adrc-city2,
      post_code1 TYPE adrc-post_code1,
      street     TYPE adrc-street,
      region     TYPE adrc-region,
      tel_number TYPE adrc-tel_number,
    END OF ty_adrc .
  types:
    BEGIN OF ty_lips,
      vbeln TYPE lips-vbeln,
      posnr TYPE lips-posnr,
      matnr TYPE lips-matnr,
      lgort TYPE lips-lgort,
      lfimg TYPE lips-lfimg,
      vrkme TYPE lips-vrkme,
    END OF ty_lips .
  types:
    BEGIN OF ty_marm,
      matnr TYPE matnr,
      meinh TYPE meinh,
      umrez TYPE umrez,
    END OF ty_marm .
  types:
* I - MAS - GAP1157
    BEGIN OF ty_vbkd,
           vbeln TYPE vbak-vbeln,
           bsark TYPE vbkd-bsark,
         END OF ty_vbkd .
  types:
* F - MAS - GAP1157
    ty_ty_knvv TYPE TABLE OF ty_knvv .
  types:
    ty_ty_vbpa TYPE TABLE OF ty_vbpa .
  types:
    ty_ty_adrc TYPE TABLE OF ty_adrc .
  types:
    ty_ty_lips TYPE TABLE OF ty_lips .
  types:
    ty_ty_marm TYPE TABLE OF ty_marm .

  data GO_SRV_TOR type ref to /BOBF/IF_TRA_SERVICE_MANAGER .

  methods BUSCA_DADOS
    importing
      !IV_REMESSA type VBELN
    exporting
      !ES_LIKP type TY_LIKP
      !ET_KNVV type TY_TY_KNVV
      !ET_VBPA type TY_TY_VBPA
      !ES_VBAK type TY_VBAK
      !ET_ADRC type TY_TY_ADRC
      !ET_LIPS type TY_TY_LIPS
      !ET_MARM type TY_TY_MARM
      !ES_VBKD type TY_VBKD .
  methods VALIDA_PARAMETROS
    importing
      !IS_LIKP type TY_LIKP
      !IV_KVGR5 type KVGR5
    exporting
      !EV_DATAAGEND type WADAT
      !EV_ZTIPO type ZE_ZTIPO
      !EV_ZTIPOG type ZE_ZTIPOG .
  methods ENVIO_SAGA
    importing
      !IS_OUTPUT type ZCLSD_MT_REMESSA_ORDEM .
  methods ENVIA_TRANSPORTE
    importing
      !IV_ORDEMFRETE type ZE_ORDEMFRETE
    exporting
      !ES_TRANSP type ZCLSD_DT_REMESSA_ORDEM_TRANSPO
      !EV_AGENTE_FRETE type /SCMTMS/PTY_CARRIER .
ENDCLASS.



CLASS ZCLSD_SAGA_ENVIO_PRE_REGISTRO IMPLEMENTATION.


  METHOD busca_dados.
    DATA: lt_docflow TYPE tdt_docflow.
    DATA: lv_parvw TYPE c LENGTH 2.
* I - MAS - GAP1157
    DATA: ls_vbak TYPE ty_vbak.
* F - MAS - GAP1157
*    DO 5 TIMES.
    SELECT SINGLE vbeln,
                  erdat,
                  vstel,
                  vkorg,
                  lfart,
                  wadat,
                  lifsk,
                  lprio,
                  kunnr,
                  kunag,
                  anzpk,
                  vtwiv,
                  werks
      FROM likp
       INTO @DATA(ls_likp)
      WHERE vbeln = @iv_remessa.
    IF sy-subrc IS INITIAL.

      SELECT SINGLE xblnr
               FROM ekes
               INTO @DATA(lv_ekes_xblnr)
              WHERE vbeln EQ @iv_remessa.

      IF sy-subrc EQ 0.

        SELECT SINGLE xblnr
       FROM mkpf
       INTO @DATA(lv_mkpf_xblnr)
      WHERE le_vbeln EQ @lv_ekes_xblnr.

        IF sy-subrc EQ 0.

          SELECT SINGLE cnpj_bupla
                   FROM j_1bnfdoc
                   INTO @DATA(lv_cgc)
                  WHERE nftype EQ 'YC'
                    AND nfenum EQ @lv_mkpf_xblnr.

          IF sy-subrc EQ 0.

            SELECT SINGLE *
                     FROM i_supplier
                     INTO @DATA(ls_customer)
                    WHERE taxnumber1 EQ @lv_cgc.

            IF sy-subrc EQ 0.
              ls_likp-kunag = ls_customer-supplier.
            ENDIF.

          ENDIF.

        ENDIF.

      ENDIF.

*        EXIT.
*      ELSE.
*        WAIT UP TO 1 SECONDS.
    ENDIF.
*    ENDDO.
    IF ls_likp IS NOT INITIAL.
      SELECT kunnr, vkorg, vtweg, kvgr5
        FROM knvv
        INTO TABLE @DATA(lt_knvv)
        WHERE kunnr = @ls_likp-kunnr AND
              vkorg = @ls_likp-vkorg AND
              vtweg = @ls_likp-vtwiv.

      CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
        EXPORTING
          input  = 'RM'
        IMPORTING
          output = lv_parvw.

      SELECT vbeln, parvw, adrnr
        FROM vbpa
        INTO TABLE @DATA(lt_vbpa)
        WHERE vbeln = @iv_remessa AND
              parvw = @lv_parvw.

      IF sy-subrc IS INITIAL.


        CALL FUNCTION 'SD_DOCUMENT_FLOW_GET' "#EC CI_SEL_NESTED
          EXPORTING
            iv_docnum  = iv_remessa
          IMPORTING
            et_docflow = lt_docflow.

        IF lt_docflow IS NOT INITIAL.

          READ TABLE lt_docflow INTO DATA(ls_flow) WITH KEY vbtyp_n = 'H'.
          IF sy-subrc IS INITIAL.

            SELECT SINGLE vbeln, xblnr
              FROM vbak
              INTO @ls_vbak
              WHERE vbeln = @ls_flow-docnum.

            IF ls_vbak-xblnr IS INITIAL.

              SELECT vbeln,
                     xblnr
                FROM vbrk
               WHERE vbeln = @ls_flow-docnuv
                INTO @DATA(ls_vbrk)
                UP TO 1 ROWS.
              ENDSELECT.

              IF sy-subrc IS INITIAL.
                ls_vbak-xblnr = ls_vbrk-xblnr.
              ENDIF.
            ENDIF.

          ELSE.

* I - MAS - GAP1157
            READ TABLE lt_docflow INTO DATA(ls_flow_aux) WITH KEY vbtyp_n = 'C'.
            IF sy-subrc IS INITIAL.

              SELECT SINGLE vbeln, xblnr
               FROM vbak
               INTO @ls_vbak
               WHERE vbeln = @ls_flow_aux-docnum.

              IF sy-subrc IS INITIAL.

                SELECT SINGLE vbeln, bsark
                  FROM vbkd
                  INTO @DATA(ls_vbkd)
                  WHERE vbeln EQ @ls_vbak-vbeln.

              ENDIF.

            ENDIF.
* F - MAS - GAP1157

          ENDIF.

          DATA(lt_vbpa_aux) = lt_vbpa[].
          SORT lt_vbpa_aux BY adrnr.
          DELETE ADJACENT DUPLICATES FROM lt_vbpa_aux COMPARING adrnr.

          IF lt_vbpa_aux[] IS NOT INITIAL.

            SELECT addrnumber, date_from, city1, city2, post_code1, region, tel_number
              FROM adrc
              INTO TABLE @DATA(lt_adrc)
              FOR ALL ENTRIES IN @lt_vbpa_aux
              WHERE addrnumber = @lt_vbpa_aux-adrnr.

            IF sy-subrc IS INITIAL.

              SORT lt_adrc BY date_from DESCENDING.

            ENDIF.
          ENDIF.
        ENDIF.
        SELECT vbeln, posnr, matnr, lgort, lfimg, vrkme
          FROM lips
          INTO TABLE @DATA(lt_lips)
          WHERE vbeln = @iv_remessa.

        IF sy-subrc IS INITIAL.
          DATA(lt_lips_aux) = lt_lips[].
          SORT lt_lips_aux BY  matnr vrkme.
          DELETE ADJACENT DUPLICATES FROM  lt_lips_aux COMPARING matnr vrkme.

          IF lt_lips_aux[] IS NOT INITIAL.

            SELECT matnr, meinh, umrez
              FROM marm
              INTO TABLE @DATA(lt_marm)
              FOR ALL ENTRIES IN @lt_lips_aux
              WHERE matnr = @lt_lips_aux-matnr AND
                    meinh = @lt_lips_aux-vrkme.
            IF sy-subrc IS INITIAL.
              SORT lt_marm BY matnr meinh. "Binary Search
            ENDIF.
          ENDIF.

        ENDIF.

      ENDIF.
    ENDIF.

    es_likp = ls_likp.
    et_knvv = lt_knvv[].
    et_vbpa = lt_vbpa[].
    es_vbak = ls_vbak.
    et_adrc = lt_adrc[].
    et_lips = lt_lips[].
    et_marm = lt_marm[].
* I - MAS - GAP1157
    es_vbkd = ls_vbkd.
* F - MAS - GAP1157

  ENDMETHOD.


  METHOD envio_registro.

    CONSTANTS: lc_zp(10)  TYPE c VALUE 'ZP'.

    DATA ls_output TYPE zclsd_mt_remessa_ordem.
    DATA lv_parvw  TYPE vbpa-parvw.

    me->busca_dados( EXPORTING
                           iv_remessa = iv_remessa
                     IMPORTING
                            es_likp = DATA(ls_likp)
                            et_knvv = DATA(lt_knvv)
                            et_vbpa = DATA(lt_vbps)
                            es_vbak = DATA(ls_vbak)
                            et_adrc = DATA(lt_adrc)
                            et_lips = DATA(lt_lips)
                            et_marm = DATA(lt_marm)
                            es_vbkd = DATA(ls_vbkd) ). " MAS - GAP1157

    IF lt_knvv[] IS NOT INITIAL.
      DATA(lv_kvgr5) = lt_knvv[ 1 ]-kvgr5.
    ENDIF.

    me->valida_parametros( EXPORTING
                                is_likp      = ls_likp
                                iv_kvgr5     = lv_kvgr5
                           IMPORTING
                                ev_dataagend = DATA(lv_dataagend)
                                ev_ztipo     = DATA(lv_ztipo)
                                ev_ztipog    = DATA(lv_ztipog) ).



*      SELECT SINGLE ordem, data_agendada
*       FROM ztsd_agendamento
*       WHERE ordem = @ls_vbak-xblnr
*       INTO @lv_dataagend.

***Flávia Leite - 12/04/202
*    SELECT SINGLE data_agendada
*     FROM ztsd_agendamento
*     WHERE ordem = @ls_vbak-vbeln
      SELECT SINGLE DataAgendada
      FROM zi_sd_hist_agendamento
      WHERE SalesOrder = @ls_vbak-vbeln
        AND agend_valid = @abap_true
***Flávia Leite - 12/04/2023
     INTO @lv_dataagend.


    IF lt_lips[] IS NOT INITIAL.
      DATA(lv_lgort) = lt_lips[ 1 ]-lgort.
      DESCRIBE TABLE lt_lips LINES DATA(lv_lines).
    ENDIF.

    IF lt_adrc[] IS NOT INITIAL.
      DATA(ls_adrc) = lt_adrc[ 1 ].
      DATA(lv_zobspostal) = ls_adrc-street && ' ' && ls_adrc-city1 && ' ' && ls_adrc-city2
                            && ' ' && ls_adrc-post_code1  && ' ' && ls_adrc-region
                            && ' ' && ls_adrc-tel_number.
    ENDIF.

    me->envia_transporte( EXPORTING
                           iv_ordemfrete = iv_ordemfrete
                           IMPORTING
                            es_transp       = DATA(ls_transp)
                            ev_agente_frete = DATA(lv_agente_frete)  ).



    IF lv_agente_frete IS INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
        EXPORTING
          input  = 'SC'
        IMPORTING
          output = lv_parvw.

      SELECT SINGLE lifnr
        FROM vbpa
        WHERE vbeln = @ls_vbak-vbeln AND
                      parvw = @lv_parvw
      into @lv_agente_frete.

    ENDIF.



*HEADER
    ls_output-mt_remessa_ordem-vbeln            = |{ ls_likp-vbeln ALPHA = OUT }|.
    ls_output-mt_remessa_ordem-werks            = ls_likp-vstel.
    ls_output-mt_remessa_ordem-ztipo            = lv_ztipo+10(2).
    ls_output-mt_remessa_ordem-ztipogeracao     = lv_ztipog.
    IF ls_output-mt_remessa_ordem-ztipo = 14.
      ls_output-mt_remessa_ordem-xbelnr           = ls_vbak-xblnr.
    ENDIF.
    ls_output-mt_remessa_ordem-kunag            = COND #( WHEN ls_likp-kunag IS INITIAL THEN ls_likp-kunnr ELSE ls_likp-kunag ).
*    ls_output-mt_remessa_ordem-lifnr            = ls_transp-zcodmot.
    ls_output-mt_remessa_ordem-lifnr            = lv_agente_frete.
    ls_output-mt_remessa_ordem-lprio            = ls_likp-lprio.
    ls_output-mt_remessa_ordem-zordemfrete      = |{ iv_ordemfrete ALPHA = OUT }|.
    ls_output-mt_remessa_ordem-lgort            = lv_lgort.
    ls_output-mt_remessa_ordem-erdat            = ls_likp-erdat.
    ls_output-mt_remessa_ordem-zdataagendamento = lv_dataagend.
    ls_output-mt_remessa_ordem-znritens         = lv_lines.
    ls_output-mt_remessa_ordem-anzpk            = ls_likp-anzpk.
    ls_output-mt_remessa_ordem-zobspostal       = lv_zobspostal.
* I - MAS - GAP1157
    ls_output-mt_remessa_ordem-bsark            = ls_vbkd-bsark.
* F - MAS - GAP1157
*TRANSPORTE
    ls_output-mt_remessa_ordem-transporte-platnumber = ls_transp-platnumber.
    ls_output-mt_remessa_ordem-transporte-zcodmot    = ls_transp-zcodmot.
    ls_output-mt_remessa_ordem-transporte-zcpfmot    = ls_transp-zcpfmot.
    ls_output-mt_remessa_ordem-transporte-ztpveic    = ls_transp-ztpveic.
    ls_output-mt_remessa_ordem-transporte-znomemot   = ls_transp-znomemot .

    IF ls_likp-lifsk EQ lc_zp.
      DATA(lv_lifsk) = ls_likp-lifsk.
    ENDIF.

    LOOP AT lt_lips ASSIGNING FIELD-SYMBOL(<fs_lips>).

      READ TABLE lt_marm ASSIGNING FIELD-SYMBOL(<fs_marm>) WITH KEY matnr = <fs_lips>-matnr
                                                                    meinh = <fs_lips>-vrkme
                                                                    BINARY SEARCH.
      IF sy-subrc IS INITIAL.

        CHECK <fs_lips>-lfimg > 0.
*ITENS
        APPEND VALUE #( posnr = <fs_lips>-posnr
                        matnr = <fs_lips>-matnr
                        umrez = <fs_marm>-umrez
                        lfimg = <fs_lips>-lfimg
                        lifsk = lv_lifsk
        ) TO ls_output-mt_remessa_ordem-itens.

      ENDIF.
    ENDLOOP.

    me->envio_saga( EXPORTING
                           is_output = ls_output ).
    .
  ENDMETHOD.


  METHOD envio_saga.

    TRY.
        NEW zclsd_co_si_envia_remessa_orde( )->si_envia_remessa_ordem_out( EXPORTING output = is_output ).
        COMMIT WORK.
      CATCH cx_root INTO DATA(lo_cx_root).
*      CATCH cx_ai_system_fault INTO DATA(lo_cx_root).
        DATA(lv_msg)  = lo_cx_root->get_text( ).
    ENDTRY.
  ENDMETHOD.


  METHOD valida_parametros.

    CONSTANTS: lc_modulo_3 TYPE ztca_param_mod-modulo VALUE 'SD',
               lc_chave1_3 TYPE ztca_param_par-chave1 VALUE 'SAGA',
               lc_chave2_3 TYPE ztca_param_par-chave2 VALUE 'ZTIPO'.
*            lc_chave3_3 TYPE ztca_param_par-chave3 VALUE 'GATILHO'.

    CONSTANTS: lc_modulo_4 TYPE ztca_param_mod-modulo VALUE 'SD',
               lc_chave1_4 TYPE ztca_param_par-chave1 VALUE 'SAGA',
               lc_chave2_4 TYPE ztca_param_par-chave2 VALUE 'ZTIPOGERACAO'.
*            lc_chave3_3 TYPE ztca_param_par-chave3 VALUE 'GATILHO'.

    CONSTANTS: lc_modulo_5 TYPE ztca_param_mod-modulo VALUE 'SD',
               lc_chave1_5 TYPE ztca_param_par-chave1 VALUE 'ADM_AGENDAMENTO',
               lc_chave2_5 TYPE ztca_param_par-chave2 VALUE 'GRP_AGENDA'.

    DATA: lv_chave2_2 TYPE ztca_param_par-chave2,
          lv_chave3_3 TYPE ztca_param_par-chave3,
          lv_chave3_4 TYPE ztca_param_par-chave3.

    DATA: lr_ztipo  TYPE RANGE OF ze_ztipo,
          lr_ztipog TYPE RANGE OF ze_ztipog,
          lr_agenda TYPE RANGE OF kvgr5.

    CLEAR: lr_ztipo, lr_ztipog, lr_agenda .


    lv_chave3_3 = is_likp-lfart.
    lv_chave3_4 = is_likp-lfart.

** Seleçao dos parametros
    DATA(lo_parametros) = NEW zclca_tabela_parametros( ).

*Buscar
    TRY.
        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_modulo_3
            iv_chave1 = lc_chave1_3
            iv_chave2 = lc_chave2_3
            iv_chave3 = lv_chave3_3
          IMPORTING
            et_range  = lr_ztipo ).
      CATCH zcxca_tabela_parametros.
        "handle exception
    ENDTRY.

* Saída
    READ TABLE lr_ztipo ASSIGNING FIELD-SYMBOL(<fs_tipo>) INDEX 1.
    IF sy-subrc EQ 0.
      ev_ztipo = <fs_tipo>-low.
    ENDIF.

*Buscar
    TRY.
        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_modulo_4
            iv_chave1 = lc_chave1_4
            iv_chave2 = lc_chave2_4
            iv_chave3 = lv_chave3_4
          IMPORTING
            et_range  = lr_ztipog ).
      CATCH zcxca_tabela_parametros.
        "handle exception
    ENDTRY.

* Saída
    READ TABLE lr_ztipog ASSIGNING FIELD-SYMBOL(<fs_tipog>) INDEX 1.
    IF sy-subrc EQ 0.
      ev_ztipog = <fs_tipog>-low.
    ELSE.
      ev_ztipog = 0.
    ENDIF.

*Buscar
    TRY.
        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_modulo_5
            iv_chave1 = lc_chave1_5
            iv_chave2 = lc_chave2_5
          IMPORTING
            et_range  = lr_agenda ).
      CATCH zcxca_tabela_parametros.
        "handle exception
    ENDTRY.

    IF NOT iv_kvgr5 IN lr_agenda .
      ev_dataagend = ''.
*      ev_dataagend = is_likp-wadat.
    ENDIF.

  ENDMETHOD.


  METHOD envia_transporte.

    DATA: lt_tor          TYPE /scmtms/t_tor_root_k,
          lt_tor_root_key TYPE /bobf/t_frw_key,
          lt_tor_party    TYPE /scmtms/t_tor_party_k,
          lt_parameters   TYPE /bobf/t_frw_query_selparam,
          lt_itemtr       TYPE /scmtms/t_tor_item_tr_k.

    go_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    APPEND INITIAL LINE TO lt_parameters ASSIGNING FIELD-SYMBOL(<fs_parameters>).
    <fs_parameters>-attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-root_elements-tor_id.
    <fs_parameters>-sign   = 'I'.
    <fs_parameters>-option = 'EQ'.
    <fs_parameters>-low    = iv_ordemfrete.

    go_srv_tor->query(
                        EXPORTING
                          iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements
                          it_selection_parameters = lt_parameters
                          iv_fill_data            = abap_true
                        IMPORTING
                          et_key                  = lt_tor_root_key
                          et_data                 = lt_tor
                     ).

    LOOP AT lt_tor ASSIGNING FIELD-SYMBOL(<fs_tor>).

      /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_tor>-key CHANGING ct_key = lt_tor_root_key ).

      go_srv_tor->retrieve_by_association(
        EXPORTING
          iv_node_key             = /scmtms/if_tor_c=>sc_node-root
          it_key                  = lt_tor_root_key
          iv_association          = /scmtms/if_tor_c=>sc_association-root-item_tr
          iv_fill_data            = abap_true
        IMPORTING
          et_data                 = lt_itemtr
      ).
      go_srv_tor->retrieve_by_association(
       EXPORTING
           iv_node_key             = /scmtms/if_tor_c=>sc_node-root
           it_key                  = lt_tor_root_key
           iv_association = /scmtms/if_tor_c=>sc_association-root-party
           iv_fill_data   = abap_true
       IMPORTING
            et_data       = lt_tor_party ).

      ev_agente_frete = <fs_tor>-tspid.

    ENDLOOP.
    LOOP AT lt_itemtr ASSIGNING FIELD-SYMBOL(<fs_itemtr>).
      CHECK <fs_itemtr>-item_cat = 'AVR'.
      es_transp-ztpveic = <fs_itemtr>-tures_tco.
      es_transp-platnumber = <fs_itemtr>-platenumber.
    ENDLOOP.
    LOOP AT lt_tor_party ASSIGNING FIELD-SYMBOL(<fs_party>).
      es_transp-zcodmot = <fs_party>-party_id.
    ENDLOOP.
    IF es_transp-zcodmot IS NOT INITIAL.
      SELECT SINGLE lifnr, mcod1, stcd2
        FROM lfa1
        INTO @DATA(ls_lfa1)
        WHERE lifnr = @es_transp-zcodmot.

      IF sy-subrc IS INITIAL.
        es_transp-znomemot = ls_lfa1-mcod1.
        es_transp-zcpfmot  = ls_lfa1-stcd2.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
