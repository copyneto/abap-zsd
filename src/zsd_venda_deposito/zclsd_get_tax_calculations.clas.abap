CLASS zclsd_get_tax_calculations DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      "! Types para dados calculados
      BEGIN OF ty_calculos,
        vbcstret        TYPE j_1bnfe_rfc_icmsstretbase,    "Montante base ST ICMS retido já debitado
        pst             TYPE j_1bnfe_pst,                  "Taxa de consumidor final
        vicmssubstituto TYPE j_1bnfe_vicmssubstituto,      "Substituir valor ICMS cobrado na transação anterior
        vicmsstret      TYPE j_1bnfe_rfc_icmsstrettaxval,  "Valor ST ICMS retido já debitado
        vbcfcpstret     TYPE j_1bnfe_vbcfcpstret,          "Base de cálculo FCP retida para substituição tributária
        pfcpstret       TYPE j_1bnfe_pfcpstret,            "Porcentagem de substituição tributária retida de FCP
        vfcpstret       TYPE j_1bnfe_vfcpstret,            "Montante de substituição tributária retido de FCP
        predbcefet      TYPE j_1bnfe_predbcefet,           "Porcentagem de redução de base de cálculo efetivo
        vbcefet         TYPE j_1bnfe_vbcefet,              "Montante base de cálculo efetivo
        picmsefet       TYPE j_1bnfe_picmsefet,            "Taxa ICMS efetiva
        vicmsefet       TYPE j_1bnfe_vicmsefet,            "Montante ICMS efetivo
      END OF ty_calculos .

    CLASS-METHODS get_instance
      RETURNING
        VALUE(ro_instance) TYPE REF TO zclsd_get_tax_calculations .
    "! Método executa chamadas principais
    "! @parameter iv_centro        | Centro
    "! @parameter iv_uf            | UF
    "! @parameter iv_material      | Material
    "! @parameter iv_gp_mercadoria | Grupo Mercadorias
    "! @parameter iv_contribuinte  | Contribuente
    "! @parameter iv_ult_compra    | Ultima Compra
    "! @parameter iv_valor_unit    | Valor Unitário
    "! @parameter iv_valor_prod    | Valor Produção
    "! @parameter iv_quantidade    | Quantidade
    "! @parameter iv_unidade       | Unidade de Medida
    "! @parameter es_calculos      | Resultado Calculos
    METHODS main
      IMPORTING
        !iv_bukrs         TYPE bukrs OPTIONAL
        !iv_centro        TYPE werks_ext
        !iv_uf            TYPE ze_uf_receb
        !iv_material      TYPE matnr
        !iv_gp_mercadoria TYPE matkl
        !iv_contribuinte  TYPE j_1bicmstaxpay
        !iv_ult_compra    TYPE verpr
        !iv_ult_ipi       TYPE verpr OPTIONAL
        !iv_valor_unit    TYPE j_1bnetpri
        !iv_valor_prod    TYPE j_1bnfnett
        !iv_quantidade    TYPE j_1bnetqty
        !iv_unidade       TYPE j_1bnetunt
        !iv_vbeln         TYPE vbeln_vl OPTIONAL
        !iv_kposn         TYPE kposn OPTIONAL
      EXPORTING
        !es_calculos      TYPE ty_calculos .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS:
      "! Constantes para tabela de parâmetros
      BEGIN OF gc_parametros,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ze_param_chave  VALUE 'CONTRIBUINTE DE ICMS',
      END OF gc_parametros .
    "! Estrutura com Calculos
    DATA gs_calculos TYPE ty_calculos .
    "! Atributo Centro
    DATA gs_centro TYPE werks_ext .
    CLASS-DATA go_instance TYPE REF TO zclsd_get_tax_calculations .
    "! Atributo UF
    DATA gs_uf TYPE ze_uf_receb .
    "! Atributo Material
    DATA gs_material TYPE matnr .
    "! Atributo Grupo Mercadorias
    DATA gs_gp_mercadoria TYPE matkl .
    "! Atributo Tabela selecionada
    DATA gs_tabela TYPE char20 .
    "! Atributo %Agregado
    DATA gs_agregado TYPE ze_agregado .
    "! Atributo ICMS Destino
    DATA gs_icms_dest TYPE ze_icms_dest .
    "! Atributo ICMS Origem
    DATA gs_icms_orig TYPE ze_icms_orig .
    "! Atributo Compra Interna
    DATA gs_compra_interna TYPE char1 .
    "! Atributo Base Origem
    DATA gs_base_red_orig TYPE ze_base_red_orig .
    "! Atributo Base Destino
    DATA gs_base_red_dest TYPE ze_base_red_dest .
    "! Atributo Taxa FCP
    DATA gs_taxa_fcp TYPE ze_taxa_fcp .
    "! Atributo ICMS Efetivo
    DATA gs_icms_efet TYPE ze_icms_efet .
    "! Atributo Base ICMS Efetivo
    DATA gs_baseredefet TYPE ze_baseredefet .
    "! Atributo Preço Comparação
    DATA gs_preco_compar TYPE ze_preco_compar .
    "! Atributo Preço Pauta
    DATA gs_preco_pauta TYPE ze_preco_pauta .
    "! Atributo Agregado Pauta
    DATA gs_agregado_pauta TYPE ze_agregado_pauta .
    "! Atributo  Número de unidades por UM informada
    DATA gs_nro_unids TYPE ze_nro_unids .
    "! Atributo Unidade Medida
    DATA gs_um TYPE ze_um .
    "! Atributo Modalidade
    DATA gs_modalidade TYPE ze_modalidade .
    "! Atributo Calculo Efetivo
    DATA gs_calc_efetivo TYPE char1 .
    "! Atributo Contribuente
    DATA gs_contribuinte TYPE j_1bicmstaxpay .
    "! Atributo Ultima Compra
    DATA gs_ult_compra TYPE verpr .
    DATA gs_ult_ipi TYPE verpr .
    DATA gv_ipi TYPE flag .
    "! Atributo Valor Unitário
    DATA gs_valor_unit TYPE j_1bnetpri .
    "! Atributo Valor Produção
    DATA gs_valor_prod TYPE j_1bnfnett .
    "! Atributo Quantidade
    DATA gs_quantidade TYPE j_1bnetqty .
    "! Atributo Unidade
    DATA gs_unidade TYPE j_1bnetunt .
    DATA:
        "! Atributo Contribuente ICMS
      gt_contribuinte_icms TYPE RANGE OF j_1bicmstaxpay .
    DATA gs_perc_bc_icms TYPE ze_perc_bc_icms .
    DATA gv_vl02n TYPE abap_bool .
    DATA gv_zipival TYPE ze_ipi .
    DATA gv_zipival_check TYPE abap_bool .
    DATA gv_contribuinte_icms_check TYPE abap_bool .
    DATA gv_vbeln_old TYPE vbeln_vl .
    DATA gv_kposn_old TYPE kposn .
    DATA gv_bukrs_old TYPE bukrs .
    DATA gv_centro_old TYPE werks_ext .
    DATA gv_material_old TYPE matnr .

    "! Método preenche atributos chaves
    "! @parameter iv_centro        | Centro
    "! @parameter iv_uf            | UF
    "! @parameter iv_material      | Material
    "! @parameter iv_gp_mercadoria | Grupo Mercadorias
    "! @parameter iv_contribuinte  | Contribuente
    "! @parameter iv_ult_compra    | Ultima Compra
    "! @parameter iv_valor_unit    | Valor Unitário
    "! @parameter iv_valor_prod    | Valor Produção
    "! @parameter iv_quantidade    | Quantidade
    "! @parameter iv_unidade       | Unidade de Medida
    "! @parameter rv_ok_keys       | Retorno se chaves foram preenchidas
    METHODS get_keys
      IMPORTING
        !iv_bukrs         TYPE bukrs
        !iv_centro        TYPE werks_ext
        !iv_uf            TYPE ze_uf_receb
        !iv_material      TYPE matnr
        !iv_gp_mercadoria TYPE matkl
        !iv_contribuinte  TYPE j_1bicmstaxpay
        !iv_ult_compra    TYPE verpr
        !iv_ult_ipi       TYPE verpr
        !iv_valor_unit    TYPE j_1bnetpri
        !iv_valor_prod    TYPE j_1bnfnett
        !iv_quantidade    TYPE j_1bnetqty
        !iv_unidade       TYPE j_1bnetunt
      RETURNING
        VALUE(rv_ok_keys) TYPE abap_bool .
    "! Método Seleciona dados
    METHODS select .
    "! Método Seleciona dados tabela parâmetros
    METHODS get_param_icms .
    "! Método Seleciona dados calculados
    METHODS get_calculations .
    "! Método seleciona quantidade
    "! @parameter rv_menge | Quantidade
    METHODS get_quantity
      RETURNING
        VALUE(rv_menge) TYPE bstmg .
    "!Método Seleciona Base ICMS Modalidade 1
    METHODS get_base_icms_mod_1 .
    "!Método Seleciona Base ICMS Modalidade 2
    METHODS get_base_icms_mod_2 .
    "!Método Seleciona Base ICMS Modalidade 3
    METHODS get_base_icms_mod_3 .
    "!Método Seleciona Base ICMS Modalidade 4
    METHODS get_base_icms_mod_4 .
    "!Método Seleciona ICMS ST
    METHODS get_icms_st .
    "!Método Seleciona ICMS ST por unidade
    METHODS get_icms_st_for_unit .
    "!Método Seleciona FCP Modalidade 1
    METHODS get_fcp_ret_mod_1 .
    "!Método Seleciona FCP Modalidade 4
    METHODS get_fcp_ret_mod_4 .
    "!Método preenche valores Modalidade 1
    METHODS set_values_mod_1 .
    "!Método preenche valores Modalidade 2
    METHODS set_values_mod_2 .
    "!Método preenche valores Modalidade 3
    METHODS set_values_mod_3 .
    "!Método preenche valores Modalidade 4
    METHODS set_values_mod_4 .
    "!Método preenche valores Modalidade 5
    METHODS set_values_mod_5 .
    "!Método seleciona base efetiva
    METHODS get_base_efet .
    "!Método seleciona ICMS efetivo
    METHODS get_icms_efet .
    "!Método preenche valores efetivos
    METHODS set_values_calc_efet .
    "!Método preenche valores Modalidades
    METHODS set_values_mod .
    METHODS set_values_mod_6 .
    METHODS get_base_icms_mod_6 .
    METHODS get_base_icms_mod_5 .
    METHODS set_values_mod_7 .
    METHODS get_base_icms_mod_7 .
    METHODS get_base_icms_mod_8 .
ENDCLASS.



CLASS ZCLSD_GET_TAX_CALCULATIONS IMPLEMENTATION.


  METHOD main.




    IF iv_vbeln NE gv_vbeln_old AND
       iv_kposn NE gv_kposn_old.
      SELECT COUNT( * )
        FROM lips
       WHERE vbeln = @iv_vbeln
         AND posnr = @iv_kposn
         AND bwart = @( |862| ).
      IF sy-subrc EQ 0.
        me->gv_vl02n = abap_true.
      ENDIF.
      gv_vbeln_old = iv_vbeln.
      gv_kposn_old = iv_kposn.
    ENDIF.



    DATA(lv_keys) = get_keys(  iv_bukrs         =  iv_bukrs
                               iv_centro        =  iv_centro
                               iv_uf            =  iv_uf
                               iv_material      =  iv_material
                               iv_gp_mercadoria =  iv_gp_mercadoria
                               iv_contribuinte  =  iv_contribuinte
                               iv_ult_compra    =  iv_ult_compra
                               iv_ult_ipi       =  iv_ult_ipi
                               iv_valor_unit    =  iv_valor_unit
                               iv_valor_prod    =  iv_valor_prod
                               iv_quantidade    =  iv_quantidade
                               iv_unidade       =  iv_unidade  ).

    CHECK lv_keys IS NOT INITIAL.

    select(  ).
    get_param_icms( ).
    get_calculations( ).

    es_calculos = gs_calculos.


  ENDMETHOD.


  METHOD get_param_icms.

    IF gv_contribuinte_icms_check IS INITIAL.

      DATA(lo_tabela_parametros) = NEW zclca_tabela_parametros( ).

      TRY.
          lo_tabela_parametros->m_get_range(
            EXPORTING
              iv_modulo = gc_parametros-modulo
              iv_chave1 = gc_parametros-chave1
            IMPORTING
              et_range  = gt_contribuinte_icms
          ).

        CATCH zcxca_tabela_parametros.

      ENDTRY.

      gv_contribuinte_icms_check = abap_true.

    ENDIF.

  ENDMETHOD.


  METHOD select.

    DATA lo_get_cst60 TYPE REF TO zclsd_get_tables_cst60.

***    DATA(lo_get_cst60) = NEW zclsd_get_tables_cst60( ).

    lo_get_cst60 = zclsd_get_tables_cst60=>get_instance( ).

    CLEAR: gs_tabela,
           gs_agregado,
           gs_icms_dest,
           gs_icms_orig,
           gs_compra_interna,
           gs_base_red_orig,
           gs_base_red_dest,
           gs_taxa_fcp,
           gs_icms_efet,
           gs_baseredefet,
           gs_preco_compar,
           gs_preco_pauta,
           gs_agregado_pauta,
           gs_nro_unids,
           gs_um,
           gs_calc_efetivo,
           gs_modalidade,
           gs_perc_bc_icms.

    lo_get_cst60->execute(
      EXPORTING
        iv_centro         = gs_centro
        iv_uf             = gs_uf
        iv_material       = gs_material
        iv_gp_mercadoria  = gs_gp_mercadoria
      IMPORTING
        ev_tabela         = gs_tabela
        ev_agregado       = gs_agregado
        ev_icms_dest      = gs_icms_dest
        ev_icms_orig      = gs_icms_orig
        ev_compra_interna = gs_compra_interna
        ev_base_red_orig  = gs_base_red_orig
        ev_base_red_dest  = gs_base_red_dest
        ev_taxa_fcp       = gs_taxa_fcp
        ev_icms_efet      = gs_icms_efet
        ev_baseredefet    = gs_baseredefet
        ev_preco_compar   = gs_preco_compar
        ev_preco_pauta    = gs_preco_pauta
        ev_agregado_pauta = gs_agregado_pauta
        ev_nro_unids      = gs_nro_unids
        ev_um             = gs_um
        ev_calc_efetivo   = gs_calc_efetivo
        ev_modalidade     = gs_modalidade
        ev_perc_bc_icms   = gs_perc_bc_icms
    ).

  ENDMETHOD.


  METHOD get_keys.

    IF iv_centro          IS NOT INITIAL OR
      iv_uf               IS NOT INITIAL OR
      iv_material         IS NOT INITIAL OR
      iv_gp_mercadoria    IS NOT INITIAL.

      gs_centro           =  iv_centro.
      gs_uf               =  iv_uf.
      gs_material         =  iv_material.
      gs_gp_mercadoria    =  iv_gp_mercadoria.

      IF iv_bukrs  NE gv_bukrs_old AND
         iv_centro NE gv_centro_old.
        IF iv_contribuinte IS INITIAL.
          SELECT SINGLE icmstaxpay
            FROM j_1bbranch
           INNER JOIN t001w
              ON j_1bbranch~branch = t001w~j_1bbranch
               WHERE j_1bbranch~bukrs = @iv_bukrs
                 AND t001w~werks      = @iv_centro
                INTO @gs_contribuinte.
        ELSE.
          gs_contribuinte     =  iv_contribuinte.
        ENDIF.
        gv_bukrs_old = iv_bukrs.
        gv_centro_old = iv_centro.
      ENDIF.

      gs_ult_compra       =  iv_ult_compra.
      gs_ult_ipi          =  iv_ult_ipi.
      gs_valor_unit       =  iv_valor_unit.
      gs_valor_prod       =  iv_valor_prod.
      gs_quantidade       =  iv_quantidade.
      gs_unidade          =  iv_unidade.

      IF iv_material NE gv_material_old AND
         iv_centro NE gv_centro_old.
        SELECT SINGLE zipival
          FROM j_1blpp
          INTO gv_zipival
            WHERE matnr EQ iv_material
              AND bwkey EQ iv_centro.
        IF sy-subrc EQ 0.
          IF gs_um IS INITIAL.
            SELECT SINGLE meins
              FROM mara
              INTO @gs_um
              WHERE matnr = @iv_material.
          ENDIF.
          DATA(lv_menge)  = get_quantity( ).
          gv_zipival = gv_zipival * lv_menge.
        ENDIF.
        gv_material_old = iv_material.
        gv_centro_old = iv_centro.
      ENDIF.

      rv_ok_keys = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD get_calculations.

    IF gs_contribuinte IN gt_contribuinte_icms.

*      IF gs_compra_interna EQ abap_true.
*        gs_calculos-vicmssubstituto = ( gs_ult_compra * ( gs_icms_orig - gs_taxa_fcp ) ) / 100.
*      ELSE.
      gs_calculos-vicmssubstituto = ( gs_ult_compra * gs_icms_orig ) / 100.
*      ENDIF.

      set_values_mod( ).

    ENDIF.

    IF gs_calc_efetivo EQ abap_true.
      set_values_calc_efet( ).
    ELSE.
      CLEAR: gs_calculos-predbcefet, gs_calculos-vbcefet.
    ENDIF.

    IF gs_calculos-vicmsstret < 0.
      CLEAR: gs_calculos-vicmsstret.
    ENDIF.



  ENDMETHOD.


  METHOD set_values_mod.

    DATA: lv_ipi TYPE j_1btaxval.
    FIELD-SYMBOLS: <fs_taxtab> TYPE ANY TABLE.


    ASSIGN ('(SAPLJ1BF)WA_NF_STX[]') TO <fs_taxtab>.

    IF <fs_taxtab> IS ASSIGNED.

      CLEAR lv_ipi.

      LOOP AT <fs_taxtab> ASSIGNING FIELD-SYMBOL(<fs_tax>).

        ASSIGN COMPONENT 'TAXGRP' OF STRUCTURE <fs_tax> TO FIELD-SYMBOL(<fs_grupo>).
        IF <fs_grupo> IS ASSIGNED AND <fs_grupo> = 'IPI'.
          ASSIGN COMPONENT 'TAXVAL' OF STRUCTURE <fs_tax> TO FIELD-SYMBOL(<fs_valor>).
          IF <fs_valor> IS ASSIGNED.
            lv_ipi = lv_ipi + <fs_valor>.
          ENDIF.
        ENDIF.

      ENDLOOP.

      IF lv_ipi IS NOT INITIAL.
        IF me->gv_vl02n EQ abap_true.
          gs_ult_ipi = lv_ipi.
        ENDIF.
        gv_ipi = abap_true.
      ENDIF.

    ENDIF.


    CASE gs_modalidade.
      WHEN 1.
        set_values_mod_1( ).

      WHEN 2.
        set_values_mod_2( ).

      WHEN 3.
        set_values_mod_3( ).

      WHEN 4.
        set_values_mod_4( ).

      WHEN 5.
        set_values_mod_5( ).

      WHEN 6.
        set_values_mod_6( ).

      WHEN 7.
        set_values_mod_7( ).

    ENDCASE.



  ENDMETHOD.


  METHOD set_values_calc_efet.

    get_base_efet( ).

    get_icms_efet( ).

    IF gs_baseredefet IS NOT INITIAL.
      gs_calculos-vbcefet = gs_valor_prod * gs_baseredefet / 100."( gs_calculos-predbcefet ).
    ELSE.
      IF me->gv_vl02n EQ abap_true.
        gs_calculos-vbcefet = gs_calculos-vbcstret.
      ELSE.
        gs_calculos-vbcefet = gs_valor_prod.
* LSCHEPP - 8000007013 - CORE 5 - Cálculo CST 60 - 05.05.2023 Início
        IF NOT gs_base_red_dest IS INITIAL.
          gs_calculos-vbcefet = gs_calculos-vbcefet * gs_base_red_dest / 100.
        ENDIF.
* LSCHEPP - 8000007013 - CORE 5 - Cálculo CST 60 - 05.05.2023 Fim
      ENDIF.
    ENDIF.

    gs_calculos-vicmsefet =  gs_calculos-picmsefet * gs_calculos-vbcefet / 100.

  ENDMETHOD.


  METHOD get_icms_efet.

    IF gs_icms_efet IS INITIAL.
      gs_calculos-picmsefet = gs_icms_dest.
    ELSE.
      gs_calculos-picmsefet = gs_icms_efet.
    ENDIF.

  ENDMETHOD.


  METHOD get_base_efet.

    IF gs_baseredefet IS NOT INITIAL.
      gs_calculos-predbcefet = 100 - gs_baseredefet.
    ELSEIF gs_base_red_dest IS NOT INITIAL AND gs_base_red_dest NE '100.00'.
* LSCHEPP - 8000007013 - CORE 5 - Cálculo CST 60 - 05.05.2023 Início
*      gs_calculos-predbcefet = gs_base_red_dest.
      gs_calculos-predbcefet = 100 - gs_base_red_dest.
* LSCHEPP - 8000007013 - CORE 5 - Cálculo CST 60 - 05.05.2023 Fim
    ENDIF.

  ENDMETHOD.


  METHOD set_values_mod_5.

    gs_calculos-pfcpstret = gs_taxa_fcp.

    get_base_icms_mod_3( ).

    gs_calculos-pst = gs_icms_dest.

    get_icms_st( ).

    IF gs_calculos-pfcpstret IS NOT INITIAL.
      gs_calculos-vbcfcpstret  = gs_calculos-vbcstret.
    ENDIF.

    gs_calculos-vfcpstret = ( gs_calculos-vbcstret * gs_calculos-pfcpstret ) / 100.

  ENDMETHOD.


  METHOD set_values_mod_4.

    get_base_icms_mod_4( ).

    gs_calculos-pst = gs_icms_dest.

    get_icms_st( ).

    IF gs_taxa_fcp IS NOT INITIAL OR me->gv_vl02n EQ abap_true.

      gs_calculos-pfcpstret    = gs_taxa_fcp.

      gs_calculos-vbcfcpstret  =  gs_calculos-vbcstret.

      get_fcp_ret_mod_4( ).

    ENDIF.

  ENDMETHOD.


  METHOD set_values_mod_3.

    get_base_icms_mod_3( ).

    gs_calculos-pst = gs_agregado_pauta.

    gs_calculos-vicmsstret = gs_calculos-vbcstret * ( gs_calculos-pst - gs_taxa_fcp ) / 100.

  ENDMETHOD.


  METHOD set_values_mod_2.

    get_base_icms_mod_2( ).

    get_icms_st_for_unit( ).

  ENDMETHOD.


  METHOD set_values_mod_1.

    gs_calculos-pfcpstret = gs_taxa_fcp.

    get_base_icms_mod_1( ).

    gs_calculos-pst = gs_icms_dest.

    get_icms_st( ).

    IF gs_compra_interna EQ abap_true.

      IF gs_calculos-pfcpstret IS NOT INITIAL.
        gs_calculos-vbcfcpstret = gs_ult_compra + ( gs_ult_compra * gs_agregado / 100 ).
      ENDIF.

      get_fcp_ret_mod_1( ).

    ELSE.

      IF gs_calculos-pfcpstret IS NOT INITIAL.
        gs_calculos-vbcfcpstret  = gs_calculos-vbcstret.
      ENDIF.

      gs_calculos-vfcpstret = gs_calculos-vbcstret * gs_calculos-pfcpstret / 100.

    ENDIF.

  ENDMETHOD.


  METHOD get_fcp_ret_mod_4.

    IF gs_valor_unit > gs_preco_compar.

      DATA(lv_base) = gs_ult_compra * gs_calculos-vbcfcpstret.

      gs_calculos-vfcpstret = lv_base * gs_calculos-pfcpstret.
    ELSE.
      gs_calculos-vfcpstret = ( gs_calculos-vbcfcpstret * gs_calculos-pfcpstret ) / 100.
    ENDIF.

  ENDMETHOD.


  METHOD get_fcp_ret_mod_1.

    DATA(lv_debito) = gs_calculos-vbcstret * gs_calculos-pfcpstret .
    DATA(lv_base_fecop) = CONV f( ( gs_ult_compra * gs_base_red_orig ) / 100 ).
    DATA(lv_credito) = lv_base_fecop * gs_calculos-pfcpstret .

    gs_calculos-vfcpstret = ( lv_debito - lv_credito ) / 100.

  ENDMETHOD.


  METHOD get_icms_st_for_unit.

    IF gs_um EQ gs_unidade.
      gs_calculos-vicmsstret = gs_quantidade * gs_preco_pauta.
    ELSE.

      DATA(lv_menge) = get_quantity( ).

      IF lv_menge IS NOT INITIAL.
        gs_calculos-vicmsstret = lv_menge * gs_preco_pauta.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD get_icms_st.

    DATA lv_debito TYPE j_1bnfe_vbcfcpstret.

    lv_debito = gs_calculos-vbcstret * ( gs_calculos-pst - gs_taxa_fcp ).

    lv_debito = lv_debito / 100.

    IF gs_compra_interna EQ abap_false.
*      gs_calculos-vicmsstret = ( lv_debito - gs_calculos-vicmssubstituto ).
      DATA(lv_base_credito) = CONV f( ( gs_ult_compra * gs_base_red_orig ) / 100 ).
      DATA(lv_valor_credito) =  ( lv_base_credito * gs_icms_orig ) / 100 .
      gs_calculos-vicmsstret = lv_debito - lv_valor_credito.
    ELSE.
*      gs_calculos-vicmsstret = ( gs_calculos-vicmssubstituto * ( gs_calculos-pst - gs_calculos-pfcpstret ) ) / gs_calculos-pst.
*      gs_calculos-vicmsstret = lv_debito - gs_calculos-vicmsstret.
      lv_base_credito = ( gs_ult_compra * gs_base_red_orig ) / 100.
      lv_valor_credito =  ( lv_base_credito * ( gs_icms_orig - gs_taxa_fcp ) ) / 100 .
      gs_calculos-vicmsstret = lv_debito - lv_valor_credito.
    ENDIF.

  ENDMETHOD.


  METHOD get_base_icms_mod_2.

    gs_calculos-vbcstret = gs_valor_prod.

    IF gv_ipi = abap_true.
      gs_calculos-vbcstret = gs_calculos-vbcstret + gs_ult_ipi.
    ENDIF.

  ENDMETHOD.


  METHOD get_base_icms_mod_4.

    IF gs_um NE gs_unidade.
*    IF gs_um EQ gs_unidade.
      DATA(lv_menge)  = get_quantity( ).
    ELSE.
      lv_menge = gs_quantidade.
    ENDIF.

    gs_preco_compar = gs_preco_compar * lv_menge.

    IF gs_ult_compra > gs_preco_compar.
      get_base_icms_mod_1( ).
    ELSE.
      get_base_icms_mod_3( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_base_icms_mod_1.

*    IF gs_base_red_orig LT 100 OR
    IF gs_base_red_dest LT 100.
*      DATA(lv_perc_red_base) = CONV j_1bnfe_rfc_icmsstretbase( 100 - gs_baseredefet ).
      DATA(lv_perc_red_base) = CONV j_1bnfe_rfc_icmsstretbase( 100 - gs_base_red_dest ).
      gs_calculos-vbcstret = gs_ult_compra - ( gs_ult_compra * lv_perc_red_base / 100 ).
      gs_calculos-vbcstret = gs_calculos-vbcstret + ( gs_calculos-vbcstret * gs_agregado / 100 ).
    ELSE.
*      gs_calculos-vbcstret = gs_ult_compra + ( gs_ult_compra * gs_agregado / 100 ).
      gs_calculos-vbcstret = ( gs_ult_compra + gv_zipival ) + ( ( gs_ult_compra + gv_zipival ) * ( gs_agregado / 100 ) ).
    ENDIF.

    IF gv_ipi = abap_true.
      gs_calculos-vbcstret = gs_calculos-vbcstret + gs_ult_ipi.
    ENDIF.

  ENDMETHOD.


  METHOD get_base_icms_mod_3.

    IF gs_um EQ gs_unidade.
      gs_calculos-vbcstret = gs_quantidade * gs_preco_pauta.

      IF gv_ipi = abap_true.
        gs_calculos-vbcstret = gs_calculos-vbcstret + gs_ult_ipi.
      ENDIF.

    ELSE.

      DATA(lv_menge) = get_quantity( ).

      IF lv_menge IS NOT INITIAL.
        gs_calculos-vbcstret = lv_menge * gs_preco_pauta.
      ENDIF.

      IF gv_ipi = abap_true.
        gs_calculos-vbcstret = gs_calculos-vbcstret + gs_ult_ipi.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD get_quantity.

    CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
      EXPORTING
        i_matnr              = gs_material
        i_in_me              = gs_unidade
        i_out_me             = gs_um
        i_menge              = gs_quantidade
      IMPORTING
        e_menge              = rv_menge
      EXCEPTIONS
        error_in_application = 1
        error                = 2
        OTHERS               = 3.

    IF sy-subrc NE 0.
      rv_menge = gs_quantidade.
    ENDIF.

  ENDMETHOD.


  METHOD get_base_icms_mod_6.

    IF gs_um NE gs_unidade.
      DATA(lv_menge)  = get_quantity( ).
    ELSE.
      lv_menge = gs_quantidade.
    ENDIF.

    gs_preco_compar = gs_preco_compar * lv_menge.

    DATA(lv_calc_bc_icms) = CONV ze_preco_compar( ( gs_ult_compra * gs_perc_bc_icms ) / 100 ).

    IF lv_calc_bc_icms > gs_preco_compar.
      get_base_icms_mod_5( ).
    ELSE.
      get_base_icms_mod_3( ).
    ENDIF.

  ENDMETHOD.


  METHOD set_values_mod_6.

    get_base_icms_mod_6( ).

    gs_calculos-pst = gs_icms_dest.

    get_icms_st( ).

    IF gs_taxa_fcp IS NOT INITIAL.

      gs_calculos-pfcpstret    = gs_taxa_fcp.

      gs_calculos-vbcfcpstret  =  gs_calculos-vbcstret.

      get_fcp_ret_mod_4( ).

    ENDIF.

  ENDMETHOD.


  METHOD get_base_icms_mod_5.

    IF gs_base_red_orig LT 100 OR
       gs_base_red_dest LT 100.
      DATA(lv_perc_red_base) = CONV j_1bnfe_rfc_icmsstretbase( 100 - gs_baseredefet ).
      gs_calculos-vbcstret = gs_ult_compra - ( gs_ult_compra * lv_perc_red_base / 100 ).
      gs_calculos-vbcstret = gs_calculos-vbcstret + ( gs_calculos-vbcstret * gs_agregado / 100 ).
    ELSE.
      gs_calculos-vbcstret = gs_ult_compra + ( gs_ult_compra * gs_agregado / 100 ).
*      gs_calculos-vbcstret = gs_preco_compar.
    ENDIF.

    IF gv_ipi = abap_true.
      gs_calculos-vbcstret = gs_calculos-vbcstret + gs_ult_ipi.
    ENDIF.

  ENDMETHOD.


  METHOD get_instance.

    IF NOT go_instance IS BOUND.
      go_instance = NEW zclsd_get_tax_calculations( ).
    ENDIF.

    ro_instance = go_instance.

  ENDMETHOD.


  METHOD get_base_icms_mod_8.

    IF gs_um EQ gs_unidade.
      gs_calculos-vbcstret = gs_quantidade * gs_preco_pauta.

      IF gv_ipi = abap_true.
        gs_calculos-vbcstret = gs_calculos-vbcstret + gs_ult_ipi.
      ENDIF.

    ELSE.

      DATA(lv_menge) = get_quantity( ).

      IF lv_menge IS NOT INITIAL.
        gs_calculos-vbcstret = ( lv_menge * gs_preco_pauta ) * ( gs_base_red_dest / 100 ).
      ENDIF.

      IF gv_ipi = abap_true.
        gs_calculos-vbcstret = gs_calculos-vbcstret + gs_ult_ipi.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD get_base_icms_mod_7.

    IF gs_um NE gs_unidade.
*    IF gs_um EQ gs_unidade.
      DATA(lv_menge)  = get_quantity( ).
    ELSE.
      lv_menge = gs_quantidade.
    ENDIF.

    gs_preco_compar = gs_preco_compar * lv_menge.

    IF gs_ult_compra > gs_preco_compar.
      get_base_icms_mod_1( ).
    ELSE.
      get_base_icms_mod_8( ).
    ENDIF.

  ENDMETHOD.


  METHOD set_values_mod_7.

    get_base_icms_mod_7( ).

    gs_calculos-pst = gs_icms_dest.

    get_icms_st( ).

    IF gs_taxa_fcp IS NOT INITIAL OR me->gv_vl02n EQ abap_true.

      gs_calculos-pfcpstret    = gs_taxa_fcp.

      gs_calculos-vbcfcpstret  =  gs_calculos-vbcstret.

      get_fcp_ret_mod_4( ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
