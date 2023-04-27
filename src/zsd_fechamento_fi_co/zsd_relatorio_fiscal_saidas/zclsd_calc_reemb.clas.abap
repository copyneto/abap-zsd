CLASS zclsd_calc_reemb DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLSD_CALC_REEMB IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    CONSTANTS: lc_sd         TYPE ztca_param_par-modulo VALUE 'SD',
               lc_chave1     TYPE ztca_param_par-chave1 VALUE 'REEMBOLSO NFE',
               lc_regra1     TYPE ztca_param_par-chave2 VALUE 'REGRA 1',
               lc_regra2     TYPE ztca_param_par-chave2 VALUE 'REGRA 2',
               lc_regra3     TYPE ztca_param_par-chave2 VALUE 'REGRA 3',
               lc_cont_icms  TYPE ztca_param_par-chave2 VALUE 'CONTRIBUINTE DE ICMS',
               lc_infadfisco TYPE ztca_param_par-chave2 VALUE 'INFADFISCO'.

    DATA: lr_regra1       TYPE RANGE OF j_1bnfdoc-vstel,
          lr_regra2       TYPE RANGE OF j_1bnfdoc-vstel,
          lr_regra3       TYPE RANGE OF j_1bnfdoc-vstel,
          lr_sp           TYPE RANGE OF j_1bnfdoc-vstel,
          lv_porcentagem1 TYPE j_1bnfe_pfcpstret,
          lv_porcentagem2 TYPE j_1bnfe_pfcpstret,
          lr_cont_icms    TYPE RANGE OF kna1-icmstaxpay,
          lv_stfcp        TYPE j_1bnflin-vfcpstret.


    DATA: lt_original_data TYPE STANDARD TABLE OF zi_sd_rel_fiscal_saida_app WITH DEFAULT KEY.
*          lv_unit_in       TYPE t006-msehi.

    lt_original_data = CORRESPONDING #( it_original_data ).
    check lt_original_data is not initial.

    DATA(lo_parametros) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_sd
            iv_chave1 = lc_chave1
            iv_chave2 = lc_regra1
          IMPORTING
            et_range  = lr_regra1 ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

    TRY.
        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_sd
            iv_chave1 = lc_chave1
            iv_chave2 = lc_regra2
          IMPORTING
            et_range  = lr_regra2 ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

    TRY.
        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_sd
            iv_chave1 = lc_chave1
            iv_chave2 = lc_regra3
          IMPORTING
            et_range  = lr_regra3 ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

    TRY.
        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_sd
            iv_chave1 = lc_cont_icms
          IMPORTING
            et_range  = lr_cont_icms ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

    TRY.
        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_sd
            iv_chave1 = lc_chave1
            iv_chave2 = lc_infadfisco
          IMPORTING
            et_range  = lr_sp ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

    SELECT lin~docnum,
           lin~itmnum,
           lin~pst,
           lin~pfcpstret,
           lin~picmsefet,
           lin~vbcstret,
           lin~vbcefet,
           lin~vicmsstret,
           lin~vbcfcpstret,
           lin~vfcpstret,
           doc~regio
        INTO TABLE @DATA(lt_lin)
        FROM j_1bnflin AS lin
        INNER JOIN j_1bnfdoc AS doc ON doc~docnum = lin~docnum
        FOR ALL ENTRIES IN @lt_original_data
        WHERE lin~docnum = @lt_original_data-notafiscal
          AND lin~itmnum = @lt_original_data-itemnf.

    SORT lt_lin BY docnum itmnum.

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).
*
*      SELECT SINGLE regio
*         FROM t001w
*         INTO @DATA(lv_regio)
*         WHERE werks EQ @<fs_data>-Plant.



      READ TABLE lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin>) WITH KEY docnum = <fs_data>-notafiscal
                                                                  itmnum = <fs_data>-itemnf BINARY SEARCH.

      IF <fs_lin>-regio IN lr_regra1.

        lv_porcentagem1 = ( <fs_lin>-pst - <fs_lin>-pfcpstret ) / 100.
        lv_porcentagem2 = ( <fs_lin>-picmsefet - <fs_lin>-pfcpstret  ) / 100.
        <fs_data>-icmsstreembolso = ( <fs_lin>-vbcstret * lv_porcentagem1 ) - ( <fs_lin>-vbcefet * lv_porcentagem2 ).
        <fs_data>-baseicms_streemb = <fs_lin>-vbcstret.

        IF <fs_data>-icmsstreembolso < 0.
          <fs_data>-icmsstreembolso = 0.
        ENDIF.

        " Base ICMS ST FCP Reembolso
        <fs_data>-baseicms_stfcpreemb = <fs_lin>-vbcfcpstret.

        " Valor ICMS ST FCP Reembolso
        lv_stfcp  = ( <fs_lin>-vbcstret * <fs_lin>-pfcpstret ) - ( <fs_lin>-vbcefet * <fs_lin>-pfcpstret ).
        lv_stfcp  = lv_stfcp / 100.

        IF lv_stfcp IS NOT INITIAL.
          IF lv_stfcp LT 0.
            lv_stfcp = 0.
          ENDIF.
          <fs_data>-icmsstfcpreembolso = lv_stfcp.
        ENDIF.

      ELSEIF <fs_lin>-regio IN lr_regra2.

        <fs_data>-icmsstreembolso  = <fs_lin>-vicmsstret.
        <fs_data>-baseicms_streemb = <fs_lin>-vbcstret.

        IF <fs_data>-icmsstreembolso < 0.
          <fs_data>-icmsstreembolso = 0.
        ENDIF.

        " Base ICMS ST FCP Reembolso
        <fs_data>-baseicms_stfcpreemb = <fs_lin>-vbcfcpstret.

        " Valor ICMS ST FCP Reembolso
        lv_stfcp = <fs_lin>-vfcpstret.

        IF lv_stfcp IS NOT INITIAL.
          IF lv_stfcp LT 0.
            lv_stfcp = 0.
          ENDIF.
          <fs_data>-icmsstfcpreembolso = lv_stfcp.
        ENDIF.

      ELSEIF <fs_lin>-regio IN lr_regra3.

        lv_porcentagem1            = ( <fs_lin>-pst - <fs_lin>-pfcpstret ) / 100.
        lv_porcentagem2            = ( <fs_lin>-picmsefet - <fs_lin>-pfcpstret  ) / 100.
        <fs_data>-icmsstreembolso  = ( <fs_lin>-vbcstret * lv_porcentagem1 ) - ( <fs_lin>-vbcefet * lv_porcentagem2 ).
        <fs_data>-baseicms_streemb = <fs_lin>-vbcstret.

        IF <fs_data>-icmsstreembolso < 0.
          <fs_data>-icmsstreembolso = 0.
        ENDIF.

        " Base ICMS ST FCP Reembolso
        <fs_data>-baseicms_stfcpreemb = <fs_lin>-vbcstret.

        " Valor ICMS ST FCP Reembolso
        lv_stfcp  = ( <fs_lin>-vbcstret * <fs_lin>-pfcpstret ) - ( <fs_lin>-vbcefet * <fs_lin>-pfcpstret ).
        lv_stfcp  = lv_stfcp / 100.

        IF lv_stfcp IS NOT INITIAL.
          IF lv_stfcp LT 0.
            lv_stfcp = 0.
            <fs_data>-baseicms_stfcpreemb = 0.
          ENDIF.
          <fs_data>-icmsstfcpreembolso = lv_stfcp.
        ELSE.
          <fs_data>-baseicms_stfcpreemb = 0.
        ENDIF.
      ENDIF.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    RETURN.
  ENDMETHOD.
ENDCLASS.
