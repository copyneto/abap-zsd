"!<p>Classe utilizada para tratar <strong>FECOP e ICMS na NF</strong>. <br/>
"! Esta classe é utilizada na BADI <em>J_1BNF_ADD_DATA</em> para tratativa de: <br/>
"! <ul>
"! <li>Informações adicionais no cabeçalho da NF relacionadas a FECOP e ICMS; </li>
"! <li>Separação de alíquota FECOP e ICMS; </li>
"! <li>Informações adicionais no item da NF relacionadas a FECOP e ICMS. </li>
"! </ul>
"! <br/><br/>
"!<p><strong>Autor:</strong> Anderson Miazato - Meta</p>
"!<p><strong>Data:</strong> 18/08/2021</p>
CLASS zclsd_fecop_operacoes_partilha DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


    CONSTANTS:
      "! Tipos de imposto
      BEGIN OF gc_taxtyp,
        "! ICMS FCP
        icms_fcp TYPE j_1bnfstx-taxtyp VALUE 'ICSC',
        "! Substituição tributária FCP
        st_fcp   TYPE j_1bnfstx-taxtyp VALUE 'ICFP',
      END OF gc_taxtyp.

    "! Construtor - inicialização de objetos
    "! @parameter is_header       | Cabeçalho da NF
    "! @parameter it_nflin        | Itens da NF
    "! @parameter it_nfstx        | Impostos da NF
    METHODS constructor
      IMPORTING !is_header TYPE j_1bnfdoc
                !it_nflin  TYPE j_1bnflin_tab
                !it_nfstx  TYPE j_1bnfstx_tab.

    "! Determina informações da NF de acordo com a regra do FECOP e ICMS na BADI J_1BNF_ADD_DATA
    "! @parameter cs_nfheader         | Cabeçalho atualizado da NF
    "! @parameter ct_nfitem           | Itens atualizados da NF
    METHODS execute
      CHANGING cs_nfheader TYPE j_1bnf_badi_header
               ct_nfitem   TYPE j_1bnf_badi_item_tab.

  PROTECTED SECTION.

  PRIVATE SECTION.

    TYPES:
      "! Utilizado no cálculo de Total de impostos
      BEGIN OF ty_tax_total,
        docnum     TYPE j_1bnfstx-docnum,
        itmnum     TYPE j_1bnfstx-itmnum,
        base_sum   TYPE j_1bnfstx-base,
        taxval_sum TYPE j_1bnfstx-taxval,
        rate       TYPE j_1bnfstx-rate,
      END OF ty_Tax_total.

    DATA:
      "! Tabela de Itens da NF importada da BADI
      gt_nflin     TYPE j_1bnflin_tab,
      "! Tabela de Impostos da NF importada da BADI
      gt_nfstx     TYPE j_1bnfstx_tab,
      "! Cabeçalho da NF importado da BADI
      gs_nf_header TYPE j_1bnfdoc.

    "! Seleciona regra de separação de FECOP e ICMS
    "! @parameter rs_result         | Regra para a NF
    METHODS get_regras_fcp_icms
      RETURNING VALUE(rs_result) TYPE zi_sd_fecop_icms.

    "! Recupera o cabeçalho da NF
    "! @parameter rs_result         | Cabeçalho da NF
    METHODS get_nf_header
      RETURNING VALUE(rs_result) TYPE j_1bnfdoc.

    "! Recupera itens da NF
    "! @parameter rt_result         | Itens da NF
    METHODS get_nflin
      RETURNING VALUE(rt_result) TYPE j_1bnflin_tab.

    "! Recupera os impostos da NF
    "! @parameter rt_result     | Impostos da NF
    METHODS get_nfstx
      RETURNING VALUE(rt_result) TYPE j_1bnfstx_tab.

    "! Atualiza alíquota de ICMS FCP
    "! @parameter ct_nfitem         | Itens da NF atualizados
    METHODS update_icms_rate
      CHANGING ct_nfitem TYPE  j_1bnf_badi_item_tab.

    "! Atualiza informações adicionais de item da NF
    "! @parameter ct_nfitem         | Itens da NF atualizados
    METHODS update_addinfo_nfitem
      CHANGING ct_nfitem TYPE j_1bnf_badi_item_tab.

    "! Atualiza informações adicionais do DANFE
    "! @parameter cs_danfe           | Cabeçalho da NF atualizado
    METHODS update_addinfo_danfe
      CHANGING cs_danfe TYPE j_1bnf_badi_header.

ENDCLASS.



CLASS ZCLSD_FECOP_OPERACOES_PARTILHA IMPLEMENTATION.


  METHOD constructor.

    " Armazena dados da BADI em atributos para consulta
    " Cabeçalho da NF
    me->gs_nf_header = is_header.

    " Itens da NF
    me->gt_nflin = it_nflin.

    " Impostos da NF
    me->gt_nfstx = it_nfstx.

    " Regras de separação de FECOP e ICMS
    me->get_regras_fcp_icms( ).

  ENDMETHOD.


  METHOD execute.
    DATA ls_nfheader TYPE j_1bnf_badi_header.

    " Se não há regra de separação do FECOP e ICMS, sai do processamento
    IF me->get_regras_fcp_icms( ) IS INITIAL.
      RETURN.
    ENDIF.

    " Atualiza alíquota de ICMS
    me->update_icms_rate(
      CHANGING
        ct_nfitem = ct_nfitem
    ).

    " Atualiza informações adicionais de item
    me->update_addinfo_nfitem(
      CHANGING
        ct_nfitem = ct_nfitem
    ).

    " Atualiza informações de DANFE
    me->update_addinfo_danfe(
      CHANGING
        cs_danfe = ls_nfheader"cs_nfheader
    ).

  ENDMETHOD.


  METHOD get_nf_header.
    rs_result = me->gs_nf_header.
  ENDMETHOD.


  METHOD get_regras_fcp_icms.

    DATA(ls_nf_header) = me->get_nf_header( ).

    SELECT SINGLE
          SalesOrgID,
          BusinessPlaceID
        FROM zi_sd_fecop_icms
        WHERE SalesOrgID      EQ @ls_nf_header-bukrs
          AND BusinessPlaceID EQ @ls_nf_header-branch
        INTO  @rs_result.

    IF sy-subrc NE 0.
      CLEAR rs_result.
    ENDIF.

  ENDMETHOD.


  METHOD get_nflin.
    rt_result = me->gt_nflin.
  ENDMETHOD.


  METHOD get_nfstx.
    rt_result = me->gt_nfstx.
  ENDMETHOD.


  METHOD update_icms_rate.

    DATA(lt_nfstx) = me->get_nfstx( ).
    SORT lt_nfstx BY docnum
                     itmnum
                     taxtyp.

    LOOP AT ct_nfitem ASSIGNING FIELD-SYMBOL(<fs_nfitem>).

      IF <fs_nfitem>-picmsefet IS INITIAL.
        CONTINUE.
      ENDIF.

      READ TABLE lt_nfstx ASSIGNING FIELD-SYMBOL(<fs_nfstx>)
        WITH KEY itmnum = <fs_nfitem>-itmnum
                 taxtyp = gc_taxtyp-icms_fcp
        BINARY SEARCH.

      IF sy-subrc EQ 0.
        <fs_nfitem>-picmsefet = <fs_nfitem>-picmsefet + <fs_nfstx>-rate.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD update_addinfo_nfitem.

    DATA: ls_tax_icms_fcp    TYPE ty_tax_total,
          ls_tax_icms_st_fcp TYPE ty_tax_total.

    DATA: lv_tax_rate     TYPE char10,
          lv_tax_base_sum TYPE char20,
          lv_tax_val      TYPE char20.

    DATA(ls_nf_header) = me->get_nf_header( ).

    DATA(lt_nflin) = me->get_nflin( ).

    DATA(lt_nfstx) = me->get_nfstx( ).

    SORT: lt_nflin BY docnum itmnum,
          lt_nfstx BY docnum itmnum taxtyp.

    " Agrupa os impostos por item antes de executar o loop
    LOOP AT lt_nfstx ASSIGNING FIELD-SYMBOL(<fs_nftax_group>)
        GROUP BY ( docnum = <fs_nftax_group>-docnum
                   itmnum = <fs_nftax_group>-itmnum )
        ASSIGNING FIELD-SYMBOL(<fs_group_tax>).

      LOOP AT GROUP <fs_group_tax> ASSIGNING FIELD-SYMBOL(<fs_nfstx>).

        " Calcula o total de ICMS FCP para este item da NF
        IF <fs_nfstx>-taxtyp EQ gc_taxtyp-icms_fcp.

          ls_tax_icms_fcp = VALUE #( LET lv_base   = ls_tax_icms_fcp-base_sum
                                         lv_taxval = ls_tax_icms_fcp-taxval_sum IN

                                         docnum     = <fs_nfstx>-docnum
                                         itmnum     = <fs_nfstx>-itmnum
                                         base_sum   = lv_base + <fs_nfstx>-base
                                         taxval_sum = lv_taxval + <fs_nfstx>-taxval
                                         rate       = <fs_nfstx>-rate
                            ).

        ENDIF.

        " Calcula o total de ICMS ST FCP para este item da NF
        IF <fs_nfstx>-taxtyp EQ gc_taxtyp-st_fcp.

          ls_tax_icms_st_fcp = VALUE #( LET lv_base   = ls_tax_icms_st_fcp-base_sum
                                            lv_taxval = ls_tax_icms_st_fcp-taxval_sum IN

                                            docnum     = <fs_nfstx>-docnum
                                            itmnum     = <fs_nfstx>-itmnum
                                            base_sum   = lv_base + <fs_nfstx>-base
                                            taxval_sum = lv_taxval + <fs_nfstx>-taxval
                                            rate       = <fs_nfstx>-rate
                            ).

        ENDIF.

      ENDLOOP.

      " Atualiza Informações adicionais no item da NFe: ICMS FCP
      IF ls_tax_icms_fcp IS NOT INITIAL.

        TRY.

            READ TABLE ct_nfitem ASSIGNING FIELD-SYMBOL(<fs_update_nfitem>)
              WITH KEY itmnum = ls_tax_icms_fcp-itmnum
              BINARY SEARCH.

            IF sy-subrc EQ 0 AND <fs_update_nfitem> IS ASSIGNED.

              WRITE ls_tax_icms_fcp-base_sum   TO lv_tax_base_sum CURRENCY ls_nf_header-waerk.
              lv_tax_base_sum = shift_left( lv_tax_base_sum ).

              WRITE: ls_tax_icms_fcp-taxval_sum TO lv_tax_val CURRENCY ls_nf_header-waerk.
              lv_tax_val = shift_left( lv_tax_val ).

              WRITE: ls_tax_icms_fcp-rate       TO lv_tax_rate CURRENCY ls_nf_header-waerk.
              lv_tax_rate = shift_left( lv_tax_rate ).

              IF <fs_update_nfitem>-infadprod IS INITIAL.

                CONCATENATE
                    TEXT-001 lv_tax_base_sum
                    TEXT-002 lv_tax_rate
                    TEXT-003 lv_tax_val
                    INTO <fs_update_nfitem>-infadprod
                    SEPARATED BY space.

              ELSE.

                CONCATENATE
                    <fs_update_nfitem>-infadprod
                    TEXT-001 lv_tax_base_sum
                    TEXT-002 lv_tax_rate
                    TEXT-003 lv_tax_val
                    INTO <fs_update_nfitem>-infadprod
                    SEPARATED BY space.
              ENDIF.

              CLEAR:
                lv_tax_base_sum,
                lv_tax_rate,
                lv_tax_val.

            ENDIF.
          CATCH cx_sy_itab_line_not_found.
        ENDTRY.

      ENDIF.

      " Atualiza Informações adicionais no item da NFe: ICMS ST FCP
      IF ls_tax_icms_st_fcp IS NOT INITIAL.

        TRY.

            READ TABLE ct_nfitem ASSIGNING <fs_update_nfitem>
              WITH KEY itmnum = ls_tax_icms_fcp-itmnum
              BINARY SEARCH.

            IF sy-subrc EQ 0 AND <fs_update_nfitem> IS ASSIGNED.

              WRITE ls_tax_icms_st_fcp-base_sum   TO lv_tax_base_sum CURRENCY ls_nf_header-waerk.
              lv_tax_base_sum = shift_left( lv_tax_base_sum ).

              WRITE: ls_tax_icms_st_fcp-taxval_sum TO lv_tax_val CURRENCY ls_nf_header-waerk.
              lv_tax_val = shift_left( lv_tax_val ).

              WRITE: ls_tax_icms_st_fcp-rate       TO lv_tax_rate CURRENCY ls_nf_header-waerk.
              lv_tax_rate = shift_left( lv_tax_rate ).

              IF <fs_update_nfitem>-infadprod IS INITIAL.

                CONCATENATE
                    TEXT-004 lv_tax_base_sum
                    TEXT-002 lv_tax_rate
                    TEXT-003 lv_tax_val
                    INTO <fs_update_nfitem>-infadprod
                    SEPARATED BY space.

              ELSE.

                CONCATENATE
                    <fs_update_nfitem>-infadprod
                    TEXT-004 lv_tax_base_sum
                    TEXT-002 lv_tax_rate
                    TEXT-003 lv_tax_val
                    INTO <fs_update_nfitem>-infadprod
                    SEPARATED BY space.
              ENDIF.

              CLEAR:
                lv_tax_base_sum,
                lv_tax_rate,
                lv_tax_val.

            ENDIF.
          CATCH cx_sy_itab_line_not_found.
        ENDTRY.

      ENDIF.

      CLEAR: ls_tax_icms_fcp,
             ls_tax_icms_st_fcp.

    ENDLOOP.

  ENDMETHOD.


  METHOD update_addinfo_danfe.

    DATA: ls_tax_icms_fcp    TYPE ty_tax_total,
          ls_tax_icms_st_fcp TYPE ty_tax_total.

    DATA: lv_tax_rate     TYPE char10,
          lv_tax_base_sum TYPE char20,
          lv_tax_val      TYPE char20.

    " Recupera cabeçalho da NF (importado da badi)
    DATA(ls_nf_header) = me->get_nf_header( ).

    " Recupera tabela de impostos da badi
    DATA(lt_nfstx) = me->get_nfstx( ).

    LOOP AT lt_nfstx ASSIGNING FIELD-SYMBOL(<fs_nfstx>).

      " Calcula o total de ICMS FCP na NF
      IF <fs_nfstx>-taxtyp EQ gc_taxtyp-icms_fcp.

        ls_tax_icms_fcp = VALUE #( LET lv_base   = ls_tax_icms_fcp-base_sum
                                       lv_taxval = ls_tax_icms_fcp-taxval_sum IN

                                       docnum     = <fs_nfstx>-docnum
                                       base_sum   = lv_base + <fs_nfstx>-base
                                       taxval_sum = lv_taxval + <fs_nfstx>-taxval
                                       rate       = <fs_nfstx>-rate
                          ).

      ENDIF.

      " Calcula o total de ICMS ST FCP na NF
      IF <fs_nfstx>-taxtyp EQ gc_taxtyp-st_fcp.

        ls_tax_icms_st_fcp = VALUE #( LET lv_base   = ls_tax_icms_st_fcp-base_sum
                                          lv_taxval = ls_tax_icms_st_fcp-taxval_sum IN

                                          docnum     = <fs_nfstx>-docnum
                                          base_sum   = lv_base + <fs_nfstx>-base
                                          taxval_sum = lv_taxval + <fs_nfstx>-taxval
                                          rate       = <fs_nfstx>-rate
                          ).

      ENDIF.

    ENDLOOP.

    " Atualiza Informações adicionais no DANFE: ICMS FCP
    IF ls_tax_icms_fcp IS NOT INITIAL.

      TRY.

          WRITE ls_tax_icms_fcp-base_sum   TO lv_tax_base_sum CURRENCY ls_nf_header-waerk.
          lv_tax_base_sum = shift_left( lv_tax_base_sum ).

          WRITE: ls_tax_icms_fcp-taxval_sum TO lv_tax_val CURRENCY ls_nf_header-waerk.
          lv_tax_val = shift_left( lv_tax_val ).

          WRITE: ls_tax_icms_fcp-rate       TO lv_tax_rate CURRENCY ls_nf_header-waerk.
          lv_tax_rate = shift_left( lv_tax_rate ).

          IF cs_danfe-infcpl IS INITIAL.

            CONCATENATE
                TEXT-005 lv_tax_base_sum
                TEXT-002 lv_tax_rate
                TEXT-003 lv_tax_val
                INTO cs_danfe-infcpl
                SEPARATED BY space.

          ELSE.

            CONCATENATE
                cs_danfe-infcpl
                TEXT-005 lv_tax_base_sum
                TEXT-002 lv_tax_rate
                TEXT-003 lv_tax_val
                INTO cs_danfe-infcpl
                SEPARATED BY space.
          ENDIF.

          CLEAR:
            lv_tax_base_sum,
            lv_tax_rate,
            lv_tax_val.


        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

    ENDIF.

    " Atualiza Informações adicionais no item da NFe: ICMS ST FCP
    IF ls_tax_icms_st_fcp IS NOT INITIAL.

      TRY.

          WRITE ls_tax_icms_st_fcp-base_sum   TO lv_tax_base_sum CURRENCY ls_nf_header-waerk.
          lv_tax_base_sum = shift_left( lv_tax_base_sum ).

          WRITE: ls_tax_icms_st_fcp-taxval_sum TO lv_tax_val CURRENCY ls_nf_header-waerk.
          lv_tax_val = shift_left( lv_tax_val ).

          WRITE: ls_tax_icms_st_fcp-rate       TO lv_tax_rate CURRENCY ls_nf_header-waerk.
          lv_tax_rate = shift_left( lv_tax_rate ).

          IF cs_danfe-infcpl IS INITIAL.

            CONCATENATE
                TEXT-006 lv_tax_base_sum
                TEXT-002 lv_tax_rate
                TEXT-003 lv_tax_val
                INTO cs_danfe-infcpl
                SEPARATED BY space.

          ELSE.

            CONCATENATE
                cs_danfe-infcpl
                TEXT-006 lv_tax_base_sum
                TEXT-002 lv_tax_rate
                TEXT-003 lv_tax_val
                INTO cs_danfe-infcpl
                SEPARATED BY space.

          ENDIF.

          CLEAR:
            lv_tax_base_sum,
            lv_tax_rate,
            lv_tax_val.

        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

    ENDIF.

    CLEAR: ls_tax_icms_fcp,
           ls_tax_icms_st_fcp.

  ENDMETHOD.
ENDCLASS.
