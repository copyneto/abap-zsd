***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Enhancement para validação de cancelamento NF-e        *
*** AUTOR    : LUÍS GUSTAVO SCHEPP –[META]                            *
*** FUNCIONAL: SANDRO SEIXAS CHANCHINSKI –[META]                      *
*** DATA     : 06.07.2022                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
CONSTANTS: lc_text1  TYPE char50 VALUE 'Documento',
           lc_text2  TYPE char50 VALUE 'não pode ser cancelado. Ordem de frete já inclusa:',
           lc_j1bnfe TYPE char50 VALUE 'J1BNFE'.

DATA lt_docflow TYPE tdt_docflow.


IF NOT it_cancel_alv IS INITIAL.
  SELECT COUNT( * )
    FROM ztsd_usuario_lib
    WHERE usuario = @sy-uname
      AND programa = @lc_j1bnfe.
  IF sy-subrc NE 0.
    SELECT b~docnum, a~vgbel
      FROM vbrp AS a
      INNER JOIN j_1bnflin AS b ON a~vbeln = b~refkey
      INTO TABLE @DATA(lt_dados)
      FOR ALL ENTRIES IN @it_cancel_alv
      WHERE docnum EQ @it_cancel_alv-docnum.
    IF sy-subrc EQ 0.
      LOOP AT lt_dados ASSIGNING FIELD-SYMBOL(<fs_dados>).
        CALL FUNCTION 'SD_DOCUMENT_FLOW_GET'
          EXPORTING
            iv_docnum  = <fs_dados>-vgbel
          IMPORTING
            et_docflow = lt_docflow.
        SORT lt_docflow BY vbtyp_n.
        READ TABLE lt_docflow ASSIGNING FIELD-SYMBOL(<fs_docflow>) WITH KEY vbtyp_n = 'TMFO' BINARY SEARCH.
        IF sy-subrc = 0.
          DATA(lv_ordem_frete) = <fs_docflow>-docnum.
          DATA(lv_message) = |{ lc_text1 } { <fs_dados>-docnum ALPHA = OUT } { lc_text2 } { lv_ordem_frete }|.
          MESSAGE lv_message TYPE 'E'.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDIF.
