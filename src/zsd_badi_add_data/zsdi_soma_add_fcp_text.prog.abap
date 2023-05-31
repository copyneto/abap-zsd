*&---------------------------------------------------------------------*
*& Include          ZSDI_ADD_FCP_TEXT
*&---------------------------------------------------------------------*
CONSTANTS: lc_icsc TYPE j_1btaxtyp VALUE 'ICSC',
           lc_icfp TYPE j_1btaxtyp VALUE 'ICFP',
           lc_fcpo TYPE j_1btaxtyp VALUE 'FCPO',
           lc_fpso TYPE j_1btaxtyp VALUE 'FPSO',
           lc_fcp3 TYPE j_1btaxtyp VALUE 'FCP3'.


CLEAR ls_fcp_values.

DATA(lt_tax) = it_nfstx.
SORT lt_tax BY itmnum taxtyp.
READ TABLE lt_tax ASSIGNING FIELD-SYMBOL(<fs_taxtyp>) WITH KEY itmnum = <fs_nflin1>-itmnum
                                                               taxtyp = lc_icsc BINARY SEARCH.
IF sy-subrc = 0.
  MOVE-CORRESPONDING <fs_taxtyp> TO ls_fcp_values.
  ls_fcp_values-matnr = <fs_nflin1>-matnr.
  COLLECT ls_fcp_values INTO lt_fcp_values.
ENDIF.

READ TABLE lt_tax ASSIGNING <fs_taxtyp> WITH KEY itmnum = <fs_nflin1>-itmnum
                                                 taxtyp = lc_icfp BINARY SEARCH.
IF sy-subrc = 0.
  MOVE-CORRESPONDING <fs_taxtyp> TO ls_fcp_values.
  ls_fcp_values-matnr = <fs_nflin1>-matnr.
  COLLECT ls_fcp_values INTO lt_fcp_values.
ENDIF.

READ TABLE lt_tax ASSIGNING <fs_taxtyp> WITH KEY itmnum = <fs_nflin1>-itmnum
                                                 taxtyp = lc_fcpo
                                                 BINARY SEARCH.
IF sy-subrc = 0.
  MOVE-CORRESPONDING <fs_taxtyp> TO ls_fcp_values.
  ls_fcp_values-matnr = <fs_nflin1>-matnr.
  COLLECT ls_fcp_values INTO lt_fcp_values.
ENDIF.

READ TABLE lt_tax ASSIGNING <fs_taxtyp> WITH KEY itmnum = <fs_nflin1>-itmnum
                                                 taxtyp = lc_fcp3
                                                 BINARY SEARCH.
IF sy-subrc = 0.
  MOVE-CORRESPONDING <fs_taxtyp> TO ls_fcp_values.
  ls_fcp_values-matnr = <fs_nflin1>-matnr.
  COLLECT ls_fcp_values INTO lt_fcp_values.
ENDIF.

READ TABLE lt_tax ASSIGNING <fs_taxtyp> WITH KEY itmnum = <fs_nflin1>-itmnum
                                                 taxtyp = lc_fpso
                                                 BINARY SEARCH.
IF sy-subrc = 0.
  MOVE-CORRESPONDING <fs_taxtyp> TO ls_fcp_values.
  ls_fcp_values-matnr = <fs_nflin1>-matnr.
  COLLECT ls_fcp_values INTO lt_fcp_values.
ENDIF.
