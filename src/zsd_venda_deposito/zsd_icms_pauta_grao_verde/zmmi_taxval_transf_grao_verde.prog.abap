*&---------------------------------------------------------------------*
*& Include ZMMI_TAXVAL_TRANSF_GRAO_VERDE
*&---------------------------------------------------------------------*
CONSTANTS:
  lc_tcode_vL       TYPE sy-tcode   VALUE 'VL',
  lc_dlv_type       TYPE likp-lfart VALUE 'ZNLC',
  lc_dlv_utilizacao TYPE lips-abrvw VALUE '2',
  lc_mat_spart      TYPE mara-spart VALUE '05',
  lc_tax_ipi        type j_1btaxtyp value 'IPI3',
  lc_tax_icms       type j_1btaxtyp value 'ICM3'.

IF wa_xmseg-tcode2_mkpf(2) = lc_tcode_vl.

  SELECT COUNT( * )
    FROM lips AS a
   INNER JOIN mara AS b ON a~matnr = b~matnr
   INNER JOIN likp AS c ON a~vbeln = c~vbeln
   WHERE a~abrvw = lc_dlv_utilizacao
     AND a~vbeln = wa_xmseg-vbeln_im
     AND a~posnr = wa_xmseg-vbelp_im
     AND c~lfart = lc_dlv_type
     AND b~spart = lc_mat_spart.

  IF sy-subrc IS INITIAL.
    IF line_exists( wa_nf_stx[ taxtyp = lc_tax_ipi itmnum = wa_nf_lin-itmnum ] ).
      ASSIGN wa_nf_stx[ taxtyp = lc_tax_ipi itmnum = wa_nf_lin-itmnum ] TO FIELD-SYMBOL(<fs_tax>).
      IF <fs_tax>-excbas IS NOT INITIAL.
        <fs_tax>-excbas = wa_nf_lin-netwr + value j_1btaxval( wa_nf_stx[ taxtyp = lc_tax_icms itmnum = wa_nf_lin-itmnum ]-taxval OPTIONAL ).
      ENDIF.
    ENDIF.
  ENDIF.

ENDIF.
