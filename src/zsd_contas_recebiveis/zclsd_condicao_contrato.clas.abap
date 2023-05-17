CLASS zclsd_condicao_contrato DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_cliente,
        kdkg1  TYPE kna1-kdkg1,
        katr2  TYPE kna1-katr2,
        katr10 TYPE kna1-katr10,
      END OF ty_cliente .
    TYPES:
      BEGIN OF ty_familia,
        familia TYPE rkeg_wwmt1,
      END OF ty_familia .
    TYPES:
      BEGIN OF ty_split,
        dia TYPE char2,
      END OF ty_split .
    TYPES:
      BEGIN OF ty_dados_janela,
        diamesfixo TYPE char2,
        diasemana  TYPE ze_dia_semana_range,
      END OF ty_dados_janela .
    TYPES:
      tt_dados_janela TYPE TABLE OF ty_dados_janela .
    TYPES:
            "ty_familia_prod TYPE TABLE OF ty_familia WITH KEY familia .
      ty_familia_prod TYPE HASHED TABLE OF ty_familia WITH UNIQUE KEY familia .
    TYPES:
      ty_accit        TYPE TABLE OF accit .
    TYPES:
      ty_vbrpvb       TYPE TABLE OF vbrpvb .
    TYPES:
      BEGIN OF ty_doc_uuid_h,
        doc_uuid_h TYPE sysuuid_x16,
      END OF   ty_doc_uuid_h .
    TYPES:
      tt_doc_uuid_h TYPE TABLE OF ty_doc_uuid_h .

    METHODS calcular
      IMPORTING
        !iv_rotina           TYPE grpno
        !is_komk             TYPE komk
        !is_komp             TYPE komp
        !iv_preisfindungsart TYPE c OPTIONAL
        !it_xkomv            TYPE tax_xkomv_tab
      CHANGING
        !cv_kwert            TYPE kwert .
    METHODS calcular_taxa_item
      IMPORTING
        !iv_kunnr      TYPE kunnr
        !iv_vkorg      TYPE vkorg
        !iv_vtweg      TYPE vtweg
        !iv_spart      TYPE spart
        !iv_vbeln      TYPE vbeln
        !iv_vbtyp      TYPE vbtypl OPTIONAL
        !it_vbrpvb     TYPE zclsd_condicao_contrato=>ty_vbrpvb
      CHANGING
        !ct_xaccit     TYPE zclsd_condicao_contrato=>ty_accit
        !ct_xacccr     TYPE tacccr
        !ct_doc_uuid_h TYPE tt_doc_uuid_h .
    METHODS calcular_data_base
      IMPORTING
        !iv_kunnr           TYPE kunnr
        !iv_vkorg           TYPE vkorg
        !iv_vtweg           TYPE vtweg
        !iv_spart           TYPE spart
        !iv_vbeln           TYPE vbeln
        !iv_aubel           TYPE vbeln_va
        !it_vbrpvb          TYPE zclsd_condicao_contrato=>ty_vbrpvb
      CHANGING
        !ct_doc_uuid_h      TYPE tt_doc_uuid_h
        !ct_xaccit          TYPE zclsd_condicao_contrato=>ty_accit
      RETURNING
        VALUE(rv_data_base) TYPE dzfbdt .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS gc_rotina_607 TYPE grpno VALUE 607 ##NO_TEXT.
    CONSTANTS gc_rotina_608 TYPE grpno VALUE 608 ##NO_TEXT.
    CONSTANTS gc_rotina_609 TYPE grpno VALUE 609 ##NO_TEXT.
    CONSTANTS gc_rotina_625 TYPE grpno VALUE 625 ##NO_TEXT.
    CONSTANTS gc_tipo_imposto_icms TYPE char1 VALUE 1 ##NO_TEXT.
    CONSTANTS gc_tipo_imposto_ipi TYPE char1 VALUE 2 ##NO_TEXT.
    CONSTANTS gc_tipo_imposto_icmsst TYPE char1 VALUE 3 ##NO_TEXT.
    CONSTANTS gc_tipo_imposto_pis_cofins TYPE char1 VALUE 4 ##NO_TEXT.
    CONSTANTS gc_tipo_imposto_todos TYPE char1 VALUE 5 ##NO_TEXT.
    DATA gv_sub_prod TYPE abap_bool .

    METHODS get_cliente
      IMPORTING
        !iv_kunnr         TYPE kunnr
      RETURNING
        VALUE(rs_cliente) TYPE ty_cliente .
    METHODS get_cond_pgto
      IMPORTING
        !iv_kunnr       TYPE kunnr
        !iv_vkorg       TYPE vkorg
        !iv_vtweg       TYPE vtweg
        !iv_spart       TYPE spart
      RETURNING
        VALUE(rv_zterm) TYPE dzterm .
    METHODS get_familia
      IMPORTING
        !iv_vbeln         TYPE vbeln
      RETURNING
        VALUE(rt_familia) TYPE ty_familia_prod .
    METHODS get_data_base
      IMPORTING
        !it_dados_janela    TYPE tt_dados_janela
        !iv_dt_base_janela  TYPE dzfbdt
      CHANGING
        VALUE(cv_data_base) TYPE dzfbdt .
ENDCLASS.



CLASS ZCLSD_CONDICAO_CONTRATO IMPLEMENTATION.


  METHOD get_cliente.

    SELECT SINGLE
      kna1~kdkg1,
      kna1~katr2,
      kna1~katr10
    FROM
      kna1
    WHERE
      kunnr = @iv_kunnr
    INTO
      @rs_cliente.

  ENDMETHOD.


  METHOD get_cond_pgto.

    SELECT SINGLE
      knvv~zterm
    FROM
      knvv
    WHERE
      kunnr = @iv_kunnr AND
      vkorg = @iv_vkorg AND
      vtweg = @iv_vtweg AND
      spart = @iv_spart
    INTO
      @rv_zterm.

  ENDMETHOD.


  METHOD get_familia.

    DATA: lv_familia TYPE ty_familia-familia.
    DATA: ls_fam TYPE ty_familia.

    SELECT DISTINCT
      prctr
    FROM
      vbrp
    WHERE
      vbeln = @iv_vbeln
    INTO TABLE
      @DATA(lt_dados).

    LOOP AT lt_dados ASSIGNING FIELD-SYMBOL(<fs_item>).
      CLEAR: lv_familia.
      lv_familia = <fs_item>(2).

      READ TABLE rt_familia WITH TABLE KEY familia = lv_familia TRANSPORTING NO FIELDS.

      IF sy-subrc <> 0.
        "APPEND lv_familia TO et_familia.
        ls_fam-familia = lv_familia.
        INSERT ls_fam INTO TABLE rt_familia.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD calcular.

    DATA lt_dados TYPE TABLE OF zi_fi_prov_cont WITH KEY docuuidh docuuidprov contrato aditivo.

    DATA: lv_mesvigencia TYPE ze_mes_vigenc_range,
          lv_calc        TYPE kzwis,
          lv_result      TYPE kzwis,
          lv_desconto    TYPE ze_percentual,
          lv_familia     TYPE ty_familia-familia.

    DATA: lt_bukrs      TYPE RANGE OF bukrs,
          lt_mes_vigenc TYPE RANGE OF ze_mes_vigenc_range,
          lt_katr2      TYPE RANGE OF katr2,
          lt_aplicadesc TYPE RANGE OF ze_aplica_desc,
          lt_status     TYPE RANGE OF ze_status_contrato.

    FIELD-SYMBOLS: <fs_abgru>      TYPE abgru_va,
                   <fs_trtyp>      TYPE trtyp,
                   <fs_tabix>      TYPE sytabix,
                   <fs_posnr>      TYPE posnr_va,
                   <fs_ex_vbapkom> TYPE vbapkom_t.


    "Importa a variável da função ZFMSD_SUBSTITUIR_DESCONTO - método CALL_BAPI_SUBSTITUIR - classe ZCLSD_VERIF_UTIL_SUB
    IMPORT gv_sub_prod TO gv_sub_prod FROM MEMORY ID 'ZSD_SUB_PROD'.

    IF NOT gv_sub_prod IS INITIAL. "App Substituir Produto

      ASSIGN ('(SAPLVBAK)EX_VBAPKOM[]') TO <fs_ex_vbapkom>.
      IF <fs_ex_vbapkom> IS ASSIGNED.
        DATA(lt_vbapkom) = <fs_ex_vbapkom>.
        DELETE lt_vbapkom WHERE matnr IS INITIAL.

        IF NOT lt_vbapkom IS INITIAL AND
           NOT is_komp-kposn IS INITIAL.
          READ TABLE lt_vbapkom TRANSPORTING NO FIELDS WITH KEY posnr = is_komp-kposn.
          IF sy-subrc NE 0.
            RETURN.
          ENDIF.
        ENDIF.
      ELSE.
        RETURN.
      ENDIF.

    ENDIF.

    IF sy-cprog EQ 'SAPMSSY1'.
      ASSIGN ('(SAPLERP_SLS_CREDBLOCKDOC)TABIX') TO <fs_tabix>.
      IF <fs_tabix> IS ASSIGNED.
        DATA(lv_ukm_case) = abap_true.
      ENDIF.
    ENDIF.

    IF sy-tcode NE 'VKM1' AND
       lv_ukm_case IS INITIAL.
      ASSIGN ('(SAPMV45A)VBAP-POSNR') TO <fs_posnr>.
      IF <fs_posnr> IS ASSIGNED AND
         <fs_posnr> IS INITIAL.
        RETURN.
      ENDIF.

      ASSIGN ('(SAPMV45A)T180-TRTYP') TO <fs_trtyp>.
      IF <fs_trtyp> IS ASSIGNED AND
         <fs_trtyp> NE 'H'.
        IF iv_preisfindungsart NE 'B' AND
           iv_preisfindungsart NE 'C' AND
           iv_preisfindungsart NE 'E' AND
           iv_preisfindungsart NE 'G'.
          RETURN.
        ENDIF.

        ASSIGN ('(SAPMV45A)VBAP-ABGRU') TO <fs_abgru>.
        IF <fs_abgru> IS ASSIGNED AND
           NOT <fs_abgru> IS INITIAL.
          RETURN.
        ENDIF.
      ELSE.
        IF iv_preisfindungsart EQ 'E'.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.

    CLEAR lv_ukm_case.

    DATA(ls_cliente) = get_cliente( EXPORTING iv_kunnr = is_komk-kunnr ).

    IF ls_cliente-katr10 IS NOT INITIAL.

      DATA(ls_condicao_pgto) = get_cond_pgto( EXPORTING iv_kunnr = is_komk-kunnr
                                                        iv_vkorg = is_komk-vkorg
                                                        iv_vtweg = is_komk-vtweg
                                                        iv_spart = is_komk-spart ).


      IF ls_condicao_pgto IS NOT INITIAL.

        lv_familia = is_komp-prctr(2).

        lv_mesvigencia = sy-datum+4(2).

        IF NOT is_komk-vkorg IS INITIAL.
          APPEND VALUE #( sign = 'I' option = 'EQ' low = is_komk-vkorg high = space ) TO lt_bukrs.
        ENDIF.

        IF NOT lv_mesvigencia IS INITIAL.
          APPEND VALUE #( sign = 'I' option = 'EQ' low = lv_mesvigencia high = space ) TO lt_mes_vigenc.
        ENDIF.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = space high = space ) TO lt_mes_vigenc.

        IF NOT ls_cliente-katr2 IS INITIAL.
          APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_cliente-katr2 high = space ) TO lt_katr2.
        ENDIF.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = space high = space ) TO lt_katr2.

        APPEND VALUE #( sign = 'I' option = 'EQ' low = 'C' ) TO lt_aplicadesc.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = 'N' ) TO lt_aplicadesc.

        APPEND VALUE #( sign = 'I' option = 'EQ' low = '4' ) TO lt_status.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = '7' ) TO lt_status.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = '8' ) TO lt_status.

        IF iv_rotina = gc_rotina_607.

          SELECT
            zi_fi_prov_cont~*
          FROM zi_fi_prov_cont
          INNER JOIN zi_fi_contrato ON zi_fi_contrato~docuuidh = zi_fi_prov_cont~docuuidh
          LEFT JOIN ztfi_prov_fam ON ztfi_prov_fam~doc_uuid_h = zi_fi_prov_cont~docuuidh
                                 AND ztfi_prov_fam~doc_uuid_prov = zi_fi_prov_cont~docuuidprov
          WHERE zi_fi_prov_cont~grupcontrato  = @ls_cliente-katr10
            AND ( zi_fi_prov_cont~classificcnpj = '' OR zi_fi_prov_cont~classificcnpj = @ls_cliente-katr2 )
            AND zi_fi_prov_cont~tipodesconto  = 'L'
            AND ( ztfi_prov_fam~familia IS NULL OR ztfi_prov_fam~familia = @lv_familia )
            AND zi_fi_contrato~bukrs IN @lt_bukrs
            AND zi_fi_prov_cont~mesvigencia IN @lt_mes_vigenc
          INTO TABLE @lt_dados.

        ELSEIF iv_rotina = gc_rotina_608.

          SELECT
            zi_fi_prov_cont~*
          FROM zi_fi_prov_cont
          INNER JOIN zi_fi_contrato ON zi_fi_contrato~docuuidh = zi_fi_prov_cont~docuuidh
          LEFT JOIN ztfi_prov_fam ON ztfi_prov_fam~doc_uuid_h = zi_fi_prov_cont~docuuidh
                                 AND ztfi_prov_fam~doc_uuid_prov = zi_fi_prov_cont~docuuidprov
          WHERE zi_fi_prov_cont~grupcontrato  = @ls_cliente-katr10
            AND ( zi_fi_prov_cont~classificcnpj = '' OR zi_fi_prov_cont~classificcnpj = @ls_cliente-katr2 )
            AND zi_fi_prov_cont~tipodesconto  = 'C'
            AND ( ztfi_prov_fam~familia IS NULL OR ztfi_prov_fam~familia = @lv_familia )
            AND zi_fi_contrato~bukrs IN @lt_bukrs
            AND zi_fi_prov_cont~mesvigencia IN @lt_mes_vigenc
          INTO TABLE @lt_dados.

        ELSEIF iv_rotina = gc_rotina_609.

          SELECT
            zi_prov~*
          FROM
            zi_fi_prov_cont AS zi_prov
          INNER JOIN
            zi_fi_contrato AS zi_con ON ( zi_prov~docuuidh = zi_con~docuuidh )
          WHERE
            zi_prov~empresa IN @lt_bukrs AND
            zi_con~grpcontratos = @ls_cliente-katr10 AND
            zi_con~status IN @lt_status AND
            zi_prov~aplicadesconto = 'I' AND
            zi_prov~mesvigencia IN @lt_mes_vigenc AND
            zi_prov~classificcnpj IN @lt_katr2
          INTO TABLE
            @lt_dados.

        ELSEIF iv_rotina = gc_rotina_625.

          SELECT
            zi_fi_prov_cont~*
          FROM zi_fi_prov_cont
          INNER JOIN zi_fi_contrato ON zi_fi_contrato~docuuidh = zi_fi_prov_cont~docuuidh
          LEFT JOIN ztfi_prov_fam ON ztfi_prov_fam~doc_uuid_h = zi_fi_prov_cont~docuuidh
                                 AND ztfi_prov_fam~doc_uuid_prov = zi_fi_prov_cont~docuuidprov
          WHERE zi_fi_prov_cont~grupcontrato  = @ls_cliente-katr10
            AND ( zi_fi_prov_cont~classificcnpj = '' OR zi_fi_prov_cont~classificcnpj = @ls_cliente-katr2 )
            AND ( ztfi_prov_fam~familia IS NULL OR ztfi_prov_fam~familia = @lv_familia )
            AND zi_fi_contrato~bukrs IN @lt_bukrs
            AND zi_fi_prov_cont~mesvigencia IN @lt_mes_vigenc
            AND zi_fi_prov_cont~tipoapuracao EQ 'N'
          INTO TABLE @lt_dados.

        ENDIF.

        LOOP AT lt_dados ASSIGNING FIELD-SYMBOL(<fs_dados>).
          ADD <fs_dados>-percconddesc TO lv_desconto.
        ENDLOOP.

        IF iv_rotina = gc_rotina_607 OR iv_rotina = gc_rotina_608 OR iv_rotina = gc_rotina_625.

          LOOP AT lt_dados ASSIGNING FIELD-SYMBOL(<fs_item>).

            IF <fs_item>-tipoapimposto = 'L'.

              CLEAR: lv_calc.

              CASE <fs_item>-tipoimposto.
                WHEN gc_tipo_imposto_icms.        "ICMS
                  lv_calc = is_komp-kzwi1 - is_komp-kzwi2 + is_komp-kzwi3.
                WHEN gc_tipo_imposto_ipi.         "IPI
                  lv_calc = is_komp-kzwi1 + is_komp-kzwi4.
                WHEN gc_tipo_imposto_icmsst.      "ICMS ST
                  lv_calc = is_komp-kzwi1 + is_komp-kzwi3.
                WHEN gc_tipo_imposto_pis_cofins.  "PIS e COFINS
                  lv_calc = is_komp-kzwi1 + is_komp-kzwi3 + is_komp-kzwi4 - is_komp-kzwi5.
                WHEN gc_tipo_imposto_todos.       "Todos
                  lv_calc = is_komp-kzwi1 - is_komp-kzwi2 - is_komp-kzwi5.
              ENDCASE.

              lv_result = lv_result + ( ( lv_calc * <fs_item>-percconddesc ) / 100 ).

            ELSE.

              TRY.
                  DATA(lv_zbdc) = it_xkomv[ kposn = is_komp-kposn kschl = 'ZBDC' ]-kwert.
                  lv_result += ( ( lv_zbdc * <fs_item>-percconddesc ) / 100 ).
                CATCH cx_sy_itab_line_not_found.
              ENDTRY.

            ENDIF.

          ENDLOOP.

          IF lv_result > 0.
            cv_kwert = lv_result.
          ENDIF.

        ELSEIF iv_rotina = gc_rotina_609.
          cv_kwert = lv_desconto * -1.
        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD calcular_data_base.

    "DATA: lt_dados   TYPE TABLE OF zi_fi_prov_cont WITH KEY docuuidh docuuidprov contrato aditivo.

    DATA: lv_prazo_contrato     TYPE c,
          lv_mesvigencia        TYPE ze_mes_vigenc_range,
          lv_verificar_prazo    TYPE ze_prazo,
          lv_prazo_selecionado  TYPE ze_prazo,
          lv_dt_fatura_contrato TYPE ze_data_fatura,
          lv_dt_base            TYPE dzfbdt,
          lv_dt_base_janela     TYPE dzfbdt,
          lv_dt_vencto_liquido  TYPE dzfbdt,
          lv_day_prazo          TYPE t5a4a-dlydy,
          lv_dt_valiacao        TYPE sy-datum,
          lv_dia_mes_fixo       TYPE ze_dia_mes_fixo,
          lv_day                TYPE scal-indicator,
          lv_day2               TYPE char02,
          lv_day_add            TYPE t5a4a-dlydy,
          lv_day_desejado       TYPE char02, "ze_dia_semana,
          lv_data_final         TYPE scal-date,
          lv_calc_date          TYPE begda,
          lv_dia_sem            TYPE cind,
          lv_posnr              TYPE accit-posnr,
          lv_zfbdt              TYPE bseg-zfbdt,
          lv_zbd1t              TYPE bseg-zbd1t.


    DATA: lt_familia TYPE ty_familia_prod,
          lt_dias    TYPE TABLE OF ty_split WITH KEY dia,
          lt_semana  TYPE TABLE OF ty_split WITH EMPTY KEY.

    DATA: lv_familia TYPE char2.


    DATA: lt_bukrs         TYPE RANGE OF bukrs,
          lt_mes_vigenc    TYPE RANGE OF ze_mes_vigenc_range,
          lt_katr2         TYPE RANGE OF katr2,
          lt_aplicadesc    TYPE RANGE OF ze_aplica_desc,
          lt_familiacl     TYPE RANGE OF char2,
          lt_status        TYPE RANGE OF ze_status_contrato,
          lv_count_familia TYPE i.


    lv_mesvigencia = sy-datum+4(2).

*    SELECT SINGLE
*      zzdcd_x_condpag_prz                               "#EC CI_NOFIELD
*    FROM
*      ukm_dcd_attr
*    WHERE
*      dcd_obj_id = @iv_aubel
*    INTO
*      @DATA(lv_cond).
*
*    IF not lv_cond IS INITIAL.
*      lv_prazo_contrato = 'X'.
*    ENDIF.

    CLEAR lv_count_familia.
    LOOP AT it_vbrpvb ASSIGNING FIELD-SYMBOL(<fs_familia>).
      lv_familia = <fs_familia>-prctr(2).
      APPEND VALUE #( sign = 'I' option = 'EQ' low = lv_familia ) TO lt_familiacl.
      ADD 1 TO lv_count_familia.
    ENDLOOP.

    DATA(ls_cliente) = get_cliente( EXPORTING iv_kunnr = iv_kunnr ).

    IF NOT iv_vkorg IS INITIAL.
      APPEND VALUE #( sign = 'I' option = 'EQ' low = iv_vkorg high = space ) TO lt_bukrs.
    ENDIF.
    APPEND VALUE #( sign = 'I' option = 'EQ' low = space high = space ) TO lt_bukrs.

    IF NOT lv_mesvigencia IS INITIAL.
      APPEND VALUE #( sign = 'I' option = 'EQ' low = lv_mesvigencia high = space ) TO lt_mes_vigenc.
    ENDIF.
    APPEND VALUE #( sign = 'I' option = 'EQ' low = space high = space ) TO lt_mes_vigenc.

    IF ls_cliente-katr2 EQ 'P'.
      APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_cliente-katr2 high = space ) TO lt_katr2.
      APPEND VALUE #( sign = 'I' option = 'EQ' low = space high = space ) TO lt_katr2.
    ELSE.
      IF NOT ls_cliente-katr2 IS INITIAL.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_cliente-katr2 high = space ) TO lt_katr2.
      ENDIF.
      APPEND VALUE #( sign = 'I' option = 'EQ' low = space high = space ) TO lt_katr2.
    ENDIF.


    APPEND VALUE #( sign = 'I' option = 'EQ' low = '4' ) TO lt_status.
    APPEND VALUE #( sign = 'I' option = 'EQ' low = '7' ) TO lt_status.
    APPEND VALUE #( sign = 'I' option = 'EQ' low = '8' ) TO lt_status.

    APPEND VALUE #( sign = 'I' option = 'EQ' low = 'C' ) TO lt_aplicadesc.
    APPEND VALUE #( sign = 'I' option = 'EQ' low = 'N' ) TO lt_aplicadesc.


    IF ls_cliente-katr10 IS NOT INITIAL.

      DATA(ls_condicao_pgto) = get_cond_pgto( EXPORTING iv_kunnr = iv_kunnr
                                                        iv_vkorg = iv_vkorg
                                                        iv_vtweg = iv_vtweg
                                                        iv_spart = iv_spart ).

      IF ls_condicao_pgto IS NOT INITIAL.

*        lt_familia = get_familia( EXPORTING iv_vbeln = iv_vbeln ).

        SELECT
          zi_prov~docuuidh,
          zi_prov~docuuidprov,
          zi_prov~tipoapimposto,
          zi_prov~tipoimposto,
          lt_jan~prazo,
          lt_jan~atributo2 AS katr2,
          lt_jan~familiacl,
          zi_con~datafatura
        FROM
          zi_fi_prov_cont AS zi_prov
*        INNER JOIN
*          ztfi_prov_fam AS zi_fam ON ( zi_prov~docuuidh = zi_fam~doc_uuid_h AND zi_prov~docuuidprov = zi_fam~doc_uuid_prov )
        INNER JOIN
          zi_fi_contrato AS zi_con ON ( zi_prov~docuuidh = zi_con~docuuidh )
*        INNER JOIN
*          @lt_familia AS lt_fam ON ( zi_fam~familia = lt_fam~familia )
        INNER JOIN
          zi_fi_janela_cont AS lt_jan ON ( zi_prov~docuuidh = lt_jan~docuuidh )
        WHERE
*          zi_prov~empresa = @iv_vkorg AND
          zi_prov~empresa IN @lt_bukrs AND
          zi_con~grpcontratos = @ls_cliente-katr10 AND
          zi_con~status IN @lt_status AND
*          ( zi_prov~mesvigencia IS INITIAL OR zi_prov~mesvigencia = @lv_mesvigencia ) AND
*          zi_prov~mesvigencia IN @lt_mes_vigenc AND
*          ( zi_prov~classificcnpj IS INITIAL OR zi_prov~classificcnpj = @ls_cliente-katr2 )
          zi_prov~classificcnpj IN @lt_katr2 AND
          lt_jan~atributo2 IN @lt_katr2
        INTO TABLE
          @DATA(lt_dados).
        IF sy-subrc <> 0.
          APPEND VALUE #( sign = 'I' option = 'EQ' low = space high = space ) TO lt_katr2.

          SELECT
            zi_prov~docuuidh,
            zi_prov~docuuidprov,
            zi_prov~tipoapimposto,
            zi_prov~tipoimposto,
            lt_jan~prazo,
            lt_jan~atributo2 AS katr2,
            lt_jan~familiacl,
            zi_con~datafatura
          FROM
            zi_fi_prov_cont AS zi_prov
*        INNER JOIN
*          ztfi_prov_fam AS zi_fam ON ( zi_prov~docuuidh = zi_fam~doc_uuid_h AND zi_prov~docuuidprov = zi_fam~doc_uuid_prov )
          INNER JOIN
            zi_fi_contrato AS zi_con ON ( zi_prov~docuuidh = zi_con~docuuidh )
*        INNER JOIN
*          @lt_familia AS lt_fam ON ( zi_fam~familia = lt_fam~familia )
          INNER JOIN
            zi_fi_janela_cont AS lt_jan ON ( zi_prov~docuuidh = lt_jan~docuuidh )
          WHERE
*          zi_prov~empresa = @iv_vkorg AND
            zi_prov~empresa IN @lt_bukrs AND
            zi_con~grpcontratos = @ls_cliente-katr10 AND
            zi_con~status IN @lt_status AND
*          ( zi_prov~mesvigencia IS INITIAL OR zi_prov~mesvigencia = @lv_mesvigencia ) AND
*            zi_prov~mesvigencia IN @lt_mes_vigenc AND
*          ( zi_prov~classificcnpj IS INITIAL OR zi_prov~classificcnpj = @ls_cliente-katr2 )
            zi_prov~classificcnpj IN @lt_katr2 AND
            lt_jan~atributo2 IN @lt_katr2
          INTO TABLE
            @lt_dados.
        ENDIF.
        IF sy-subrc = 0.

          IF line_exists( lt_dados[ katr2 = ls_cliente-katr2 ] ).
            DELETE lt_dados WHERE katr2 NE ls_cliente-katr2.
            DELETE lt_katr2 WHERE low NE ls_cliente-katr2.
          ENDIF.

*          DATA(lt_dados_aux) = lt_dados.
*          DELETE lt_dados_aux[] WHERE familiacl = space.
*          IF NOT lt_dados_aux IS INITIAL.
*            IF lines( lt_dados_aux ) NE lines( lt_dados ).
*              LOOP AT lt_dados ASSIGNING FIELD-SYMBOL(<fs_dados>).
*                IF <fs_dados>-familiacl IS INITIAL.
*                  DELETE lt_dados INDEX sy-tabix.
*                ELSE.
*                  APPEND VALUE #( sign = 'I' option = 'EQ' low = <fs_dados>-familiacl ) TO lt_familiacl.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.
*          ENDIF.
*          SELECT *
*            FROM
*              ztfi_prov_fam
*            INTO TABLE @DATA(lt_fam)
*            FOR ALL ENTRIES IN @lt_dados
*            WHERE doc_uuid_h  EQ @lt_dados-docuuidh
*            AND doc_uuid_prov EQ @lt_dados-docuuidprov.
**            AND familia       EQ @lv_familia.

          SELECT *
            FROM
              ztfi_cont_janela
            INTO TABLE @DATA(lt_fam)
            FOR ALL ENTRIES IN @lt_dados
            WHERE doc_uuid_h  EQ @lt_dados-docuuidh.
*            AND familia       EQ @lv_familia.

          IF lt_fam IS NOT INITIAL.

            SORT lt_fam BY doc_uuid_h familia_cl.

            LOOP AT lt_dados ASSIGNING FIELD-SYMBOL(<fs_dados_aux>).
              DATA(lv_tabix) = sy-tabix.

              LOOP AT lt_fam ASSIGNING FIELD-SYMBOL(<fs_fam>) WHERE doc_uuid_h    = <fs_dados_aux>-docuuidh
                                                                AND familia_cl    = <fs_dados_aux>-familiacl. "#EC CI_STDSEQ
*              READ TABLE lt_fam ASSIGNING FIELD-SYMBOL(<fs_fam>) WITH KEY DOC_UUID_H    = <fs_dados_aux>-docuuidh
*                                                                          FAMILIA_CL    = lv_familia BINARY SEARCH.
                IF <fs_fam> IS ASSIGNED.
*                  DATA(lv_tabix1) = sy-tabix.
                  IF NOT <fs_fam>-familia_cl IS INITIAL.
                    IF <fs_fam>-familia_cl NOT IN lt_familiacl.
                      DELETE lt_dados INDEX lv_tabix.
*                      DELETE lt_fam INDEX lv_tabix1.
                    ELSE.
                      DATA(lv_familia_ok) = abap_true.
                    ENDIF.
                  ENDIF.
                ELSE.
                  DELETE lt_dados INDEX lv_tabix.
                ENDIF.
              ENDLOOP.
              UNASSIGN <fs_fam>.
            ENDLOOP.

            IF NOT lv_familia_ok IS INITIAL.
              DELETE lt_dados WHERE familiacl IS INITIAL.
              DELETE lt_fam WHERE familia_cl IS INITIAL.
              IF lv_count_familia > 1.
                TRY.
                    SORT lt_fam BY prazo.
                    lv_familia = lt_fam[ 1 ]-familia_cl.
                    DELETE lt_dados WHERE familiacl NE lv_familia.
                  CATCH cx_sy_itab_line_not_found.
                ENDTRY.
              ENDIF.
            ENDIF.
*          ELSE.
*             REFRESH lt_dados.
          ENDIF.

          REFRESH lt_familiacl.

*          DATA(lt_dados_aux) = lt_dados.
*          DELETE lt_dados_aux[] WHERE familiacl = space.
          LOOP AT lt_dados ASSIGNING FIELD-SYMBOL(<fs_dados>).
            APPEND VALUE #( sign = 'I' option = 'EQ' low = <fs_dados>-familiacl ) TO lt_familiacl.
          ENDLOOP.
        ENDIF.


        SORT lt_dados BY prazo ASCENDING.
        LOOP AT lt_dados ASSIGNING FIELD-SYMBOL(<fs_item>).

          "Se tiver múltiplas correspondências com prazos diferentes, pegaremos o menor prazo.
          IF sy-tabix = 1.
            lv_prazo_selecionado = <fs_item>-prazo.
            lv_verificar_prazo = <fs_item>-prazo.
            IF NOT <fs_item>-datafatura IS INITIAL.
              lv_dt_fatura_contrato = <fs_item>-datafatura.
            ELSE.
              lv_dt_fatura_contrato = sy-datum.
            ENDIF.
          ELSE.
            "Se tiver múltiplas correspondências com o mesmo prazo, aplicaremos o prazo.
            IF lv_verificar_prazo = <fs_item>-prazo.
              lv_prazo_selecionado = <fs_item>-prazo.
              EXIT.
            ELSE.
              lv_verificar_prazo = <fs_item>-prazo.
            ENDIF.
          ENDIF.
          APPEND VALUE #( doc_uuid_h = <fs_item>-docuuidh ) TO ct_doc_uuid_h.
        ENDLOOP.

        "Se não houver correspondência mas tiver uma linha com o campo FAMILIA em branco, pegaremos o prazo dessa linha se não encontrar correspondência em uma linha específica.
        IF lv_prazo_selecionado IS INITIAL.

          SELECT SINGLE
            lt_jan~prazo,
            zi_con~datafatura
          FROM
            zi_fi_prov_cont AS zi_prov
*          INNER JOIN
*            ztfi_prov_fam AS zi_fam ON ( zi_prov~docuuidh = zi_fam~doc_uuid_h AND zi_prov~docuuidprov = zi_fam~doc_uuid_prov )
          INNER JOIN
            zi_fi_contrato AS zi_con ON ( zi_prov~docuuidh = zi_con~docuuidh )
          INNER JOIN
            zi_fi_janela_cont AS lt_jan ON ( zi_prov~docuuidh = lt_jan~docuuidh )
          WHERE
*            zi_prov~empresa = @iv_vkorg AND
            zi_prov~empresa IN @lt_bukrs AND
            zi_con~grpcontratos = @ls_cliente-katr10 AND
            zi_con~status IN @lt_status AND
*            ( zi_prov~mesvigencia IS INITIAL OR zi_prov~mesvigencia = @lv_mesvigencia ) AND
            zi_prov~mesvigencia IN @lt_mes_vigenc AND
*            ( zi_prov~classificcnpj IS INITIAL OR zi_prov~classificcnpj = @ls_cliente-katr2 ) AND
*            zi_fam~familia IS INITIAL
            zi_prov~classificcnpj IN @lt_katr2 AND
            lt_jan~atributo2 IN @lt_katr2
          INTO
            @DATA(ls_dados_contrato).
          IF sy-subrc = 0.
            lv_prazo_selecionado = ls_dados_contrato-prazo.
            lv_dt_fatura_contrato = ls_dados_contrato-datafatura.
          ENDIF.
        ENDIF.

        "----- Calcular o vencimento -----

*        IF lv_prazo_contrato = 'X'.
        IF ls_cliente-kdkg1 IS NOT INITIAL.

          SELECT SINGLE
            lt_jan~diamesfixo,
            lt_jan~diasemana
          FROM
            zi_fi_prov_cont AS zi_prov
*          INNER JOIN
*            ztfi_prov_fam AS zi_fam ON ( zi_prov~docuuidh = zi_fam~doc_uuid_h AND zi_prov~docuuidprov = zi_fam~doc_uuid_prov )
          INNER JOIN
            zi_fi_contrato AS zi_con ON ( zi_prov~docuuidh = zi_con~docuuidh )
          INNER JOIN
            zi_fi_janela_cont AS lt_jan ON ( zi_prov~docuuidh = lt_jan~docuuidh )
          WHERE
*            zi_prov~empresa = @iv_vkorg AND
            zi_prov~empresa IN @lt_bukrs AND
            zi_con~grpcontratos = @ls_cliente-katr10 AND
            zi_con~status IN @lt_status AND
*            ( zi_prov~mesvigencia IS INITIAL OR zi_prov~mesvigencia = @lv_mesvigencia ) AND
*            zi_prov~mesvigencia IN @lt_mes_vigenc AND
*            ( zi_prov~classificcnpj IS INITIAL OR zi_prov~classificcnpj = @ls_cliente-katr2 ) AND
            zi_prov~classificcnpj IN @lt_katr2 AND
            lt_jan~atributo2 IN @lt_katr2 AND
            lt_jan~familiacl IN @lt_familiacl
*            ( lt_jan~diamesfixo IS NOT INITIAL OR lt_jan~diasemana IS NOT INITIAL )
          INTO
            @DATA(ls_dados_janela).

          IF sy-subrc = 0.

            SPLIT ls_dados_janela-diamesfixo AT '-' INTO TABLE lt_dias.
            DATA(lv_dia_semana) = ls_dados_janela-diasemana.

            SELECT
              "CAST( dia AS NUMC( 2 ) ) AS diamesfixo,
              dia AS diamesfixo,
              @lv_dia_semana AS diasemana
            FROM
              @lt_dias AS lt_d
            INTO TABLE
              @DATA(lt_dados_janela).
            IF NOT ls_dados_janela-diasemana IS INITIAL.
              SPLIT ls_dados_janela-diasemana AT '-' INTO TABLE lt_semana.
              LOOP AT lt_semana ASSIGNING FIELD-SYMBOL(<fs_semana>).
                APPEND INITIAL LINE TO lt_dados_janela ASSIGNING FIELD-SYMBOL(<fs_dados_janela>).
                <fs_dados_janela>-diasemana = <fs_semana>-dia.
              ENDLOOP.
            ENDIF.


          ENDIF.

          "Calcular a data base adicionando os dias do prazo
          IF lv_prazo_selecionado IS NOT INITIAL.

*            lv_day_prazo = lv_prazo_selecionado.

*            CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
*              EXPORTING
*                date      = lv_dt_fatura_contrato
*                days      = lv_day_prazo
*                months    = 0
*                signum    = '+'
*                years     = 0
*              IMPORTING
*                calc_date = lv_dt_base.

            lv_zfbdt = lv_dt_fatura_contrato.
            lv_zbd1t = lv_prazo_selecionado.

            CALL FUNCTION 'J_1B_FI_NETDUE'
              EXPORTING
                zfbdt   = lv_zfbdt
                zbd1t   = lv_zbd1t
                zbd2t   = ''
                zbd3t   = ''
              IMPORTING
                duedate = lv_dt_base.

          ELSE.
            IF lv_dt_fatura_contrato IS NOT INITIAL.
              lv_dt_base = lv_dt_fatura_contrato.
            ENDIF.
          ENDIF.

        ELSE.

          SELECT SINGLE
            lt_jan~diamesfixo,
            lt_jan~diasemana
          FROM
            zi_fi_prov_cont AS zi_prov
          INNER JOIN
            zi_fi_contrato AS zi_con ON ( zi_prov~docuuidh = zi_con~docuuidh )
          INNER JOIN
            zi_fi_janela_cont AS lt_jan ON ( zi_prov~docuuidh = lt_jan~docuuidh )
          WHERE
            zi_prov~empresa IN @lt_bukrs AND
            zi_con~grpcontratos = @ls_cliente-katr10 AND
            zi_con~status IN @lt_status AND
            lt_jan~atributo2 IN @lt_katr2
          INTO
            @ls_dados_janela.

          IF sy-subrc = 0.

            SPLIT ls_dados_janela-diamesfixo AT '-' INTO TABLE lt_dias.
            lv_dia_semana = ls_dados_janela-diasemana.

            SELECT
              dia AS diamesfixo,
              @lv_dia_semana AS diasemana
            FROM
              @lt_dias AS lt_d
            INTO TABLE
              @lt_dados_janela.
            IF NOT ls_dados_janela-diasemana IS INITIAL.
              SPLIT ls_dados_janela-diasemana AT '-' INTO TABLE lt_semana.
              LOOP AT lt_semana ASSIGNING <fs_semana>.
                APPEND INITIAL LINE TO lt_dados_janela ASSIGNING <fs_dados_janela>.
                <fs_dados_janela>-diasemana = <fs_semana>-dia.
              ENDLOOP.
            ENDIF.


          ENDIF.

          "Calcular a data base adicionando os dias do prazo
          IF lv_prazo_selecionado IS NOT INITIAL.

*            lv_day_prazo = lv_prazo_selecionado.

*            CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
*              EXPORTING
*                date      = lv_dt_fatura_contrato
*                days      = lv_day_prazo
*                months    = 0
*                signum    = '+'
*                years     = 0
*              IMPORTING
*                calc_date = lv_dt_base.

            CLEAR: lv_zfbdt,
                   lv_zbd1t.

            lv_zfbdt = lv_dt_fatura_contrato.
            lv_zbd1t = lv_prazo_selecionado.

            CALL FUNCTION 'J_1B_FI_NETDUE'
              EXPORTING
                zfbdt   = lv_zfbdt
                zbd1t   = lv_zbd1t
                zbd2t   = ''
                zbd3t   = ''
              IMPORTING
                duedate = lv_dt_base.
          ELSE.
            IF lv_dt_fatura_contrato IS NOT INITIAL.
              lv_dt_base = lv_dt_fatura_contrato.
            ENDIF.
          ENDIF.

        ENDIF.


        "SPLIT ls_dados_janela_s_cont-diafixo AT '-' INTO TABLE lt_dias.
        "lv_dia_semana = ls_dados_janela_s_cont-diasemana.

*          SELECT
*            "CAST( dia AS NUMC( 2 ) ) AS diamesfixo,
*            dia as diamesfixo,
*            @lv_dia_semana AS diasemana
*          FROM
*            @lt_dias AS lt_d
*          INTO TABLE
*            @lt_dados_janela.

*        lv_dt_base = lv_dt_fatura_contrato.

      ENDIF.

      IF lv_dt_base IS NOT INITIAL.

        CALL FUNCTION 'J_1B_FI_NETDUE'
          EXPORTING
            zfbdt   = lv_dt_base
            zbd1t   = ''
            zbd2t   = ''
            zbd3t   = ''
          IMPORTING
            duedate = lv_dt_vencto_liquido.

      ENDIF.

      LOOP AT lt_dados_janela ASSIGNING <fs_dados_janela>.
        IF strlen( <fs_dados_janela>-diamesfixo ) EQ 1.
          <fs_dados_janela>-diamesfixo = |0{ <fs_dados_janela>-diamesfixo }|.
        ENDIF.
        IF strlen( <fs_dados_janela>-diasemana ) EQ 1.
          <fs_dados_janela>-diasemana = |0{ <fs_dados_janela>-diasemana }|.
        ENDIF.
      ENDLOOP.

      "Se o campo JANELA_MES estiver preenchido, teremos que buscar o dia do mês mais próximo da data base não podendo ser um valor anterior.
      DESCRIBE TABLE lt_dados_janela LINES DATA(lv_lines).
      IF lv_lines > 1.
        SORT lt_dados_janela BY diamesfixo DESCENDING.
      ELSE.
        SORT lt_dados_janela BY diamesfixo ASCENDING.
      ENDIF.

      CLEAR lv_dt_valiacao.

      LOOP AT lt_dados_janela ASSIGNING FIELD-SYMBOL(<fs_item_jan_dia_mes>).

        IF <fs_item_jan_dia_mes>-diamesfixo IS NOT INITIAL AND lv_dt_base IS NOT INITIAL.
          IF lv_dt_valiacao IS INITIAL AND lv_dt_base+6(2) > <fs_item_jan_dia_mes>-diamesfixo.
            lv_calc_date = |{ lv_dt_base(6) }{ <fs_item_jan_dia_mes>-diamesfixo }|.
            CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
              EXPORTING
                date      = lv_calc_date
                days      = 00
                months    = 01
                years     = 00
              IMPORTING
                calc_date = lv_dt_valiacao.
*            lv_dt_valiacao = lv_dt_base(6) && <fs_item_jan_dia_mes>-diamesfixo.
          ELSE.
            IF lv_dt_base+6(2) LE <fs_item_jan_dia_mes>-diamesfixo.
              lv_dt_valiacao = |{ lv_dt_base(6) }{ <fs_item_jan_dia_mes>-diamesfixo }|.
            ENDIF.
          ENDIF.

        ENDIF.

      ENDLOOP.

      IF NOT lv_dt_valiacao IS INITIAL.
        DO.
          "Verifica se é dia de semana
          CALL FUNCTION 'DATE_COMPUTE_DAY'
            EXPORTING
              date = lv_dt_valiacao
            IMPORTING
              day  = lv_dia_sem.

          CASE lv_dia_sem.
            WHEN '6'.
              ADD 2 TO lv_dt_valiacao.
            WHEN '7'.
              ADD 1 TO lv_dt_valiacao.
            WHEN OTHERS.
              EXIT.
          ENDCASE.

          CALL FUNCTION 'DATE_CHECK_WORKINGDAY'
            EXPORTING
              date                       = lv_dt_valiacao
              factory_calendar_id        = 'BR'
              message_type               = 'I'
            EXCEPTIONS
              date_after_range           = 1
              date_before_range          = 2
              date_invalid               = 3
              date_no_workingday         = 4
              factory_calendar_not_found = 5
              message_type_invalid       = 6
              OTHERS                     = 7.
          IF sy-subrc EQ 4.
            ADD 1 TO lv_dt_valiacao.
          ENDIF.
        ENDDO.
      ENDIF.

      "Guardamos para utilizar caso não encontre a data correta da janela
*      IF lv_dia_mes_fixo IS INITIAL.
*        lv_dia_mes_fixo = <fs_item_jan_dia_mes>-diamesfixo.
*      ENDIF.

*      ENDIF.

      IF lv_dt_base_janela IS INITIAL AND
        lv_dt_valiacao IS NOT INITIAL AND
        lv_dt_valiacao >= lv_dt_vencto_liquido.

        "Encontramos a data correta
        lv_dt_base_janela = lv_dt_valiacao.
*          EXIT.

      ENDIF.


      "Chegou aqui sem a janela...
      IF lv_dt_base_janela IS INITIAL AND lv_dt_base IS NOT INITIAL.

        IF lv_dia_mes_fixo IS NOT INITIAL AND lv_dt_base IS NOT INITIAL.
          DATA(lv_mes) = lv_dt_base+4(2).
          "Se o mês for Dezembro - jogamos para Janeiro
          IF lv_mes = 12.
            lv_mes = 01.
            "Senão somamos 1 mês
          ELSE.
            lv_mes = lv_mes + 1.
          ENDIF.

          lv_dt_base_janela = lv_dt_base(4) && lv_mes && lv_dia_mes_fixo.
*          ELSE.
*            lv_dt_base_janela = sy-datum.
        ELSE.
          lv_dt_base_janela = lv_dt_base.
*          rv_data_base = lv_dt_base.
        ENDIF.

      ENDIF.

      "Se o campo JANELA_SEMANA estiver preenchido, teremos que buscar o dia da semana mais próximo da data base, não podendo ser um valor anterior.
*      CLEAR: lt_dados_janela.
*      REFRESH: lt_dados_janela.
*      SPLIT ls_dados_janela-diasemana AT '-' INTO TABLE lt_semana.
*      SELECT
*        "CAST( dia AS NUMC( 2 ) ) AS diamesfixo,
*        @lv_dia_semana AS diasemana
*      FROM
*        @lt_semana AS lt_s
*      INTO CORRESPONDING FIELDS OF TABLE
*        @lt_dados_janela.
      DESCRIBE TABLE lt_dados_janela LINES lv_lines.
      IF lv_lines > 1.
        SORT lt_dados_janela BY diasemana DESCENDING.
      ELSE.
        SORT lt_dados_janela BY diasemana ASCENDING.
      ENDIF.
      LOOP AT lt_dados_janela ASSIGNING FIELD-SYMBOL(<fs_item_jan_dia_semana>).

        CLEAR: lv_day,
               lv_day2.

        CALL FUNCTION 'DATE_COMPUTE_DAY'
          EXPORTING
            date = lv_dt_base_janela
          IMPORTING
            day  = lv_day.

        lv_day2 = lv_day.

        IF lv_day IS INITIAL.
          EXIT.
        ENDIF.

        IF strlen( lv_day2 ) EQ 1.
          lv_day2 = |0{ lv_day2 }|.
        ENDIF.

        IF <fs_item_jan_dia_semana>-diasemana IS NOT INITIAL AND
          lv_day2 = <fs_item_jan_dia_semana>-diasemana.
          lv_day_desejado = ''.
          EXIT.
        ELSEIF <fs_item_jan_dia_semana>-diasemana IS NOT INITIAL AND
          lv_day2 < <fs_item_jan_dia_semana>-diasemana.

          lv_day_add = ( <fs_item_jan_dia_semana>-diasemana - lv_day2 ).

          "Nova data ajustada
*          CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
*            EXPORTING
*              date      = lv_dt_base_janela
*              days      = lv_day_add
*              months    = 0
*              signum    = '+'
*              years     = 0
*            IMPORTING
*              calc_date = lv_dt_base_janela.

          CLEAR: lv_zfbdt,
                 lv_zbd1t.

          lv_zfbdt = lv_dt_base_janela.
          lv_zbd1t = lv_day_add.

          CALL FUNCTION 'J_1B_FI_NETDUE'
            EXPORTING
              zfbdt   = lv_zfbdt
              zbd1t   = lv_zbd1t
              zbd2t   = ''
              zbd3t   = ''
            IMPORTING
              duedate = lv_dt_base_janela.

          lv_day_desejado = ''.
          EXIT.
        ELSEIF <fs_item_jan_dia_semana>-diasemana IS NOT INITIAL AND
          lv_day2 > <fs_item_jan_dia_semana>-diasemana.
          lv_day_desejado = <fs_item_jan_dia_semana>-diasemana.
        ENDIF.

      ENDLOOP.

      IF lv_day_desejado IS NOT INITIAL AND lv_dt_base_janela IS NOT INITIAL.

        CLEAR: lv_day2.

        "Vamos adicionando 1 dia na data até chegar no dia desejado
        WHILE lv_day_desejado <> lv_day2.

          CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
            EXPORTING
              date      = lv_dt_base_janela
              days      = 1
              months    = 0
              signum    = '+'
              years     = 0
            IMPORTING
              calc_date = lv_dt_base_janela.

          IF lv_dt_base_janela IS INITIAL.
            EXIT.
          ENDIF.

          CALL FUNCTION 'DATE_COMPUTE_DAY'
            EXPORTING
              date = lv_dt_base_janela
            IMPORTING
              day  = lv_day.

          IF lv_day IS INITIAL.
            EXIT.
          ENDIF.

          lv_day2 = lv_day.

          IF strlen( lv_day2 ) EQ 1.
            lv_day2 = |0{ lv_day2 }|.
          ENDIF.

        ENDWHILE.
      ENDIF.

      "Última validação que fazemos é verificar se o dia do vencimento é um dia útil, não sendo buscamos o próximo dia útil pela BAPI abaixo.

      IF lv_dt_base_janela IS NOT INITIAL.

        CALL FUNCTION 'DATE_CONVERT_TO_FACTORYDATE'
          EXPORTING
            date                         = lv_dt_base_janela
            factory_calendar_id          = 'BR'
          IMPORTING
            date                         = lv_data_final
          EXCEPTIONS
            calendar_buffer_not_loadable = 1
            correct_option_invalid       = 2
            date_after_range             = 3
            date_before_range            = 4
            date_invalid                 = 5
            factory_calendar_not_found   = 6
            OTHERS                       = 7.

        IF sy-subrc = 0.
          "lv_data_final = sy-datum.
          rv_data_base = lv_data_final.
        ENDIF.

      ENDIF.

******
      IF ls_cliente-kdkg1 IS NOT INITIAL.
        SELECT SINGLE
          diafixo,
          diasemana
        FROM
          zi_fi_clientes_sem_contrato
        WHERE
          bukrs = @iv_vkorg AND
          kunnr = @iv_kunnr
        INTO
          @DATA(ls_dados_janela_s_cont).

        IF sy-subrc = 0.

          "Na tabela acima só pode ser cadastrado dia fixo ou dia semana, então vamos verificar qual campo contém o valor "-" para transformar em tabela
          IF ls_dados_janela_s_cont-diafixo CA '-'.
            SPLIT ls_dados_janela_s_cont-diafixo AT '-' INTO TABLE lt_dias.
            lv_dia_semana = ls_dados_janela_s_cont-diasemana.

            SELECT
              "CAST( dia AS NUMC( 2 ) ) AS diamesfixo,
              dia AS diamesfixo,
              @lv_dia_semana AS diasemana
            FROM
              @lt_dias AS lt_d
            INTO TABLE
              @lt_dados_janela.

          ELSEIF ls_dados_janela_s_cont-diasemana CA '-'.
            SPLIT ls_dados_janela_s_cont-diasemana AT '-' INTO TABLE lt_dias.
            DATA(lv_dia_fixo) = ls_dados_janela_s_cont-diafixo.

            SELECT
              "CAST( dia AS NUMC( 2 ) ) AS diamesfixo,
              @lv_dia_fixo AS diamesfixo,
              dia AS diasemana
            FROM
              @lt_dias AS lt_d
            INTO TABLE
              @lt_dados_janela.

          ELSE.

            APPEND VALUE #( diamesfixo = ls_dados_janela_s_cont-diafixo
                            diasemana = ls_dados_janela_s_cont-diasemana ) TO lt_dados_janela.

          ENDIF.
*          READ TABLE ct_xaccit ASSIGNING FIELD-SYMBOL(<fs_xaccit>) WITH KEY posnr = '0000000001'.
*          IF sy-subrc = 0.
*            lv_dt_base = <fs_xaccit>-zfbdt + <fs_xaccit>-zbd1t.
*          ENDIF.

        ENDIF.


*        lv_posnr = '0000000001'.
        SORT ct_xaccit BY posnr ASCENDING.
        LOOP AT ct_xaccit ASSIGNING FIELD-SYMBOL(<fs_xaccit>).
          IF NOT <fs_xaccit>-zbd1t IS INITIAL AND rv_data_base IS INITIAL.
            IF <fs_xaccit>-posnr > '0000001000'.
              EXIT.
            ENDIF.
            lv_dt_base = <fs_xaccit>-zfbdt + <fs_xaccit>-zbd1t.

            IF lv_dt_base IS NOT INITIAL.

              CALL FUNCTION 'J_1B_FI_NETDUE'
                EXPORTING
                  zfbdt   = lv_dt_base
                  zbd1t   = ''
                  zbd2t   = ''
                  zbd3t   = ''
                IMPORTING
                  duedate = lv_dt_vencto_liquido.

            ENDIF.

            LOOP AT lt_dados_janela ASSIGNING <fs_dados_janela>.
              IF strlen( <fs_dados_janela>-diamesfixo ) EQ 1.
                <fs_dados_janela>-diamesfixo = |0{ <fs_dados_janela>-diamesfixo }|.
              ENDIF.
              IF strlen( <fs_dados_janela>-diasemana ) EQ 1.
                <fs_dados_janela>-diasemana = |0{ <fs_dados_janela>-diasemana }|.
              ENDIF.
            ENDLOOP.

            "Se o campo JANELA_MES estiver preenchido, teremos que buscar o dia do mês mais próximo da data base não podendo ser um valor anterior.
            DESCRIBE TABLE lt_dados_janela LINES lv_lines.
            IF lv_lines > 1.
              SORT lt_dados_janela BY diamesfixo DESCENDING.
            ELSE.
              SORT lt_dados_janela BY diamesfixo ASCENDING.
            ENDIF.

            CLEAR lv_dt_valiacao.

            LOOP AT lt_dados_janela ASSIGNING FIELD-SYMBOL(<fs_item_jan_dia_mes1>).

              IF <fs_item_jan_dia_mes1>-diamesfixo IS NOT INITIAL AND lv_dt_base IS NOT INITIAL.
                IF lv_dt_valiacao IS INITIAL AND lv_dt_base+6(2) > <fs_item_jan_dia_mes1>-diamesfixo.
                  lv_calc_date = |{ lv_dt_base(6) }{ <fs_item_jan_dia_mes1>-diamesfixo }|.
                  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
                    EXPORTING
                      date      = lv_calc_date
                      days      = 00
                      months    = 01
                      years     = 00
                    IMPORTING
                      calc_date = lv_dt_valiacao.
*            lv_dt_valiacao = lv_dt_base(6) && <fs_item_jan_dia_mes>-diamesfixo.
                ELSE.
                  IF <fs_item_jan_dia_mes1>-diamesfixo LE lv_dt_valiacao+6(2).
                    IF NOT lv_dt_valiacao IS INITIAL.
                      lv_dt_valiacao = |{ lv_dt_valiacao(6) }{ <fs_item_jan_dia_mes1>-diamesfixo }|.
                    ELSE.
                      IF <fs_item_jan_dia_mes1>-diamesfixo LE lv_dt_base+6(2).
                        lv_dt_valiacao = |{ lv_dt_base(6) }{ <fs_item_jan_dia_mes1>-diamesfixo }|.
                      ENDIF.
                    ENDIF.
                  ENDIF.
                ENDIF.

              ENDIF.

            ENDLOOP.

            IF NOT lv_dt_valiacao IS INITIAL.
              DO.
                "Verifica se é dia de semana
                CALL FUNCTION 'DATE_COMPUTE_DAY'
                  EXPORTING
                    date = lv_dt_valiacao
                  IMPORTING
                    day  = lv_dia_sem.

                CASE lv_dia_sem.
                  WHEN '6'.
                    ADD 2 TO lv_dt_valiacao.
                  WHEN '7'.
                    ADD 1 TO lv_dt_valiacao.
                  WHEN OTHERS.
                    EXIT.
                ENDCASE.

                CALL FUNCTION 'DATE_CHECK_WORKINGDAY'
                  EXPORTING
                    date                       = lv_dt_valiacao
                    factory_calendar_id        = 'BR'
                    message_type               = 'I'
                  EXCEPTIONS
                    date_after_range           = 1
                    date_before_range          = 2
                    date_invalid               = 3
                    date_no_workingday         = 4
                    factory_calendar_not_found = 5
                    message_type_invalid       = 6
                    OTHERS                     = 7.
                IF sy-subrc EQ 4.
                  ADD 1 TO lv_dt_valiacao.
                ENDIF.
              ENDDO.
            ENDIF.

            "Guardamos para utilizar caso não encontre a data correta da janela
*                IF lv_dia_mes_fixo IS INITIAL.
*                  lv_dia_mes_fixo = <fs_item_jan_dia_mes1>-diamesfixo.
*                ENDIF.

            IF lv_dt_base_janela IS INITIAL AND
              lv_dt_valiacao IS NOT INITIAL AND
              lv_dt_valiacao >= lv_dt_vencto_liquido.

              "Encontramos a data correta
              lv_dt_base_janela = lv_dt_valiacao.
            ELSE.
              lv_dt_base_janela = lv_dt_base.
              EXIT.

            ENDIF.


            "Chegou aqui sem a janela...
            IF lv_dt_base_janela IS INITIAL.

              IF lv_dia_mes_fixo IS NOT INITIAL AND lv_dt_base IS NOT INITIAL.
                lv_mes = lv_dt_base+4(2).
                "Se o mês for Dezembro - jogamos para Janeiro
                IF lv_mes = 12.
                  lv_mes = 01.
                  "Senão somamos 1 mês
                ELSE.
                  lv_mes = lv_mes + 1.
                ENDIF.

                lv_dt_base_janela = lv_dt_base(4) && lv_mes && lv_dia_mes_fixo.
*          ELSE.
*            lv_dt_base_janela = sy-datum.
              ELSE.
                rv_data_base = lv_dt_base.
              ENDIF.

            ENDIF.

            get_data_base(
                EXPORTING
                  iv_dt_base_janela = lv_dt_base_janela
                  it_dados_janela   = lt_dados_janela
                CHANGING
                  cv_data_base      = rv_data_base ).

          ELSE.
            IF <fs_xaccit>-posnr > '0000001000'.
              EXIT.
            ENDIF.
            IF rv_data_base IS NOT INITIAL.
              <fs_xaccit>-zfbdt = rv_data_base.
              <fs_xaccit>-zbd1t = 0.
              <fs_xaccit>-zbd2t = 0.
            ENDIF.
*          ADD 1 TO lv_posnr.
          ENDIF.
        ENDLOOP.
      ELSE.
        SORT ct_xaccit BY posnr ASCENDING.
        LOOP AT ct_xaccit ASSIGNING <fs_xaccit>.
          IF <fs_xaccit>-posnr > '0000001000'.
            EXIT.
          ENDIF.
          IF rv_data_base IS NOT INITIAL.
            <fs_xaccit>-zfbdt = rv_data_base.
            <fs_xaccit>-zbd1t = 0.
            <fs_xaccit>-zbd2t = 0.
          ENDIF.
        ENDLOOP.
      ENDIF.

******


    ELSE.

      IF ls_cliente-kdkg1 IS NOT INITIAL.
        SELECT SINGLE
          diafixo,
          diasemana
        FROM
          zi_fi_clientes_sem_contrato
        WHERE
          bukrs = @iv_vkorg AND
          kunnr = @iv_kunnr
        INTO
          @ls_dados_janela_s_cont.

        IF sy-subrc = 0.

          "Na tabela acima só pode ser cadastrado dia fixo ou dia semana, então vamos verificar qual campo contém o valor "-" para transformar em tabela
          IF ls_dados_janela_s_cont-diafixo CA '-'.
            SPLIT ls_dados_janela_s_cont-diafixo AT '-' INTO TABLE lt_dias.
            lv_dia_semana = ls_dados_janela_s_cont-diasemana.

            SELECT
              "CAST( dia AS NUMC( 2 ) ) AS diamesfixo,
              dia AS diamesfixo,
              @lv_dia_semana AS diasemana
            FROM
              @lt_dias AS lt_d
            INTO TABLE
              @lt_dados_janela.

          ELSEIF ls_dados_janela_s_cont-diasemana CA '-'.
            SPLIT ls_dados_janela_s_cont-diasemana AT '-' INTO TABLE lt_dias.
            lv_dia_fixo = ls_dados_janela_s_cont-diafixo.

            SELECT
              "CAST( dia AS NUMC( 2 ) ) AS diamesfixo,
              @lv_dia_fixo AS diamesfixo,
              dia AS diasemana
            FROM
              @lt_dias AS lt_d
            INTO TABLE
              @lt_dados_janela.

          ELSE.

            APPEND VALUE #( diamesfixo = ls_dados_janela_s_cont-diafixo
                            diasemana = ls_dados_janela_s_cont-diasemana ) TO lt_dados_janela.

          ENDIF.
*          READ TABLE ct_xaccit ASSIGNING FIELD-SYMBOL(<fs_xaccit>) WITH KEY posnr = '0000000001'.
*          IF sy-subrc = 0.
*            lv_dt_base = <fs_xaccit>-zfbdt + <fs_xaccit>-zbd1t.
*          ENDIF.

        ELSE.
          RETURN.
        ENDIF.

*        lv_posnr = '0000000001'.
        SORT ct_xaccit BY posnr ASCENDING.
        LOOP AT ct_xaccit ASSIGNING <fs_xaccit>.
          IF <fs_xaccit>-posnr > '0000001000'.
            EXIT.
          ENDIF.
          lv_dt_base = <fs_xaccit>-zfbdt + <fs_xaccit>-zbd1t.

          IF lv_dt_base IS NOT INITIAL.

            CALL FUNCTION 'J_1B_FI_NETDUE'
              EXPORTING
                zfbdt   = lv_dt_base
                zbd1t   = ''
                zbd2t   = ''
                zbd3t   = ''
              IMPORTING
                duedate = lv_dt_vencto_liquido.

          ENDIF.

          LOOP AT lt_dados_janela ASSIGNING <fs_dados_janela>.
            IF NOT <fs_dados_janela>-diamesfixo IS INITIAL.
              IF strlen( <fs_dados_janela>-diamesfixo ) EQ 1.
                <fs_dados_janela>-diamesfixo = |0{ <fs_dados_janela>-diamesfixo }|.
              ENDIF.
              DATA(lv_diasmesfixo) = abap_true.
            ENDIF.
            IF NOT <fs_dados_janela>-diasemana IS INITIAL.
              IF strlen( <fs_dados_janela>-diasemana ) EQ 1.
                <fs_dados_janela>-diasemana = |0{ <fs_dados_janela>-diasemana }|.
              ENDIF.
              DATA(lv_diasemana) = abap_true.
            ENDIF.
          ENDLOOP.

          IF NOT lv_diasmesfixo IS INITIAL.

            "Se o campo JANELA_MES estiver preenchido, teremos que buscar o dia do mês mais próximo da data base não podendo ser um valor anterior.
            DESCRIBE TABLE lt_dados_janela LINES lv_lines.
            IF lv_lines > 1.
              SORT lt_dados_janela BY diamesfixo DESCENDING.
            ELSE.
              SORT lt_dados_janela BY diamesfixo ASCENDING.
            ENDIF.

            CLEAR lv_dt_valiacao.

            LOOP AT lt_dados_janela ASSIGNING <fs_item_jan_dia_mes1>.

              IF <fs_item_jan_dia_mes1>-diamesfixo IS NOT INITIAL AND lv_dt_base IS NOT INITIAL.
                IF lv_dt_valiacao IS INITIAL AND lv_dt_base+6(2) > <fs_item_jan_dia_mes1>-diamesfixo.
                  lv_calc_date = |{ lv_dt_base(6) }{ <fs_item_jan_dia_mes1>-diamesfixo }|.
                  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
                    EXPORTING
                      date      = lv_calc_date
                      days      = 00
                      months    = 01
                      years     = 00
                    IMPORTING
                      calc_date = lv_dt_valiacao.
*            lv_dt_valiacao = lv_dt_base(6) && <fs_item_jan_dia_mes>-diamesfixo.
                ELSE.
                  IF <fs_item_jan_dia_mes1>-diamesfixo LE lv_dt_valiacao+6(2).
                    IF NOT lv_dt_valiacao IS INITIAL.
                      lv_dt_valiacao = |{ lv_dt_valiacao(6) }{ <fs_item_jan_dia_mes1>-diamesfixo }|.
                    ELSE.
                      IF <fs_item_jan_dia_mes1>-diamesfixo LE lv_dt_base+6(2).
                        lv_dt_valiacao = |{ lv_dt_base(6) }{ <fs_item_jan_dia_mes1>-diamesfixo }|.
                      ENDIF.
                    ENDIF.
                  ENDIF.
                ENDIF.

              ENDIF.

            ENDLOOP.

            IF NOT lv_dt_valiacao IS INITIAL.
              DO.
                "Verifica se é dia de semana
                CALL FUNCTION 'DATE_COMPUTE_DAY'
                  EXPORTING
                    date = lv_dt_valiacao
                  IMPORTING
                    day  = lv_dia_sem.

                CASE lv_dia_sem.
                  WHEN '6'.
                    ADD 2 TO lv_dt_valiacao.
                  WHEN '7'.
                    ADD 1 TO lv_dt_valiacao.
                  WHEN OTHERS.
                    EXIT.
                ENDCASE.

                CALL FUNCTION 'DATE_CHECK_WORKINGDAY'
                  EXPORTING
                    date                       = lv_dt_valiacao
                    factory_calendar_id        = 'BR'
                    message_type               = 'I'
                  EXCEPTIONS
                    date_after_range           = 1
                    date_before_range          = 2
                    date_invalid               = 3
                    date_no_workingday         = 4
                    factory_calendar_not_found = 5
                    message_type_invalid       = 6
                    OTHERS                     = 7.
                IF sy-subrc EQ 4.
                  ADD 1 TO lv_dt_valiacao.
                ENDIF.
              ENDDO.
            ENDIF.

            "Guardamos para utilizar caso não encontre a data correta da janela
*              IF lv_dia_mes_fixo IS INITIAL.
*                lv_dia_mes_fixo = <fs_item_jan_dia_mes1>-diamesfixo.
*              ENDIF.

            IF lv_dt_base_janela IS INITIAL AND
              lv_dt_valiacao IS NOT INITIAL AND
              lv_dt_valiacao >= lv_dt_vencto_liquido.

              "Encontramos a data correta
              lv_dt_base_janela = lv_dt_valiacao.
            ELSE.
              lv_dt_base_janela = lv_dt_base.
***            EXIT.

            ENDIF.

            get_data_base(
                EXPORTING
                  iv_dt_base_janela = lv_dt_base_janela
                  it_dados_janela   = lt_dados_janela
                CHANGING
                  cv_data_base      = rv_data_base ).

            "Chegou aqui sem a janela...
            IF lv_dt_base_janela IS INITIAL.

              IF lv_dia_mes_fixo IS NOT INITIAL AND lv_dt_base IS NOT INITIAL.
                lv_mes = lv_dt_base+4(2).
                "Se o mês for Dezembro - jogamos para Janeiro
                IF lv_mes = 12.
                  lv_mes = 01.
                  "Senão somamos 1 mês
                ELSE.
                  lv_mes = lv_mes + 1.
                ENDIF.

                lv_dt_base_janela = lv_dt_base(4) && lv_mes && lv_dia_mes_fixo.
*          ELSE.
*            lv_dt_base_janela = sy-datum.
              ELSE.
                rv_data_base = lv_dt_base.
              ENDIF.

            ENDIF.

          ELSEIF NOT lv_diasemana IS INITIAL.

            DESCRIBE TABLE lt_dados_janela LINES lv_lines.
            IF lv_lines > 1.
              SORT lt_dados_janela BY diasemana DESCENDING.
            ELSE.
              SORT lt_dados_janela BY diasemana ASCENDING.
            ENDIF.

            lv_dt_base_janela = lv_dt_base.

            LOOP AT lt_dados_janela ASSIGNING <fs_item_jan_dia_semana>.

              CLEAR: lv_day,
                     lv_day2.

              CALL FUNCTION 'DATE_COMPUTE_DAY'
                EXPORTING
                  date = lv_dt_base_janela
                IMPORTING
                  day  = lv_day.

              lv_day2 = lv_day.

              IF lv_day IS INITIAL.
                EXIT.
              ENDIF.

              IF strlen( lv_day2 ) EQ 1.
                lv_day2 = |0{ lv_day2 }|.
              ENDIF.

              IF <fs_item_jan_dia_semana>-diasemana IS NOT INITIAL AND
                lv_day2 = <fs_item_jan_dia_semana>-diasemana.
                lv_day_desejado = ''.
                EXIT.
              ELSEIF <fs_item_jan_dia_semana>-diasemana IS NOT INITIAL AND
                lv_day2 < <fs_item_jan_dia_semana>-diasemana.

                lv_day_add = ( <fs_item_jan_dia_semana>-diasemana - lv_day2 ).

                CLEAR: lv_zfbdt,
                       lv_zbd1t.

                lv_zfbdt = lv_dt_base_janela.
                lv_zbd1t = lv_day_add.

                CALL FUNCTION 'J_1B_FI_NETDUE'
                  EXPORTING
                    zfbdt   = lv_zfbdt
                    zbd1t   = lv_zbd1t
                    zbd2t   = ''
                    zbd3t   = ''
                  IMPORTING
                    duedate = lv_dt_base_janela.

                lv_day_desejado = ''.
                EXIT.
              ELSEIF <fs_item_jan_dia_semana>-diasemana IS NOT INITIAL AND
                lv_day2 > <fs_item_jan_dia_semana>-diasemana.
                lv_day_desejado = <fs_item_jan_dia_semana>-diasemana.
              ENDIF.

            ENDLOOP.

            IF lv_day_desejado IS NOT INITIAL AND lv_dt_base_janela IS NOT INITIAL.

              CLEAR: lv_day2.

              "Vamos adicionando 1 dia na data até chegar no dia desejado
              WHILE lv_day_desejado <> lv_day2.

                CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
                  EXPORTING
                    date      = lv_dt_base_janela
                    days      = 1
                    months    = 0
                    signum    = '+'
                    years     = 0
                  IMPORTING
                    calc_date = lv_dt_base_janela.

                IF lv_dt_base_janela IS INITIAL.
                  EXIT.
                ENDIF.

                CALL FUNCTION 'DATE_COMPUTE_DAY'
                  EXPORTING
                    date = lv_dt_base_janela
                  IMPORTING
                    day  = lv_day.

                IF lv_day IS INITIAL.
                  EXIT.
                ENDIF.

                lv_day2 = lv_day.

                IF strlen( lv_day2 ) EQ 1.
                  lv_day2 = |0{ lv_day2 }|.
                ENDIF.

              ENDWHILE.
            ENDIF.

            "Última validação que fazemos é verificar se o dia do vencimento é um dia útil, não sendo buscamos o próximo dia útil pela BAPI abaixo.

            IF lv_dt_base_janela IS NOT INITIAL.

              CALL FUNCTION 'DATE_CONVERT_TO_FACTORYDATE'
                EXPORTING
                  date                         = lv_dt_base_janela
                  factory_calendar_id          = 'BR'
                IMPORTING
                  date                         = lv_data_final
                EXCEPTIONS
                  calendar_buffer_not_loadable = 1
                  correct_option_invalid       = 2
                  date_after_range             = 3
                  date_before_range            = 4
                  date_invalid                 = 5
                  factory_calendar_not_found   = 6
                  OTHERS                       = 7.

              IF sy-subrc = 0.
                "lv_data_final = sy-datum.
                rv_data_base = lv_data_final.
              ENDIF.

            ENDIF.

          ELSE.

            IF NOT lv_dt_base IS INITIAL.
              rv_data_base = lv_dt_base.
            ENDIF.

          ENDIF.

          <fs_xaccit>-zfbdt = rv_data_base.
          <fs_xaccit>-zbd1t = 0.
          <fs_xaccit>-zbd2t = 0.
*          ADD 1 TO lv_posnr.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD calcular_taxa_item.

    DATA: lt_bukrs      TYPE RANGE OF bukrs,
          lt_mes_vigenc TYPE RANGE OF ze_mes_vigenc_range,
          lt_familia    TYPE RANGE OF char2.

    DATA lv_mesvigencia TYPE ze_mes_vigenc_range.

    DATA: lv_result   TYPE acbtr_rw,
          lv_desconto TYPE acbtr_rw.


    IF ct_doc_uuid_h IS INITIAL.

      LOOP AT it_vbrpvb ASSIGNING FIELD-SYMBOL(<fs_familia>).
        APPEND VALUE #( sign = 'I' option = 'EQ' low = <fs_familia>-prctr(2) ) TO lt_familia.
      ENDLOOP.

      lv_mesvigencia = sy-datum+4(2).

      DATA(ls_cliente) = get_cliente( EXPORTING iv_kunnr = iv_kunnr ).

      IF NOT iv_vkorg IS INITIAL.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = iv_vkorg high = space ) TO lt_bukrs.
      ENDIF.

      IF NOT lv_mesvigencia IS INITIAL.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = lv_mesvigencia high = space ) TO lt_mes_vigenc.
      ENDIF.
      APPEND VALUE #( sign = 'I' option = 'EQ' low = space high = space ) TO lt_mes_vigenc.

      SELECT
        zi_fi_prov_cont~*
      FROM zi_fi_prov_cont
      INNER JOIN zi_fi_contrato ON zi_fi_contrato~docuuidh = zi_fi_prov_cont~docuuidh
      LEFT JOIN ztfi_prov_fam ON ztfi_prov_fam~doc_uuid_h = zi_fi_prov_cont~docuuidh
                             AND ztfi_prov_fam~doc_uuid_prov = zi_fi_prov_cont~docuuidprov
      WHERE zi_fi_prov_cont~grupcontrato  = @ls_cliente-katr10
        AND ( zi_fi_prov_cont~classificcnpj = '' OR zi_fi_prov_cont~classificcnpj = @ls_cliente-katr2 )
        AND ( ztfi_prov_fam~familia IS NULL OR ztfi_prov_fam~familia IN @lt_familia )
        AND zi_fi_contrato~bukrs IN @lt_bukrs
        AND zi_fi_prov_cont~mesvigencia IN @lt_mes_vigenc
        AND zi_fi_prov_cont~tipoapuracao EQ 'N'
      INTO TABLE @DATA(lt_dados).

      LOOP AT lt_dados ASSIGNING FIELD-SYMBOL(<fs_dados>).
        APPEND VALUE #( doc_uuid_h = <fs_dados>-docuuidh ) TO ct_doc_uuid_h.
      ENDLOOP.

    ENDIF.

    CLEAR lv_result.
    LOOP AT it_vbrpvb ASSIGNING FIELD-SYMBOL(<fs_vbrpvb>).
      lv_result += <fs_vbrpvb>-zzkzwi2.
    ENDLOOP.

    IF lv_result > 0.
      DATA(lt_xaccit) = ct_xaccit[].
      DELETE lt_xaccit WHERE posnr GE '0000001000'.
      DESCRIBE TABLE lt_xaccit LINES DATA(lv_lines).
      LOOP AT ct_xaccit ASSIGNING FIELD-SYMBOL(<fs_xaccit>) WHERE posnr LT '0000001000'.
        READ TABLE ct_xacccr ASSIGNING FIELD-SYMBOL(<fs_xacccr>) WITH KEY posnr = <fs_xaccit>-posnr.
        IF sy-subrc EQ 0.
          lv_desconto = lv_result * 100 / <fs_xacccr>-wrbtr.
          <fs_xaccit>-zbd1p = lv_desconto / lv_lines.
          <fs_xacccr>-skfbt = <fs_xacccr>-wrbtr.
        ENDIF.
      ENDLOOP.
    ELSE.
      LOOP AT ct_xacccr ASSIGNING <fs_xacccr> WHERE posnr LT '0000001000'.
        <fs_xacccr>-skfbt = <fs_xacccr>-wrbtr.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD get_data_base.

    DATA: lv_day            TYPE scal-indicator,
          lv_day2           TYPE char02,
          lv_day_add        TYPE t5a4a-dlydy,
          lv_dt_base_janela TYPE dzfbdt,
          lv_day_desejado   TYPE char02,
          lv_data_final     TYPE scal-date.


    DATA(lt_dados_janela) = it_dados_janela.
    lv_dt_base_janela = iv_dt_base_janela.

    "Se o campo JANELA_SEMANA estiver preenchido, teremos que buscar o dia da semana mais próximo da data base, não podendo ser um valor anterior.
    SORT lt_dados_janela BY diasemana ASCENDING.
    LOOP AT lt_dados_janela ASSIGNING FIELD-SYMBOL(<fs_item_jan_dia_semana>).

      CLEAR lv_day.

      CALL FUNCTION 'DATE_COMPUTE_DAY'
        EXPORTING
          date = lv_dt_base_janela
        IMPORTING
          day  = lv_day.

      IF lv_day IS INITIAL.
        EXIT.
      ENDIF.

      lv_day2 = lv_day.

      IF strlen( lv_day2 ) EQ 1.
        lv_day2 = |0{ lv_day2 }|.
      ENDIF.

      IF <fs_item_jan_dia_semana>-diasemana IS NOT INITIAL AND
        lv_day2 = <fs_item_jan_dia_semana>-diasemana.
        lv_day_desejado = ''.
        EXIT.
      ELSEIF <fs_item_jan_dia_semana>-diasemana IS NOT INITIAL AND
        lv_day2 < <fs_item_jan_dia_semana>-diasemana.

        lv_day_add = ( <fs_item_jan_dia_semana>-diasemana - lv_day2 ).

        "Nova data ajustada
        CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
          EXPORTING
            date      = lv_dt_base_janela
            days      = lv_day_add
            months    = 0
            signum    = '+'
            years     = 0
          IMPORTING
            calc_date = lv_dt_base_janela.

        lv_day_desejado = ''.
        EXIT.
      ELSEIF <fs_item_jan_dia_semana>-diasemana IS NOT INITIAL AND
        lv_day2 > <fs_item_jan_dia_semana>-diasemana.
        lv_day_desejado = <fs_item_jan_dia_semana>-diasemana.
      ENDIF.

    ENDLOOP.

    IF lv_day_desejado IS NOT INITIAL AND lv_dt_base_janela IS NOT INITIAL.

      CLEAR: lv_day2.

      "Vamos adicionando 1 dia na data até chegar no dia desejado
      WHILE lv_day_desejado <> lv_day2.

        CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
          EXPORTING
            date      = lv_dt_base_janela
            days      = 1
            months    = 0
            signum    = '+'
            years     = 0
          IMPORTING
            calc_date = lv_dt_base_janela.

        IF lv_dt_base_janela IS INITIAL.
          EXIT.
        ENDIF.

        CLEAR lv_day.
        CALL FUNCTION 'DATE_COMPUTE_DAY'
          EXPORTING
            date = lv_dt_base_janela
          IMPORTING
            day  = lv_day.

        IF lv_day IS INITIAL.
          EXIT.
        ENDIF.

        lv_day2 = lv_day.

        IF strlen( lv_day2 ) EQ 1.
          lv_day2 = |0{ lv_day2 }|.
        ENDIF.

      ENDWHILE.
    ENDIF.

    "Última validação que fazemos é verificar se o dia do vencimento é um dia útil, não sendo buscamos o próximo dia útil pela BAPI abaixo.

    IF lv_dt_base_janela IS NOT INITIAL.

      CALL FUNCTION 'DATE_CONVERT_TO_FACTORYDATE'
        EXPORTING
          date                         = lv_dt_base_janela
          factory_calendar_id          = 'BR'
        IMPORTING
          date                         = lv_data_final
        EXCEPTIONS
          calendar_buffer_not_loadable = 1
          correct_option_invalid       = 2
          date_after_range             = 3
          date_before_range            = 4
          date_invalid                 = 5
          factory_calendar_not_found   = 6
          OTHERS                       = 7.

      IF sy-subrc = 0.
        cv_data_base = lv_data_final.
      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
