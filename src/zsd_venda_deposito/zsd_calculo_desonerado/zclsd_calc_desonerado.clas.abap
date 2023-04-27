CLASS zclsd_calc_desonerado DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! Método principal da classe
    "! @parameter IS_HEADER         | Dados do cabeçalho da nota
    "! @parameter IT_NFLIN          | Dados dos itens da nota
    "! @parameter IT_NFSTX          | Dados dos impostos da nota
    "! @parameter IT_VBRP           | Dados da fatura da nota
    "! @parameter CT_ITEM           | Retorno dos itens
    METHODS execute
      IMPORTING
        !is_header     TYPE j_1bnfdoc
        !it_nflin      TYPE j_1bnflin_tab
        !it_nfstx      TYPE j_1bnfstx_tab
        VALUE(it_vbrp) TYPE vbrp_tab OPTIONAL
        VALUE(it_mseg) TYPE ty_t_mseg OPTIONAL
      CHANGING
        !ct_item       TYPE j_1bnf_badi_item_tab .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_rate,
        docnum TYPE j_1bdocnum,
        itmnum TYPE j_1bitmnum,
        rate   TYPE j_1btxrate,
      END OF ty_rate .

    DATA gs_header TYPE j_1bnfdoc .
    DATA gt_nflin TYPE j_1bnflin_tab .
    DATA gt_nfstx TYPE j_1bnfstx_tab .
    DATA gt_vbrp TYPE vbrp_tab .
    DATA gt_item_out TYPE j_1bnf_badi_item_tab .
    DATA gt_mseg TYPE ty_t_mseg .
    DATA gs_address TYPE sadr .
    DATA gs_vbak TYPE vbak .
    CONSTANTS gc_br TYPE char2 VALUE 'BR' ##NO_TEXT.
    CONSTANTS gc_suframa TYPE char1 VALUE '7' ##NO_TEXT.
    DATA gt_j1btxic1 TYPE zctgsd_j1btxic1 .
    DATA gt_cbenef TYPE zctgsd_cbenef .
    CONSTANTS gc_icms TYPE char4 VALUE 'ICMS' ##NO_TEXT.
    CONSTANTS gc_rj TYPE char1 VALUE '1' ##NO_TEXT.
    CONSTANTS gc_convencional TYPE char1 VALUE '2' ##NO_TEXT.

    "! Salva os parametros de entrada como global
    "! @parameter IS_HEADER         | Dados do cabeçalho da nota
    "! @parameter IT_NFLIN          | Dados dos itens da nota
    "! @parameter IT_NFSTX          | Dados dos impostos da nota
    "! @parameter IT_VBRP           | Dados da fatura da nota
    "! @parameter IT_ITEM           | Retorno dos itens
    METHODS set_parameter_input
      IMPORTING
        !is_header TYPE j_1bnfdoc
        !it_nflin  TYPE j_1bnflin_tab
        !it_nfstx  TYPE j_1bnfstx_tab
        !it_vbrp   TYPE vbrp_tab
        !it_item   TYPE j_1bnf_badi_item_tab
        !it_mseg   TYPE ty_t_mseg .
    "! Seleciona dos dados para a realização dos cáculos
    METHODS select_data .
    "! Seleciona a tabela de parametro
    METHODS select_parameter_table .
    "! Realiza dos Cálculos
    METHODS process_data .
    "! Retorna a tabela de item atualizada
    "! @parameter RT_ITEM           | Retorno dos itens
    METHODS set_output
      RETURNING
        VALUE(rt_item) TYPE j_1bnf_badi_item_tab .
    METHODS get_taxsit
      IMPORTING
        !is_cbenef       TYPE ztsd_cbenef
      RETURNING
        VALUE(rv_taxsit) TYPE j_1bnflin-taxsit .
ENDCLASS.



CLASS ZCLSD_CALC_DESONERADO IMPLEMENTATION.


  METHOD execute.

    set_parameter_input( EXPORTING is_header = is_header
                                   it_nflin  = it_nflin
                                   it_nfstx  = it_nfstx
                                   it_vbrp   = it_vbrp
                                   it_mseg   = it_mseg
                                   it_item   = ct_item ).


    select_data( ).

    process_data( ).

    ct_item = set_output( ).


  ENDMETHOD.                                             "#EC CI_VALPAR


  METHOD process_data.

    DATA: lv_rate       TYPE j_1btxrate,
          lv_vicmsdeson TYPE j_1bnfe_ststcl_vicmsdeson,
          lv_taxsit_lin TYPE char2,
          lt_rate       TYPE TABLE OF ty_rate,
          ls_rate       TYPE ty_rate,
          lv_cfop       TYPE char10,
          lv_sucesso    TYPE c,
          lv_suframa    TYPE j_1bnfe_icms_exemption_reason.

    CONSTANTS lc_null TYPE c VALUE ' '.


    DATA(lt_nfstx) =  gt_nfstx.

    DATA(lt_cbenef)  = gt_cbenef.
    SORT lt_cbenef BY shipfrom cfop taxsit."direcao.

    DATA(lt_cbenef8) = gt_cbenef.
    SORT lt_cbenef8 BY shipfrom shipto cfop taxsit.

    DATA(lt_cbenef1) = gt_cbenef.
    SORT lt_cbenef1 BY shipfrom shipto auart matnr.

    DATA(lt_cbenef2) = gt_cbenef.
    SORT lt_cbenef2 BY shipfrom auart taxsit.
    DATA(lt_cbenef3) = gt_cbenef.
    SORT lt_cbenef3 BY shipfrom shipto auart taxsit.

    DATA(lt_cbenef4) = gt_cbenef.
    SORT lt_cbenef4 BY shipfrom shipto matnr taxsit.

    DATA(lt_cbenef5) = gt_cbenef.
    SORT lt_cbenef5 BY shipfrom shipto matkl taxsit.

    DATA(lt_cbenef6) = gt_cbenef.
    SORT lt_cbenef6 BY shipfrom shipto taxsit.

    DATA(lt_cbenef7) = gt_cbenef.
    SORT lt_cbenef7 BY shipfrom auart taxsit.

    SORT lt_cbenef BY shipfrom
                      shipto
                      auart
                      augru
                      matnr
                      matkl
                      bwart
                      cfop
                      taxsit.

    SORT lt_nfstx BY docnum itmnum taxgrp taxtyp.

    LOOP AT lt_nfstx ASSIGNING FIELD-SYMBOL(<fs_nfstx>).
      IF <fs_nfstx>-taxgrp = gc_icms.
        MOVE-CORRESPONDING <fs_nfstx> TO ls_rate.

        COLLECT ls_rate INTO lt_rate.
      ENDIF.
    ENDLOOP.

    SORT lt_rate BY docnum itmnum.

    CHECK gt_nflin IS NOT INITIAL.

    SELECT cfop, icms_exempt_reas FROM j_1bagn
    FOR ALL ENTRIES IN @gt_nflin
    WHERE cfop = @gt_nflin-cfop
    INTO TABLE @DATA(lt_1bagn).

    LOOP AT gt_nflin ASSIGNING FIELD-SYMBOL(<fs_nflin>).

      CLEAR: lv_sucesso, lv_vicmsdeson.

      CALL FUNCTION 'CONVERSION_EXIT_TXSIT_OUTPUT'
        EXPORTING
          input  = <fs_nflin>-taxsit
        IMPORTING
          output = lv_taxsit_lin.

      CALL FUNCTION 'CONVERSION_EXIT_CFOBR_OUTPUT'
        EXPORTING
          input  = <fs_nflin>-cfop
        IMPORTING
          output = lv_cfop.


*      READ TABLE lt_cbenef INTO DATA(ls_cbenef) WITH KEY shipfrom = gs_address-regio
*                                                         shipto   = gs_header-regio
*                                                         matkl    =  <fs_nflin>-matkl
*                                                         taxsit   =  lv_taxsit_lin
*                                                         BINARY SEARCH.
* Seleção 1 - CFOP
      READ TABLE lt_cbenef INTO DATA(ls_cbenef) WITH KEY shipfrom = gs_address-regio
                                                         shipto   = lc_null
                                                         auart    = lc_null
                                                         augru    = lc_null
                                                         matnr    = lc_null
                                                         matkl    = lc_null
                                                         bwart    = lc_null
                                                         cfop     = lv_cfop
                                                         taxsit   = lv_taxsit_lin
                                                         BINARY SEARCH.
      IF sy-subrc = 0.
        lv_sucesso = abap_true.
      ELSE.
* Seleção 1 - CFOP
        READ TABLE lt_cbenef8 INTO ls_cbenef WITH KEY shipfrom = gs_address-regio
                                                      shipto   = gs_header-regio
                                                      auart    = lc_null
                                                      augru    = lc_null
                                                      matnr    = lc_null
                                                      matkl    = lc_null
                                                      bwart    = lc_null
                                                      cfop     = lv_cfop
                                                      taxsit   = lv_taxsit_lin
                                                      BINARY SEARCH.
        IF sy-subrc = 0.
          lv_sucesso = abap_true.
        ELSE.
* Seleção 2 - Tipo de ordem/Material
          READ TABLE lt_cbenef1 INTO ls_cbenef WITH KEY shipfrom = gs_address-regio
                                                        shipto   = gs_header-regio
                                                        auart    = gs_vbak-auart
                                                        augru    = lc_null
                                                        matnr    = <fs_nflin>-matnr
                                                        matkl    = lc_null
                                                        bwart    = lc_null
                                                        cfop     = lc_null
                                                        taxsit   = lv_taxsit_lin
                                                        BINARY SEARCH.

          IF sy-subrc = 0.
            lv_sucesso = abap_true.
          ELSE.
* Seleção 3 - Tipo da ordem / Motivo
            READ TABLE lt_cbenef2 INTO ls_cbenef WITH KEY shipfrom  = gs_address-regio
                                                          shipto    = gs_header-regio
                                                          auart     = gs_vbak-auart
                                                          augru     = gs_vbak-augru
                                                          matnr     = lc_null
                                                          matkl     = lc_null
                                                          bwart     = lc_null
                                                          cfop      = lc_null
                                                          taxsit    = lv_taxsit_lin
                                                          BINARY SEARCH.
            IF sy-subrc = 0.
              lv_sucesso = abap_true.
            ELSE.

* Seleção 4 - Tipo de ordem
              READ TABLE lt_cbenef7 INTO ls_cbenef WITH KEY shipfrom  = gs_address-regio
                                                            shipto    = lc_null
                                                            auart     = gs_vbak-auart
                                                            augru     = lc_null
                                                            matnr     = lc_null
                                                            matkl     = lc_null
                                                            bwart     = lc_null
                                                            cfop      = lc_null
                                                            taxsit    = lv_taxsit_lin
                                                            BINARY SEARCH.
              IF sy-subrc = 0.
                lv_sucesso = abap_true.
              ELSE.

* Seleção 5 - Tipo de ordem/Recebedor
                READ TABLE lt_cbenef3 INTO ls_cbenef WITH KEY shipfrom = gs_address-regio
                                                              shipto   = gs_header-regio
                                                              auart    = gs_vbak-auart
                                                              augru    = lc_null
                                                              matnr    = lc_null
                                                              matkl    = lc_null
                                                              bwart    = lc_null
                                                              cfop     = lc_null
                                                              taxsit   = lv_taxsit_lin
                                                              BINARY SEARCH.
                IF sy-subrc = 0.
                  lv_sucesso = abap_true.
                ELSE.
* Seleção 6 - Cod.Material
                  READ TABLE lt_cbenef4 INTO ls_cbenef WITH KEY shipfrom = gs_address-regio
                                                                shipto   = gs_header-regio
                                                                auart    = lc_null
                                                                augru    = lc_null
                                                                matkl    = lc_null
                                                                bwart    = lc_null
                                                                cfop     = lc_null
                                                                matnr    = <fs_nflin>-matnr
                                                                taxsit   = lv_taxsit_lin
                                                                BINARY SEARCH.
                  IF sy-subrc = 0.
                    lv_sucesso = abap_true.
                  ELSE.

                    READ TABLE lt_cbenef5 INTO ls_cbenef WITH KEY shipfrom = gs_address-regio
                                                                  shipto   = gs_header-regio
                                                                  auart    = lc_null
                                                                  augru    = lc_null
                                                                  matnr    = lc_null
                                                                  matkl    = <fs_nflin>-matkl
                                                                  bwart    = lc_null
                                                                  cfop     = lc_null
                                                                  taxsit   = lv_taxsit_lin
                                                                  BINARY SEARCH.
                    IF sy-subrc = 0.
                      lv_sucesso = abap_true.
                    ELSE.

                      READ TABLE lt_cbenef6 INTO ls_cbenef WITH KEY shipfrom = gs_address-regio
                                                                    shipto   = gs_header-regio
                                                                    auart    = lc_null
                                                                    augru    = lc_null
                                                                    matnr    = lc_null
                                                                    matkl    = lc_null
                                                                    bwart    = lc_null
                                                                    cfop     = lc_null
                                                                    taxsit   = lv_taxsit_lin
                                                                    BINARY SEARCH.
                      IF sy-subrc = 0.
                        lv_sucesso = abap_true.
                      ENDIF.
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

      IF  lv_sucesso = abap_true.

        DATA(lv_taxsit) = get_taxsit( ls_cbenef ).

*      Para todos os itens da tabela IT_NFLIN onde o campo motivo desoneração (MOTDESICMS) for diferente de ‘7’

        IF <fs_nflin>-motdesicms IS INITIAL.

          <fs_nflin>-motdesicms = VALUE #( lt_1bagn[ cfop = <fs_nflin>-cfop ]-icms_exempt_reas OPTIONAL ).

        ENDIF.

        IF <fs_nflin>-motdesicms <> gc_suframa.
          READ TABLE gt_item_out ASSIGNING FIELD-SYMBOL(<fs_item>) WITH KEY itmnum = <fs_nflin>-itmnum BINARY SEARCH.
          IF sy-subrc IS INITIAL.

            IF ls_cbenef-cbenef <> space.

              IF NOT ls_cbenef IS INITIAL.
                DATA(lv_tipo_calc) = ls_cbenef-tipo_calc.
                DATA(ls_parameter) = ls_cbenef.
              ENDIF.

            ELSE.
              lv_tipo_calc = 2.
            ENDIF.

**          Determinar código de benefício para CST's 10, 51 e 60
*            IF   <fs_nflin>-taxsit = '1' OR
*                 <fs_nflin>-taxsit = 'B' OR
*                 <fs_nflin>-taxsit = '6'.
**            Verificar se código de benefício não foi determinado pelo “Standard”
*              IF <fs_nflin>-cbenef = space AND <fs_nflin>-taxsit EQ lv_taxsit.
*                <fs_item>-cbenef = ls_parameter-cbenef.
*              ENDIF.
*
*            ELSE.
*            Buscar alíquota conjunta de ICMS + FCP
            READ TABLE lt_nfstx ASSIGNING FIELD-SYMBOL(<fs_basedeson>) WITH KEY docnum = <fs_nflin>-docnum
                                                                                itmnum = <fs_nflin>-itmnum
                                                                                taxgrp = gc_icms
                                                                                BINARY SEARCH.
            IF sy-subrc IS INITIAL.
*                Tratamento para a base desonerada
              DATA(lv_basedeson) =  COND #( WHEN <fs_basedeson>-excbas <> space THEN <fs_basedeson>-excbas ELSE <fs_basedeson>-othbas ).
            ENDIF.

*            Em caso de Alíquota zero, considerar alíquota interna

            READ TABLE lt_rate INTO ls_rate WITH KEY docnum = <fs_nflin>-docnum
                                                     itmnum = <fs_nflin>-itmnum
                                                     BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              IF ls_rate-rate IS INITIAL.
                IF line_exists( gt_j1btxic1[ 1 ] ).
                  lv_rate = gt_j1btxic1[ 1 ]-rate.
                ENDIF.
              ELSE.
                lv_rate = ls_rate-rate.
              ENDIF.
            ELSE.
              lv_rate = gt_j1btxic1[ 1 ]-rate.
            ENDIF.



            CASE lv_tipo_calc.
              WHEN gc_rj. "Cálculo RJ - Retira o ICMS do preço e insere novamente com alíquota cheia

                IF gs_header-manual = abap_true.
                  IF <fs_nflin>-netwr IS NOT INITIAL.
                    lv_vicmsdeson = <fs_nflin>-netwr * ( 1 - ( ( lv_rate / 100 ) * ( 1 - ( lv_basedeson / <fs_nflin>-netwr ) ) ) ) / ( 1 - ( lv_rate / 100 ) ) - <fs_nflin>-netwr.
                  ENDIF.
                ELSE.
                  IF <fs_nflin>-netwrt IS NOT INITIAL.
                    lv_vicmsdeson = <fs_nflin>-netwrt * ( 1 - ( ( lv_rate / 100 ) * ( 1 - ( lv_basedeson / <fs_nflin>-netwrt ) ) ) ) / ( 1 - ( lv_rate / 100 ) ) - <fs_nflin>-netwrt.
                  ENDIF.
                ENDIF.

              WHEN gc_convencional. "Cálculo Convencional

                IF line_exists( lt_nfstx[ itmnum = <fs_nflin>-itmnum taxtyp = 'ICM3' ] ).
                  DATA(ls_nfstx) = lt_nfstx[ itmnum = <fs_nflin>-itmnum taxtyp = 'ICM3' ].
                ENDIF.

                IF <fs_nflin>-itmtyp = '02'
                OR <fs_nflin>-itmtyp = '04'. " MM
*                  lv_vicmsdeson = ( <fs_nflin>-nfpri * ( lv_rate / 100 ) ) - ( ls_nfstx-base * ( lv_rate / 100 ) ).
                  lv_vicmsdeson = ( <fs_nflin>-nfnet * ( lv_rate / 100 ) ) - ( ls_nfstx-base * ( lv_rate / 100 ) ).
                ELSE.

                  IF gs_header-manual = abap_true.
                    lv_vicmsdeson = ( <fs_nflin>-netwr * ( lv_rate / 100 ) ) - ls_nfstx-taxval.
                  ELSE.
                    lv_vicmsdeson = ( <fs_nflin>-netwrt * ( lv_rate / 100 ) ) - ls_nfstx-taxval.
                  ENDIF.

                ENDIF.
              WHEN space.
                <fs_item>-cbenef = ls_parameter-cbenef.
              WHEN OTHERS.
            ENDCASE.

            IF lv_vicmsdeson < 0.
              CLEAR  lv_vicmsdeson.
            ENDIF.

*            Caso ICMS Desonerado seja encontrado, determinar código de benefício e motivo da desoneração
            IF lv_vicmsdeson IS NOT INITIAL.

              <fs_item>-ststcl_vicmsdeson = lv_vicmsdeson.

              IF ls_parameter-motdesicms IS NOT INITIAL.
                <fs_item>-motdesicms = ls_parameter-motdesicms.
              ELSE.
                <fs_item>-motdesicms = 9.
              ENDIF.

              IF <fs_nflin>-cbenef IS INITIAL AND <fs_nflin>-motdesicms IS INITIAL.
                IF  <fs_nflin>-taxsit EQ lv_taxsit.
                  <fs_item>-cbenef = ls_parameter-cbenef.
                ENDIF.
*                ELSEIF <fs_nflin>-cbenef IS NOT INITIAL AND <fs_nflin>-motdesicms IS INITIAL.
*                  <fs_item>-motdesicms = 9.
              ENDIF.

            ENDIF.

*            ENDIF. <-------- Do IF Determinar código de benefício para CST's 10, 51 e 60

          ENDIF.

        ELSE. " Suframa - Transferências

          READ TABLE gt_item_out ASSIGNING <fs_item> WITH KEY itmnum = <fs_nflin>-itmnum BINARY SEARCH.
          IF sy-subrc IS INITIAL.

            CHECK <fs_item>-vicmsdeson IS INITIAL.

            lv_tipo_calc = 2.

*           Buscar alíquota conjunta de ICMS + FCP
            READ TABLE lt_nfstx ASSIGNING <fs_basedeson> WITH KEY docnum = <fs_nflin>-docnum
                                                                  itmnum = <fs_nflin>-itmnum
                                                                  taxgrp = gc_icms
                                                                  taxtyp = 'ICZF' BINARY SEARCH.
            IF sy-subrc IS INITIAL.
*                Tratamento para a base desonerada
              lv_basedeson =  COND #( WHEN <fs_basedeson>-excbas <> space THEN <fs_basedeson>-excbas ELSE <fs_basedeson>-othbas ).

              IF <fs_basedeson>-rate IS INITIAL.
                IF line_exists( gt_j1btxic1[ 1 ] ).
                  lv_rate = gt_j1btxic1[ 1 ]-rate.
                ENDIF.
              ELSE.
                lv_rate = <fs_basedeson>-rate.
              ENDIF.
            ELSE.
              CONTINUE.
            ENDIF.


            IF line_exists( lt_nfstx[ itmnum = <fs_nflin>-itmnum taxtyp = 'ICZF' ] ).
              ls_nfstx = lt_nfstx[ itmnum = <fs_nflin>-itmnum taxtyp = 'ICZF' ].
            ENDIF.

            lv_vicmsdeson = ( lv_basedeson * ( lv_rate / 100 ) ).
            <fs_item>-vicmsdeson = lv_vicmsdeson * -1.
          ENDIF.

        ENDIF.
      ENDIF.
      CLEAR: ls_parameter, ls_cbenef.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_taxsit.

    CALL FUNCTION 'CONVERSION_EXIT_TXSIT_INPUT'
      EXPORTING
        input  = is_cbenef-taxsit
      IMPORTING
        output = rv_taxsit.

  ENDMETHOD.


  METHOD select_data.

    CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
      EXPORTING
        branch            = gs_header-branch
        bukrs             = gs_header-bukrs
      IMPORTING
        address           = gs_address
      EXCEPTIONS
        branch_not_found  = 1
        address_not_found = 2
        company_not_found = 3
        OTHERS            = 4.
    IF sy-subrc <> 0.
      CLEAR gs_address.
    ENDIF.

    IF gt_vbrp IS NOT INITIAL.
      SELECT * UP TO 1 ROWS
        INTO gs_vbak
        FROM vbak
        FOR ALL ENTRIES IN gt_vbrp
        WHERE vbeln  = gt_vbrp-aubel.
      ENDSELECT.
    ENDIF.

    IF gs_header-land1 <> gc_br.

      SELECT *
        INTO TABLE gt_j1btxic1
        FROM j_1btxic1
        WHERE land1       = gs_address-land1
          AND	shipfrom    = gs_address-regio
          AND	shipto      = gs_address-regio
          AND	validfrom   >= sy-datum.

      IF sy-subrc IS INITIAL.
        SORT gt_j1btxic1 BY  land1 shipfrom shipto.
      ENDIF.

    ELSE.

      SELECT *
        INTO TABLE gt_j1btxic1
        FROM j_1btxic1
        WHERE land1       = gs_address-land1
          AND	shipfrom    = gs_address-regio
          AND	shipto      = gs_header-regio
          AND	validfrom   >= sy-datum.

      IF sy-subrc IS INITIAL.
        SORT gt_j1btxic1 BY  land1 shipfrom shipto.
      ENDIF.

    ENDIF.

    select_parameter_table( ).


  ENDMETHOD.


  METHOD select_parameter_table.

    DATA: lr_cfop   TYPE RANGE OF char10,
          lr_taxsit TYPE RANGE OF char2,
          lv_cfop   TYPE char10,
          lv_taxsit TYPE char2.
    CONSTANTS:
          lc_null   TYPE char1  VALUE ' '.

    LOOP AT gt_nflin ASSIGNING FIELD-SYMBOL(<fs_nflin>).

      CALL FUNCTION 'CONVERSION_EXIT_CFOBR_OUTPUT'
        EXPORTING
          input  = <fs_nflin>-cfop
        IMPORTING
          output = lv_cfop.

      CALL FUNCTION 'CONVERSION_EXIT_TXSIT_OUTPUT'
        EXPORTING
          input  = <fs_nflin>-taxsit
        IMPORTING
          output = lv_taxsit.

      APPEND VALUE #( sign = 'I' option = 'EQ' low = lv_cfop ) TO lr_cfop.
      APPEND VALUE #( sign = 'I' option = 'EQ' low = lv_taxsit ) TO lr_taxsit.

    ENDLOOP.
* Seleciona tabela 1 - CFOP
    SELECT *
      INTO TABLE gt_cbenef
      FROM ztsd_cbenef
      WHERE shipfrom = gs_address-regio
        AND shipto   = lc_null
        AND auart    = lc_null
        AND augru    = lc_null
        AND matnr    = lc_null
        AND matkl    = lc_null
        AND bwart    = lc_null
        AND cfop    IN lr_cfop[]
        AND taxsit  IN lr_taxsit[].

    IF sy-subrc IS INITIAL.
      EXIT.
    ELSE.

* Seleciona tabela 1 - CFOP
      SELECT *
        INTO TABLE gt_cbenef
        FROM ztsd_cbenef
        WHERE shipfrom = gs_address-regio
          AND shipto   = gs_header-regio
          AND auart    = lc_null
          AND augru    = lc_null
          AND matnr    = lc_null
          AND matkl    = lc_null
          AND bwart    = lc_null
          AND cfop    IN lr_cfop[]
          AND taxsit  IN lr_taxsit[].

      IF sy-subrc IS INITIAL.
        EXIT.
      ELSE.

        DATA(lt_nflin_fae) = gt_nflin.
        SORT lt_nflin_fae BY matnr.
        DELETE ADJACENT DUPLICATES FROM lt_nflin_fae COMPARING matnr.
        IF lt_nflin_fae IS NOT INITIAL.
* Seleciona tabela 2 - Tipo ordem/Material
          SELECT *
            INTO TABLE gt_cbenef
            FROM ztsd_cbenef
            FOR ALL ENTRIES IN lt_nflin_fae
            WHERE shipfrom = gs_address-regio
              AND shipto   = gs_header-regio
              AND auart    = gs_vbak-auart
              AND augru    = lc_null
              AND matnr    = lt_nflin_fae-matnr
              AND matkl    = lc_null
              AND bwart    = lc_null
              AND cfop     IN lr_cfop[]
              AND taxsit   IN lr_taxsit[].

          IF sy-subrc IS INITIAL.
            EXIT.
          ELSE.
* Seleciona tabela 3 - Tipo de ordem/Motivo
            SELECT *
              INTO TABLE gt_cbenef
              FROM ztsd_cbenef
              WHERE shipfrom = gs_address-regio
                AND shipto   = gs_header-regio
                AND auart    = gs_vbak-auart
                AND augru    = gs_vbak-augru
                AND matnr    = lc_null
                AND matkl    = lc_null
                AND bwart    = lc_null
                AND cfop     = lc_null
                AND taxsit   IN lr_taxsit[].
            IF sy-subrc IS INITIAL.
              EXIT.
            ELSE.
* Seleciona tabela 4 - Tipo de ordem
              SELECT *
                INTO TABLE gt_cbenef
                FROM ztsd_cbenef
                WHERE shipfrom = gs_address-regio
                  AND shipto   = lc_null
                  AND auart    = gs_vbak-auart
                  AND augru    = lc_null
                  AND matnr    = lc_null
                  AND matkl    = lc_null
                  AND bwart    = lc_null
                  AND cfop     = lc_null
                  AND taxsit IN lr_taxsit[].
              IF sy-subrc IS INITIAL.
                EXIT.
              ELSE.
* Seleciona tabela 5 - Tipo de ordem/recebedor.
                SELECT *
                   INTO TABLE gt_cbenef
                   FROM ztsd_cbenef
                  WHERE shipfrom = gs_address-regio
                    AND shipto   = gs_header-regio
                    AND auart    = gs_vbak-auart
                    AND augru    = lc_null
                    AND matnr    = lc_null
                    AND matkl    = lc_null
                    AND bwart    = lc_null
                    AND cfop     = lc_null
                    AND taxsit IN lr_taxsit[].

                IF sy-subrc IS INITIAL.
                  EXIT.
                ELSE.
* Seleciona tabela 6 - material
                  SELECT *
                    INTO TABLE gt_cbenef
                    FROM ztsd_cbenef
                    FOR ALL ENTRIES IN lt_nflin_fae
                    WHERE shipfrom = gs_address-regio
                      AND shipto   = gs_header-regio
                      AND auart    = lc_null
                      AND augru    = lc_null
                      AND matnr    = lt_nflin_fae-matnr
                      AND matkl    = lc_null
                      AND bwart    = lc_null
                      AND cfop     = lc_null
                      AND taxsit IN lr_taxsit[].
                  IF sy-subrc IS INITIAL.
                    EXIT.
                  ELSE.

                    lt_nflin_fae = gt_nflin.
                    SORT lt_nflin_fae BY matkl.
                    DELETE ADJACENT DUPLICATES FROM lt_nflin_fae COMPARING matkl.

                    DATA(lt_mseg) = gt_mseg.
                    SORT lt_mseg BY matnr.
                    DELETE ADJACENT DUPLICATES FROM lt_mseg COMPARING matnr.

                    IF NOT lt_mseg IS INITIAL.
* Seleciona tabela 7 - Tipo de Movimento
                      SELECT *
                        INTO TABLE gt_cbenef
                        FROM ztsd_cbenef
                        FOR ALL ENTRIES IN lt_mseg
                        WHERE shipfrom = gs_address-regio
                          AND shipto   = gs_header-regio
                          AND auart    = lc_null
                          AND augru    = lc_null
                          AND matnr    = lc_null
                          AND matkl    = lc_null
                          AND bwart    = lt_mseg-bwart
                          AND cfop     = lc_null
                          AND taxsit   IN lr_taxsit[].
                    ENDIF.
                    IF sy-subrc IS INITIAL.
                      EXIT.
                    ELSE.
* Seleciona tabela 8 - Grupo de mercadoria
                      SELECT *
                        INTO TABLE gt_cbenef
                        FROM ztsd_cbenef
                        FOR ALL ENTRIES IN lt_nflin_fae
                        WHERE shipfrom = gs_address-regio
                          AND shipto   = gs_header-regio
                          AND auart    = lc_null
                          AND augru    = lc_null
                          AND matnr    = lc_null
                          AND matkl    = lt_nflin_fae-matkl
                          AND bwart    = lc_null
                          AND cfop     = lc_null
                          AND taxsit   IN lr_taxsit[].
                      IF sy-subrc IS INITIAL.
                        EXIT.
                      ELSE.
* Seleciona tabela 9 - Situação tributária
                        SELECT *
                          INTO TABLE gt_cbenef
                          FROM ztsd_cbenef
                          WHERE shipfrom = gs_address-regio
                            AND shipto   = gs_header-regio
                            AND auart    = lc_null
                            AND augru    = lc_null
                            AND matnr    = lc_null
                            AND matkl    = lc_null
                            AND bwart    = lc_null
                            AND cfop     = lc_null
                            AND taxsit   IN lr_taxsit[].
                      ENDIF.
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD set_output.

    rt_item = gt_item_out.

  ENDMETHOD.


  METHOD set_parameter_input.

    gs_header     = is_header.
    gt_nflin      = it_nflin.
    gt_nfstx      = it_nfstx.
    gt_vbrp       = it_vbrp.
    gt_mseg       = it_mseg.
    gt_item_out   = it_item.

  ENDMETHOD.
ENDCLASS.
