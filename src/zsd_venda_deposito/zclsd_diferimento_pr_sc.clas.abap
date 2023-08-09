"! <p class="shorttext synchronized" lang="pt">Diferimento PR e SC</p>
CLASS zclsd_diferimento_pr_sc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! Executa Regra diferimento PR e SC
    "! @parameter iv_wkreg   | Região do Centro
    "! @parameter iv_regio   | Região do Cliente
    "! @parameter rv_retorno | Retorno da regra de diferimento
    METHODS executa_regra_diferimento
      IMPORTING
        !iv_wkreg         TYPE wkreg
        !iv_regio         TYPE regio
        !it_komv          TYPE komv_t OPTIONAL
        !it_xkomv         TYPE tax_xkomv_tab
        !iv_kposn         TYPE komp-kposn
        !iv_kozgf         TYPE t682i-kozgf
      RETURNING
        VALUE(rv_retorno) TYPE sy-subrc .
    "! Atualiza Valor de Provisão de ICMS nos itens da Nota Fiscal
    "! @parameter it_itens_nf        | Itens da Nota Fiscal
    "! @parameter ct_itens_adicional | Itens da Nota Fiscal adicional
    METHODS atualiza_valor_provisao_icms
      IMPORTING
        !it_itens_nf        TYPE j_1bnflin_tab
        !it_vbrp            TYPE vbrp_tab
      CHANGING
        !ct_itens_adicional TYPE j_1bnf_badi_item_tab .
  PRIVATE SECTION.

    CONSTANTS:
      gc_modulo      TYPE ze_param_modulo VALUE 'SD',
      gc_chave1      TYPE ze_param_chave VALUE 'REGIAO DIFERIMENTO',
      gc_chave1_dif  TYPE ze_param_chave VALUE 'DIFERIMENTO',
      gc_chave2_st   TYPE ze_param_chave VALUE 'ST',
      gc_chave2_icms TYPE ze_param_chave VALUE 'ICMS',
      gc_kschl       TYPE konp-kschl VALUE 'ZDIF'.

ENDCLASS.



CLASS ZCLSD_DIFERIMENTO_PR_SC IMPLEMENTATION.


  METHOD executa_regra_diferimento.
    DATA lr_regio TYPE RANGE OF regio.
    DATA lr_kozgf TYPE RANGE OF t682i-kozgf.

    DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).    " INSERT - JWSILVA - 22.07.2023

    TRY.
        lo_param->m_get_range(                                    " CHANGE - JWSILVA - 22.07.2023
          EXPORTING
            iv_modulo = gc_modulo
            iv_chave1 = gc_chave1
          IMPORTING
            et_range  = lr_regio
        ).

        IF NOT iv_wkreg IN lr_regio."Se não for região de diferimento
          rv_retorno = 0.
          DATA(lv_regio) = abap_true.
        ELSE."Se for região de diferimento
          IF iv_wkreg NE iv_regio. "Se a região do centro não for igual a região do cliente
            rv_retorno = 0.
            lv_regio = abap_true.
          ENDIF.
        ENDIF.

      CATCH zcxca_tabela_parametros.
        lv_regio = abap_false.
    ENDTRY.

    IF lv_regio = abap_false.

      TRY.
          lo_param->m_get_range(                                  " CHANGE - JWSILVA - 22.07.2023
            EXPORTING
              iv_modulo = gc_modulo
              iv_chave1 = gc_chave1_dif
              iv_chave2 = gc_chave2_st
            IMPORTING
              et_range  = lr_kozgf
          ).
          IF iv_kozgf IN lr_kozgf.
            DATA(lv_regra_st) = abap_true.
          ENDIF.
        CATCH zcxca_tabela_parametros.
          lv_regra_st = abap_false.
      ENDTRY.

      IF lv_regra_st = abap_false.
        TRY.
            CLEAR lr_kozgf.
            lo_param->m_get_range(                                " CHANGE - JWSILVA - 22.07.2023
              EXPORTING
                iv_modulo = gc_modulo
                iv_chave1 = gc_chave1_dif
                iv_chave2 = gc_chave2_icms
              IMPORTING
                et_range  = lr_kozgf
            ).
            IF iv_kozgf IN lr_kozgf.
              rv_retorno = COND #(
                WHEN line_exists( it_komv[ kposn = iv_kposn kschl = gc_kschl ] )
                  OR line_exists( it_xkomv[ kposn = iv_kposn kschl = gc_kschl ] )
                THEN 0
                ELSE 4
              ).
            ENDIF.
            RETURN.
          CATCH zcxca_tabela_parametros.
            RETURN.
        ENDTRY.
      ENDIF.

      IF lv_regra_st = abap_true.
        TRY.
            lo_param->m_get_range(                                " CHANGE - JWSILVA - 22.07.2023
              EXPORTING
                iv_modulo = gc_modulo
                iv_chave1 = gc_chave1
              IMPORTING
                et_range  = lr_regio
            ).

            IF iv_wkreg = iv_regio.
              IF iv_wkreg IN lr_regio.
                rv_retorno = 4.
              ELSE.
                rv_retorno = 0.
              ENDIF.
            ELSE.
              rv_retorno = 0.
            ENDIF.
          CATCH zcxca_tabela_parametros.
            rv_retorno = 0.
        ENDTRY.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD atualiza_valor_provisao_icms.

*    DATA: lv_novokzwi6 TYPE prcd_elements-kbetr,
*          lv_kzwi6_aux TYPE prcd_elements-kbetr,
*          lv_vicmsdif  TYPE j_1bnfstx-taxval.

    DATA: lv_novokzwi6 TYPE f,
          lv_kzwi6_aux TYPE f,
          lv_vicmsdif  TYPE f,
          lv_vicms     TYPE f,
          lv_rate      TYPE i,
          lv_vicmsop   TYPE f.



    TYPES: ty_wnfstx TYPE TABLE OF j_1bnfstx.
    FIELD-SYMBOLS: <fs_wnfstx_tab> TYPE ty_wnfstx.

    ASSIGN ('(SAPLJ1BG)wnfstx[] ') TO <fs_wnfstx_tab>.

    LOOP AT it_itens_nf INTO DATA(ls_item_nf)
      WHERE reftyp = 'BI'.
      READ TABLE it_vbrp ASSIGNING FIELD-SYMBOL(<fs_vbrp>) WITH KEY posnr = ls_item_nf-refitm.
      IF sy-subrc = 0.
        READ TABLE ct_itens_adicional ASSIGNING FIELD-SYMBOL(<fs_item_adicional>)
        WITH KEY itmnum = ls_item_nf-itmnum.
        IF sy-subrc = 0.

          SELECT knumv FROM vbak INTO TABLE @DATA(lt_vbak) WHERE vbeln = @<fs_vbrp>-aubel.
          SELECT kbetr FROM prcd_elements INTO TABLE @DATA(lt_kbetr) FOR ALL ENTRIES IN  @lt_vbak WHERE  knumv = @lt_vbak-knumv
                                                                                            AND  kposn   = @<fs_vbrp>-aupos
                                                                                            AND kschl = 'ZDIF'.


          IF <fs_wnfstx_tab> IS ASSIGNED.
            READ TABLE lt_kbetr ASSIGNING FIELD-SYMBOL(<fs_kbetr>) INDEX 1.
            IF sy-subrc EQ 0.
              READ TABLE <fs_wnfstx_tab> ASSIGNING FIELD-SYMBOL(<fs_wnfstx>) WITH KEY itmnum = ls_item_nf-itmnum
                                                                                      taxtyp = 'ICM3'.

              IF sy-subrc EQ 0.
                lv_kzwi6_aux  = <fs_kbetr>-kbetr.
                lv_novokzwi6 = 1 - ( lv_kzwi6_aux / 100 ).
                lv_vicmsdif   = ( <fs_wnfstx>-taxval / lv_novokzwi6  ) * lv_kzwi6_aux.

                lv_vicmsdif = lv_vicmsdif / 100.

                <fs_item_adicional>-vicmsdif = lv_vicmsdif.

                IF  ls_item_nf-taxsit EQ 'B'.
                  DATA(lv_rate_i) = <fs_wnfstx>-rate.
*                  <fs_wnfstx>-rate = ( ( <fs_item_adicional>-vicmsdif + <fs_wnfstx>-taxval ) / <fs_wnfstx>-base ) * 100.
                  IF NOT <fs_wnfstx>-base IS INITIAL.
                    lv_rate = ( ( lv_vicmsdif + <fs_wnfstx>-taxval ) / <fs_wnfstx>-base ) * 100.
                    <fs_wnfstx>-rate = lv_rate.

                    lv_vicmsop = <fs_wnfstx>-rate * <fs_wnfstx>-base / 100.
                    lv_vicms = <fs_wnfstx>-base * lv_rate_i / 100.
                    lv_vicmsdif = lv_vicmsop - lv_vicms.
                    <fs_item_adicional>-vicmsdif = lv_vicmsdif.
                    <fs_item_adicional>-pdif = <fs_kbetr>-kbetr.
                  ENDIF.
                ENDIF.

              ENDIF.
            ENDIF.
          ENDIF.

        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
