CLASS zclsd_nfe_print DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_ex_cl_nfe_print .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      check_coligada
        IMPORTING
          is_obj_header      TYPE j_1bnfdoc
        RETURNING
          VALUE(rv_coligada) TYPE abap_bool.

ENDCLASS.



CLASS zclsd_nfe_print IMPLEMENTATION.


  METHOD if_ex_cl_nfe_print~call_rsnast00.

****Impressão automática da Danfe Simplificada
    INCLUDE zsde_imprimir_nfe_auto IF FOUND.

****Integração GKO
    INCLUDE ztme_integracao_gko IF FOUND.

****Automação GNRE
    INCLUDE zsdi_automacao_gnre IF FOUND.

  ENDMETHOD.


  METHOD if_ex_cl_nfe_print~check_subsequent_documents.
  ENDMETHOD.


  METHOD if_ex_cl_nfe_print~determine_matdoc_cancel_date.
  ENDMETHOD.


  METHOD if_ex_cl_nfe_print~exclude_nfes_from_batch.
  ENDMETHOD.


  METHOD if_ex_cl_nfe_print~fill_autxml.
  ENDMETHOD.


  METHOD if_ex_cl_nfe_print~fill_cte.
  ENDMETHOD.


  METHOD if_ex_cl_nfe_print~fill_cte_200.
  ENDMETHOD.


  METHOD if_ex_cl_nfe_print~fill_cte_300.
  ENDMETHOD.


  METHOD if_ex_cl_nfe_print~fill_export.
  ENDMETHOD.


  METHOD if_ex_cl_nfe_print~fill_fuel.
  ENDMETHOD.


  METHOD if_ex_cl_nfe_print~fill_header.

    DATA: it_lin          TYPE TABLE OF j_1bnflin,
          it_item         TYPE j1b_nf_xml_item_tab,
          wa_item         LIKE LINE OF it_item,
          wa_item_aux     LIKE LINE OF it_item,
          it_item_aux     TYPE j1b_nf_xml_item_tab,
          it_tax          TYPE TABLE OF j_1bnfstx,
          it_tax_aux      TYPE TABLE OF j_1bnfstx,
          wa_tax_aux      TYPE j_1bnfstx,
          it_item_tax     TYPE j1b_nf_xml_item_tab,
          wa_item_tax     LIKE LINE OF it_item_tax,
          it_item_310     TYPE j_1bnfe_t_badi_item,
          it_item_310_aux TYPE j_1bnfe_t_badi_item,
          gs_item_310     TYPE j_1bnfe_s_badi_item,
          gs_item_310_aux TYPE j_1bnfe_s_badi_item,
          l_vdesc         TYPE j1b_nf_xml_item-vdesc,
          lv_matnr        TYPE j_1bnflin-matnr,
          v_string        TYPE string,
          wk_tax          TYPE j_1bnfstx.

    FIELD-SYMBOLS: <fs_it_nfftx> TYPE  STANDARD TABLE, "Victor Almeida 02.02.2010
                   <fs_header>   TYPE j1b_nf_xml_header,
                   <fs_tax>      TYPE j_1bnfstx_tab,
                   <ls_tax>      TYPE j_1bnfstx,
                   <fs_item>     TYPE j1b_nf_xml_item_tab,
                   <fs_item_310> TYPE j_1bnfe_t_badi_item, "STK(NABT) - Target 59168 - 19.04.2017
                   <fs_item310>  TYPE j_1bnfe_t_badi_item,
                   <wk_item>     TYPE any.


    CLEAR: it_lin[].
*  IF in_doc-parvw NE c_br AND lv_check IS INITIAL.

    CLEAR v_string.
    v_string = '(SAPLJ_1B_NFE)wk_item[]'.
    ASSIGN (v_string) TO <wk_item>.
    IF <wk_item> IS ASSIGNED.
      it_lin = <wk_item>.
    ENDIF.


        IF in_doc-land1 = 'BR' AND
           check_coligada( in_doc ) IS INITIAL.
*           AND <wk_item>[ 1 ]-itmtyp NE '2'.

*    IF sy-uname EQ 'LSCHEPP' OR
*       sy-uname EQ 'CGARCIA' OR
*       sy-uname EQ 'SEIXASS'.

    CLEAR v_string.
    v_string = '(SAPLJ_1B_NFE)xmli_tab'.
    ASSIGN (v_string) TO <fs_item>.
    IF <fs_item> IS ASSIGNED.
      it_item[] = <fs_item>.
    ENDIF.

**********************************************************************
******** Não faz a junção dos itens quando for transferência. ********
**********************************************************************


    it_item_tax = it_item.

    "IF in_doc-xmlvers EQ c_xml_310.
    ASSIGN ('(SAPLJ_1B_NFE)wk_item_tax[]') TO <fs_tax>.
    IF sy-subrc EQ 0.
      it_tax = <fs_tax>.
    ENDIF.
    "ENDIF.
    "<<Fim FFF NFE V310

* Início - STK(NABT) - Target 59168 - 19.04.2017
    CLEAR v_string.
    v_string = '(SAPLJ_1B_NFE)XMLI_TAB_310[]'.
    ASSIGN (v_string) TO <fs_item_310>.
    IF <fs_item_310> IS ASSIGNED.
      it_item_310[] = <fs_item_310>.
    ENDIF.
* Fim - STK(NABT) - Target 59168 - 19.04.2017

*    CLEAR wa_cont_aux.

    SORT: it_item BY cprod,
          it_item_310 BY docnum itmnum. "STK(NABT) - Target 59168 - 19.04.2017
    LOOP AT it_item INTO wa_item.

      IF wa_item-cprod NE wa_item_aux-cprod.

        " Início - STK(NABT) - Target 59168 - 19.04.2017
        READ TABLE it_item_310 INTO gs_item_310_aux WITH KEY docnum = wa_item-docnum
                                                             itmnum = wa_item-itmnum.
        IF sy-subrc EQ 0.
          CLEAR: gs_item_310_aux-vicmsop,
                 gs_item_310_aux-vicmsdif,
                 gs_item_310_aux-vicmsdeson,
                 gs_item_310_aux-vipidevol,
                 gs_item_310_aux-vbcstret,
               gs_item_310_aux-vicmssubstituto,
               gs_item_310_aux-vbcfcpstret,
               gs_item_310_aux-vfcpstret,
               gs_item_310_aux-vbcefet,
               gs_item_310_aux-vicmsefet,
               gs_item_310_aux-vicmsstret.
        ENDIF.
        " Fim - STK(NABT) - Target 59168 - 19.04.2017

        CLEAR: wa_item_aux.
        MOVE-CORRESPONDING: wa_item TO wa_item_aux.

        CLEAR:  wa_item_aux-vprod,
** Inicio - Josieudes Claudio - Target 57836 - 27.03.17
* Acumular valor do desconto de itens particionados
                wa_item_aux-vdesc,
** Fim - Josieudes Claudio - Target 57836 - 27.03.17
                wa_item_aux-qcom_v20,
                wa_item_aux-qtrib_v20,
                wa_item_aux-l1_00_vbc,
                wa_item_aux-l1_00_vicms,
                wa_item_aux-l1_10_vbc,
                wa_item_aux-l1_10_vicms,
                wa_item_aux-l1_10_vbcst,
                wa_item_aux-l1_10_vicmsst,
                wa_item_aux-l1_20_vbc,
                wa_item_aux-l1_20_vicms,
                wa_item_aux-l1_30_vbcst,
                wa_item_aux-l1_30_vicmsst,
                wa_item_aux-l1_51_vbc,
                wa_item_aux-l1_51_vicms,
                wa_item_aux-l1_60_vbcst,
                wa_item_aux-l1_60_vicmsst,
                wa_item_aux-l1_70_vbc,
                wa_item_aux-l1_70_vicms,
                wa_item_aux-l1_70_vbcst,
                wa_item_aux-l1_70_vicmsst,
                wa_item_aux-l1_90_vbc,
                wa_item_aux-l1_90_vicms,
                wa_item_aux-l1_90_vbcst,
                wa_item_aux-l1_90_vicmsst,
                wa_item_aux-n1_vbc,
                wa_item_aux-n1_qunid,
                wa_item_aux-n1_vunid,
                wa_item_aux-n1_vipi,
                wa_item_aux-p1_vbc,
                wa_item_aux-p1_vpis,
                wa_item_aux-p2_vpis,
                wa_item_aux-p4_vbc,
                wa_item_aux-p4_vpis,
                wa_item_aux-p5_vbc,
                wa_item_aux-p5_vpis,
                wa_item_aux-q1_vbc,
                wa_item_aux-q1_vcofins,
                wa_item_aux-q2_vcofins,
                wa_item_aux-q4_vbc,
                wa_item_aux-q4_vcofins,
                wa_item_aux-q5_vbc,
                wa_item_aux-q5_vcofins,
                wa_item_aux-x_vbc,
                wa_item_aux-x_vissqn,
                wa_item_aux-vicmssubstituto, wa_item_aux-vbcfcpstret, wa_item_aux-vfcpstret, wa_item_aux-vbcefet, wa_item_aux-vicmsefet,
                wa_item_aux-vfrete.

*        ADD 1 TO wa_cont_aux.

        LOOP AT it_item INTO wa_item WHERE cprod EQ wa_item_aux-cprod.

          wa_item_aux-vprod         = wa_item_aux-vprod         + wa_item-vprod.
** Inicio - Josieudes Claudio - Target 57836 - 27.03.17
* Acumular valor do desconto de itens particionados
          wa_item_aux-vdesc         = wa_item_aux-vdesc         + wa_item-vdesc.
** Fim - Josieudes Claudio - Target 57836 - 27.03.17
          wa_item_aux-qcom_v20        = wa_item_aux-qcom_v20        + wa_item-qcom_v20.
          wa_item_aux-qtrib_v20       = wa_item_aux-qtrib_v20       + wa_item-qtrib_v20.
          wa_item_aux-l1_00_vbc       = wa_item_aux-l1_00_vbc       + wa_item-l1_00_vbc.
          wa_item_aux-l1_00_vicms     = wa_item_aux-l1_00_vicms     + wa_item-l1_00_vicms.
          wa_item_aux-l1_10_vbc       = wa_item_aux-l1_10_vbc       + wa_item-l1_10_vbc.
          wa_item_aux-l1_10_vicms     = wa_item_aux-l1_10_vicms     + wa_item-l1_10_vicms.
          wa_item_aux-l1_10_vbcst     = wa_item_aux-l1_10_vbcst     + wa_item-l1_10_vbcst.
          wa_item_aux-l1_10_vicmsst   = wa_item_aux-l1_10_vicmsst   + wa_item-l1_10_vicmsst.
          wa_item_aux-l1_20_vbc       = wa_item_aux-l1_20_vbc       + wa_item-l1_20_vbc.
          wa_item_aux-l1_20_vicms     = wa_item_aux-l1_20_vicms     + wa_item-l1_20_vicms.
          wa_item_aux-l1_30_vbcst     = wa_item_aux-l1_30_vbcst     + wa_item-l1_30_vbcst.
          wa_item_aux-l1_30_vicmsst   = wa_item_aux-l1_30_vicmsst   + wa_item-l1_30_vicmsst.
          wa_item_aux-l1_51_vbc       = wa_item_aux-l1_51_vbc       + wa_item-l1_51_vbc.
          wa_item_aux-l1_51_vicms     = wa_item_aux-l1_51_vicms     + wa_item-l1_51_vicms.
          wa_item_aux-l1_60_vbcst     = wa_item_aux-l1_60_vbcst     + wa_item-l1_60_vbcst.
          wa_item_aux-l1_60_vicmsst   = wa_item_aux-l1_60_vicmsst   + wa_item-l1_60_vicmsst.
          wa_item_aux-l1_70_vbc       = wa_item_aux-l1_70_vbc       + wa_item-l1_70_vbc.
          wa_item_aux-l1_70_vicms     = wa_item_aux-l1_70_vicms     + wa_item-l1_70_vicms.
          wa_item_aux-l1_70_vbcst     = wa_item_aux-l1_70_vbcst     + wa_item-l1_70_vbcst.
          wa_item_aux-l1_70_vicmsst   = wa_item_aux-l1_70_vicmsst   + wa_item-l1_70_vicmsst.
          wa_item_aux-l1_90_vbc       = wa_item_aux-l1_90_vbc       + wa_item-l1_90_vbc.
          wa_item_aux-l1_90_vicms     = wa_item_aux-l1_90_vicms     + wa_item-l1_90_vicms.
          wa_item_aux-l1_90_vbcst     = wa_item_aux-l1_90_vbcst     + wa_item-l1_90_vbcst.
          wa_item_aux-l1_90_vicmsst   = wa_item_aux-l1_90_vicmsst   + wa_item-l1_90_vicmsst.
          wa_item_aux-n1_vbc          = wa_item_aux-n1_vbc          + wa_item-n1_vbc.
          wa_item_aux-n1_qunid        = wa_item_aux-n1_qunid        + wa_item-n1_qunid.
          wa_item_aux-n1_vunid        = wa_item_aux-n1_vunid        + wa_item-n1_vunid.
          wa_item_aux-n1_vipi         = wa_item_aux-n1_vipi         + wa_item-n1_vipi.
          wa_item_aux-p1_vbc          = wa_item_aux-p1_vbc          + wa_item-p1_vbc.
          wa_item_aux-p1_vpis         = wa_item_aux-p1_vpis         + wa_item-p1_vpis.
          wa_item_aux-p2_vpis         = wa_item_aux-p2_vpis         + wa_item-p2_vpis.
          wa_item_aux-p4_vbc          = wa_item_aux-p4_vbc          + wa_item-p4_vbc.
          wa_item_aux-p4_vpis         = wa_item_aux-p4_vpis         + wa_item-p4_vpis.
          wa_item_aux-p5_vbc          = wa_item_aux-p5_vbc          + wa_item-p5_vbc.
          wa_item_aux-p5_vpis         = wa_item_aux-p5_vpis         + wa_item-p5_vpis.
          wa_item_aux-q1_vbc          = wa_item_aux-q1_vbc          + wa_item-q1_vbc.
          wa_item_aux-q1_vcofins      = wa_item_aux-q1_vcofins      + wa_item-q1_vcofins.
          wa_item_aux-q2_vcofins      = wa_item_aux-q2_vcofins      + wa_item-q2_vcofins.
          wa_item_aux-q4_vbc          = wa_item_aux-q4_vbc          + wa_item-q4_vbc.
          wa_item_aux-q4_vcofins      = wa_item_aux-q4_vcofins      + wa_item-q4_vcofins.
          wa_item_aux-q5_vbc          = wa_item_aux-q5_vbc          + wa_item-q5_vbc.
          wa_item_aux-q5_vcofins      = wa_item_aux-q5_vcofins      + wa_item-q5_vcofins.
          wa_item_aux-x_vbc           = wa_item_aux-x_vbc           + wa_item-x_vbc.
          wa_item_aux-x_vissqn        = wa_item_aux-x_vissqn        + wa_item-x_vissqn.

          wa_item_aux-vicmssubstituto = wa_item-vicmssubstituto."wa_item_aux-vicmssubstituto + wa_item-vicmssubstituto.
          wa_item_aux-vbcfcpstret     = wa_item-vbcfcpstret.    "wa_item_aux-vbcfcpstret     + wa_item-vbcfcpstret.
          wa_item_aux-vfcpstret       = wa_item-vfcpstret.      "wa_item_aux-vfcpstret       + wa_item-vfcpstret.
          wa_item_aux-vbcefet         = wa_item-vbcefet.        "wa_item_aux-vbcefet         + wa_item-vbcefet.
          wa_item_aux-vicmsefet       = wa_item-vicmsefet.      "wa_item_aux-vicmsefet       + wa_item-vicmsefet.

          wa_item_aux-vfrete = wa_item_aux-vfrete + wa_item-vfrete.


*            wa_item_aux-vbcstret        = wa_item_aux-vbcstret        + wa_item-vbcstret.
*            wa_item_aux-vICMSSubstituto = wa_item_aux-vICMSSubstituto + wa_item-vICMSSubstituto.
*            wa_item_aux-vICMSSTRet      = wa_item_aux-vICMSSTRet      + wa_item-vICMSSTRet.
*            wa_item_aux-vBCEfet         = wa_item_aux-vBCEfet         + wa_item-vBCEfet.
*            wa_item_aux-vICMSEfet       = wa_item_aux-vICMSEfet       + wa_item-vICMSEfet.


          " Início - STK(NABT) - Target 59168 - 19.04.2017
          READ TABLE it_item_310 INTO gs_item_310 WITH KEY docnum = wa_item-docnum
                                                           itmnum = wa_item-itmnum.
          IF sy-subrc = 0.
            gs_item_310_aux-vicmsop         = gs_item_310_aux-vicmsop         + gs_item_310-vicmsop.
            gs_item_310_aux-vicmsdif        = gs_item_310_aux-vicmsdif        + gs_item_310-vicmsdif.
            gs_item_310_aux-vicmsdeson      = gs_item_310_aux-vicmsdeson      + gs_item_310-vicmsdeson.
            gs_item_310_aux-vipidevol       = gs_item_310_aux-vipidevol       + gs_item_310-vipidevol.

            gs_item_310_aux-vbcstret        = gs_item_310_aux-vbcstret        + gs_item_310-vbcstret.
            gs_item_310_aux-vicmssubstituto = gs_item_310_aux-vicmssubstituto + gs_item_310-vicmssubstituto.
            gs_item_310_aux-vbcfcpstret     = gs_item_310_aux-vbcfcpstret     + gs_item_310-vbcfcpstret    .
            gs_item_310_aux-vfcpstret       = gs_item_310_aux-vfcpstret       + gs_item_310-vfcpstret      .
            gs_item_310_aux-vbcefet         = gs_item_310_aux-vbcefet         + gs_item_310-vbcefet        .
            gs_item_310_aux-vicmsefet       = gs_item_310_aux-vicmsefet       + gs_item_310-vicmsefet      .
            gs_item_310_aux-vicmsstret       = gs_item_310_aux-vicmsstret     + gs_item_310-vicmsstret      .
          ENDIF.
          " Fim - STK(NABT) - Target 59168 - 19.04.2017


          ">>Inicio FFF NFE V310
          "IF in_doc-xmlvers EQ c_xml_310.

          LOOP AT it_tax INTO wk_tax WHERE itmnum = wa_item-itmnum.
            CLEAR wa_tax_aux.

            LOOP AT it_item_tax INTO wa_item_tax WHERE cprod EQ wa_item_aux-cprod
                                                   AND itmnum NE wa_item-itmnum.

              READ TABLE it_tax INTO wa_tax_aux WITH KEY itmnum = wa_item_tax-itmnum
                                                   taxtyp = wk_tax-taxtyp.
              wk_tax-base = wk_tax-base + wa_tax_aux-base.
              wk_tax-taxval = wk_tax-taxval + wa_tax_aux-taxval.
            ENDLOOP.

            APPEND wk_tax TO it_tax_aux.

          ENDLOOP.

          " ENDIF.
          "<<Fim FFF NFE V310
        ENDLOOP.

        ">>Inicio FFF
        IF wa_item_aux-qtrib_v20 IS NOT INITIAL.
          wa_item_aux-vuntrib_v20 = wa_item_aux-vprod / wa_item_aux-qtrib_v20.
        ENDIF.
        "<<Fim FFF
*--
        IF NOT wa_item_aux-qcom_v20 IS INITIAL.
          wa_item_aux-vuncom_v20 = wa_item_aux-vprod / wa_item_aux-qcom_v20.
        ENDIF.
*--
*        wa_item_aux-nitem = wa_cont_aux.
        APPEND wa_item_aux TO it_item_aux.

        " Início - STK(NABT) - Target 59168 - 19.04.2017
        APPEND gs_item_310_aux TO it_item_310_aux.
        " Fim - STK(NABT) - Target 59168 - 19.04.2017

      ENDIF.

    ENDLOOP.

** Inicio - Carlos Henrique - Target 63980 - 19.01.2018
    DATA: lv_nitem TYPE nitem VALUE '001'.
    SORT: it_item_aux BY docnum itmnum.
    LOOP AT it_item_aux ASSIGNING FIELD-SYMBOL(<fs_item_aux>).
      <fs_item_aux>-nitem = lv_nitem.
      ADD 1 TO lv_nitem.
    ENDLOOP.
** Fim - Carlos Henrique - Target 63980 - 19.01.2018


    ">>Inicio FFF NFE V310
    "IF in_doc-xmlvers EQ c_xml_310.
    IF <fs_tax> IS ASSIGNED.
      SORT it_tax_aux BY docnum itmnum taxtyp.
      <fs_tax> = it_tax_aux.
    ENDIF.
    "ENDIF.
    "<<Fim FFF NFE V310
    SORT it_item_aux BY docnum itmnum.
    IF <fs_item> IS ASSIGNED.
      <fs_item> = it_item_aux[].
    ENDIF.
    " Início - STK(NABT) - Target 59168 - 19.04.2017
    IF <fs_item_310> IS ASSIGNED.
      <fs_item_310> = it_item_310_aux[].
    ENDIF.
    " Fim - STK(NABT) - Target 59168 - 19.04.2017

*  ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD if_ex_cl_nfe_print~fill_import.
  ENDMETHOD.


  METHOD if_ex_cl_nfe_print~fill_item.

  ENDMETHOD.


  METHOD if_ex_cl_nfe_print~fill_nve.
  ENDMETHOD.


  METHOD if_ex_cl_nfe_print~fill_trace.
  ENDMETHOD.


  METHOD if_ex_cl_nfe_print~get_server.
  ENDMETHOD.


  METHOD if_ex_cl_nfe_print~get_server_dfe.
  ENDMETHOD.


  METHOD if_ex_cl_nfe_print~is_icms_part_in_exception_list.
  ENDMETHOD.


  METHOD if_ex_cl_nfe_print~reset_subrc.
  ENDMETHOD.


  METHOD if_ex_cl_nfe_print~set_commit.
  ENDMETHOD.


  METHOD if_ex_cl_nfe_print~set_order_for_batch.
  ENDMETHOD.


  METHOD if_ex_cl_nfe_print~fill_add_inflin.
  ENDMETHOD.

  METHOD check_coligada.
    DATA ls_zcgc_coligada TYPE t001w.

    CASE is_obj_header-partyp.
      WHEN 'C'. "Cliente
        SELECT SINGLE *
          FROM t001w
          INTO ls_zcgc_coligada
          WHERE kunnr = is_obj_header-parid.

      WHEN 'V'. "Fornecedor
        SELECT SINGLE *
          FROM t001w
          INTO ls_zcgc_coligada
          WHERE lifnr = is_obj_header-parid.

      WHEN 'B'. "Filial
        SELECT SINGLE *
          FROM t001w
          INTO ls_zcgc_coligada
          WHERE j_1bbranch = is_obj_header-parid+4(4).

      WHEN OTHERS.
        rv_coligada = abap_false.
        RETURN.

    ENDCASE.

    IF sy-subrc IS INITIAL.
      rv_coligada = abap_true.
    ELSE.
      rv_coligada = abap_false.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
