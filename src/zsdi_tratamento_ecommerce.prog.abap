***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Tratamento Ecommerce                                   *
*** AUTOR    : Luís Gustavo Schepp - META                             *
*** FUNCIONAL: Sandro Seixas Chanchinski – META                       *
*** DATA     : 07/12/22                                               *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
*&--------------------------------------------------------------------*
*& Include ZSDI_TRATAMENTO_ECOMMERCE
*&--------------------------------------------------------------------*
CONSTANTS: lc_canal TYPE char2 VALUE 'CD',
           lc_setor TYPE char2 VALUE 'SA',
           lc_posnr TYPE accit-posnr VALUE '1'.

DATA lt_lines TYPE idmx_di_t_tline.

DATA lv_name TYPE THEAD-TDNAME.


ASSIGN xaccit[ posnr = lc_posnr ] TO FIELD-SYMBOL(<fs_bkpf>). "#EC CI_STDSEQ

IF <fs_bkpf> IS ASSIGNED.

  <fs_bkpf>-xref2_hd = |{ lc_canal }{ cvbrk-vtweg }/{ lc_setor }{ cvbrk-spart }|.

  IF cvbrk-fkart = 'Z003' OR cvbrk-fkart = 'ZR03' OR cvbrk-fkart = 'ZRP3' OR cvbrk-fkart = 'Z012'.
    <fs_bkpf>-xref1_hd = cvbrk-bstnk_vf.

    lv_name = cvbrp-aubel.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = 'Z009'
        language                = 'P'
        name                    = lv_name
        object                  = 'VBBK'
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
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO DATA(lv_message).
    ELSE.
      LOOP AT lt_lines ASSIGNING FIELD-SYMBOL(<fs_lines>).
        IF <fs_lines>-tdline(7) EQ 'VOUCHER'.
          SPLIT <fs_lines>-tdline AT '|' INTO DATA(lv_value) DATA(lv_voucher) DATA(lv_value1).
          EXIT.
        ENDIF.
      ENDLOOP.
      IF NOT lv_voucher IS INITIAL.
        REPLACE ALL OCCURRENCES OF '-' IN lv_voucher WITH space.
        CONDENSE lv_voucher NO-GAPS.
        READ TABLE xaccit ASSIGNING FIELD-SYMBOL(<fs_xaccit1>) WITH KEY hkont = '2112000007'.
        IF sy-subrc EQ 0.
          <fs_xaccit1>-zuonr = lv_voucher.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDIF.

ENDIF.
