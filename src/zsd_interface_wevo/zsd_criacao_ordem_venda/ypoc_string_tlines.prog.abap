*&---------------------------------------------------------------------*
*& Report YPOC_STRING_TLINES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ypoc_string_tlines.


PARAMETERS: p_string TYPE string.

DATA: lt_lines TYPE TABLE OF tline.
*DATA lt_edit_table TYPE TABLE OF tline.
DATA: lv_texto(65000) TYPE c.

lv_texto =  p_string.


CALL FUNCTION 'C14W_STRING_TO_TLINE'
  EXPORTING
    i_string    = lv_texto
  TABLES
    e_tline_tab = lt_lines.


cl_Demo_output=>write( p_string ).
cl_Demo_output=>write( lt_lines ).
cl_Demo_output=>display( ).
