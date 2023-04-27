*&---------------------------------------------------------------------*
*& Include ZSDI_CALC_DESONERADO
*&---------------------------------------------------------------------*

    NEW zclsd_calc_desonerado( )->execute( EXPORTING is_header = is_header
                               it_nflin = it_nflin
                               it_nfstx = it_nfstx
                               it_vbrp = it_vbrp
                               it_mseg = it_mseg
                     CHANGING  ct_item = et_item ).
