class ZCLSD_MSG_XML_DANFE definition
  public
  final
  create public .

public section.

  class-methods GET_UNIDADE_PRODUTORA_CAFE
    returning
      value(RT_TDLINE) type TLINET .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_MSG_XML_DANFE IMPLEMENTATION.


  METHOD get_unidade_produtora_cafe.

    DATA: lt_lines  TYPE tline_tab,
          lt_html   TYPE STANDARD TABLE OF htmlline,
          ls_header TYPE thead,
          ls_tdline TYPE tline,
          le_html   TYPE htmlline.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'ST'
        language                = 'P'
        name                    = 'Z_UNIDADE_PRODUTORA_CAFE'
        object                  = 'TEXT'
      IMPORTING
        header                  = ls_header
      TABLES
        lines                   = lt_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.

    IF sy-subrc EQ 0.

      CALL FUNCTION 'CONVERT_ITF_TO_HTML'
        EXPORTING
          i_header       = ls_header
          i_html_header  = space
        TABLES
          t_itf_text     = lt_lines
          t_html_text    = lt_html
        EXCEPTIONS
          syntax_check   = 1
          replace        = 2
          illegal_header = 3
          OTHERS         = 4.

      IF sy-subrc EQ 0.

        FREE rt_tdline.
        LOOP AT lt_html INTO DATA(ls_html).
          REPLACE ALL OCCURRENCES OF: '<P>'  IN ls_html-tdline WITH '',
                                      '</P>' IN ls_html-tdline WITH ''.
          ls_tdline-tdline = ls_html-tdline.
          APPEND ls_tdline TO rt_tdline.
        ENDLOOP.

      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
