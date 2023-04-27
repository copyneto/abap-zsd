*&---------------------------------------------------------------------*
*& Include          ZSDI_FILL_TEXT_LEI_TRANSP
*&---------------------------------------------------------------------*
  CONSTANTS: lc_direct  TYPE char1 VALUE '2',
             lc_taxtyp1 TYPE char4 VALUE 'ICEP',
             lc_taxtyp2 TYPE char4 VALUE 'ICAP',
             lc_taxtyp3 TYPE char4 VALUE 'IPI3',
             lc_taxtyp4 TYPE char4 VALUE 'ICON',
             lc_taxtyp5 TYPE char4 VALUE 'IPSN',
             lc_taxtyp6 TYPE char4 VALUE 'ISSA',
             lc_taxtyp7 TYPE char4 VALUE 'ICM3',
             lc_taxtyp8 TYPE char4 VALUE 'ICS3'.
* Saída Nacional
  DATA:
    lv_feder   TYPE j_1bnfstx-taxval,
    lv_feder_c TYPE char12,
    lv_estad   TYPE j_1bnfstx-taxval,
    lv_estad_c TYPE char12,
    lv_munic   TYPE j_1bnfstx-taxval,
    lv_munic_c TYPE char12,
    lv_icep    TYPE j_1bnfstx-taxval,
    lv_icep_c  TYPE char12,
    lv_icap    TYPE j_1bnfstx-taxval,
    lv_icap_c  TYPE char12.

  DATA: lr_tcode   TYPE RANGE OF sy-tcode.

  CHECK is_header-direct = lc_direct.

  LOOP AT it_nfstx ASSIGNING FIELD-SYMBOL(<fs_nfstx>).

    CASE <fs_nfstx>-taxtyp.
      WHEN lc_taxtyp1.
        lv_icep = lv_icep + <fs_nfstx>-taxval.
      WHEN lc_taxtyp2.
        lv_icap = lv_icap + <fs_nfstx>-taxval.
      WHEN lc_taxtyp3 OR
           lc_taxtyp4 OR
           lc_taxtyp5.
        lv_feder = lv_feder + <fs_nfstx>-taxval.
      WHEN lc_taxtyp6.
        lv_munic = lv_munic + <fs_nfstx>-taxval.
      WHEN lc_taxtyp7 OR
           lc_taxtyp8.
        lv_estad = lv_estad + <fs_nfstx>-taxval.
    ENDCASE.

  ENDLOOP.

  WRITE lv_icep TO lv_icep_c CURRENCY gc_currency.
  SHIFT lv_icep_c LEFT DELETING LEADING space.
  WRITE lv_icap TO lv_icap_c CURRENCY gc_currency.
  SHIFT lv_icap_c LEFT DELETING LEADING space.
  WRITE lv_feder TO lv_feder_c CURRENCY gc_currency.
  SHIFT lv_feder_c LEFT DELETING LEADING space.
  WRITE lv_estad TO lv_estad_c CURRENCY gc_currency.
  SHIFT lv_estad_c LEFT DELETING LEADING space.
  WRITE lv_munic TO lv_munic_c CURRENCY gc_currency.
  SHIFT lv_munic_c LEFT DELETING LEADING space.

  DESCRIBE TABLE ct_add_info LINES DATA(lv_lines).

  DATA(lv_text1) = VALUE char120( ).

  lv_text1 = TEXT-f06.

  CONCATENATE TEXT-f07
              lv_feder_c
              TEXT-f08
              lv_estad_c
              TEXT-f09
  INTO DATA(lv_text2) SEPARATED BY space.

  CONCATENATE lv_munic_c
              TEXT-f10
  INTO DATA(lv_text3) SEPARATED BY space.

  DATA(lv_text4) = VALUE char120( ).

  lv_text4 = TEXT-f11.

  CONCATENATE TEXT-f07
              lv_icap_c
              TEXT-f12
  INTO DATA(lv_text5) SEPARATED BY space.

  CONCATENATE TEXT-f07
              lv_icep_c
              TEXT-f13
  INTO DATA(lv_text6) SEPARATED BY space.

  lv_lines = lv_lines + 1.

  APPEND VALUE j_1bnfadd_info(
  docnum     = is_header-docnum
  xcampo     = lv_lines
  xtexto     = lv_text1
  xtexto2    = lv_text2 )
  TO ct_add_info.

  lv_lines = lv_lines + 1.

  APPEND VALUE j_1bnfadd_info(
  docnum  = is_header-docnum
  xcampo  = lv_lines
  xtexto  = lv_text3
  xtexto2 = lv_text4 )
  TO ct_add_info.

  lv_lines = lv_lines + 1.

  APPEND VALUE j_1bnfadd_info(
  docnum  = is_header-docnum
  xcampo  = lv_lines
  xtexto  = lv_text5
  xtexto2 = lv_text6 )
  TO ct_add_info.

  SORT ct_add_info BY xtexto
                      xcampo.

  DELETE ADJACENT DUPLICATES FROM ct_add_info COMPARING xtexto.
