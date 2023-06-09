"! <p class="shorttext synchronized">Classe para Geração da Nota de Débito em PDF</p>
"! Autor: Caio Mossmann
"! Data: 10/09/2021
class ZCLSD_ADOBE_NOTA_DEBITO definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_vbrk_nast,
        vbeln TYPE vbrk-vbeln,
        bupla TYPE vbrk-bupla,
        bukrs TYPE vbrk-bukrs,
        kunag TYPE vbrk-kunag,
        erdat TYPE vbrk-erdat,
        fkart TYPE vbrk-fkart,
      END OF ty_vbrk_nast .

  constants:
      "! Constantes para tabela de parâmetros
    BEGIN OF gc_parametros,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ze_param_chave  VALUE 'ECOMMERCE',
        chave2 TYPE ze_param_chave  VALUE 'TIPO_OV_DEBITO',
      END OF gc_parametros .
  data:
      "! Dados para enviar email
    BEGIN OF gs_dados,
*        pedido    TYPE bstnk,
        pedido    TYPE BSTKD,
        nf        TYPE char13,
        nt_debito TYPE vbeln_von,
      END OF gs_dados .
  data:
          "! Tipo documento de faturamento
    gs_tipo_condicao TYPE RANGE OF fkart .

  methods EXECUTE_NAST
    importing
      !IV_VBELN type VBRK-VBELN
      !IV_BUPLA type VBRK-BUPLA
      !IV_BUKRS type VBRK-BUKRS
      !IV_KUNAG type VBRK-KUNAG
      !IV_DATA type VBRK-ERDAT
      !IV_FKART type VBRK-FKART
    returning
      value(RV_RC) type SY-SUBRC .
    "! Método de execução para ser chamado fora da classe
    "! @parameter iv_vbeln | Documento de faturamento
    "! @parameter iv_bupla | Local de negócios
    "! @parameter iv_bukrs | Empresa
    "! @parameter iv_kunag | Emissor de ordem
    "! @parameter iv_data  | Data de emissão
    "! @parameter iv_fkart | Tipo documento de faturamento
  methods EXECUTE
    importing
      !IV_VBELN type VBRK-VBELN
      !IV_BUPLA type VBRK-BUPLA
      !IV_BUKRS type VBRK-BUKRS
      !IV_KUNAG type VBRK-KUNAG
      !IV_DATA type VBRK-ERDAT
      !IV_FKART type VBRK-FKART .
  methods GET_VBRK_FROM_NAST
    importing
      !IS_NAST type NAST
    returning
      value(RS_VBRK) type TY_VBRK_NAST .
  methods SEND_MAIL
    importing
      !IV_PDF type FPCONTENT
      !IV_KUNAG type VBRK-KUNAG
      !IV_FKART type VBRK-FKART
      !IV_NF_VEN type LOGBR_NFNUM9 optional
      !IV_NUM_PED type BSTKD optional
      !IV_NF_DEB type VBELN_VF optional
      !IV_TRANSPORTER type MD_CUSTOMER_NAME optional
      !IV_BELNR type BELNR_D optional
      !IV_BUKRS type BUKRS optional
      !IV_GJAHR type GJAHR optional
    changing
      !CV_RETURN type CHAR1 optional .
    "! Método executado após chamada da função background
    "! @parameter p_task | Parametro obrigatório do método
  methods TASK_FINISH
    importing
      !P_TASK type CLIKE .
  methods GET_PARAM_TYPE_COND .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_konv,
        kposn TYPE v_konv-kposn,
        kbetr TYPE v_konv-kbetr,
      END OF ty_konv .

    DATA gs_dados_nota_deb TYPE zi_sd_furto_extravio_app .
    DATA:
      gt_vl_uni TYPE TABLE OF ty_konv .

    "! Seleciona os dados das tabelas
    "! @parameter iv_vbeln | Documento de faturamento
    "! @parameter iv_bupla | Local de negócios
    "! @parameter iv_bukrs | Empresa
    "! @parameter iv_kunag | Emissor de ordem
    "! @parameter iv_data  | Data de emissão
    "! @parameter iv_fkart | Tipo documento de faturamento
    METHODS get_data
      IMPORTING
        !iv_vbeln       TYPE vbrk-vbeln
        !iv_bupla       TYPE vbrk-bupla
        !iv_bukrs       TYPE vbrk-bukrs
        !iv_kunag       TYPE vbrk-kunag
        !iv_data        TYPE vbrk-erdat
        !iv_fkart       TYPE vbrk-fkart
      RETURNING
        VALUE(rs_adobe) TYPE zssd_adobe_nota_debito .
    "! Chama o Adobe Forms
    "! @parameter is_data | Estrutra necessária contendo os dados do Adobe Forms
    "! @parameter rv_pdf  | Codificação do PDF
    METHODS call_form
      IMPORTING
        !is_data      TYPE zssd_adobe_nota_debito
      CHANGING
        VALUE(cv_rv)  TYPE sy-subrc OPTIONAL
      RETURNING
        VALUE(rv_pdf) TYPE fpcontent .
ENDCLASS.



CLASS ZCLSD_ADOBE_NOTA_DEBITO IMPLEMENTATION.


  METHOD execute.

    DATA: ls_outputparams TYPE sfpoutputparams,
          ls_joboutput    TYPE sfpjoboutput.

    DATA(ls_adobe) = get_data(
      iv_vbeln = iv_vbeln
      iv_bukrs = iv_bukrs
      iv_bupla = iv_bupla
      iv_kunag = iv_kunag
      iv_data  = iv_data
      iv_fkart = iv_fkart ).

    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = ls_outputparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.
    IF sy-subrc IS NOT INITIAL.

    ENDIF.

    DATA(lv_pdf) = call_form( is_data = ls_adobe ).

    send_mail( iv_pdf   = lv_pdf
               iv_kunag = iv_kunag
               iv_fkart = iv_fkart ).


    CALL FUNCTION 'FP_JOB_CLOSE'
      IMPORTING
        e_result       = ls_joboutput
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.
    IF sy-subrc IS NOT INITIAL.

    ENDIF.

  ENDMETHOD.


  METHOD task_finish.
    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_EMAIL_NOTA_DEB'.
    RETURN.
  ENDMETHOD.


  METHOD get_data.

    SORT gt_vl_uni BY kposn.

    CONSTANTS lc_object TYPE nriv-object VALUE 'ZNOTADEB'.

    DATA: ls_address     TYPE sadr,
          ls_branch_data TYPE j_1bbranch,
          ls_cgc_number  TYPE j_1bcgc,
          ls_address1    TYPE addr1_val.

    CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
      EXPORTING
        branch            = iv_bupla
        bukrs             = iv_bukrs
      IMPORTING
        address           = ls_address
        branch_data       = ls_branch_data
        cgc_number        = ls_cgc_number
        address1          = ls_address1
      EXCEPTIONS
        branch_not_found  = 1
        address_not_found = 2
        company_not_found = 3
        OTHERS            = 4.

    IF sy-subrc IS NOT INITIAL.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    SELECT SINGLE _kna1~stcd1
      FROM vbrp AS _vbrp
      JOIN t001w AS _t001w ON _vbrp~werks = _t001w~werks
      JOIN kna1 AS _kna1 ON _t001w~kunnr = _kna1~kunnr
      WHERE vbeln EQ @iv_vbeln
      INTO @DATA(lv_cnpj_emi).

    rs_adobe-razao_social = ls_address-name1.
    rs_adobe-endereco     = ls_address-stras.
    rs_adobe-bairro       = ls_address-ort02.
    rs_adobe-cidade       = ls_address-ort01.
    rs_adobe-regiao       = ls_address-regio.
    rs_adobe-cep          = ls_address-pstlz.
    rs_adobe-telefone     = ls_address-telf1.
    "rs_adobe-cnpj         = ls_branch_data-stcd1.
    rs_adobe-cnpj         = lv_cnpj_emi.
    rs_adobe-ins_est      = ls_branch_data-state_insc.
    CONCATENATE iv_data+4(2) '/' iv_data(4) INTO DATA(lv_mes).
    rs_adobe-mes_servico  = lv_mes.
    rs_adobe-data_emissao = iv_data.

    SELECT SINGLE pernr
      FROM vbpa
      INTO @DATA(lv_pernr)
      WHERE vbeln EQ @iv_vbeln
      AND   posnr EQ @abap_false
      AND   parvw EQ 'VD'.

    IF sy-subrc IS INITIAL.
      rs_adobe-dados_vendedor = lv_pernr.
    ENDIF.

    SELECT SINGLE name1,
                  stcd1,
                  stras,
                  ort02,
                  pstlz,
                  ort01,
                  telf1,
                  regio,
                  stcd3
      FROM kna1
      INTO @DATA(ls_kna1)
      WHERE kunnr EQ @iv_kunag.

    rs_adobe-razao_dest      = ls_kna1-name1.
    rs_adobe-endereco_dest   = ls_kna1-stras.
    rs_adobe-bairro_dest     = ls_kna1-ort02.
    rs_adobe-municipio_dest  = ls_kna1-ort01.
    rs_adobe-regiao_dest     = ls_kna1-regio.
    rs_adobe-cep_dest        = ls_kna1-pstlz.
    rs_adobe-telf_dest       = ls_kna1-telf1.
    rs_adobe-cnpj_dest       = ls_kna1-stcd1.
    rs_adobe-insc_est_dest   = ls_kna1-stcd3.
    rs_adobe-codigo_cli      = iv_kunag.

    SELECT matnr,
           posnr,
           arktx,
           meins,
           fklmg,
           netwr,
           waerk,
           cmpre                        " INSERT - JWSILVA - 03.06.2023
        FROM vbrp
        INTO TABLE @DATA(lt_itens)
        WHERE vbeln EQ @iv_vbeln.

    IF sy-subrc IS INITIAL.

      LOOP AT lt_itens ASSIGNING FIELD-SYMBOL(<fs_itens>).

        APPEND INITIAL LINE TO rs_adobe-item ASSIGNING FIELD-SYMBOL(<fs_adobe>).
        <fs_adobe>-codigo     = <fs_itens>-matnr.
        <fs_adobe>-descricao  = <fs_itens>-arktx.
        <fs_adobe>-valor_tot  = <fs_itens>-cmpre.           " CHANGE - JWSILVA - 03.06.2023
        <fs_adobe>-moeda      = <fs_itens>-waerk.
        <fs_adobe>-quantidade = <fs_itens>-fklmg.
        <fs_adobe>-unidade    = <fs_itens>-meins.

        IF iv_fkart IN gs_tipo_condicao.
          READ TABLE gt_vl_uni ASSIGNING FIELD-SYMBOL(<fs_vl_uni>) WITH KEY kposn = <fs_itens>-posnr BINARY SEARCH.
          IF <fs_vl_uni> IS ASSIGNED.
            <fs_adobe>-valor_uni  = <fs_vl_uni>-kbetr.
          ENDIF.
        ELSE.
          "<fs_adobe>-valor_uni  = <fs_itens>-netwr.
          <fs_adobe>-valor_uni  = <fs_itens>-cmpre.
        ENDIF.

      ENDLOOP.

      SELECT SINGLE netwr,
                    mwsbk,
                    waerk,
                    xblnr
        FROM vbrk
        INTO @DATA(ls_valor)
        WHERE vbeln EQ @iv_vbeln.

      IF sy-subrc IS INITIAL.

        "rs_adobe-valor_total = ls_valor-netwr.
        rs_adobe-valor_total = ( ls_valor-netwr + ls_valor-mwsbk ).
        rs_adobe-moeda       = ls_valor-waerk.
        rs_adobe-nrlevel     = ls_valor-xblnr.

      ENDIF.

    ENDIF.
* INICIO - TGRACA - RICEFW BD9-451F16 - 07/10/2021
*    SELECT SINGLE *
*      FROM nriv
*      INTO @DATA(ls_nrlevel)
*      WHERE object EQ @lc_object.
*
*    IF sy-subrc IS INITIAL.
*
*      ADD 1 TO ls_nrlevel-nrlevel.
*      rs_adobe-nrlevel = ls_nrlevel-nrlevel.
*
*      MODIFY nriv FROM ls_nrlevel.
*      IF sy-subrc IS INITIAL.
*
*        COMMIT WORK.
*
*      ELSE.
*
*        ROLLBACK WORK.
*
*      ENDIF.
*
*    ENDIF.

    SORT gs_tipo_condicao BY low.
    READ TABLE gs_tipo_condicao WITH KEY low = iv_fkart TRANSPORTING NO FIELDS BINARY SEARCH.
    IF sy-subrc = 0.

      SELECT SINGLE precedingdocument
      FROM i_sddocumentmultilevelprocflow
      INTO @gs_dados-nt_debito
      WHERE subsequentdocument   = @iv_vbeln
      AND   precedingdocumentcategory = 'C'.

      IF gs_dados-nt_debito IS INITIAL.
        gs_dados-nt_debito = gs_dados_nota_deb-correspncexternalreference.
        DATA(lv_ov_debito) = gs_dados_nota_deb-salesorderdeb.
      ELSE.
        lv_ov_debito = gs_dados-nt_debito.
      ENDIF.

      IF gs_dados-nt_debito IS NOT INITIAL.

*        rs_adobe-nrlevel = gs_dados-nt_debito.

*        SELECT SINGLE bstnk
*        FROM vbak
*        INTO @gs_dados-pedido
*        WHERE vbeln = @lv_ov_debito.

*        SELECT SINGLE bstkd
*        FROM vbkd
*        INTO @gs_dados-pedido
*        WHERE vbeln = @lv_ov_debito
*          AND posnr = @space.

        gs_dados-pedido = gs_dados_nota_deb-purchaseorderbycustomer.
*        IF sy-subrc IS INITIAL.
*          SELECT SINGLE precedingdocument
*            FROM i_sddocumentmultilevelprocflow
*            INTO @DATA(lv_vbelv_rem)
*            WHERE subsequentdocument = @gs_dados-pedido
*            AND  precedingdocumentcategory = 'J'.
*
*          IF sy-subrc IS INITIAL.
*            SELECT SINGLE precedingdocument
*              FROM i_sddocumentmultilevelprocflow
*              INTO @DATA(lv_vbelv_fat)
*              WHERE subsequentdocument = @lv_vbelv_rem
*              AND  precedingdocumentcategory = 'M'.
*
*            IF sy-subrc IS INITIAL.
*              SELECT SINGLE docnum
*                FROM j_1bnflin
*                INTO @DATA(lv_docnum)
*                WHERE reftyp = 'BI'
*                AND   refkey = @lv_vbelv_fat.
*
*              IF sy-subrc IS INITIAL.
*
*                SELECT SINGLE nfenum, series
*                FROM j_1bnfdoc
*                INTO @DATA(ls_j_1bnfdoc)
*                WHERE docnum = @lv_docnum.
*
*                IF sy-subrc IS INITIAL.
*
*                  gs_dados-nf = |{ ls_j_1bnfdoc-nfenum }-{ ls_j_1bnfdoc-series }|.
*
*                  DATA(lv_nf) = |{ TEXT-001 } { gs_dados-nf }|.
*
*                ENDIF.
*              ENDIF.
*            ENDIF.
*          ENDIF.
*        ENDIF.

        IF gs_dados-nf IS INITIAL.
          DATA(lv_nf) = |{ TEXT-001 } { gs_dados_nota_deb-br_nfenumber }|.
        ENDIF.

        IF gs_dados-pedido IS NOT INITIAL.
          DATA(lv_pedido) = |{ TEXT-002 } { gs_dados-pedido }|.
        ENDIF.
      ENDIF.

      SELECT SINGLE netdt
          FROM acdoca
          INTO @DATA(lv_netdt)
          WHERE rbukrs = @iv_bukrs
          AND   koart  = 'D'
          AND   kunnr  = @iv_kunag
          AND   belnr  = @iv_vbeln.

      IF sy-subrc IS INITIAL.

        DATA(lv_data) = |{ TEXT-003 } { lv_netdt+6(2) }.{ lv_netdt+4(2) }.{ lv_netdt(4) }|.

      ENDIF.

      DATA(lv_linha2) = |{ lv_nf } { lv_pedido }|.

      CONCATENATE lv_data lv_nf lv_pedido INTO rs_adobe-observacao SEPARATED BY cl_abap_char_utilities=>newline.
      CLEAR rs_adobe-observacao2.
    ELSE.

      SELECT SINGLE *
        FROM nriv
        INTO @DATA(ls_nrlevel)
        WHERE object EQ @lc_object.

      IF sy-subrc IS INITIAL.

*        ADD 1 TO ls_nrlevel-nrlevel.
*        rs_adobe-nrlevel = ls_nrlevel-nrlevel.

        MODIFY nriv FROM ls_nrlevel.
        IF sy-subrc IS INITIAL.

          COMMIT WORK.

        ELSE.

          ROLLBACK WORK.

        ENDIF.

      ENDIF.
      rs_adobe-observacao2 = |NOTA DE DÉBITO ELABORADA EM SUBSTITUIÇÃO A NOTA FISCAL DE PRESTAÇÃO DE SERVIÇO COM BASE NA LEI COMP. FEDERAL 116/2003|.
    ENDIF.
* FIM - TGRACA - RICEFW BD9-451F16 - 07/10/2021

  ENDMETHOD.


  METHOD call_form.

    CONSTANTS lc_formname TYPE fpname VALUE 'ZAFSD_NOTA_DEBITO'.

    DATA: lv_funcname   TYPE funcname,
          ls_params     TYPE sfpdocparams,
          ls_formoutput TYPE fpformoutput.

    TRY.

        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = lc_formname
          IMPORTING
            e_funcname = lv_funcname.

      CATCH cx_fp_api_repository cx_fp_api_usage cx_fp_api_internal.
        RETURN.
    ENDTRY.

    CALL FUNCTION lv_funcname
      EXPORTING
        /1bcdwb/docparams  = ls_params
        is_dados           = is_data
      IMPORTING
        /1bcdwb/formoutput = ls_formoutput
      EXCEPTIONS
        usage_error        = 1
        system_error       = 2
        internal_error     = 3
        OTHERS             = 4.

    cv_rv = sy-subrc.

    IF sy-subrc <> 0.
      RETURN.
    ELSE.
      rv_pdf = ls_formoutput-pdf.
    ENDIF.

  ENDMETHOD.


  METHOD send_mail.

    DATA: lt_key_boleto   TYPE zctgfi_post_key,
          lt_return       TYPE bapiret2_t,
          lt_bindata      TYPE solix_tab,
          lt_message_body TYPE bcsy_text VALUE IS INITIAL.

    DATA: ls_key_boleto TYPE LINE OF zctgfi_post_key,
          ls_process    TYPE zsfi_boleto_process,
          ls_param      TYPE ssfctrlop.

    DATA: lv_pdf            TYPE xstring,
          lv_size           TYPE i,
          lv_error_log      TYPE abap_bool,
          lv_email_sub      TYPE string,
          lv_subject        TYPE so_obj_des,
          lv_pdf_file       TYPE xstring,
          lv_send           TYPE adr6-smtp_addr VALUE IS INITIAL,
          lv_sent_to_all(1) TYPE c VALUE IS INITIAL,
          lv_sender_email   TYPE adr6-smtp_addr.

    DATA: lr_parametro TYPE RANGE OF but021_fs-adr_kind.

    DATA: lo_sender       TYPE REF TO if_sender_bcs    VALUE IS INITIAL,
          lo_document     TYPE REF TO cl_document_bcs  VALUE IS INITIAL,
          lo_send_request TYPE REF TO cl_bcs           VALUE IS INITIAL,
          lo_recipient    TYPE REF TO if_recipient_bcs VALUE IS INITIAL.

    CONSTANTS: lc_type            TYPE so_obj_tp             VALUE 'RAW',
*               lc_subject TYPE so_obj_des VALUE 'Nota de Débito',
               lc_attachment_type TYPE so_obj_tp             VALUE 'PDF',
               lc_modulo          TYPE ztca_param_mod-modulo VALUE 'SD',
               lc_chave1          TYPE ztca_param_par-chave1 VALUE 'CONTRATOS FOOD',
               lc_chave2          TYPE ztca_param_par-chave2 VALUE 'TIPO ENDERECO',
               lc_chave2_email    TYPE ztca_param_par-chave2 VALUE 'TIPO DE EMAIL',
               lc_chave3_ecomm    TYPE ztca_param_par-chave3 VALUE 'ECOMMERC',
               lc_chave3_ntdbt    TYPE ztca_param_par-chave3 VALUE 'NTDEBITO',
*               lc_sender_email    TYPE adr6-smtp_addr        VALUE 'cobrancaecommerce@3coracoes.com.br',
               lc_subject_bolt    TYPE so_obj_des            VALUE 'Boleto'.

    " Converting PDF to binary format ----------------------------------------------
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = iv_pdf
      IMPORTING
        output_length = lv_size
      TABLES
        binary_tab    = lt_bindata.
    IF sy-subrc IS NOT INITIAL.

    ENDIF.

    TRY.
        lo_send_request = cl_bcs=>create_persistent( ).
      CATCH cx_send_req_bcs.
        "handle exception
    ENDTRY.

    " Message body and subject -----------------------------------------------------
    DATA(lo_prm_send) = NEW zclca_tabela_parametros( ).

* INICIO - TGRACA - RICEFW BD9-451F16 - 07/10/2021
*    IF line_exists( gs_tipo_condicao[ low = iv_fkart ] ).
    SORT gs_tipo_condicao BY low.

    READ TABLE gs_tipo_condicao WITH KEY low = iv_fkart TRANSPORTING NO FIELDS BINARY SEARCH.
    IF sy-subrc = 0.
      APPEND 'Prezado Transportador,' TO lt_message_body.
      APPEND 'Agradecemos a parceria.' TO lt_message_body.
      APPEND 'Segue Nota de Débito referente ao Extravio da Nota Fiscal' && | | && |{ iv_nf_ven }| && |.| TO lt_message_body.
      APPEND '' TO lt_message_body.
      APPEND 'Nº do Pedido:' && | | && |{ iv_num_ped }| && |.| TO lt_message_body.
      APPEND 'Nota de Débito:' && | | && |{ iv_nf_deb }| && |.| TO lt_message_body.
      APPEND '' TO lt_message_body.
      APPEND 'Qualquer dúvida, entrar em contato com o nosso Setor de Cobrança Corporativa, informando o número da Nota Fiscal e a Nota de Débito.' TO lt_message_body.
      APPEND '' TO lt_message_body.
      APPEND 'Cordialmente,' TO lt_message_body.
      APPEND '' TO lt_message_body.
      APPEND 'Cobrança Corporativa.' TO lt_message_body.
      "APPEND '0800 591 0232' TO lt_message_body.
      APPEND 'cobrancaecommerce@3coracoes.com.br' TO lt_message_body.

      "lv_subject = |{ TEXT-004 } - { iv_transporter } - Nota Fiscal { iv_nf_ven } { gs_dados-nf } { gs_dados-pedido } { gs_dados-nt_debito }|.
      lv_subject = |{ TEXT-004 } { TEXT-005 } { iv_nf_ven } { gs_dados-nf } { gs_dados-pedido } { gs_dados-nt_debito }|.

      TRY.
          lo_prm_send->m_get_single( EXPORTING iv_modulo = lc_modulo
                                               iv_chave1 = lc_chave1
                                               iv_chave2 = lc_chave2_email
                                               iv_chave3 = lc_chave3_ecomm
                                     IMPORTING ev_param  = lv_sender_email ).
        CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros
      ENDTRY.

    ELSE.

      TRY.
          lo_prm_send->m_get_single( EXPORTING iv_modulo = lc_modulo
                                               iv_chave1 = lc_chave1
                                               iv_chave2 = lc_chave2_email
                                               iv_chave3 = lc_chave3_ntdbt
                                     IMPORTING ev_param  = lv_sender_email ).
        CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros
      ENDTRY.

      APPEND 'Prezado Cliente,' TO lt_message_body.
      APPEND ' ' TO lt_message_body.
*      APPEND 'Segue em anexo sua nota de débito.' TO lt_message_body.
      APPEND 'Segue arquivo pdf da Nota de Débito e do Boleto referente a sua locação para pagamento.' TO lt_message_body.
      APPEND ' ' TO lt_message_body.
      APPEND 'Em caso de dúvidas, entrar em contato com o nosso SAC Clientes pelo telefone 0800 591 0232 ou pelo e-mail: atendimentoclientes@3coracoes.com.br.' TO lt_message_body.
      APPEND 'Horário de atendimento: de segunda a sexta, das 8h às 18hs, e aos sábados, das 8hs às 12hs.' TO lt_message_body.
      APPEND ' ' TO lt_message_body.
      APPEND ' ' TO lt_message_body.
      APPEND 'Agradecemos a preferência.' TO lt_message_body.
      APPEND 'Cordialmente.' TO lt_message_body.
      APPEND ' ' TO lt_message_body.
      APPEND 'SAC Clientes' TO lt_message_body.
      APPEND '0800 591 0232' TO lt_message_body.
      APPEND 'atendimentoclientes@3coracoes.com.br' TO lt_message_body.

      lv_subject = |Nota de Débito|.
    ENDIF.

*      APPEND 'Prezado Cliente,' TO lt_message_body.
*      APPEND ' ' TO lt_message_body.
*      APPEND 'Segue em anexo sua nota de débito.' TO lt_message_body.
* FIM - TGRACA - RICEFW BD9-451F16 - 07/10/2021

    TRY.
        lo_document = cl_document_bcs=>create_document( i_type    = lc_type
                                                        i_text    = lt_message_body
                                                        i_subject = lv_subject ).
      CATCH cx_document_bcs.
        "handle exception
    ENDTRY.

    TRY.
        lo_document->add_attachment( EXPORTING i_attachment_type    = lc_attachment_type
                                               i_attachment_subject = lv_subject
                                               i_att_content_hex    = lt_bindata ).
      CATCH cx_document_bcs INTO DATA(lo_document_bcs).
    ENDTRY.

    " Boleto
    IF iv_belnr IS NOT INITIAL
   AND iv_bukrs IS NOT INITIAL.

      DO 10 TIMES.
        SELECT bukrs,
               belnr,
               gjahr,
               buzei
          FROM zi_fi_boleto_all
         WHERE bukrs = @iv_bukrs
           AND belnr = @iv_belnr
           AND gjahr = @iv_gjahr
          INTO TABLE @DATA(lt_boletos).

        IF sy-subrc IS INITIAL.
          EXIT.
        ELSE.

          SELECT bukrs,
                 belnr,
                 gjahr,
                 buzei
            FROM zi_fi_boleto_all
           WHERE bukrs = @iv_bukrs
             AND vbeln = @iv_belnr
             AND gjahr = @iv_gjahr
            INTO TABLE @lt_boletos.

          IF sy-subrc IS INITIAL.
            EXIT.
          ELSE.
            WAIT UP TO 1 SECONDS.
          ENDIF.
        ENDIF.
      ENDDO.

      IF lt_boletos[] IS NOT INITIAL.

        LOOP AT lt_boletos ASSIGNING FIELD-SYMBOL(<fs_boletos>).

          ls_key_boleto = <fs_boletos>-bukrs && <fs_boletos>-belnr && <fs_boletos>-gjahr && <fs_boletos>-buzei.
          APPEND ls_key_boleto TO lt_key_boleto.
          CLEAR ls_key_boleto.

        ENDLOOP.

        ls_process-app     = abap_true.
        ls_param-no_dialog = abap_true.

        CALL FUNCTION 'ZFMSD_GERAR_BOLETO'
          EXPORTING
            is_process  = ls_process
            is_param    = ls_param
            it_key      = lt_key_boleto
          IMPORTING
            ev_pdf_file = lv_pdf_file
          TABLES
            et_return   = lt_return.

        IF lv_pdf_file IS NOT INITIAL.

          FREE: lt_bindata[].
          CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
            EXPORTING
              buffer        = lv_pdf_file
            IMPORTING
              output_length = lv_size
            TABLES
              binary_tab    = lt_bindata.

          IF lt_bindata[] IS NOT INITIAL.
            TRY.
                lo_document->add_attachment( EXPORTING i_attachment_type    = lc_attachment_type
                                                       i_attachment_subject = lc_subject_bolt
                                                       i_att_content_hex    = lt_bindata ).
              CATCH cx_document_bcs INTO lo_document_bcs.
            ENDTRY.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    TRY.
        lo_send_request->set_document( lo_document ).
      CATCH cx_send_req_bcs.
        "handle exception
    ENDTRY.

* Create sender -----------------------------------------------------------------
    DATA(lo_parametros) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_parametros->m_get_range( EXPORTING iv_modulo = lc_modulo
                                              iv_chave1 = lc_chave1
                                              iv_chave2 = lc_chave2
                                    IMPORTING et_range  = lr_parametro ).
      CATCH zcxca_tabela_parametros.
        "handle exception
    ENDTRY.

    READ TABLE lr_parametro ASSIGNING FIELD-SYMBOL(<fs_parametro>) INDEX 1.

    IF sy-subrc IS INITIAL.
      SELECT SINGLE addrnumber
        FROM but021_fs
        INTO @DATA(lv_addrnumber)
       WHERE partner EQ @iv_kunag
         AND adr_kind EQ @<fs_parametro>-low.

*      SELECT SINGLE smtp_addr
*          FROM adr6
*          INTO lv_send
*          WHERE addrnumber EQ lv_addrnumber.

      SELECT smtp_addr
        FROM adr6
        INTO TABLE @DATA(lt_send)
       WHERE addrnumber EQ @lv_addrnumber.

    ENDIF.

    TRY.
        "lo_sender = cl_sapuser_bcs=>create( sy-uname ).
        lo_sender = cl_cam_address_bcs=>create_internet_address( lv_sender_email ).
      CATCH cx_address_bcs.
        "handle exception
    ENDTRY.

    TRY.
        lo_send_request->set_sender( EXPORTING i_sender = lo_sender ).
      CATCH cx_send_req_bcs.
        "handle exception
    ENDTRY.

    " Create recipient ---------------------------------------------------------------
    LOOP AT lt_send ASSIGNING FIELD-SYMBOL(<fs_send>).
      TRY.
*        lo_recipient = cl_cam_address_bcs=>create_internet_address( lv_send ).
          lo_recipient = cl_cam_address_bcs=>create_internet_address( <fs_send>-smtp_addr ).
        CATCH cx_address_bcs.
          "handle exception
      ENDTRY.

      TRY.
          lo_send_request->add_recipient( EXPORTING i_recipient = lo_recipient
                                                    i_express   = abap_true ).
        CATCH cx_send_req_bcs.
          "handle exception
      ENDTRY.
    ENDLOOP.

    TRY.
        lo_send_request->add_recipient( EXPORTING i_recipient = lo_recipient
                                                  i_express   = abap_true ).
      CATCH cx_send_req_bcs.
        "handle exception
    ENDTRY.

    " Send email -----------------------------------------------------------------------
    TRY.
        lo_send_request->set_send_immediately( i_send_immediately = abap_true ).

        lo_send_request->send( EXPORTING i_with_error_screen = abap_true
                               RECEIVING result              = lv_sent_to_all ).
      CATCH cx_send_req_bcs.
        "handle exception
    ENDTRY.

    COMMIT WORK.

    cv_return = abap_true.

  ENDMETHOD.


  METHOD get_param_type_cond.
    DATA(lo_tabela_parametros) = NEW  zclca_tabela_parametros( ).

    CLEAR gs_tipo_condicao.

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
            iv_modulo = gc_parametros-modulo
            iv_chave1 = gc_parametros-chave1
            iv_chave2 = gc_parametros-chave2
          IMPORTING
            et_range  = gs_tipo_condicao
        ).

      CATCH zcxca_tabela_parametros.

    ENDTRY.
  ENDMETHOD.


  METHOD get_vbrk_from_nast.

    SELECT SINGLE
        vbeln, bupla, bukrs,
        kunag, erdat, fkart
      FROM vbrk
      INTO @rs_vbrk
      WHERE vbeln = @is_nast-objky.

    SELECT SINGLE *
     FROM zi_sd_furto_extravio_app
     WHERE subsequentdocument = @is_nast-objky
           INTO @gs_dados_nota_deb.

    SELECT konv~kposn, konv~kbetr
   FROM i_billingdocument  AS fat
   INNER JOIN v_konv AS konv ON konv~knumv = fat~pricingdocument
       INTO TABLE @gt_vl_uni
   WHERE fat~billingdocument  = @is_nast-objky
   AND konv~kschl = 'ZPR0'
           .


  ENDMETHOD.


  METHOD execute_nast.

    DATA: ls_outputparams TYPE sfpoutputparams,
          ls_joboutput    TYPE sfpjoboutput.

    CONSTANTS lc_formname TYPE fpname VALUE 'ZAFSD_NOTA_DEBITO'.

    DATA: lv_funcname   TYPE funcname,
          ls_params     TYPE sfpdocparams,
          ls_formoutput TYPE fpformoutput.

    DATA lv_return TYPE char1.

    get_param_type_cond( ).

    DATA(ls_adobe) = get_data( iv_vbeln = iv_vbeln
                               iv_bukrs = iv_bukrs
                               iv_bupla = iv_bupla
                               iv_kunag = iv_kunag
                               iv_data  = iv_data
                               iv_fkart = iv_fkart ).

    IF sy-tcode EQ 'VF02'
    OR sy-tcode EQ 'VF31'.
      ls_outputparams-dest = 'LP01'.
      ls_outputparams-preview = abap_true.
      ls_outputparams-nodialog = abap_true.
      "ls_outputparams-reqimm    = abap_true.
      "ls_outputparams-reqnew    = abap_true.
    ELSE.
      ls_outputparams-dest = 'LP01'.
      ls_outputparams-nodialog = abap_true.
      ls_outputparams-reqimm   = abap_true.
      ls_outputparams-reqnew   = abap_true.
    ENDIF.

    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = ls_outputparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.

    IF sy-subrc IS INITIAL.

      TRY.

          CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
            EXPORTING
              i_name     = lc_formname
            IMPORTING
              e_funcname = lv_funcname.

        CATCH cx_fp_api_repository cx_fp_api_usage cx_fp_api_internal.
          RETURN.
      ENDTRY.

      CALL FUNCTION lv_funcname
        EXPORTING
          /1bcdwb/docparams = ls_params
          is_dados          = ls_adobe
        EXCEPTIONS
          usage_error       = 1
          system_error      = 2
          internal_error    = 3
          OTHERS            = 4.

      CALL FUNCTION 'FP_JOB_CLOSE'
        IMPORTING
          e_result       = ls_joboutput
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.

      IF sy-subrc IS NOT INITIAL.
        RETURN.
      ELSEIF sy-tcode <> 'VF02' AND sy-tcode <> 'VF31'.

        " Gerar email
        ls_outputparams-getpdf    = abap_true.

        CALL FUNCTION 'FP_JOB_OPEN'
          CHANGING
            ie_outputparams = ls_outputparams
          EXCEPTIONS
            cancel          = 1
            usage_error     = 2
            system_error    = 3
            internal_error  = 4
            OTHERS          = 5.

        DATA(lv_pdf) = call_form( EXPORTING is_data = ls_adobe
                                   CHANGING cv_rv   = rv_rc  ).

        CALL FUNCTION 'ZFMSD_EMAIL_NOTA_DEB'
          STARTING NEW TASK 'SEND_EMAIL'
*          CALLING task_finish ON END OF TASK
          EXPORTING
            iv_pdf         = lv_pdf
            iv_kunag       = iv_kunag
            iv_fkart       = iv_fkart
            iv_nf_ven      = gs_dados_nota_deb-br_nfenumber
            iv_num_ped     = gs_dados_nota_deb-purchaseorderbycustomer
            iv_nf_deb      = gs_dados_nota_deb-correspncexternalreference
            iv_transporter = gs_dados_nota_deb-soldtopartyname
            iv_belnr       = iv_vbeln
            iv_bukrs       = iv_bukrs
            iv_gjahr       = iv_data(4)
          CHANGING
            cv_return      = lv_return.

*        WAIT FOR ASYNCHRONOUS TASKS UNTIL lv_return IS NOT INITIAL.

        CALL FUNCTION 'FP_JOB_CLOSE'
          IMPORTING
            e_result       = ls_joboutput
          EXCEPTIONS
            usage_error    = 1
            system_error   = 2
            internal_error = 3
            OTHERS         = 4.

      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
