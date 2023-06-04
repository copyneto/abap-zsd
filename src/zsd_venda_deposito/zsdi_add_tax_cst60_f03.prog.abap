************************************************************************
****                      © 3corações                                ***
************************************************************************
****                                                                   *
**** DESCRIÇÃO: REEMBOLSO-mapeamento tag infadprod do XML              *
**** AUTOR    : FLÁVIA LEITE –[META]                                   *
**** FUNCIONAL: JANA TOLEDO –[META]                                    *
**** DATA     : 08.03.2022                                             *
************************************************************************
**** HISTÓRICO DAS MODIFICAÇÕES                                        *
****-------------------------------------------------------------------*
**** DATA      | AUTOR        | DESCRIÇÃO                              *
****-------------------------------------------------------------------*
****           |              |                                        *
************************************************************************

  TYPES: ty_t_wnfref TYPE TABLE OF j_1bnfref.

  CONSTANTS: lc_sd         TYPE ztca_param_par-modulo VALUE 'SD',
             lc_chave1     TYPE ztca_param_par-chave1 VALUE 'REEMBOLSO NFE',
             lc_regra1     TYPE ztca_param_par-chave2 VALUE 'REGRA 1',
             lc_regra2     TYPE ztca_param_par-chave2 VALUE 'REGRA 2',
             lc_regra3     TYPE ztca_param_par-chave2 VALUE 'REGRA 3',
             lc_cont_icms  TYPE ztca_param_par-chave2 VALUE 'CONTRIBUINTE DE ICMS',
             lc_infadfisco TYPE ztca_param_par-chave2 VALUE 'INFADFISCO'.


  DATA: lr_regra1    TYPE RANGE OF j_1bnfdoc-vstel,
        lr_regra2    TYPE RANGE OF j_1bnfdoc-vstel,
        lr_regra3    TYPE RANGE OF j_1bnfdoc-vstel,
        lr_sp        TYPE RANGE OF j_1bnfdoc-vstel,
        lr_cont_icms TYPE RANGE OF kna1-icmstaxpay.

  DATA: lv_icmsst       TYPE j_1bnflin-vicmsstret,
* LSCHEPP - SD - 8000007767 - RM1008 - tag infAdFisco - 01.06.2023 Início
        lv_icmsst_txt   TYPE char30,
* LSCHEPP - SD - 8000007767 - RM1008 - tag infAdFisco - 01.06.2023 Fim
        lv_stfcp        TYPE j_1bnflin-vfcpstret,
        lv_porcentagem1 TYPE j_1bnfe_pfcpstret,
        lv_porcentagem2 TYPE j_1bnfe_pfcpstret,
        lv_icms         TYPE j_1bnfe_vicmssubstituto,
        lv_infadfisco   TYPE j_1bnf_badi_header-infadfisco.

  FIELD-SYMBOLS: <fs_wnfref_tab> TYPE ty_t_wnfref.

  ASSIGN ('(SAPLJ1BG)wnfref[]') TO <fs_wnfref_tab>.

  DATA(lo_parametros) = NEW zclca_tabela_parametros( ).

  TRY.
      lo_parametros->m_get_range(
        EXPORTING
          iv_modulo = lc_sd
          iv_chave1 = lc_chave1
          iv_chave2 = lc_regra1
        IMPORTING
          et_range  = lr_regra1 ).
    CATCH zcxca_tabela_parametros.

  ENDTRY.

  TRY.
      lo_parametros->m_get_range(
        EXPORTING
          iv_modulo = lc_sd
          iv_chave1 = lc_chave1
          iv_chave2 = lc_regra2
        IMPORTING
          et_range  = lr_regra2 ).
    CATCH zcxca_tabela_parametros.

  ENDTRY.

  TRY.
      lo_parametros->m_get_range(
        EXPORTING
          iv_modulo = lc_sd
          iv_chave1 = lc_chave1
          iv_chave2 = lc_regra3
        IMPORTING
          et_range  = lr_regra3 ).
    CATCH zcxca_tabela_parametros.

  ENDTRY.

  TRY.
      lo_parametros->m_get_range(
        EXPORTING
          iv_modulo = lc_sd
          iv_chave1 = lc_cont_icms
        IMPORTING
          et_range  = lr_cont_icms ).
    CATCH zcxca_tabela_parametros.

  ENDTRY.

  TRY.
      lo_parametros->m_get_range(
        EXPORTING
          iv_modulo = lc_sd
          iv_chave1 = lc_chave1
          iv_chave2 = lc_infadfisco
        IMPORTING
          et_range  = lr_sp ).
    CATCH zcxca_tabela_parametros.

  ENDTRY.

  SELECT SINGLE icmstaxpay
     FROM kna1
     INTO @DATA(lv_cont_icms)
     WHERE kunnr EQ @is_header-parid.

  IF lv_cont_icms IN lr_cont_icms.
    READ TABLE lt_itens_adicional ASSIGNING FIELD-SYMBOL(<fs_item>) WITH KEY itmnum = <fs_nflin>-itmnum BINARY SEARCH.
    IF sy-subrc = 0.

      SELECT SINGLE regio
         FROM t001w
         INTO @DATA(lv_regio)
         WHERE werks EQ @<fs_nflin>-werks.

      IF lv_regio IN lr_regra1.

        lv_porcentagem1 = ( <fs_item>-pst - <fs_item>-pfcpstret ) / 100.
        lv_porcentagem2 = ( <fs_item>-picmsefet - <fs_item>-pfcpstret  ) / 100.
        lv_icmsst = ( <fs_item>-vbcstret * lv_porcentagem1 ) - ( <fs_item>-vbcefet * lv_porcentagem2 ).

        lv_stfcp  = ( <fs_item>-vbcstret * <fs_item>-pfcpstret ) - ( <fs_item>-vbcefet * <fs_item>-pfcpstret ).
        lv_stfcp  = lv_stfcp / 100.

        IF  <fs_item>-vbcstret IS NOT INITIAL.
          lv_texto  = |{ TEXT-f21 }: { <fs_item>-vbcstret }|.
        ENDIF.
        IF lv_icmsst IS NOT INITIAL.
          IF lv_icmsst LT 0.
            lv_icmsst = 0.
          ENDIF.

          lv_texto  = |{ lv_texto } { TEXT-f22 }: { lv_icmsst }|.

          IF lv_regio IN lr_sp.
* LSCHEPP - SD - 8000007767 - RM1008 - tag infAdFisco - 01.06.2023 Início
            WRITE lv_icmsst TO lv_icmsst_txt CURRENCY is_header-waerk.
            CONDENSE lv_icmsst_txt NO-GAPS.
* LSCHEPP - SD - 8000007767 - RM1008 - tag infAdFisco - 01.06.2023 Fim
            IF lv_infadfisco IS INITIAL.
              DATA(lv_material) = |{ <fs_nflin>-matnr ALPHA = OUT  }|.
              CONDENSE lv_material NO-GAPS.
* LSCHEPP - SD - 8000007767 - RM1008 - tag infAdFisco - 01.06.2023 Início
*              lv_infadfisco = |{ '&|' }{ lv_material } { '|' }{ lv_icmsst }{ '|' }|.
              lv_infadfisco = |{ '&|' }{ lv_material } { '|' }{ lv_icmsst_txt }{ '|' }|.
* LSCHEPP - SD - 8000007767 - RM1008 - tag infAdFisco - 01.06.2023 Fim
            ELSE.
              lv_material = |{ '&|' }{ <fs_nflin>-matnr ALPHA = OUT  }|.
              CONDENSE lv_material NO-GAPS.
* LSCHEPP - SD - 8000007767 - RM1008 - tag infAdFisco - 01.06.2023 Início
*              lv_infadfisco = |{ lv_infadfisco }{ lv_material }{ '|' } { lv_icmsst }{ '|' }|.
              lv_infadfisco = |{ lv_infadfisco }{ lv_material }{ '|' } { lv_icmsst_txt }{ '|' }|.
* LSCHEPP - SD - 8000007767 - RM1008 - tag infAdFisco - 01.06.2023 Fim
            ENDIF.
          ENDIF.

        ENDIF.
        IF <fs_item>-vbcfcpstret IS NOT INITIAL.
          lv_texto  = |{ lv_texto } { TEXT-f23 }: { <fs_item>-vbcfcpstret }|.
        ENDIF.
        IF lv_stfcp IS NOT INITIAL.
          IF lv_stfcp LT 0.
            lv_stfcp = 0.
          ENDIF.
          lv_texto  = |{ lv_texto } { TEXT-f24 }: { lv_stfcp }|.
        ENDIF.

      ELSEIF lv_regio IN lr_regra2.

        lv_icmsst = <fs_item>-vicmsstret.
        lv_stfcp  = <fs_item>-vfcpstret.

        IF  <fs_item>-vbcstret IS NOT INITIAL.
          lv_texto  = |{ TEXT-f21 }: { <fs_item>-vbcstret }|.
        ENDIF.
        IF lv_icmsst IS NOT INITIAL.
          IF lv_icmsst LT 0.
            lv_icmsst = 0.
          ENDIF.
          lv_texto  = |{ lv_texto } { TEXT-f22 }: { lv_icmsst }|.
        ENDIF.
        IF <fs_item>-vbcfcpstret IS NOT INITIAL.
          lv_texto  = |{ lv_texto } { TEXT-f23 }: { <fs_item>-vbcfcpstret }|.
        ENDIF.
        IF lv_stfcp IS NOT INITIAL.
          IF lv_stfcp LT 0.
            lv_stfcp = 0.
          ENDIF.
          lv_texto  = |{ lv_texto } { TEXT-f24 }: { lv_stfcp }|.
        ENDIF.

      ELSEIF lv_regio IN lr_regra3.

        lv_porcentagem1 = ( <fs_item>-pst - <fs_item>-pfcpstret ) / 100.
        lv_porcentagem2 = ( <fs_item>-picmsefet - <fs_item>-pfcpstret  ) / 100.
        lv_icmsst = ( <fs_item>-vbcstret * lv_porcentagem1 ) - ( <fs_item>-vbcefet * lv_porcentagem2 ).

        lv_stfcp  = ( <fs_item>-vbcstret * <fs_item>-pfcpstret ) - ( <fs_item>-vbcefet * <fs_item>-pfcpstret ).
        lv_stfcp  = lv_stfcp / 100.

        IF <fs_item>-vicmssubstituto IS NOT INITIAL.
*          lv_icms   = <fs_item>-vicmssubstituto + <fs_item>-vicmsstret + <fs_item>-vfcpstret.
          lv_icms   = <fs_item>-vicmssubstituto + <fs_item>-vicmsstret.

          lv_texto  = |{ TEXT-f25 }: { lv_icms }|.
        ENDIF.

        IF  <fs_item>-vbcstret IS NOT INITIAL.
          lv_texto  = |{ lv_texto } { TEXT-f21 }: { <fs_item>-vbcstret }|.
        ENDIF.
        IF lv_icmsst IS NOT INITIAL.
          IF lv_icmsst LT 0.
            lv_icmsst = 0.
          ENDIF.
          lv_texto  = |{ lv_texto } { TEXT-f22 }: { lv_icmsst }|.
        ENDIF.

        IF <fs_item>-vbcfcpstret IS NOT INITIAL.
          lv_texto  = |{ lv_texto } { TEXT-f23 }: { <fs_item>-vbcfcpstret }|.
        ENDIF.
        IF lv_stfcp IS NOT INITIAL.
          IF lv_stfcp LT 0.
            lv_stfcp = 0.
          ENDIF.
          lv_texto  = |{ lv_texto } { TEXT-f24 }: { lv_stfcp }|.
        ENDIF.

      ENDIF.

    ENDIF.
  ENDIF.

  IF <fs_wnfref_tab> IS ASSIGNED.
    DATA(lt_texto_ref) = <fs_wnfref_tab>.
    SORT lt_texto_ref[] BY itmnum .
  ENDIF.

  IF <fs_nfetx_tab> IS ASSIGNED.
    DATA(lt_texto) = <fs_nfetx_tab>.
    SORT lt_texto[] BY  seqnum .
  ENDIF.

  READ TABLE lt_texto_ref TRANSPORTING NO FIELDS WITH KEY itmnum = <fs_nflin>-itmnum BINARY SEARCH.

  IF sy-subrc = 0.
    LOOP AT lt_texto_ref ASSIGNING FIELD-SYMBOL(<fs_texto_ref>) FROM sy-tabix.
      IF  <fs_texto_ref>-itmnum = <fs_nflin>-itmnum.

        READ TABLE lt_texto TRANSPORTING NO FIELDS WITH KEY seqnum = <fs_texto_ref>-seqnum BINARY SEARCH.
        LOOP AT lt_texto ASSIGNING FIELD-SYMBOL(<fs_texto>) FROM sy-tabix.
          IF  <fs_texto>-seqnum = <fs_texto_ref>-seqnum.

            READ TABLE ct_itens_adicional ASSIGNING FIELD-SYMBOL(<fs_item_add>) WITH KEY itmnum = <fs_nflin>-itmnum BINARY SEARCH.
*            READ TABLE lt_ITENS_ADICIONAL ASSIGNING FIELD-SYMBOL(<fs_item_add>) WITH KEY itmnum = <fs_nflin>-itmnum BINARY SEARCH.
            IF sy-subrc = 0.
              <fs_item_add>-infadprod = |{ <fs_item_add>-infadprod } { <fs_texto>-message }|.
            ENDIF.

          ELSE.
            EXIT.
          ENDIF.
        ENDLOOP.

      ELSE.
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF lv_texto IS NOT INITIAL.
    REPLACE ALL OCCURRENCES OF '.' IN lv_texto WITH ','.

    READ TABLE ct_itens_adicional ASSIGNING <fs_item_add> WITH KEY itmnum = <fs_nflin>-itmnum BINARY SEARCH.
*    READ TABLE lt_ITENS_ADICIONAL ASSIGNING <fs_item_add> WITH KEY itmnum = <fs_nflin>-itmnum BINARY SEARCH.
    IF sy-subrc = 0.
      <fs_item_add>-infadprod = |{ <fs_item_add>-infadprod } { lv_texto }|.
      CLEAR: lv_texto.
    ENDIF.

  ENDIF.
