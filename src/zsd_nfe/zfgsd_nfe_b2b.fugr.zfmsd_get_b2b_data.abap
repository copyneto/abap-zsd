FUNCTION zfmsd_get_b2b_data.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IV_ACCESS_KEY) TYPE  J_1B_NFE_ACCESS_KEY_DTEL44
*"     REFERENCE(IV_SCENARIO) TYPE  CHAR10 OPTIONAL
*"     REFERENCE(IV_GET_DANFE) TYPE  FLAG OPTIONAL
*"  EXPORTING
*"     REFERENCE(EV_DANFE) TYPE  XSTRING
*"     REFERENCE(EV_SUBJECT) TYPE  STRING
*"  TABLES
*"      ET_DANFE TYPE  TLINE_TAB
*"      ET_COMM
*"----------------------------------------------------------------------
  TYPES:
    BEGIN OF ty_address,
      adrnr TYPE vbpa-adrnr,
      parvw TYPE vbpa-parvw,
    END   OF ty_address,
    BEGIN OF ty_partner,
      parvw      TYPE j_1bnfnad-parvw,
      parid      TYPE j_1bnfnad-parid,
      adrnr      TYPE adrnr,
      ad_smtpadr TYPE ad_smtpadr,
* LSCHEPP - 8000006997 - CONFIG ENVIO XML NFE TRANSPORTADOR - 05.05.2023 Início
      ad_remark2 TYPE ad_remark2,
* LSCHEPP - 8000006997 - CONFIG ENVIO XML NFE TRANSPORTADOR - 05.05.2023 Fim
    END   OF ty_partner.

  DATA:
    ls_j_1bnfdoc   TYPE j_1bnfdoc,
    lt_j_1bnflin   TYPE TABLE OF j_1bnflin,
    ls_j_1bnflin   LIKE LINE OF lt_j_1bnflin,
    ls_j_1bnfnad   TYPE ty_partner,
    lt_vbrk        TYPE TABLE OF vbrk,
    ls_vbrk        LIKE LINE OF lt_vbrk,
    lt_vbrk_wrk    LIKE lt_vbrk,
    lt_vbpa        TYPE TABLE OF vbpa,
    ls_vbpa        LIKE LINE OF lt_vbpa,
    lt_vbrp        TYPE TABLE OF vbrp,
    lv_scenario    TYPE string,
    lv_other       TYPE string,
    lt_scenario    TYPE TABLE OF string,
    ls_scenario    LIKE LINE OF lt_scenario,
    lr_parvw       TYPE RANGE OF j_1bparvw,
    ls_parvw       LIKE LINE OF lr_parvw,
    lt_address     TYPE TABLE OF ty_address,
    ls_address     LIKE LINE OF lt_address,
    lt_partner     TYPE TABLE OF ty_partner,
    ls_partner     LIKE LINE OF lt_partner,
    lt_partner_wrk LIKE lt_partner,
    lv_parvw       TYPE j_1bparvw,
    lv_parid       TYPE j_1bparid,
    lv_partyp      TYPE j_1bpartyp,
    lv_docnum      TYPE j_1bdocnum,
    lv_adrnr       TYPE adrnr,
    lt_email       TYPE TABLE OF ad_smtpadr,
    lt_file        TYPE tline_t,
    lv_filesize    TYPE int4,
    ls_comm        TYPE zssd_s100,
    ls_key         TYPE j_1b_nfe_access_key,
    lt_parvw       TYPE RANGE OF j_1bparvw.


  CONSTANTS:
    gc_parvw_buyer    TYPE parvw VALUE 'AG',
    gc_parvw_carrier  TYPE parvw VALUE 'SP',
    gc_parvw_operator TYPE parvw VALUE 'ZW',
    gc_parvw_vendor   TYPE parvw VALUE 'LF',
* LSCHEPP - 8000006997 - CONFIG ENVIO XML NFE TRANSPORTADOR - 05.05.2023 Início
    gc_mailnfe        TYPE ad_remark2 VALUE 'MAILNFE'.
* LSCHEPP - 8000006997 - CONFIG ENVIO XML NFE TRANSPORTADOR - 05.05.2023 Fim

  FIELD-SYMBOLS: <fs_mail> TYPE ad_smtpadr.

  MOVE iv_access_key TO ls_key.

  SELECT SINGLE
    b~docnum
    b~parid
    INTO (lv_docnum, lv_parid)
    FROM j_1bnfe_active AS a
    INNER JOIN j_1bnfdoc AS b ON a~docnum = b~docnum
   WHERE a~regio   = ls_key-regio
     AND a~nfyear  = ls_key-nfyear
     AND a~nfmonth = ls_key-nfmonth
     AND a~stcd1   = ls_key-stcd1
     AND a~model   = ls_key-model
     AND a~serie   = ls_key-serie
     AND a~nfnum9  = ls_key-nfnum9
     AND a~docnum9 = ls_key-docnum9
     AND a~cdv     = ls_key-cdv.

  IF lv_parid IS NOT INITIAL.

    SELECT SINGLE
      adrnr
      INTO lv_adrnr
      FROM kna1
      WHERE kunnr = lv_parid.

    IF sy-subrc = 0.
      ls_address-adrnr = lv_adrnr.
      APPEND ls_address TO lt_address.
    ENDIF.

    SELECT SINGLE
      adrnr
      INTO lv_adrnr
      FROM lfa1
      WHERE lifnr = lv_parid.

    IF sy-subrc = 0.
      ls_address-adrnr = lv_adrnr.
      APPEND ls_address TO lt_address.
    ENDIF.

  ENDIF.

  lt_parvw = VALUE #( sign = 'I'  option = 'EQ' ( low = gc_parvw_operator  )
                                                ( low = gc_parvw_carrier   )
                                                ( low = gc_parvw_vendor    ) ).

* LSCHEPP - 8000006997 - CONFIG ENVIO XML NFE TRANSPORTADOR - 05.05.2023 Início
*  SELECT
*    parvw
*    parid
*    adrnr
*    c~smtp_addr
*    FROM j_1bnfnad AS a
*    INNER JOIN lfa1 AS b
*    ON a~parid = b~lifnr
*    INNER JOIN adr6 AS c
*    ON b~adrnr = c~addrnumber
*    INTO TABLE lt_partner
*   WHERE docnum = lv_docnum
*     AND parvw  IN lt_parvw.

  SELECT a~parvw, a~parid, b~adrnr, c~emailaddress, c~addresscommunicationremarktext
    FROM j_1bnfnad AS a
    INNER JOIN lfa1 AS b ON a~parid = b~lifnr
    INNER JOIN c_bpemailaddress AS c ON b~adrnr = c~addressid
   WHERE a~docnum EQ @lv_docnum
     AND a~parvw  IN @lt_parvw
     INTO TABLE @lt_partner.
* LSCHEPP - 8000006997 - CONFIG ENVIO XML NFE TRANSPORTADOR - 05.05.2023 Fim

  IF sy-subrc EQ 0.

    LOOP AT lt_partner ASSIGNING FIELD-SYMBOL(<fs_email>).

* LSCHEPP - 8000006997 - CONFIG ENVIO XML NFE TRANSPORTADOR - 05.05.2023 Início
      IF <fs_email>-parvw EQ gc_parvw_carrier AND
         <fs_email>-ad_remark2 NE gc_mailnfe.
        CONTINUE.
      ENDIF.
* LSCHEPP - 8000006997 - CONFIG ENVIO XML NFE TRANSPORTADOR - 05.05.2023 Fim

      ls_comm-type = 'MAIL'.
      ls_comm-address = <fs_email>-ad_smtpadr.
      APPEND ls_comm TO et_comm.

    ENDLOOP.

  ENDIF.

  IF iv_get_danfe EQ abap_true.

    CALL FUNCTION 'ZFMSD_GET_DANFE_PDF'
      EXPORTING
        iv_docnum            = lv_docnum
      IMPORTING
        et_file              = lt_file
        ev_filesize          = lv_filesize
        ev_file              = ev_danfe
      EXCEPTIONS
        document_not_found   = 1
        nfe_not_approved     = 2
        nfe_not_printed      = 3
        conversion_exception = 4
        print_program_error  = 5
        OTHERS               = 6.

    IF sy-subrc EQ 0 AND lv_filesize IS NOT INITIAL.

      CALL FUNCTION 'SSFC_BASE64_CODE'
        EXPORTING
          ostr_input_data_l        = lv_filesize
        TABLES
          ostr_input_data          = lt_file
          ostr_digested_data       = et_danfe
        EXCEPTIONS
          ssf_krn_error            = 1
          ssf_krn_noop             = 2
          ssf_krn_nomemory         = 3
          ssf_krn_opinv            = 4
          ssf_krn_input_data_error = 5
          ssf_krn_invalid_par      = 6
          ssf_krn_invalid_parlen   = 7
          OTHERS                   = 8.

      IF sy-subrc NE 0.
        DATA(lv_erro) = space.
      ENDIF.

    ENDIF.

  ENDIF.

  IF ev_subject IS NOT INITIAL.

    SELECT SINGLE name1, ort01
      FROM j_1bnfdoc
      INTO (@DATA(lv_name1), @DATA(lv_ort1))
      WHERE docnum = @lv_docnum.

    SELECT SINGLE name1, ort01
      FROM j_1bnfnad
      INTO (@DATA(lv_name2), @DATA(lv_ort2))
      WHERE docnum = @lv_docnum AND
            parvw  = 'WE'.

    ev_subject = |{ lv_name1 } - { lv_ort1 } / { lv_name2 } - { lv_ort2 }|.

  ENDIF.

ENDFUNCTION.
