FUNCTION zfmsd_read_text.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_ID) LIKE  THEAD-TDID
*"     VALUE(IV_LANGUAGE) LIKE  THEAD-TDSPRAS
*"     VALUE(IV_NAME) LIKE  THEAD-TDNAME
*"     VALUE(IV_OBJECT) LIKE  THEAD-TDOBJECT
*"  TABLES
*"      T_LINES STRUCTURE  TLINE
*"  EXCEPTIONS
*"      ID
*"      LANGUAGE
*"      NAME
*"      NOT_FOUND
*"      OBJECT
*"      REFERENCE_CHECK
*"      WRONG_ACCESS_TO_ARCHIVE
*"----------------------------------------------------------------------
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      client   = sy-mandt
      id       = iv_id
      language = iv_language
      name     = iv_name
      object   = iv_object
    TABLES
      lines    = t_lines.

ENDFUNCTION.
