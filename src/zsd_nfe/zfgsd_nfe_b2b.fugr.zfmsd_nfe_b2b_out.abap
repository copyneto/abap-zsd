FUNCTION zfmsd_nfe_b2b_out.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IS_NFEHD) TYPE  /XNFE/NFEHD OPTIONAL
*"     REFERENCE(IS_OUTNFEHD) TYPE  /XNFE/OUTNFEHD OPTIONAL
*"     REFERENCE(IS_OUTCTEHD) TYPE  /XNFE/OUTCTEHD OPTIONAL
*"     REFERENCE(IV_SCENARIO) TYPE  /XNFE/B2BSCENARIO OPTIONAL
*"  EXPORTING
*"     REFERENCE(EV_COMMPARAM) TYPE  /XNFE/COMMPARAM
*"----------------------------------------------------------------------
  CONSTANTS: BEGIN OF gc_data,
               lc6  TYPE string VALUE '',
               lc7  TYPE string VALUE '',
               lc8  TYPE string VALUE '',
               lc9  TYPE string VALUE '',
               lc10 TYPE string VALUE '',
               lc11 TYPE string VALUE '',
               lc12 TYPE string VALUE '',
               lc13 TYPE string VALUE '',
               lc14 TYPE string VALUE '',
               lc15 TYPE string VALUE '',
               lc16 TYPE string VALUE '',
               lc17 TYPE string VALUE '',
             END OF gc_data.

  CONSTANTS lc_texto TYPE char40 VALUE '3Corações - NF-e'.

  DATA: lv_mail                 TYPE string,
        lv_subject_1            TYPE string,
        lv_sender               TYPE string,
        lv_receiver             TYPE string,
        lv_replyto              TYPE string,
        lv_boundary             TYPE string VALUE 'JrSnBoUnDaRy',
        lv_mail_content         TYPE string,
        lv_attachmentname       TYPE string,
        lv_attachmentname_danfe TYPE string,
        lv_attachment_pdf       TYPE string,
        lv_guid                 TYPE /xnfe/ev_guid_16,
        lv_cnpj                 TYPE /xnfe/cnpj_own,
        lv_b64_xml              TYPE string,
        lv_b64_pdf              TYPE string,
        ls_xml                  TYPE /xnfe/xml,
        lv_acckey               TYPE /xnfe/id,
        lv_xs_xml               TYPE xstring,
        lv_xs_pdf               TYPE xstring,
        ls_nfehd310             TYPE /xnfe/outnfehd,
        ls_xml310               TYPE /xnfe/outnfexml,
        lv_event                TYPE string VALUE '(/XNFE/NFE_B2B_SEND)<LS_EVENTS>',
        lv_event_t              TYPE string VALUE '(/XNFE/NFE_B2B_SEND)LT_EVENTS',
        ls_event                TYPE /xnfe/events,
        ls_xml_e                TYPE /xnfe/event_xml,
        ls_b2bcust              TYPE ztsd_cst_b2b_out,
        lv_logsys               TYPE logsys,
        lv_destination          TYPE bdbapidst,
        lv_txt_name             TYPE tdobname,
        lv_is_event             TYPE abap_bool,
        lt_comm_param           TYPE TABLE OF zssd_s100,
        lv_separator            TYPE abap_cr_lf,
        lt_text                 TYPE tline_tab,
        lt_danfeb64             TYPE tline_tab,
        lv_issuer_name          TYPE string,
        lv_destin_name          TYPE string,
        lv_carrier_name         TYPE string,
        lv_protocol             TYPE string,
        lv_event_type           TYPE string,
        lv_nfenum               TYPE string,
        lv_serie                TYPE string,
        lv_get_danfe            TYPE abap_bool,
        lv_subject_2            TYPE string.

  FIELD-SYMBOLS: <fs_event>   TYPE /xnfe/events,
                 <fs_event_t> TYPE /xnfe/events_t,
                 <fs_cp>      TYPE zssd_s100,
                 <fs_text>    TYPE tline,
                 <fs_d>       TYPE tline.


*--------------------------------------------------------------------*
* Get the NF-e/Event XML
*--------------------------------------------------------------------*
*  ASSIGN (lv_event_t) TO <fs_event_t> .
*  IF <fs_event_t> IS ASSIGNED AND <fs_event_t>[] IS NOT INITIAL.
*    ASSIGN (lv_event) TO <fs_event>.
*    IF <fs_event> IS ASSIGNED.
*      ls_event = <fs_event>.
*    ENDIF.
*  ELSE.
  IMPORT lv_guid = lv_guid FROM SHARED BUFFER indx(st) ID 'IV_GUID'.
  IF lv_guid IS NOT INITIAL.
    ls_event-guid = lv_guid.
  ENDIF.
*  ENDIF.

  IF ls_event IS NOT INITIAL. "NF-e events

    lv_is_event = abap_true.

    CALL FUNCTION '/XNFE/EV_READ_EVENT_FOR_UPD'
      EXPORTING
        iv_guid              = ls_event-guid
      IMPORTING
        es_event             = ls_event
        es_xml               = ls_xml_e
      EXCEPTIONS
        event_does_not_exist = 1
        event_locked         = 2
        technical_error      = 3
        OTHERS               = 4.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    lv_xs_xml = ls_xml_e-xmlstring.
    lv_acckey = ls_event-chnfe.

    IF is_outnfehd IS NOT INITIAL.
      lv_logsys = is_outnfehd-logsys.

      lv_issuer_name = is_outnfehd-xnome_emit.
      lv_destin_name = is_outnfehd-xnome_dest.
      lv_carrier_name = is_outnfehd-xnome_transp.
      lv_protocol = ls_event-nprot.
      lv_event_type = ls_event-tpevento.
      lv_nfenum = is_outnfehd-nnf.
      lv_serie = is_outnfehd-serie.
    ELSE.
      lv_logsys = is_nfehd-logsys.

      lv_issuer_name = is_nfehd-c_xnome.
      lv_destin_name = is_nfehd-e_xnome.
      lv_carrier_name = ''.
      lv_protocol = is_nfehd-authcod.
      lv_nfenum = is_nfehd-nnf.
      lv_serie = is_nfehd-serie.
    ENDIF.
    lv_attachmentname = lv_acckey && '-' && lv_event_type && '.xml'.

  ELSEIF is_outnfehd IS NOT INITIAL.                        "NF-e 3.10

    CALL FUNCTION '/XNFE/OUTNFE_READ_NFE_FOR_UPD'
      EXPORTING
        iv_guid            = is_outnfehd-guid
      IMPORTING
        es_nfehd           = ls_nfehd310
        es_xml_nfe         = ls_xml310
      EXCEPTIONS
        nfe_does_not_exist = 1
        nfe_locked         = 2
        technical_error    = 3
        OTHERS             = 4.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    lv_xs_xml = ls_xml310-xmlstring.
    lv_logsys = is_outnfehd-logsys.
    lv_acckey = is_outnfehd-id.

    lv_issuer_name = is_outnfehd-xnome_emit.
    lv_destin_name = is_outnfehd-xnome_dest.
    lv_carrier_name = is_outnfehd-xnome_transp.
    lv_protocol = is_outnfehd-nprot.
    lv_nfenum = is_outnfehd-nnf.
    lv_serie = is_outnfehd-serie.

    lv_attachmentname = lv_acckey && '.xml'.

  ELSEIF is_nfehd IS NOT INITIAL.                           "NF-e 2.00

    CALL FUNCTION '/XNFE/READ_XML'
      EXPORTING
        iv_id              = is_nfehd-id
        iv_type            = is_nfehd-type
        iv_tpemis          = is_nfehd-tpemis
      IMPORTING
        es_xml             = ls_xml
      EXCEPTIONS
        no_xml_found       = 1
        error_reading_kpro = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    lv_xs_xml = ls_xml-xmlstring.
    lv_logsys = is_nfehd-logsys.
    lv_acckey = is_nfehd-id.

    lv_issuer_name = is_nfehd-c_xnome.
    lv_destin_name = is_nfehd-e_xnome.
    lv_carrier_name = ''.
    lv_protocol = is_nfehd-authcod.
    lv_nfenum = is_nfehd-nnf.
    lv_serie = is_nfehd-serie.

    lv_attachmentname = lv_acckey && '.xml'.
  ELSEIF is_outctehd IS NOT INITIAL."CT-e
    "TBD
  ENDIF.

*--------------------------------------------------------------------*
* Read B2B Mail customizing
*--------------------------------------------------------------------*
  lv_cnpj = lv_acckey+6(14).

  CALL FUNCTION 'ZFMSD_NFE_B2B_READ_CUSTOMIZING'
    EXPORTING
      iv_cnpj    = lv_cnpj
    IMPORTING
      es_b2bcust = ls_b2bcust
    EXCEPTIONS
      OTHERS     = 1.

  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  lv_sender = ls_b2bcust-sender_email.
  lv_replyto = ls_b2bcust-replyto_email.
*  IF iv_scenario = 'BUYER' AND lv_is_event = abap_false.
*    lv_subject_1 = ls_b2bcust-subject_nfecu.
*    lv_txt_name = ls_b2bcust-nfe_cutxt_name.
*  ELSEIF iv_scenario = 'BUYER' AND lv_is_event = abap_true.
*    lv_subject_1 = ls_b2bcust-subject_evecu.
*    lv_txt_name = ls_b2bcust-eve_cutxt_name.
  IF iv_scenario = 'CARRIER' AND lv_is_event = abap_false.
* LSCHEPP - Ajuste - 14.10.2022 Início
*    lv_subject_1 = ls_b2bcust-subject_nfeca.
    lv_subject_1 = |{ lc_texto } { lv_nfenum } : { is_outnfehd-dhemi+6(2) }.{ is_outnfehd-dhemi+4(2) }.{ is_outnfehd-dhemi(4) }|.
* LSCHEPP - Ajuste - 14.10.2022 Fim
    lv_txt_name = ls_b2bcust-nfe_catxt_name.
*  ELSEIF iv_scenario = 'CARRIER' AND lv_is_event = abap_true.
*    lv_subject_1 = ls_b2bcust-subject_eveca.
*    lv_txt_name = ls_b2bcust-eve_catxt_name.
*  ELSEIF iv_scenario = 'CARRIER'.
*    lv_subject_1 = ls_b2bcust-subject_eveca.
*    lv_txt_name  = ls_b2bcust-eve_catxt_name.
  ENDIF.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = ls_b2bcust-text_id
      language                = ls_b2bcust-text_langu
      name                    = lv_txt_name
      object                  = 'TEXT'
    TABLES
      lines                   = lt_text
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.

  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    RETURN.
  ENDIF.

  LOOP AT lt_text ASSIGNING <fs_text>.
    CASE <fs_text>-tdformat.
      WHEN '*'.
        lv_separator = cl_abap_char_utilities=>cr_lf.
      WHEN '/'.
        lv_separator = cl_abap_char_utilities=>cr_lf.
      WHEN OTHERS.
        CLEAR lv_separator.
    ENDCASE.
    CONCATENATE lv_mail_content <fs_text>-tdline INTO
     lv_mail_content SEPARATED BY lv_separator.
  ENDLOOP.
*--------------------------------------------------------------------*
* Replace variables in lv_mail_content and lv_subject_2_1
*--------------------------------------------------------------------*
  REPLACE ALL OCCURRENCES OF '<NFE_ID>' IN lv_subject_1 WITH lv_acckey.
  REPLACE ALL OCCURRENCES OF '<NFENUM>' IN lv_subject_1 WITH lv_nfenum.
  REPLACE ALL OCCURRENCES OF '<SERIE>' IN lv_subject_1 WITH lv_serie.
  REPLACE ALL OCCURRENCES OF '<PROTOCOL>' IN lv_subject_1 WITH lv_protocol.
  REPLACE ALL OCCURRENCES OF '<EVENT_TYPE>' IN lv_subject_1 WITH lv_event_type.
  REPLACE ALL OCCURRENCES OF '<PARTNER_NAME>' IN lv_subject_1 WITH lv_destin_name.
  REPLACE ALL OCCURRENCES OF '<CARRIER_NAME>' IN lv_subject_1 WITH lv_carrier_name.
  REPLACE ALL OCCURRENCES OF '<ISSUER_NAME>' IN lv_subject_1 WITH lv_issuer_name.

  REPLACE ALL OCCURRENCES OF '<(>' IN lv_mail_content WITH space.
  REPLACE ALL OCCURRENCES OF '<)>' IN lv_mail_content WITH space.
  REPLACE ALL OCCURRENCES OF '<NFE_ID>' IN lv_mail_content WITH lv_acckey.
  REPLACE ALL OCCURRENCES OF '<NFENUM>' IN lv_mail_content WITH lv_nfenum.
  REPLACE ALL OCCURRENCES OF '<SERIE>' IN lv_mail_content WITH lv_serie.
  REPLACE ALL OCCURRENCES OF '<PROTOCOL>' IN lv_mail_content WITH lv_protocol.
  REPLACE ALL OCCURRENCES OF '<EVENT_TYPE>' IN lv_mail_content WITH lv_event_type.
  REPLACE ALL OCCURRENCES OF '<PARTNER_NAME>' IN lv_mail_content WITH lv_destin_name.
  REPLACE ALL OCCURRENCES OF '<CARRIER_NAME>' IN lv_mail_content WITH lv_carrier_name.
  REPLACE ALL OCCURRENCES OF '<ISSUER_NAME>' IN lv_mail_content WITH lv_issuer_name.

  lv_mail_content = cl_http_utility=>escape_xml_char_data( lv_mail_content ).
*--------------------------------------------------------------------*
* Retrieve Partner data + DANFE PDF from ECC
*--------------------------------------------------------------------*

  CALL FUNCTION '/XNFE/READ_RFC_DESTINATION'
    EXPORTING
      iv_logsys     = lv_logsys
    IMPORTING
      ev_rfcdest    = lv_destination
    EXCEPTIONS
      no_dest_found = 1
      OTHERS        = 2.

  IF sy-subrc NE 0.
    RETURN.
  ENDIF.

  IF lv_is_event EQ abap_false.
    lv_get_danfe = abap_true.
  ENDIF.

  CALL FUNCTION 'ZFMSD_GET_B2B_DATA'
    EXPORTING
      iv_access_key = lv_acckey
      iv_scenario   = iv_scenario
      iv_get_danfe  = lv_get_danfe
    IMPORTING
      ev_danfe      = lv_xs_pdf
      ev_subject    = lv_subject_2
    TABLES
      et_comm       = lt_comm_param
      et_danfe      = lt_danfeb64.

*  IF lv_subject_2 IS NOT INITIAL.
  lv_subject_2 = |{ lv_subject_1 } { lv_subject_2 }|.
*  ENDIF.

  PERFORM f_convert_to_base64 USING lv_xs_xml CHANGING lv_b64_xml.
  PERFORM f_convert_to_base64 USING lv_xs_pdf CHANGING lv_b64_pdf.

  LOOP AT lt_danfeb64 ASSIGNING <fs_d>.
    CONCATENATE lv_b64_pdf <fs_d> INTO lv_b64_pdf.
  ENDLOOP.

  IF ls_b2bcust-test_mode EQ abap_true.

    lv_receiver = ls_b2bcust-receiver_mail.

  ELSE.

    LOOP AT lt_comm_param ASSIGNING <fs_cp>.
      CASE <fs_cp>-type.
        WHEN 'MAIL'.
          CONCATENATE lv_receiver <fs_cp>-address INTO lv_receiver SEPARATED BY ';'.
      ENDCASE.
    ENDLOOP.
  ENDIF.


*--------------------------------------------------------------------*
* Build NF-e DANFE PDF attachment - if found
*--------------------------------------------------------------------*
  IF lv_b64_pdf IS NOT INITIAL AND lv_is_event EQ abap_false.

    lv_attachmentname_danfe = lv_acckey && '.pdf'.

    lv_attachment_pdf = '--' && lv_boundary &&
                        cl_abap_char_utilities=>cr_lf &&
                        'Content-Type: Application/Octet-stream; name="' &&
                        lv_attachmentname_danfe && '"' &&
                        cl_abap_char_utilities=>cr_lf &&
                        'Content-Disposition: attachment; filename="' &&
                        lv_attachmentname_danfe && '"' &&
                        cl_abap_char_utilities=>cr_lf &&
                        'Content-Transfer-Encoding: base64' &&
                        cl_abap_char_utilities=>cr_lf &&
                        cl_abap_char_utilities=>cr_lf &&
                        lv_b64_pdf &&
                        cl_abap_char_utilities=>cr_lf.
  ENDIF.

*--------------------------------------------------------------------*
*  Build the Mail Package XML
*--------------------------------------------------------------------*
  lv_mail = '<?xml version="1.0" encoding="UTF-8"?>' &&
            '<ns:Mail xmlns:ns="http://sap.com/xi/XI/Mail/30">' &&
            '<Subject>' &&
            lv_subject_2 &&
            '</Subject>' &&
            '<From>' &&
            lv_sender &&
            '</From>' &&
            '<To>' &&
            lv_receiver &&
            '</To>' &&
            '<Reply_To>' &&
            lv_replyto &&
            '</Reply_To>' &&
            '<Content_Type>multipart/mixed; boundary="' &&
            lv_boundary &&
            '"</Content_Type>' &&
            "//First Part: E-mail body
            '<Content>' &&
            '--' && lv_boundary &&
            cl_abap_char_utilities=>cr_lf &&
            cl_abap_char_utilities=>cr_lf &&
            lv_mail_content &&
            cl_abap_char_utilities=>cr_lf &&
            '--' && lv_boundary &&
            cl_abap_char_utilities=>cr_lf &&
            'Content-Type: application/xml; name="' &&
            lv_attachmentname && '"' &&
            cl_abap_char_utilities=>cr_lf &&
            'Content-Disposition: attachment; filename="' &&
            lv_attachmentname && '"' &&
            cl_abap_char_utilities=>cr_lf &&
            'Content-Transfer-Encoding: base64' &&
            cl_abap_char_utilities=>cr_lf &&
            cl_abap_char_utilities=>cr_lf &&
            lv_b64_xml &&
            cl_abap_char_utilities=>cr_lf &&
            "//Third Part: NF-e DANFE PDF Attachment Base64 encoded [optional]
            lv_attachment_pdf &&
            '--' && lv_boundary && '--' &&
            '</Content></ns:Mail>'.

  ev_commparam = lv_mail.

ENDFUNCTION.


FORM f_convert_to_base64 USING uv_xstring TYPE xstring
                      CHANGING cv_string  TYPE string.

  DATA: lv_len  TYPE syindex,
        lv_off  TYPE syindex,
        lv_xml  TYPE string,
        lv_rptd TYPE p DECIMALS 2,
        lv_rpt  TYPE syindex,
        lv_rst  TYPE syindex.

  cv_string = cl_http_utility=>encode_x_base64( uv_xstring ).

  lv_len = strlen( cv_string ).

  lv_rptd = lv_len / 76.
  lv_rpt = round( val = lv_rptd dec = 0 mode = cl_abap_math=>round_down ).
  lv_rst = lv_len MOD 76.
  CLEAR lv_xml.
  DO lv_rpt TIMES.
    lv_xml = lv_xml && cv_string+lv_off(76) && cl_abap_char_utilities=>newline.
    lv_off = ( 76 * sy-index ).
  ENDDO.
  IF lv_rst > 0 .
    lv_xml = lv_xml && cv_string+lv_off.
  ENDIF.

  cv_string = lv_xml.
ENDFORM.
