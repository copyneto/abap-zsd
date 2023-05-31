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



CLASS ZCLSD_NFE_PRINT IMPLEMENTATION.


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

    DATA: lt_lin          TYPE TABLE OF j_1bnflin,
          lt_item         TYPE j1b_nf_xml_item_tab,
          ls_item         LIKE LINE OF lt_item,
          ls_item_aux     LIKE LINE OF lt_item,
          lt_item_aux     TYPE j1b_nf_xml_item_tab,
          lt_tax          TYPE TABLE OF j_1bnfstx,
          lt_tax_aux      TYPE TABLE OF j_1bnfstx,
          ls_tax_aux      TYPE j_1bnfstx,
          lt_item_tax     TYPE j1b_nf_xml_item_tab,
          ls_item_tax     LIKE LINE OF lt_item_tax,
          lt_item_310     TYPE j_1bnfe_t_badi_item,
          lt_item_310_aux TYPE j_1bnfe_t_badi_item,
          ls_item_310     TYPE j_1bnfe_s_badi_item,
          ls_item_310_aux TYPE j_1bnfe_s_badi_item,
          lv_vdesc        TYPE j1b_nf_xml_item-vdesc,
          lv_matnr        TYPE j_1bnflin-matnr,
          lv_string       TYPE string,
          ls_tax          TYPE j_1bnfstx.

    FIELD-SYMBOLS: <fs_t_nfftx>    TYPE  STANDARD TABLE, "Victor Almeida 02.02.2010
                   <fs_s_header>   TYPE j1b_nf_xml_header,
                   <fs_t_tax>      TYPE j_1bnfstx_tab,
                   <fs_s_tax>      TYPE j_1bnfstx,
                   <fs_t_item>     TYPE j1b_nf_xml_item_tab,
                   <fs_t_item_310> TYPE j_1bnfe_t_badi_item, "STK(NABT) - Target 59168 - 19.04.2017
                   <fs_t_item310>  TYPE j_1bnfe_t_badi_item,
                   <fs_s_item>     TYPE any.


    CLEAR: lt_lin[].
*  IF in_doc-parvw NE c_br AND lv_check IS INITIAL.

    CLEAR lv_string.
    lv_string = '(SAPLJ_1B_NFE)wk_item[]'.
    ASSIGN (lv_string) TO <fs_s_item>.
    IF <fs_s_item> IS ASSIGNED.
      lt_lin = <fs_s_item>.
    ENDIF.


    IF in_doc-land1 = 'BR' AND
       check_coligada( in_doc ) IS INITIAL.
*           AND <fs_s_item>[ 1 ]-itmtyp NE '2'.

*    IF sy-uname EQ 'LSCHEPP' OR
*       sy-uname EQ 'CGARCIA' OR
*       sy-uname EQ 'SEIXASS'.

      CLEAR lv_string.
      lv_string = '(SAPLJ_1B_NFE)xmli_tab'.
      ASSIGN (lv_string) TO <fs_t_item>.
      IF <fs_t_item> IS ASSIGNED.
        lt_item[] = <fs_t_item>.
      ENDIF.

**********************************************************************
******** Não faz a junção dos itens quando for transferência. ********
**********************************************************************


      lt_item_tax = lt_item.

      "IF in_doc-xmlvers EQ c_xml_310.
      ASSIGN ('(SAPLJ_1B_NFE)wk_item_tax[]') TO <fs_t_tax>.
      IF sy-subrc EQ 0.
        lt_tax = <fs_t_tax>.
      ENDIF.
      "ENDIF.
      "<<Fim FFF NFE V310

* Início - STK(NABT) - Target 59168 - 19.04.2017
      CLEAR lv_string.
      lv_string = '(SAPLJ_1B_NFE)XMLI_TAB_310[]'.
      ASSIGN (lv_string) TO <fs_t_item_310>.
      IF <fs_t_item_310> IS ASSIGNED.
        lt_item_310[] = <fs_t_item_310>.
      ENDIF.
* Fim - STK(NABT) - Target 59168 - 19.04.2017

*    CLEAR ls_cont_aux.

      SORT: lt_item BY cprod,
            lt_item_310 BY docnum itmnum. "STK(NABT) - Target 59168 - 19.04.2017
      LOOP AT lt_item INTO ls_item.

        IF ls_item-cprod NE ls_item_aux-cprod.

          " Início - STK(NABT) - Target 59168 - 19.04.2017
          READ TABLE lt_item_310 INTO ls_item_310_aux WITH KEY docnum = ls_item-docnum
                                                               itmnum = ls_item-itmnum.
          IF sy-subrc EQ 0.
            CLEAR: ls_item_310_aux-vicmsop,
                   ls_item_310_aux-vicmsdif,
                   ls_item_310_aux-vicmsdeson,
                   ls_item_310_aux-vipidevol,
                   ls_item_310_aux-vbcstret,
                 ls_item_310_aux-vicmssubstituto,
                 ls_item_310_aux-vbcfcpstret,
                 ls_item_310_aux-vfcpstret,
                 ls_item_310_aux-vbcefet,
                 ls_item_310_aux-vicmsefet,
                 ls_item_310_aux-vicmsstret.
          ENDIF.
          " Fim - STK(NABT) - Target 59168 - 19.04.2017

          CLEAR: ls_item_aux.
          MOVE-CORRESPONDING: ls_item TO ls_item_aux.

          CLEAR:  ls_item_aux-vprod,
** Inicio - Josieudes Claudio - Target 57836 - 27.03.17
* Acumular valor do desconto de itens particionados
                  ls_item_aux-vdesc,
** Fim - Josieudes Claudio - Target 57836 - 27.03.17
                  ls_item_aux-qcom_v20,
                  ls_item_aux-qtrib_v20,
                  ls_item_aux-l1_00_vbc,
                  ls_item_aux-l1_00_vicms,
                  ls_item_aux-l1_10_vbc,
                  ls_item_aux-l1_10_vicms,
                  ls_item_aux-l1_10_vbcst,
                  ls_item_aux-l1_10_vicmsst,
                  ls_item_aux-l1_20_vbc,
                  ls_item_aux-l1_20_vicms,
                  ls_item_aux-l1_30_vbcst,
                  ls_item_aux-l1_30_vicmsst,
                  ls_item_aux-l1_51_vbc,
                  ls_item_aux-l1_51_vicms,
                  ls_item_aux-l1_60_vbcst,
                  ls_item_aux-l1_60_vicmsst,
                  ls_item_aux-l1_70_vbc,
                  ls_item_aux-l1_70_vicms,
                  ls_item_aux-l1_70_vbcst,
                  ls_item_aux-l1_70_vicmsst,
                  ls_item_aux-l1_90_vbc,
                  ls_item_aux-l1_90_vicms,
                  ls_item_aux-l1_90_vbcst,
                  ls_item_aux-l1_90_vicmsst,
                  ls_item_aux-n1_vbc,
                  ls_item_aux-n1_qunid,
                  ls_item_aux-n1_vunid,
                  ls_item_aux-n1_vipi,
                  ls_item_aux-p1_vbc,
                  ls_item_aux-p1_vpis,
                  ls_item_aux-p2_vpis,
                  ls_item_aux-p4_vbc,
                  ls_item_aux-p4_vpis,
                  ls_item_aux-p5_vbc,
                  ls_item_aux-p5_vpis,
                  ls_item_aux-q1_vbc,
                  ls_item_aux-q1_vcofins,
                  ls_item_aux-q2_vcofins,
                  ls_item_aux-q4_vbc,
                  ls_item_aux-q4_vcofins,
                  ls_item_aux-q5_vbc,
                  ls_item_aux-q5_vcofins,
                  ls_item_aux-x_vbc,
                  ls_item_aux-x_vissqn,
                  ls_item_aux-vicmssubstituto, ls_item_aux-vbcfcpstret, ls_item_aux-vfcpstret, ls_item_aux-vbcefet, ls_item_aux-vicmsefet,
                  ls_item_aux-vfrete.

*        ADD 1 TO ls_cont_aux.

          LOOP AT lt_item INTO ls_item WHERE cprod EQ ls_item_aux-cprod.

            ls_item_aux-vprod         = ls_item_aux-vprod         + ls_item-vprod.
** Inicio - Josieudes Claudio - Target 57836 - 27.03.17
* Acumular valor do desconto de itens particionados
            ls_item_aux-vdesc         = ls_item_aux-vdesc         + ls_item-vdesc.
** Fim - Josieudes Claudio - Target 57836 - 27.03.17
            ls_item_aux-qcom_v20        = ls_item_aux-qcom_v20        + ls_item-qcom_v20.
            ls_item_aux-qtrib_v20       = ls_item_aux-qtrib_v20       + ls_item-qtrib_v20.
            ls_item_aux-l1_00_vbc       = ls_item_aux-l1_00_vbc       + ls_item-l1_00_vbc.
            ls_item_aux-l1_00_vicms     = ls_item_aux-l1_00_vicms     + ls_item-l1_00_vicms.
            ls_item_aux-l1_10_vbc       = ls_item_aux-l1_10_vbc       + ls_item-l1_10_vbc.
            ls_item_aux-l1_10_vicms     = ls_item_aux-l1_10_vicms     + ls_item-l1_10_vicms.
            ls_item_aux-l1_10_vbcst     = ls_item_aux-l1_10_vbcst     + ls_item-l1_10_vbcst.
            ls_item_aux-l1_10_vicmsst   = ls_item_aux-l1_10_vicmsst   + ls_item-l1_10_vicmsst.
            ls_item_aux-l1_20_vbc       = ls_item_aux-l1_20_vbc       + ls_item-l1_20_vbc.
            ls_item_aux-l1_20_vicms     = ls_item_aux-l1_20_vicms     + ls_item-l1_20_vicms.
            ls_item_aux-l1_30_vbcst     = ls_item_aux-l1_30_vbcst     + ls_item-l1_30_vbcst.
            ls_item_aux-l1_30_vicmsst   = ls_item_aux-l1_30_vicmsst   + ls_item-l1_30_vicmsst.
            ls_item_aux-l1_51_vbc       = ls_item_aux-l1_51_vbc       + ls_item-l1_51_vbc.
            ls_item_aux-l1_51_vicms     = ls_item_aux-l1_51_vicms     + ls_item-l1_51_vicms.
            ls_item_aux-l1_60_vbcst     = ls_item_aux-l1_60_vbcst     + ls_item-l1_60_vbcst.
            ls_item_aux-l1_60_vicmsst   = ls_item_aux-l1_60_vicmsst   + ls_item-l1_60_vicmsst.
            ls_item_aux-l1_70_vbc       = ls_item_aux-l1_70_vbc       + ls_item-l1_70_vbc.
            ls_item_aux-l1_70_vicms     = ls_item_aux-l1_70_vicms     + ls_item-l1_70_vicms.
            ls_item_aux-l1_70_vbcst     = ls_item_aux-l1_70_vbcst     + ls_item-l1_70_vbcst.
            ls_item_aux-l1_70_vicmsst   = ls_item_aux-l1_70_vicmsst   + ls_item-l1_70_vicmsst.
            ls_item_aux-l1_90_vbc       = ls_item_aux-l1_90_vbc       + ls_item-l1_90_vbc.
            ls_item_aux-l1_90_vicms     = ls_item_aux-l1_90_vicms     + ls_item-l1_90_vicms.
            ls_item_aux-l1_90_vbcst     = ls_item_aux-l1_90_vbcst     + ls_item-l1_90_vbcst.
            ls_item_aux-l1_90_vicmsst   = ls_item_aux-l1_90_vicmsst   + ls_item-l1_90_vicmsst.
            ls_item_aux-n1_vbc          = ls_item_aux-n1_vbc          + ls_item-n1_vbc.
            ls_item_aux-n1_qunid        = ls_item_aux-n1_qunid        + ls_item-n1_qunid.
            ls_item_aux-n1_vunid        = ls_item_aux-n1_vunid        + ls_item-n1_vunid.
            ls_item_aux-n1_vipi         = ls_item_aux-n1_vipi         + ls_item-n1_vipi.
            ls_item_aux-p1_vbc          = ls_item_aux-p1_vbc          + ls_item-p1_vbc.
            ls_item_aux-p1_vpis         = ls_item_aux-p1_vpis         + ls_item-p1_vpis.
            ls_item_aux-p2_vpis         = ls_item_aux-p2_vpis         + ls_item-p2_vpis.
            ls_item_aux-p4_vbc          = ls_item_aux-p4_vbc          + ls_item-p4_vbc.
            ls_item_aux-p4_vpis         = ls_item_aux-p4_vpis         + ls_item-p4_vpis.
            ls_item_aux-p5_vbc          = ls_item_aux-p5_vbc          + ls_item-p5_vbc.
            ls_item_aux-p5_vpis         = ls_item_aux-p5_vpis         + ls_item-p5_vpis.
            ls_item_aux-q1_vbc          = ls_item_aux-q1_vbc          + ls_item-q1_vbc.
            ls_item_aux-q1_vcofins      = ls_item_aux-q1_vcofins      + ls_item-q1_vcofins.
            ls_item_aux-q2_vcofins      = ls_item_aux-q2_vcofins      + ls_item-q2_vcofins.
            ls_item_aux-q4_vbc          = ls_item_aux-q4_vbc          + ls_item-q4_vbc.
            ls_item_aux-q4_vcofins      = ls_item_aux-q4_vcofins      + ls_item-q4_vcofins.
            ls_item_aux-q5_vbc          = ls_item_aux-q5_vbc          + ls_item-q5_vbc.
            ls_item_aux-q5_vcofins      = ls_item_aux-q5_vcofins      + ls_item-q5_vcofins.
            ls_item_aux-x_vbc           = ls_item_aux-x_vbc           + ls_item-x_vbc.
            ls_item_aux-x_vissqn        = ls_item_aux-x_vissqn        + ls_item-x_vissqn.

            ls_item_aux-vicmssubstituto = ls_item-vicmssubstituto."ls_item_aux-vicmssubstituto + ls_item-vicmssubstituto.
* LSCHEPP - SD - 8000007872 - Quebra de lote Val incor Tag ICMS retid - 25.05.2023 Início
*            ls_item_aux-vbcfcpstret     = ls_item-vbcfcpstret.    "ls_item_aux-vbcfcpstret     + ls_item-vbcfcpstret.
*            ls_item_aux-vfcpstret       = ls_item-vfcpstret.      "ls_item_aux-vfcpstret       + ls_item-vfcpstret.
            ls_item_aux-vbcfcpstret     = ls_item_aux-vbcfcpstret     + ls_item-vbcfcpstret.
            ls_item_aux-vfcpstret       = ls_item_aux-vfcpstret       + ls_item-vfcpstret.
* LSCHEPP - SD - 8000007872 - Quebra de lote Val incor Tag ICMS retid - 25.05.2023 Fim
            ls_item_aux-vbcefet         = ls_item-vbcefet.        "ls_item_aux-vbcefet         + ls_item-vbcefet.
            ls_item_aux-vicmsefet       = ls_item-vicmsefet.      "ls_item_aux-vicmsefet       + ls_item-vicmsefet.

            ls_item_aux-vfrete = ls_item_aux-vfrete + ls_item-vfrete.


*            ls_item_aux-vbcstret        = ls_item_aux-vbcstret        + ls_item-vbcstret.
*            ls_item_aux-vICMSSubstituto = ls_item_aux-vICMSSubstituto + ls_item-vICMSSubstituto.
*            ls_item_aux-vICMSSTRet      = ls_item_aux-vICMSSTRet      + ls_item-vICMSSTRet.
*            ls_item_aux-vBCEfet         = ls_item_aux-vBCEfet         + ls_item-vBCEfet.
*            ls_item_aux-vICMSEfet       = ls_item_aux-vICMSEfet       + ls_item-vICMSEfet.


            " Início - STK(NABT) - Target 59168 - 19.04.2017
            READ TABLE lt_item_310 INTO ls_item_310 WITH KEY docnum = ls_item-docnum
                                                             itmnum = ls_item-itmnum.
            IF sy-subrc = 0.
              ls_item_310_aux-vicmsop         = ls_item_310_aux-vicmsop         + ls_item_310-vicmsop.
              ls_item_310_aux-vicmsdif        = ls_item_310_aux-vicmsdif        + ls_item_310-vicmsdif.
              ls_item_310_aux-vicmsdeson      = ls_item_310_aux-vicmsdeson      + ls_item_310-vicmsdeson.
              ls_item_310_aux-vipidevol       = ls_item_310_aux-vipidevol       + ls_item_310-vipidevol.

              ls_item_310_aux-vbcstret        = ls_item_310_aux-vbcstret        + ls_item_310-vbcstret.
              ls_item_310_aux-vicmssubstituto = ls_item_310_aux-vicmssubstituto + ls_item_310-vicmssubstituto.
              ls_item_310_aux-vbcfcpstret     = ls_item_310_aux-vbcfcpstret     + ls_item_310-vbcfcpstret    .
              ls_item_310_aux-vfcpstret       = ls_item_310_aux-vfcpstret       + ls_item_310-vfcpstret      .
              ls_item_310_aux-vbcefet         = ls_item_310_aux-vbcefet         + ls_item_310-vbcefet        .
              ls_item_310_aux-vicmsefet       = ls_item_310_aux-vicmsefet       + ls_item_310-vicmsefet      .
              ls_item_310_aux-vicmsstret       = ls_item_310_aux-vicmsstret     + ls_item_310-vicmsstret      .
            ENDIF.
            " Fim - STK(NABT) - Target 59168 - 19.04.2017


            ">>Inicio FFF NFE V310
            "IF in_doc-xmlvers EQ c_xml_310.

            LOOP AT lt_tax INTO ls_tax WHERE itmnum = ls_item-itmnum.
              CLEAR ls_tax_aux.

              LOOP AT lt_item_tax INTO ls_item_tax WHERE cprod EQ ls_item_aux-cprod
                                                     AND itmnum NE ls_item-itmnum.

                READ TABLE lt_tax INTO ls_tax_aux WITH KEY itmnum = ls_item_tax-itmnum
                                                     taxtyp = ls_tax-taxtyp.
                ls_tax-base = ls_tax-base + ls_tax_aux-base.
                ls_tax-taxval = ls_tax-taxval + ls_tax_aux-taxval.
              ENDLOOP.

              APPEND ls_tax TO lt_tax_aux.

            ENDLOOP.

            " ENDIF.
            "<<Fim FFF NFE V310
          ENDLOOP.

          ">>Inicio FFF
          IF ls_item_aux-qtrib_v20 IS NOT INITIAL.
            ls_item_aux-vuntrib_v20 = ls_item_aux-vprod / ls_item_aux-qtrib_v20.
          ENDIF.
          "<<Fim FFF
*--
          IF NOT ls_item_aux-qcom_v20 IS INITIAL.
            ls_item_aux-vuncom_v20 = ls_item_aux-vprod / ls_item_aux-qcom_v20.
          ENDIF.
*--
*        ls_item_aux-nitem = ls_cont_aux.
          APPEND ls_item_aux TO lt_item_aux.

          " Início - STK(NABT) - Target 59168 - 19.04.2017
          APPEND ls_item_310_aux TO lt_item_310_aux.
          " Fim - STK(NABT) - Target 59168 - 19.04.2017

        ENDIF.

      ENDLOOP.

** Inicio - Carlos Henrique - Target 63980 - 19.01.2018
      DATA: lv_nitem TYPE nitem VALUE '001'.
      SORT: lt_item_aux BY docnum itmnum.
      LOOP AT lt_item_aux ASSIGNING FIELD-SYMBOL(<fs_item_aux>).
        <fs_item_aux>-nitem = lv_nitem.
        ADD 1 TO lv_nitem.
      ENDLOOP.
** Fim - Carlos Henrique - Target 63980 - 19.01.2018


      ">>Inicio FFF NFE V310
      "IF in_doc-xmlvers EQ c_xml_310.
      IF <fs_t_tax> IS ASSIGNED.
        SORT lt_tax_aux BY docnum itmnum taxtyp.
        <fs_t_tax> = lt_tax_aux.
      ENDIF.
      "ENDIF.
      "<<Fim FFF NFE V310
      SORT lt_item_aux BY docnum itmnum.
      IF <fs_t_item> IS ASSIGNED.
        <fs_t_item> = lt_item_aux[].
      ENDIF.
      " Início - STK(NABT) - Target 59168 - 19.04.2017
      IF <fs_t_item_310> IS ASSIGNED.
        <fs_t_item_310> = lt_item_310_aux[].
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
