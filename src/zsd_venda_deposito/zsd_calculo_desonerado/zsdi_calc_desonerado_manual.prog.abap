*&---------------------------------------------------------------------*
*& Include          ZSDI_CALC_DESONERADO_MANUAL
*&---------------------------------------------------------------------*
    NEW zclsd_calc_desonerado( )->execute( EXPORTING is_header = is_header
                               it_nflin = it_nflin
                               it_nfstx = it_nfstx
                     CHANGING  ct_item = et_item ).
