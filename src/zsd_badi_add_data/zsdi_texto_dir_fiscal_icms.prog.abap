*&---------------------------------------------------------------------*
*& Include ZSDI_TEXTO_DIR_FISCAL_ICMS
*&---------------------------------------------------------------------*
CONSTANTS: lc_nflin TYPE tdobject VALUE 'J_1BNFLIN',
           lc_0001  TYPE tdid VALUE '0001'.

DATA lv_name_t TYPE thead-tdname.

DATA: ls_header_t TYPE thead,
      lt_lines_t  TYPE tline_tab.


SELECT SINGLE *
  FROM j_1batl1t
  INTO @ls_j_1batl1t
  WHERE langu  EQ @sy-langu
    AND taxlaw EQ @<fs_nflin>-taxlw1.
IF sy-subrc EQ 0.

  lv_name_t = |{ <fs_nflin>-docnum }{ <fs_nflin>-itmnum }|.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_0001
      language                = sy-langu
      name                    = lv_name_t
      object                  = lc_nflin
    TABLES
      lines                   = lt_lines_t
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.

  LOOP AT lt_lines_t ASSIGNING FIELD-SYMBOL(<fs_lines>).
    SEARCH <fs_lines>-tdline FOR ls_j_1batl1t-line1.
    IF sy-subrc NE 0.
      DATA(lv_delete) = abap_true.
    ENDIF.
    EXIT.
  ENDLOOP.

  IF NOT lv_delete IS INITIAL.
    CALL FUNCTION 'DELETE_TEXT'
      EXPORTING
        id        = lc_0001
        language  = sy-langu
        name      = lv_name_t
        object    = lc_nflin
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.
  ENDIF.

  REFRESH lt_lines_t.
  IF NOT ls_j_1batl1t-line1 IS INITIAL.
    UNASSIGN <fs_lines>.
    APPEND INITIAL LINE TO lt_lines_t ASSIGNING <fs_lines>.
    <fs_lines>-tdformat = '*'.
    <fs_lines>-tdline   = ls_j_1batl1t-line1.
  ELSE.
    RETURN.
  ENDIF.
  IF NOT ls_j_1batl1t-line2 IS INITIAL.
    UNASSIGN <fs_lines>.
    APPEND INITIAL LINE TO lt_lines_t ASSIGNING <fs_lines>.
    <fs_lines>-tdformat = '='.
    <fs_lines>-tdline   = ls_j_1batl1t-line2.
  ENDIF.
  IF NOT ls_j_1batl1t-line3 IS INITIAL.
    UNASSIGN <fs_lines>.
    APPEND INITIAL LINE TO lt_lines_t ASSIGNING <fs_lines>.
    <fs_lines>-tdformat = '='.
    <fs_lines>-tdline   = ls_j_1batl1t-line3.
  ENDIF.
  IF NOT ls_j_1batl1t-line4 IS INITIAL.
    UNASSIGN <fs_lines>.
    APPEND INITIAL LINE TO lt_lines_t ASSIGNING <fs_lines>.
    <fs_lines>-tdformat = '='.
    <fs_lines>-tdline   = ls_j_1batl1t-line4.
  ENDIF.

  ls_header_t-tdobject = lc_nflin.
  ls_header_t-tdname   = lv_name_t.
  ls_header_t-tdid     = lc_0001.
  ls_header_t-tdspras  = sy-langu.

  CALL FUNCTION 'SAVE_TEXT'
    EXPORTING
      header   = ls_header_t
    TABLES
      lines    = lt_lines_t
    EXCEPTIONS
      id       = 1
      language = 2
      name     = 3
      object   = 4
      OTHERS   = 5.
  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

ENDIF.
