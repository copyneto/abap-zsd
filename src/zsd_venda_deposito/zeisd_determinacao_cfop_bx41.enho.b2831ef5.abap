"Name: \PR:SAPFV45P\FO:PREISFINDUNG\SE:END\EI
ENHANCEMENT 0 ZEISD_DETERMINACAO_CFOP_BX41.

CONSTANTS: BEGIN OF lc_param,
             modulo TYPE ztca_param_par-modulo VALUE 'SD',
             chave1 TYPE ztca_param_par-chave1 VALUE 'NF COMPLEMENTAR',
             chave2 TYPE ztca_param_par-chave2 VALUE 'AUART',
           END OF lc_param.

DATA lt_auart TYPE RANGE OF auart.


DATA(lo_param) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 24.07.2023
TRY.
    lo_param->m_get_range( EXPORTING iv_modulo = lc_param-modulo
                                     iv_chave1 = lc_param-chave1
                                     iv_chave2 = lc_param-chave2
                           IMPORTING et_range  = lt_auart ).
    IF vbak-auart NOT IN lt_auart.

      DATA(lo_determinacao_cfop) = NEW zclsd_determinacao_cfop( ).
      DATA(lv_cfop) = lo_determinacao_cfop->determinacao_cfop_bx40_bx41(
        iv_vbap_posnr  = vbap-posnr
        iv_xvbap_posnr = xvbap-posnr
        is_komk        = tkomk
        it_komv        = xkomv[]
      ).

      DATA:
         lv_j_1bcfop TYPE j_1bcfop.

      IF lv_cfop IS NOT INITIAL.

        IMPORT lv_j_1bcfop FROM MEMORY ID TEXT-035.
        IF NOT lv_j_1bcfop IS INITIAL.
          IF xvbap-j_1bcfop <> lv_j_1bcfop.
            *vbap-j_1bcfop = lv_j_1bcfop.
            CLEAR lv_j_1bcfop.
          ENDIF.
        ENDIF.
        IF lv_j_1bcfop IS INITIAL.
          IF xvbap-j_1bcfop <> *vbap-j_1bcfop.
            vbap-j_1bcfop = xvbap-j_1bcfop.
            lv_j_1bcfop = *vbap-j_1bcfop.
            EXPORT lv_j_1bcfop TO MEMORY ID TEXT-035.
          ELSE.

            vbap-j_1bcfop = lv_cfop.
            LOOP AT xvbap.                         "#EC CI_LOOP_INTO_HL
              CHECK xvbap-posnr = vbap-posnr.
              xvbap-j_1bcfop = lv_cfop.
              MODIFY xvbap.
            ENDLOOP.
          ENDIF.
        ENDIF.

*    vbap-j_1bcfop = lv_cfop.
*    LOOP AT xvbap.                                 "#EC CI_LOOP_INTO_HL
*      CHECK xvbap-posnr = vbap-posnr.
*      xvbap-j_1bcfop = lv_cfop.
*      MODIFY xvbap.
*    ENDLOOP.
      ENDIF.
      CLEAR lv_cfop.

    ENDIF.
  CATCH zcxca_tabela_parametros.
ENDTRY.

ENDENHANCEMENT.
