*&---------------------------------------------------------------------*
*& Include          ZSDI_MENSAGEM_CAFE_INFCPL
*&---------------------------------------------------------------------*
  DATA(lt_tline) = zclsd_msg_xml_danfe=>get_unidade_produtora_cafe( ).
  LOOP AT lt_tline INTO DATA(ls_tline).
    IF es_header-infcpl IS INITIAL.
      es_header-infcpl = ls_tline-tdline.
    ELSE.
      es_header-infcpl = |{ es_header-infcpl }  { ls_tline-tdline }|.
    ENDIF.
  ENDLOOP.
