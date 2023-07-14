*&---------------------------------------------------------------------*
*& Include          ZSDI_MENSAGEM_CAFE_INFCPL
*&---------------------------------------------------------------------*
FIND 'Para identificacao das unidades produtoras de cafes torrados em graos' IN es_header-infcpl.
"Valida se já algum texto referente ao café inserido na string, caso não existe faz a busca e insere
IF sy-subrc = 4.
  DATA(lt_tline) = zclsd_msg_xml_danfe=>get_unidade_produtora_cafe( ).
  LOOP AT lt_tline INTO DATA(ls_tline).
    IF es_header-infcpl IS INITIAL.
      es_header-infcpl = ls_tline-tdline.
    ELSE.
      es_header-infcpl = |{ es_header-infcpl }  { ls_tline-tdline }|.
    ENDIF.
  ENDLOOP.
ENDIF.
