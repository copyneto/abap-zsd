CLASS zclsd_preenche_tabelas DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! Converte xstring para tabela interna
    "! @parameter iv_xstring | Arquivo Xstring
    "! @parameter iv_nome_arq | Nome do arquivo
    "! @parameter ct_tabela | Tabela tipificada
    METHODS converte_xstring_para_it
      IMPORTING
        !iv_xstring  TYPE xstring
        !iv_nome_arq TYPE rsfilenm
      CHANGING
        !ct_tabela   TYPE STANDARD TABLE .
    METHODS insert_ztsd_arq_ordvend
      IMPORTING
        !it_tabela TYPE STANDARD TABLE
        !iv_guid   TYPE guid_16 .
    "! Preenche tabela dos componentes
    "! @parameter is_line | Linha da tabela
    "! @parameter ct_tabela | Tabela tipificada
    METHODS preenche_tabela_componentes
      IMPORTING
        !is_line   TYPE any
      CHANGING
        !ct_tabela TYPE STANDARD TABLE .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclsd_preenche_tabelas IMPLEMENTATION.


  METHOD converte_xstring_para_it.
    DATA: lo_ref_descr TYPE REF TO cl_abap_structdescr,
          lo_excel_ref TYPE REF TO cl_fdt_xl_spreadsheet.

    DATA: lt_detail TYPE abap_compdescr_tab.

    FIELD-SYMBOLS : <fs_data>      TYPE STANDARD TABLE.

    TRY .
        lo_excel_ref = NEW cl_fdt_xl_spreadsheet(
          document_name = CONV #( iv_nome_arq )
          xdocument     = iv_xstring ).
      CATCH cx_fdt_excel_core.
        "Implement suitable error handling here
    ENDTRY .

    "Get List of Worksheets
    lo_excel_ref->if_fdt_doc_spreadsheet~get_worksheet_names(
      IMPORTING
        worksheet_names = DATA(lt_worksheets) ).

    IF NOT lt_worksheets IS INITIAL.
      READ TABLE lt_worksheets INTO DATA(lv_woksheetname) INDEX 1.

      DATA(lo_data_ref) = lo_excel_ref->if_fdt_doc_spreadsheet~get_itab_from_worksheet(
                                               lv_woksheetname ).
      "now you have excel work sheet data in dyanmic internal table
      ASSIGN lo_data_ref->* TO <fs_data>.

      LOOP AT <fs_data> ASSIGNING FIELD-SYMBOL(<fs_line>) FROM 2. "Ignorar linha do cabeçalho
        me->preenche_tabela_componentes( EXPORTING is_line = <fs_line> CHANGING ct_tabela = ct_tabela ).
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD insert_ztsd_arq_ordvend.

    DELETE FROM ztsd_arq_ordvend
      WHERE numclient IS NOT INITIAL
        AND created_by = @sy-uname.

    DATA: ls_arquivo TYPE ztsd_arq_ordvend.

    DATA: lt_arquivo TYPE TABLE OF ztsd_arq_ordvend.

    LOOP AT it_tabela ASSIGNING FIELD-SYMBOL(<fs_arquivo>).
      MOVE-CORRESPONDING <fs_arquivo> TO ls_arquivo.
*
      CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
        EXPORTING
          input          = ls_arquivo-salesunit
          language       = sy-langu
        IMPORTING
          output         = ls_arquivo-salesunit
        EXCEPTIONS
          unit_not_found = 1
          OTHERS         = 2.

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.
      ls_arquivo-created_by = sy-uname.
      APPEND ls_arquivo TO lt_arquivo.
    ENDLOOP.

    IF lt_arquivo IS NOT INITIAL.
      MODIFY ztsd_arq_ordvend FROM TABLE lt_arquivo.
    ENDIF.

*    DELETE lt_arquivo WHERE pldord_profile = ''.           "#EC CI_STDSEQ

*    lr_range = VALUE #( FOR ls_arquivo_aux IN lt_arquivo ( sign = 'I' option = 'EQ' low = ls_arquivo_aux-unit ) ).
*
*    CALL FUNCTION 'CONVERSION_EXIT_CUNIT_RANGE_I'
*      EXPORTING
*        input          = sy-repid
*        language       = sy-langu
*      TABLES
*        range_int      = lr_range_aux
*        range_ext      = lr_range
*      EXCEPTIONS
*        unit_not_found = 1
*        OTHERS         = 2.
*    IF sy-subrc <> 0.
*      RETURN.
*    ENDIF.

*    LOOP AT lt_arquivo ASSIGNING FIELD-SYMBOL(<fs_arquivo_aux>).
*      READ TABLE lr_range_aux ASSIGNING FIELD-SYMBOL(<fs_range>) INDEX sy-tabix.
*      IF sy-subrc = 0.
*        <fs_arquivo_aux>-unit = <fs_range>-low.
*      ENDIF.
*    ENDLOOP.

  ENDMETHOD.


  METHOD preenche_tabela_componentes.
    DATA: lo_ref_descr TYPE REF TO cl_abap_structdescr.

    DATA: lt_detail TYPE abap_compdescr_tab.

    DATA: lv_qty  TYPE char13,
          lv_data TYPE char10,
          lv_guid TYPE char16.

    ASSIGN is_line TO FIELD-SYMBOL(<fs_line>).

    APPEND INITIAL LINE TO ct_tabela ASSIGNING FIELD-SYMBOL(<fs_return>).

    lo_ref_descr ?= cl_abap_typedescr=>describe_by_data( <fs_return> ).
    lt_detail[] = lo_ref_descr->components.

    LOOP AT lt_detail ASSIGNING FIELD-SYMBOL(<fs_detail>).

      ASSIGN COMPONENT <fs_detail>-name OF STRUCTURE <fs_return> TO FIELD-SYMBOL(<fs_ref>).
      ASSIGN COMPONENT sy-tabix         OF STRUCTURE <fs_line>   TO FIELD-SYMBOL(<fs_line_value>).

      IF <fs_ref> IS ASSIGNED AND <fs_line_value> IS ASSIGNED.
        CASE <fs_detail>-type_kind.
          WHEN 'D'.
            IF <fs_line_value> IS NOT INITIAL.
              lv_data = <fs_line_value>.
              TRANSLATE lv_data USING '/ . '.
              CONDENSE lv_data NO-GAPS.
              lv_data = |{ lv_data+4(4) }{ lv_data+2(2) }{ lv_data(2) }|.
              ASSIGN lv_data TO <fs_line_value>.
            ENDIF.

          WHEN 'P'.
            lv_qty = <fs_line_value>.
            TRANSLATE lv_qty USING '.,'.
            ASSIGN lv_qty TO <fs_line_value>.
          WHEN 'X'.
            lv_guid = <fs_line_value>.
            lv_guid = to_upper( lv_guid ).
            TRANSLATE lv_guid USING '- '.
            CONDENSE lv_guid NO-GAPS .
            ASSIGN lv_guid TO <fs_line_value>.
        ENDCASE.

        TRY .
            <fs_ref> = <fs_line_value>.
          CATCH cx_root.
        ENDTRY.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
