*&---------------------------------------------------------------------*
*& Include          ZSDI_FILL_IMPORT
*&---------------------------------------------------------------------*

DATA: lv_icms      TYPE j_1bnfstx-taxval,
      lv_icms_c    TYPE char12,
      lv_ipi       TYPE j_1bnfstx-taxval,
      lv_ipi_c     TYPE char12,
      lv_pis       TYPE j_1bnfstx-taxval,
      lv_pis_c     TYPE char12,
      lv_cof       TYPE j_1bnfstx-taxval,
      lv_cof_c     TYPE char12,
      lv_ii        TYPE j_1bnfstx-taxval,
      lv_ii_c      TYPE char12,
      lv_ddi_c     TYPE char12,
      lv_nftot     TYPE j_1bnfdoc-nftot,
      lv_nftot_c   TYPE char12,
      lt_mensagens TYPE TABLE OF tline,
      ls_msg       LIKE LINE OF lt_mensagens.

CONSTANTS: lc_icms    TYPE char4 VALUE 'ICMS',
           lc_ics3    TYPE char4 VALUE 'ICS3',
           lc_ipi     TYPE char3 VALUE 'IPI',
           lc_ipi3    TYPE char4 VALUE 'IPI3',
           lc_pis     TYPE char3 VALUE 'PIS',
           lc_cofins  TYPE char4 VALUE 'COFI',
           lc_cofins2 TYPE char6 VALUE 'COFINS',
           lc_ii      TYPE char2 VALUE 'II',
           lc_e       TYPE char1 VALUE 'E',
           lc_direct  TYPE char1 VALUE '1',
           lc_stattx  TYPE char1 VALUE 'X',
           lc_moeda   TYPE char2 VALUE 'R$'.

FIELD-SYMBOLS <fs_wnfdoc> TYPE j_1bnfdoc.

SELECT SINGLE land1 FROM lfa1 INTO @DATA(lv_land1)
WHERE lifnr EQ @is_header-parid.

* Tratativa para Importação
IF ( lv_land1 NE gc_land AND lv_land1 IS NOT INITIAL ) AND
     is_header-direct EQ lc_direct.

  LOOP AT it_nfstx ASSIGNING FIELD-SYMBOL(<fs_nfstx>).

    CASE <fs_nfstx>-taxgrp.
      WHEN lc_icms.
        lv_icms = lv_icms + <fs_nfstx>-taxval.
      WHEN lc_ipi.
        lv_ipi = lv_ipi + <fs_nfstx>-taxval.
      WHEN lc_pis.
        lv_pis = lv_pis + <fs_nfstx>-taxval.
      WHEN lc_cofins.
        lv_cof = lv_cof + <fs_nfstx>-taxval.
      WHEN lc_ii.
        lv_ii = lv_ii + <fs_nfstx>-taxval.
    ENDCASE.

    IF <fs_nfstx>-stattx = lc_stattx AND ( <fs_nfstx>-taxtyp = lc_ics3 OR <fs_nfstx>-taxtyp = lc_ipi3 ).
      lv_nftot = lv_nftot + <fs_nfstx>-taxval.
    ENDIF.

  ENDLOOP.

  WRITE lv_icms TO lv_icms_c CURRENCY gc_currency.
  SHIFT lv_icms_c LEFT DELETING LEADING space.
  WRITE lv_ipi TO lv_ipi_c CURRENCY gc_currency.
  SHIFT lv_ipi_c LEFT DELETING LEADING space.
  WRITE lv_pis TO lv_pis_c CURRENCY gc_currency.
  SHIFT lv_pis_c LEFT DELETING LEADING space.
  WRITE lv_cof TO lv_cof_c CURRENCY gc_currency.
  SHIFT lv_cof_c LEFT DELETING LEADING space.
  WRITE lv_ii TO lv_ii_c CURRENCY gc_currency.
  SHIFT lv_ii_c LEFT DELETING LEADING space.
*  WRITE lv_nftot TO lv_nftot_c CURRENCY gc_currency.
*  SHIFT lv_nftot_c LEFT DELETING LEADING space.

  REFRESH ct_add_info[].

  READ TABLE it_import_di ASSIGNING FIELD-SYMBOL(<fs_import_di>) INDEX 1.
  IF sy-subrc EQ 0.
    WRITE <fs_import_di>-ddi TO lv_ddi_c.

    CONCATENATE TEXT-f16
                 <fs_import_di>-ndi
                 lc_e
                 lv_ddi_c
                 gc_virgula
    INTO DATA(lv_text1) SEPARATED BY space.

    CONCATENATE lv_text1
                lc_ii gc_doispontos lc_moeda
                lv_ii_c
                gc_barra
     INTO lv_text1 SEPARATED BY space.

    CLEAR: ls_msg-tdline.
    ls_msg-tdline = lv_text1.
    CONDENSE ls_msg-tdline.
    APPEND ls_msg TO lt_mensagens.
  ENDIF.

  CLEAR lv_text1.

  CONCATENATE lc_ipi gc_doispontos lc_moeda
              lv_ipi_c
              gc_barra
   INTO lv_text1 SEPARATED BY space.

  CONCATENATE lv_text1
              lc_pis gc_doispontos lc_moeda
              lv_pis_c
              gc_barra
   INTO lv_text1 SEPARATED BY space.

  CLEAR: ls_msg-tdline.
  ls_msg-tdline = lv_text1.
  CONDENSE ls_msg-tdline.
  APPEND ls_msg TO lt_mensagens.

  CLEAR lv_text1.

  CONCATENATE  lc_cofins gc_doispontos lc_moeda
               lv_cof_c
               gc_barra
   INTO lv_text1 SEPARATED BY space.

  CONCATENATE lv_text1
              lc_icms gc_doispontos lc_moeda
              lv_icms_c
              gc_barra
   INTO lv_text1 SEPARATED BY space.

  CLEAR: ls_msg-tdline.
  ls_msg-tdline = lv_text1.
  CONDENSE ls_msg-tdline.
  APPEND ls_msg TO lt_mensagens.

  ASSIGN cs_header TO FIELD-SYMBOL(<fs_header>).
  LOOP AT lt_mensagens ASSIGNING FIELD-SYMBOL(<fs_msg>).
    CONCATENATE <fs_header>-infcpl <fs_msg>-tdline
    INTO <fs_header>-infcpl SEPARATED BY space.
  ENDLOOP.

  LOOP AT it_nfftx ASSIGNING FIELD-SYMBOL(<fs_nfttx>).
    IF <fs_nfttx>-manual = abap_true.
      CONCATENATE <fs_header>-infcpl <fs_nfttx>-message
      INTO <fs_header>-infcpl SEPARATED BY space.
    ENDIF.
  ENDLOOP.

ENDIF.
*INDINTERMED
cs_header-indintermed = '0'. "transação sem intermediário

"Valor Total NF - Consignação
IF lv_nftot IS NOT INITIAL.
  ASSIGN ('(SAPLJ1BG)WNFDOC') TO <fs_wnfdoc>.
  IF <fs_wnfdoc> IS ASSIGNED.
    <fs_wnfdoc>-nftot = is_header-nftot - lv_nftot.
  ENDIF.
ELSE.

  LOOP AT it_nfstx ASSIGNING <fs_nfstx>.
    IF <fs_nfstx>-stattx = lc_stattx AND ( <fs_nfstx>-taxtyp = lc_ics3 OR <fs_nfstx>-taxtyp = lc_ipi3 ).
      lv_nftot = lv_nftot + <fs_nfstx>-taxval.
    ENDIF.
  ENDLOOP.

  IF lv_nftot IS NOT INITIAL.
    ASSIGN ('(SAPLJ1BG)WNFDOC') TO <fs_wnfdoc>.
    IF <fs_wnfdoc> IS ASSIGNED.
      <fs_wnfdoc>-nftot = is_header-nftot - lv_nftot.
    ENDIF.
  ENDIF.

ENDIF.
