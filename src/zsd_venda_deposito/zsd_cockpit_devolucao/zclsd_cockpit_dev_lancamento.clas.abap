CLASS zclsd_cockpit_dev_lancamento DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! Determina Lançamento
    "! @parameter cs_cockpit   | Cockpit Devolução
    "! @parameter rt_mensagens | Mensagem retorno
    METHODS determina_lancamento
      CHANGING
        !cs_cockpit         TYPE zi_sd_cockpit_devolucao
      RETURNING
        VALUE(rt_mensagens) TYPE bapiret2_tab .
    METHODS elimina_lancamento
      IMPORTING
        !is_cockpit         TYPE zi_sd_cockpit_devolucao
      RETURNING
        VALUE(rt_mensagens) TYPE bapiret2_tab .
    METHODS determina_campos_pagamento
      CHANGING
        !cs_cockpit TYPE zi_sd_cockpit_devolucao .
    METHODS preenche_itens_lancamento
      IMPORTING
        !is_cockpit TYPE zi_sd_cockpit_devolucao .
  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS preenche_dados_transportadora
      CHANGING
        !cs_cockpit TYPE zi_sd_cockpit_devolucao .
ENDCLASS.



CLASS zclsd_cockpit_dev_lancamento IMPLEMENTATION.


  METHOD determina_lancamento.

    "Não permitir criar mais de um pré-lançamento para a mesma nota
    SELECT COUNT( * )
      FROM ztsd_devolucao
      WHERE numero_nfe  = @cs_cockpit-nfe
        AND chaveacesso = @cs_cockpit-chaveacesso.
    IF sy-subrc EQ 0.
      APPEND VALUE #( type = 'E'
                      id  = 'ZSD_COCKPIT_DEVOL'
                      number = 010
                      message_v1 = cs_cockpit-nfe ) TO rt_mensagens.
      RETURN.
    ENDIF.

    cs_cockpit-regiao        = cs_cockpit-chaveacesso(2).
    cs_cockpit-ano           = cs_cockpit-chaveacesso+2(2).
    cs_cockpit-mes           = cs_cockpit-chaveacesso+4(2).
    cs_cockpit-modelo        = cs_cockpit-chaveacesso+20(2).
    cs_cockpit-nroaleatorio  = cs_cockpit-chaveacesso+34(9).
    cs_cockpit-digitoverific = cs_cockpit-chaveacesso+43(1).
    cs_cockpit-situacao      = '0'.
    cs_cockpit-dtlancamento  = sy-datum.

    IF cs_cockpit-tipodevolucao NE '1'.
      DATA(lv_cnpj) = cs_cockpit-cnpj.
    ELSE.
      lv_cnpj = cs_cockpit-chaveacesso+6(14).
    ENDIF.

    IF NOT lv_cnpj IS INITIAL.

      IF strlen( lv_cnpj ) EQ 11.
        SELECT SINGLE kunnr
        FROM kna1
        INTO cs_cockpit-cliente
        WHERE stcd2 = lv_cnpj.
      ELSE.
        SELECT SINGLE kunnr
        FROM kna1
        INTO cs_cockpit-cliente
        WHERE stcd1 = lv_cnpj.
      ENDIF.

      IF cs_cockpit-tipodevolucao NE '1'.
        DATA(lv_serie) = cs_cockpit-serie.
      ELSE.
        lv_serie = |{ cs_cockpit-serie ALPHA = OUT }|.
      ENDIF.

*      SELECT SINGLE valortotalnota, codmoeda
*        FROM zi_sd_infos_nftotal
*        WHERE cnpjcliente  EQ @cs_cockpit-cnpj
*          AND centro       EQ @cs_cockpit-centro
*          AND nfe          EQ @cs_cockpit-nfe
*          AND serie        EQ @lv_serie
*          AND datasaidanfe <= @sy-datum
*        INTO ( @cs_cockpit-nftotal, @cs_cockpit-moedasd ).

      IF cs_cockpit-tipodevolucao NE '1'.

        SELECT SINGLE a~nftot, a~waerk
          FROM j_1bnfdoc AS a
          INNER JOIN /xnfe/outnfehd AS b ON a~docnum = b~docnum
          INTO ( @cs_cockpit-nftotal, @cs_cockpit-moedasd )
          WHERE b~id = @cs_cockpit-chaveacesso.

        "Preenche campos transportadora, motorista, placa e tipo de expedição
        preenche_dados_transportadora( CHANGING cs_cockpit = cs_cockpit ).

      ELSE.
        SELECT SINGLE s1_vnf, waers
          FROM /xnfe/innfehd
          WHERE nfeid EQ @cs_cockpit-chaveacesso
          INTO ( @cs_cockpit-nftotal, @cs_cockpit-moedasd ).
      ENDIF.

      "Busca local de negócio
      SELECT SINGLE j_1bbranch
        FROM t001w
        INTO @cs_cockpit-localnegocio
        WHERE werks = @cs_cockpit-centro.

    ENDIF.

    "Preenche campos banco, agência, conta e denomi. banco
    determina_campos_pagamento( CHANGING cs_cockpit = cs_cockpit ).

    "Popula tabela de itens
    preenche_itens_lancamento( cs_cockpit ).

  ENDMETHOD.


  METHOD preenche_dados_transportadora.

    DATA: lv_vbeln  TYPE vbeln,
          lv_tor_id TYPE /scmtms/tor_id.

    DATA lt_docflow TYPE tdt_docflow.


    SELECT SINGLE a~refkey
      FROM j_1bnflin AS a
      INNER JOIN j_1bnfe_active AS b ON a~docnum = b~docnum
      INTO @DATA(lv_refkey)
      WHERE b~regio   = @cs_cockpit-chaveacesso(2)
        AND b~nfyear  = @cs_cockpit-chaveacesso+2(2)
        AND b~nfmonth = @cs_cockpit-chaveacesso+4(2)
        AND b~stcd1   = @cs_cockpit-chaveacesso+6(14)
        AND b~model   = @cs_cockpit-chaveacesso+20(2)
        AND b~serie   = @cs_cockpit-chaveacesso+22(3)
        AND b~nfnum9  = @cs_cockpit-chaveacesso+25(9)
        AND b~docnum9 = @cs_cockpit-chaveacesso+34(9)
        AND b~cdv     = @cs_cockpit-chaveacesso+43(1).

    IF sy-subrc EQ 0.

      lv_vbeln = lv_refkey.

      CALL FUNCTION 'SD_DOCUMENT_FLOW_GET'
        EXPORTING
          iv_docnum  = lv_vbeln
        IMPORTING
          et_docflow = lt_docflow.

      SORT lt_docflow BY vbtyp_v.

      IF NOT lt_docflow IS INITIAL.

        READ TABLE lt_docflow ASSIGNING FIELD-SYMBOL(<fs_docflow>) WITH KEY vbtyp_v = 'J' BINARY SEARCH.
        IF sy-subrc EQ 0.

          lv_vbeln = <fs_docflow>-docnuv.

          REFRESH lt_docflow.
          CALL FUNCTION 'SD_DOCUMENT_FLOW_GET'
            EXPORTING
              iv_docnum  = lv_vbeln
            IMPORTING
              et_docflow = lt_docflow.

          SORT lt_docflow BY vbtyp_n.

          READ TABLE lt_docflow ASSIGNING <fs_docflow> WITH KEY vbtyp_n = 'TMFO' BINARY SEARCH.
          IF sy-subrc EQ 0.

            DATA(lv_docnum) = <fs_docflow>-docnum.

            lv_tor_id = |{ lv_docnum ALPHA = IN }|.

            SELECT SINGLE db_key AS parent_key,
                          tspid AS transportadora,
                          zz_motorista AS motorista,
                          zz1_tipo_exped AS tipoexpedicao
              FROM /scmtms/d_torrot
              INTO @DATA(ls_dados_transp)
              WHERE tor_id EQ @lv_tor_id.
            IF sy-subrc EQ 0.

              MOVE-CORRESPONDING ls_dados_transp TO cs_cockpit.

              SELECT SINGLE platenumber
                FROM /scmtms/d_torite
                INTO @cs_cockpit-placa
                WHERE parent_key  EQ @ls_dados_transp-parent_key
                  AND platenumber NE @space.

            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD elimina_lancamento.

    IF is_cockpit-ordemdevolucao IS INITIAL.

      SELECT SINGLE *
        FROM ztsd_devolucao
        INTO @DATA(ls_devolucao)
        WHERE guid = @is_cockpit-guid.
*        AND ord_devolucao  = @space.

      IF sy-subrc EQ 0.

        DELETE ztsd_devolucao FROM ls_devolucao.
        IF sy-subrc NE 0.
          APPEND VALUE #( type = 'E'
                          id  = 'ZSD_COCKPIT_DEVOL'
                          number = 000
                          message = TEXT-001
                          message_v1 = TEXT-001 ) TO rt_mensagens.
        ELSE.
          APPEND VALUE #( type = 'S'
                          id  = 'ZSD_COCKPIT_DEVOL'
                          number = 011
                          message_v1 = is_cockpit-nfe ) TO rt_mensagens.
        ENDIF.

      ENDIF.

      SELECT SINGLE *
      FROM ztsd_devolucao_i
      INTO @DATA(ls_devolucao_i)
      WHERE guid = @is_cockpit-guid.
*        AND ord_devolucao  = @space.

      IF sy-subrc EQ 0.

        DELETE ztsd_devolucao_i FROM ls_devolucao_i.
*        IF sy-subrc NE 0.
*          APPEND VALUE #( type = 'E'
*                          id  = 'ZSD_COCKPIT_DEVOL'
*                          number = 000
*                          message = TEXT-001
*                          message_v1 = TEXT-001 ) TO rt_mensagens.
*        ELSE.
*          APPEND VALUE #( type = 'S'
*                          id  = 'ZSD_COCKPIT_DEVOL'
*                          number = 011
*                          message_v1 = is_cockpit-nfe ) TO rt_mensagens.
*        ENDIF.

      ENDIF.


      SELECT *
        FROM ztsd_anexo_dev
        INTO TABLE @DATA(lt_anexo_dev)
        WHERE guid = @is_cockpit-guid.

      IF sy-subrc EQ 0.

        DELETE ztsd_anexo_dev FROM TABLE lt_anexo_dev.
        IF sy-subrc NE 0.
          APPEND VALUE #( type = 'E'
                          id  = 'ZSD_COCKPIT_DEVOL'
                          number = 000
                          message = TEXT-001
                          message_v1 = TEXT-001 ) TO rt_mensagens.
        ENDIF.

      ENDIF.
    ELSE.
      APPEND VALUE #( type = 'E'
                       id  = 'ZSD_COCKPIT_DEVOL'
                    number = 022
                message_v1 = is_cockpit-nfe ) TO rt_mensagens.

    ENDIF.

  ENDMETHOD.


  METHOD determina_campos_pagamento.

    DATA lr_deb_conta TYPE RANGE OF ztsd_devolucao-form_pagamento.

    DATA: lt_bankdetails TYPE STANDARD TABLE OF bapibus1006_bankdetails,
          lt_return      TYPE STANDARD TABLE OF bapiret2.

    FIELD-SYMBOLS <fs_dadosbanco> TYPE bapibus1006_bankdetails.


    IF cs_cockpit-formapagamento NE 'X'.
      RETURN.
    ENDIF.

    SELECT SINGLE docnum
      FROM j_1bnfe_active
      INTO @DATA(lv_docnum)
      WHERE regio   = @cs_cockpit-chaveacesso(2)
        AND nfyear  = @cs_cockpit-chaveacesso+2(2)
        AND nfmonth = @cs_cockpit-chaveacesso+4(2)
        AND stcd1   = @cs_cockpit-chaveacesso+6(14)
        AND model   = @cs_cockpit-chaveacesso+20(2)
        AND serie   = @cs_cockpit-chaveacesso+22(3)
        AND nfnum9  = @cs_cockpit-chaveacesso+25(9)
        AND docnum9 = @cs_cockpit-chaveacesso+34(9)
        AND cdv     = @cs_cockpit-chaveacesso+43(1).

    IF sy-subrc EQ 0.

      SELECT SINGLE parid
        FROM j_1bnfdoc
        INTO @DATA(lv_parid)
        WHERE docnum = @lv_docnum.

      IF sy-subrc IS INITIAL.

        CALL FUNCTION 'BAPI_BUPA_BANKDETAILS_GET'
          EXPORTING
            businesspartner = lv_parid
            valid_date      = sy-datlo
          TABLES
            bankdetails     = lt_bankdetails
            return          = lt_return.

        IF lt_return IS INITIAL.
          TRY.
              DATA(ls_bankdetails) = lt_bankdetails[ 1 ].
              SELECT SINGLE banka
                FROM bnka
                INTO @DATA(lv_denomi)
                WHERE bankl = @ls_bankdetails-bank_key.
              IF sy-subrc EQ 0.
                cs_cockpit-banco        = ls_bankdetails-bank_key.
                cs_cockpit-agencia      = ls_bankdetails-bank_key.
                cs_cockpit-conta        = ls_bankdetails-bank_acct.
                cs_cockpit-denomibanco = lv_denomi.
              ENDIF.
            CATCH cx_sy_itab_line_not_found.
          ENDTRY.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD preenche_itens_lancamento.

    DATA ls_devolucao_i TYPE ztsd_devolucao_i.

    DATA lt_devolucao_i TYPE TABLE OF ztsd_devolucao_i.


    IF is_cockpit-tipodevolucao EQ '1'.
      SELECT chaveacesso, item, material, textomaterial AS texto_material,
             codean AS ean, quantidade AS quantidade_nfe, unidmedida AS unmedida_nfe,
             valortotal, codmoeda AS cod_moeda
        FROM zi_sd_cockpit_devolucao_matean
        WHERE chaveacesso = @is_cockpit-chaveacesso
        INTO TABLE @DATA(lt_matean).
      IF sy-subrc EQ 0.
        LOOP AT lt_matean ASSIGNING FIELD-SYMBOL(<fs_matean>).
          MOVE-CORRESPONDING <fs_matean> TO ls_devolucao_i.
          ls_devolucao_i-guid = is_cockpit-guid.
          TRY.
              ls_devolucao_i-valor_unit = <fs_matean>-valortotal / <fs_matean>-quantidade_nfe.
            CATCH cx_sy_zerodivide.
          ENDTRY.
          APPEND ls_devolucao_i TO lt_devolucao_i.
          CLEAR ls_devolucao_i.
        ENDLOOP.
      ENDIF.
    ELSE.
      SELECT a~br_notafiscal, a~br_notafiscalitem AS item, a~material, a~materialname AS texto_material,
             a~internationalarticlenumber AS ean, a~quantityinbaseunit AS quantidade_nfe, a~baseunit AS unmedida_nfe,
             a~netvalueamount, a~salesdocumentcurrency AS cod_moeda, a~netpriceamount AS valor_unit,
             a~br_nfsourcedocumentnumber AS fatura, a~br_nfsourcedocumentitem AS item_fatura, c~br_nftotalamount AS valortotalnfe,
             d~unvenda AS un_fatura, d~valortotal AS vl_total_fatura, d~valorunit AS vl_unit_fatura, d~totalbruto AS vl_bruto_fatura,
             d~datadoc AS data_fatura, d~nfe AS nfe_fatura, d~quantidade AS qtd_fatura
        FROM i_br_nfitem  AS a
        INNER JOIN j_1bnfe_active AS b ON b~docnum = a~br_notafiscal
        INNER JOIN i_br_nfdocument AS c ON c~br_notafiscal = b~docnum
        INNER JOIN zi_sd_cockpit_devolucao_docfat AS d ON d~docfaturamento = a~br_nfsourcedocumentnumber
                                                      AND d~item = a~br_nfsourcedocumentitem
        WHERE b~regio     = @is_cockpit-chaveacesso(2)
          AND b~nfyear    = @is_cockpit-chaveacesso+2(2)
          AND b~nfmonth   = @is_cockpit-chaveacesso+4(2)
          AND b~stcd1     = @is_cockpit-chaveacesso+6(14)
          AND b~model     = @is_cockpit-chaveacesso+20(2)
          AND b~serie     = @is_cockpit-chaveacesso+22(3)
          AND b~nfnum9    = @is_cockpit-chaveacesso+25(9)
          AND b~docnum9   = @is_cockpit-chaveacesso+34(9)
          AND b~cdv       = @is_cockpit-chaveacesso+43(1)
          AND d~faturadev = ' '
        INTO TABLE @DATA(lt_nf_item).
      IF sy-subrc EQ 0.
        LOOP AT lt_nf_item ASSIGNING FIELD-SYMBOL(<fs_nf_item>).
          MOVE-CORRESPONDING <fs_nf_item> TO ls_devolucao_i.
          ls_devolucao_i-guid = is_cockpit-guid.

          IF ls_devolucao_i-item >= 10.
            DIVIDE ls_devolucao_i-item BY 10.
          ENDIF.

          TRY.
              ls_devolucao_i-valor_unit = <fs_nf_item>-netvalueamount / <fs_nf_item>-quantidade_nfe.
            CATCH cx_sy_zerodivide.
          ENDTRY.
          APPEND ls_devolucao_i TO lt_devolucao_i.
          CLEAR ls_devolucao_i.
        ENDLOOP.
      ENDIF.
    ENDIF.

    IF NOT lt_devolucao_i IS INITIAL.
      MODIFY ztsd_devolucao_i FROM TABLE lt_devolucao_i.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
