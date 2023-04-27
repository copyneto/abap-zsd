*&---------------------------------------------------------------------*
*& Include          ZSDI_TAG_ICMS60
*&---------------------------------------------------------------------*

  IF NOT is_nfe_det_imposto-icms_ref IS INITIAL.
    <choice>-selection = 'SEQUENCE'.
    READ TABLE <lt_nfe_imposto_icms> INTO ls_nfe_imposto_icms
       WITH KEY id =  is_nfe_det_imposto-icms_ref.
    IF sy-subrc = 0.
      IF ls_nfe_imposto_icms-cst = '60' AND
            ls_nfe_imposto_icms-v_bcstdest IS INITIAL.
        IF ls_nfe_imposto_icms-p_red_bcefet IS INITIAL AND ls_nfe_imposto_icms-v_bcefet IS INITIAL
           AND ls_nfe_imposto_icms-p_icmsefet IS INITIAL AND ls_nfe_imposto_icms-v_icmsefet IS INITIAL.
          <choice>-sequence-icms-choice-icms60-sequence2-p_red_bcefet = ls_nfe_imposto_icms-p_red_bcefet.
          <choice>-sequence-icms-choice-icms60-sequence2-v_bcefet   = ls_nfe_imposto_icms-v_bcefet.
          <choice>-sequence-icms-choice-icms60-sequence2-p_icmsefet   = ls_nfe_imposto_icms-p_icmsefet.
          <choice>-sequence-icms-choice-icms60-sequence2-v_icmsefet   = ls_nfe_imposto_icms-v_icmsefet.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
