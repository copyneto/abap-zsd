FUNCTION zfmsd_get_mdfe_pdf.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IV_DOCNUM) TYPE  J_1BDOCNUM
*"     REFERENCE(IV_PRINTER) TYPE  RSPOPNAME
*"  EXPORTING
*"     REFERENCE(EV_FILE) TYPE  XSTRING
*"     REFERENCE(EV_FILESIZE) TYPE  INT4
*"     REFERENCE(ET_LINES) TYPE  TLINE_T
*"  TABLES
*"      ET_OTF TYPE  TSFOTF OPTIONAL
*"  EXCEPTIONS
*"      ERRO_GET_FORM
*"      CONVERSION_EXCEPTION
*"      NOT_AUTHORIZED
*"----------------------------------------------------------------------

  DATA: lt_condutor   TYPE STANDARD TABLE OF zstm_condut,
        lt_nfe        TYPE STANDARD TABLE OF zstm_nfe,
        lt_observacao TYPE STANDARD TABLE OF zstm_obs,
        lt_pdf        TYPE STANDARD TABLE OF itcoo.

  DATA: ls_damdfe             TYPE zstm_damdfe,
        ls_return             TYPE ssfcrescl,
        ls_control_parameters TYPE ssfctrlop,
        ls_output_options     TYPE ssfcompop.

  DATA: lv_smartform TYPE rs38l_fnam.

  CONSTANTS: lc_name_mdfe TYPE tdsfname       VALUE 'ZSFTM_DAMDFE',
             lc_code      TYPE j_1bnfdoc-code VALUE '100',
             lc_printer   TYPE rspopname      VALUE 'LOCL'.

  TRY.

      CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
        EXPORTING
          formname = lc_name_mdfe
        IMPORTING
          fm_name  = lv_smartform.

    CATCH cx_fp_api_repository.
      RAISE erro_get_form.
  ENDTRY.

  SELECT SINGLE a~docnum,
                a~rntc,
                a~authcod,
                a~code,
                a~stras,
                a~ort01,
                a~ort02,
                a~model,
                a~hemi,
                a~ufembarq,
                a~pstlz,
                b~bukrs,
                b~stcd1,
                b~model AS model2,
*                b~ie,
                b~serie,
                b~nfnum9,
                b~regio,
                b~nfyear,
                b~nfmonth,
*                b~mdfenum,
*                b~tpemiss,
*                b~cmdfe,
                b~cdv,
                b~tpemis
    FROM j_1bnfdoc AS a
   INNER JOIN j_1bnfe_active AS b
           ON b~docnum = a~docnum
   WHERE a~docnum = @iv_docnum
     AND a~code   = @lc_code
    INTO @DATA(ls_j_1bnfe).

  IF sy-subrc IS INITIAL.

    SELECT SINGLE butxt
      FROM t001
     WHERE bukrs = @ls_j_1bnfe-bukrs
      INTO @DATA(lv_butxt).

    SELECT a~docnum,
           a~itmnum,
           c~gro_wei_val
      FROM j_1bnflin AS a
     INNER JOIN vbfa AS b
             ON b~vbeln = a~refkey
     INNER JOIN /scmtms/d_torrot AS c
             ON c~base_btd_id = b~vbelv
            AND c~tor_cat = 'TO'
     WHERE a~docnum = @iv_docnum
      INTO @DATA(ls_compls1)
        UP TO 1 ROWS.
    ENDSELECT.

    ls_damdfe-cnpj         = ls_j_1bnfe-stcd1.
*    ls_damdfe-ie = .
    ls_damdfe-razao_social = lv_butxt.
    ls_damdfe-logradouro   = ls_j_1bnfe-stras.
    ls_damdfe-bairro       = ls_j_1bnfe-ort02.
    ls_damdfe-uf           = ls_j_1bnfe-ufembarq.
    ls_damdfe-municipio    = ls_j_1bnfe-ort01.
    ls_damdfe-cep          = ls_j_1bnfe-pstlz.
    ls_damdfe-modelo       = ls_j_1bnfe-model.
    ls_damdfe-serie        = ls_j_1bnfe-serie.
*    ls_damdfe-mdfenum      = .
*    ls_damdfe-data_emissao = .
    ls_damdfe-hora_emissao = ls_j_1bnfe-hemi.
    ls_damdfe-uf_carrega   = ls_j_1bnfe-ufembarq.
*    ls_damdfe-quant_nfe    = .
    ls_damdfe-peso_total   = ls_compls1-gro_wei_val.
*    ls_damdfe-placa        = .
    ls_damdfe-rntrc        = ls_j_1bnfe-rntc.
    ls_damdfe-chave_acesso = ls_j_1bnfe-regio && ls_j_1bnfe-nfyear && ls_j_1bnfe-nfmonth && ls_j_1bnfe-stcd1 && ls_j_1bnfe-model2 && ls_j_1bnfe-serie  && ls_j_1bnfe-tpemis && ls_j_1bnfe-cdv.
    ls_damdfe-protocolo    = ls_j_1bnfe-authcod.
    ls_damdfe-bukrs        = ls_j_1bnfe-bukrs.
*    ls_damdfe-tknum        = .
*    ls_damdfe-uf_descarrega = .
*    ls_damdfe-placa_sr1 = .
*    ls_damdfe-placa_sr2 = .
*    ls_damdfe-placa_sr3 = .
*    ls_damdfe-rntrc_sr1 = .
*    ls_damdfe-rntrc_sr2 = .
*    ls_damdfe-rntrc_sr3 = .
*    ls_damdfe-cnpj_prop = .
*    ls_damdfe-ped_cnpjpg = .
*    ls_damdfe-ncompra = .
*    ls_damdfe-cpf = .
*    ls_damdfe-nome_cond = .
*    ls_damdfe-num_nfe = .
*    ls_damdfe-ch_nfe = .
*    ls_damdfe-id_unid_transp = .
*    ls_damdfe-id_unid_carga = .

    IF ls_damdfe IS NOT INITIAL.

      ls_control_parameters-no_dialog = abap_true.
*      ls_control_parameters-getotf    = abap_true.
      ls_control_parameters-preview   = space.
      IF NOT iv_printer IS INITIAL.
        ls_output_options-tddest = iv_printer.
        ls_output_options-tdimmed = abap_true. "****
      ELSE.
        ls_output_options-tddest = lc_printer.
      ENDIF.

      CALL FUNCTION lv_smartform
        EXPORTING
          control_parameters = ls_control_parameters
          output_options     = ls_output_options
          user_settings      = space
          gs_damdfe          = ls_damdfe
          iv_homologation    = abap_true
*         IV_CONTINGENCY     =
        IMPORTING
          job_output_info    = ls_return
        TABLES
          gt_condutor        = lt_condutor
          gt_nfe             = lt_nfe
          gt_observacao      = lt_observacao
        EXCEPTIONS
          formatting_error   = 1
          internal_error     = 2
          send_error         = 3
          user_canceled      = 4
          OTHERS             = 5.

      IF sy-subrc IS INITIAL.

        IF NOT iv_printer IS INITIAL.
          RETURN.
        ENDIF.

        lt_pdf   = ls_return-otfdata.
        et_otf[] = lt_pdf[].

        CALL FUNCTION 'CONVERT_OTF'
          EXPORTING
            format                = 'PDF'
          IMPORTING
            bin_filesize          = ev_filesize
            bin_file              = ev_file
          TABLES
            otf                   = lt_pdf
            lines                 = et_lines
          EXCEPTIONS
            err_max_linewidth     = 1
            err_format            = 2
            err_conv_not_possible = 3
            err_bad_otf           = 4
            OTHERS                = 5.
        IF sy-subrc NE 0.
          RAISE conversion_exception.
        ENDIF.

      ENDIF.
    ENDIF.
  ELSE.
    RAISE not_authorized.
  ENDIF.

ENDFUNCTION.
