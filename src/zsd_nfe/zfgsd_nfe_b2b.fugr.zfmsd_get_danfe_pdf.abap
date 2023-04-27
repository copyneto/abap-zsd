FUNCTION zfmsd_get_danfe_pdf.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IV_DOCNUM) TYPE  J_1BDOCNUM
*"     REFERENCE(IV_PRINTER) TYPE  RSPOPNAME OPTIONAL
*"  EXPORTING
*"     REFERENCE(ET_FILE) TYPE  TLINE_T
*"     REFERENCE(EV_FILESIZE) TYPE  INT4
*"     REFERENCE(EV_FILE) TYPE  XSTRING
*"  TABLES
*"      ET_OTF TYPE  TSFOTF OPTIONAL
*"  EXCEPTIONS
*"      DOCUMENT_NOT_FOUND
*"      NFE_NOT_APPROVED
*"      NFE_NOT_PRINTED
*"      CONVERSION_EXCEPTION
*"      PRINT_PROGRAM_ERROR
*"----------------------------------------------------------------------
  TABLES: nast , tnapr.

  TYPES: BEGIN OF ty_doc,
           docnum LIKE j_1bnfdoc-docnum,
           form   LIKE j_1bnfdoc-form,
           printd LIKE j_1bnfdoc-printd,
           code   LIKE j_1bnfe_active-code,
         END OF ty_doc.

  DATA: lt_pdf TYPE TABLE OF itcoo,
        lt_otf TYPE tsfotf.

  DATA: ls_doc    TYPE ty_doc,
        lv_pdf    TYPE c VALUE 'X',
        lv_subrc  TYPE i VALUE 0,
        lv_screen TYPE i VALUE 0,
        lv_buf_id TYPE indx_srtfd.

  SELECT SINGLE a~docnum a~form  a~printd b~code
    INTO ls_doc
    FROM j_1bnfdoc AS a INNER JOIN j_1bnfe_active AS b
      ON b~docnum = a~docnum
   WHERE a~docnum EQ iv_docnum.

  IF sy-subrc NE 0.
    RAISE document_not_found.
  ENDIF.
  IF ls_doc-code NE '100'.
    RAISE nfe_not_approved.
  ENDIF.

*  IF ls_doc-printd NE 'X'.
*    RAISE nfe_not_printed.
*  ENDIF.

  lv_buf_id = 'DANFE_OTF_' && ls_doc-docnum.

  SELECT SINGLE * FROM tnapr
    INTO tnapr
   WHERE kschl = ls_doc-form.

  nast-kappl = tnapr-kappl.
  nast-objky = ls_doc-docnum.
  nast-kschl = tnapr-kschl.
  nast-spras = 'P'.
  nast-erdat = sy-datum.
  nast-eruhr = sy-uzeit.
  nast-nacha = 1.
  nast-anzal = 1.
  nast-vsztp = 1.
  IF NOT iv_printer IS INITIAL.
    nast-ldest = iv_printer.
    nast-dimme = abap_true.
  ELSE.
    nast-ldest = 'LOCL'.
  ENDIF.
  nast-nauto = 'X'.

* Executar programa de impressão
  tnapr-ronam = 'ENTRY'.
  tnapr-pgnam = 'ZNFE_PRINT_DANFE'.

  EXPORT lv_pdf = lv_pdf TO MEMORY ID 'DANFE_PDF'.

  PERFORM (tnapr-ronam) IN PROGRAM (tnapr-pgnam)
    USING lv_subrc lv_screen IF FOUND.

  IF lv_subrc NE 0.
    RAISE print_program_error.
  ELSE.
    CLEAR: tnapr.
  ENDIF.

  IF NOT iv_printer IS INITIAL.
    RETURN.
  ENDIF.

  IMPORT lt_otf = lt_otf[] FROM SHARED BUFFER indx(st) ID lv_buf_id.
  DELETE FROM SHARED BUFFER indx(st) ID lv_buf_id.
  et_otf[] = lt_otf[].
  lt_pdf[] = lt_otf[].

  CALL FUNCTION 'CONVERT_OTF'
    EXPORTING
      format                = 'PDF'
      max_linewidth         = 132
    IMPORTING
      bin_filesize          = ev_filesize
      bin_file              = ev_file
    TABLES
      otf                   = lt_pdf
      lines                 = et_file
    EXCEPTIONS
      err_max_linewidth     = 1
      err_format            = 2
      err_conv_not_possible = 3
      err_bad_otf           = 4
      OTHERS                = 5.
  IF sy-subrc NE 0.
    RAISE conversion_exception.
  ENDIF.

ENDFUNCTION.
