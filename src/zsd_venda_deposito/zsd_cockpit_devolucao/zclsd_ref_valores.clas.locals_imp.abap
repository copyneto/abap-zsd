CLASS lcl_refval DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
  PRIVATE SECTION.
    DATA: lt_refvalores TYPE TABLE FOR READ RESULT zi_sd_cockpit_devolucao_refval.

*    METHODS get_features FOR FEATURES
*      IMPORTING keys REQUEST requested_features FOR GeraDevolucao RESULT result.

*    METHODS calculavalores FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR refval~calculavalores.

    METHODS aceitavalores FOR VALIDATE ON SAVE
      IMPORTING keys FOR refval~aceitavalores.

    METHODS atualizamaterial FOR DETERMINE ON MODIFY
      IMPORTING keys FOR refval~atualizamaterial.

    METHODS verificaquantidade FOR VALIDATE ON SAVE
      IMPORTING keys FOR refval~verificaquantidade.

    METHODS conversion_exit_cunit CHANGING cs_docfat TYPE zi_sd_cockpit_devolucao_docfat.

    METHODS convert_unit
      IMPORTING
                is_refvalores      TYPE zi_sd_cockpit_devolucao_refval
      RETURNING VALUE(rv_unmedida) TYPE zi_sd_cockpit_devolucao_refval-unmedida.

    METHODS convert_quantidade
      IMPORTING
        is_refvalores TYPE zi_sd_cockpit_devolucao_refval
        is_docfat     TYPE zi_sd_cockpit_devolucao_docfat
      EXPORTING
        ev_menge      TYPE j_1bnetqty.

ENDCLASS.

CLASS lcl_refval IMPLEMENTATION.

*  METHOD calculavalores.
*
** Verificando a Autorização do User!
*    AUTHORITY-CHECK OBJECT 'ZDEV_DEVOL' FOR USER sy-uname
*      ID 'ACTVT' FIELD '01'.    "Criar
*
*    IF sy-subrc IS INITIAL.
*
*      READ ENTITIES OF zi_sd_cockpit_devolucao_gerdev IN LOCAL MODE
*      ENTITY geradevolucao BY \_refval ALL FIELDS
*      WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_refvalores)
*      FAILED DATA(lt_failed).
*
*      CHECK lt_refvalores IS NOT INITIAL.
*
*      SELECT *                                     "#EC CI_EMPTY_SELECT
*      FROM ztsd_devolucao_i
*      INTO @DATA(ls_devolucao_i)
*      FOR ALL ENTRIES IN @lt_refvalores
*      WHERE guid  EQ @lt_refvalores-guid
*        AND item  EQ @lt_refvalores-item.
*      ENDSELECT.
*
*
*      LOOP AT lt_refvalores ASSIGNING FIELD-SYMBOL(<fs_refvalores>).
**        IF <fs_refvalores>-quantidade > <fs_refvalores>-quantidadefatura.
**          APPEND VALUE #( %msg = new_message( id       = 'ZSD_COCKPIT_DEVOL'
**                                              number   = '019'
**                                              severity = CONV #( 'E' ) ) ) TO reported-refval.
**          RETURN.
**        ENDIF.
*        IF <fs_refvalores>-aceitavalores IS NOT INITIAL.
*
*          <fs_refvalores>-valortotal = <fs_refvalores>-valorunit * <fs_refvalores>-quantidade.
*
*          ls_devolucao_i-vl_bruto_fatura  = <fs_refvalores>-brutofatura + <fs_refvalores>-valortotal.
*          ls_devolucao_i-vl_total_fatura  = <fs_refvalores>-valorunitfatura + <fs_refvalores>-valorunit.
*
*          <fs_refvalores>-brutofatura     = ls_devolucao_i-vl_bruto_fatura.
*          <fs_refvalores>-valorunitfatura = ls_devolucao_i-vl_total_fatura.
*
*          MODIFY ENTITIES OF zi_sd_cockpit_devolucao_gerdev IN LOCAL MODE ENTITY refval
*              UPDATE SET FIELDS WITH VALUE #( (  brutofatura     = <fs_refvalores>-brutofatura
*                                               valorunitfatura = <fs_refvalores>-valorunitfatura ) )
*            REPORTED DATA(lt_reported).
*
*          MODIFY ztsd_devolucao_i FROM ls_devolucao_i. "#EC CI_IMUD_NESTED
*
*        ENDIF.
*      ENDLOOP.
*
** ---------------------------------------------------------------------------
** Retornar mensagens
** ---------------------------------------------------------------------------
*    ELSE.
*
*      APPEND VALUE #(
*
*                               %msg       = new_message(
*                                 id       = 'ZSD_COCKPIT_DEVOL'
*                                 number   = '001'
*                                 severity = CONV #( 'E' ) ) ) TO reported-refval.
*
*    ENDIF.

*ENDMETHOD.

*  METHOD get_features.
*
*
*  ENDMETHOD.


  METHOD aceitavalores.
    DATA: lt_refvalores_aux TYPE TABLE OF zi_sd_cockpit_devolucao_refval,
          lv_erro           TYPE abap_bool,
          lv_erro_l         TYPE abap_bool.
* *------------------------------------------------------------------
* *Recupera informações o
* *------------------------------------------------------------------
* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZDEV_DEVOL' FOR USER sy-uname
      ID 'ACTVT' FIELD '01'.    "Criar

    IF sy-subrc IS INITIAL.

      READ ENTITIES OF zi_sd_cockpit_devolucao_gerdev IN LOCAL MODE
      ENTITY refval
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT lt_refvalores.


      CHECK lt_refvalores IS NOT INITIAL.

      SELECT *                                     "#EC CI_EMPTY_SELECT
      FROM ztsd_devolucao_i
      INTO TABLE @DATA(lt_devolucao_i)
      FOR ALL ENTRIES IN @lt_refvalores
      WHERE guid  EQ @lt_refvalores-guid
        AND item  EQ @lt_refvalores-item.

      SORT lt_devolucao_i BY guid item.

      DATA(lo_calcula) = NEW zclsd_ckpt_dev_calc_valores(  ).

* *------------------------------------------------------------------
* *Calcula Peso Bruto
* *------------------------------------------------------------------
*lt_refvalores_aux = LT_REFVALORES.
      DATA(lt_mensagens) = lo_calcula->atualiza_preco_bruto( IMPORTING ev_erro = lv_erro  CHANGING ct_refvalores =  lt_refvalores ).

* *------------------------------------------------------------------
* * Verifica se o aceitar valores foi setado e Calcula Peso Liquido
* *------------------------------------------------------------------
      LOOP AT lt_refvalores[] ASSIGNING FIELD-SYMBOL(<fs_refvalores>).

        IF <fs_refvalores>-aceitavalores IS NOT INITIAL.
          READ TABLE lt_devolucao_i ASSIGNING FIELD-SYMBOL(<fs_item>) WITH KEY guid = <fs_refvalores>-guid  item = <fs_refvalores>-item BINARY SEARCH.

          DATA(lt_mensagens_aux) = lo_calcula->atualiza_preco_liquido( IMPORTING ev_erro = lv_erro_l  CHANGING cs_refvalores = <fs_refvalores> ).

* *------------------------------------------------------------------
* * Mensagens de Retorno
* *------------------------------------------------------------------
          APPEND LINES OF lt_mensagens_aux TO lt_mensagens.

          reported-refval = VALUE #(
      FOR ls_mensagem IN lt_mensagens
      ( %tky = VALUE #( guid = <fs_refvalores>-guid item = <fs_refvalores>-item )
        %msg        =
          new_message(
            id       = ls_mensagem-id
            number   = ls_mensagem-number
            severity = CONV #( ls_mensagem-type )
            v1       = ls_mensagem-message_v1
            v2       = ls_mensagem-message_v2
            v3       = ls_mensagem-message_v3
            v4       = ls_mensagem-message_v4 )
      ) ) .

* *------------------------------------------------------------------
* * Preenche estrutura para  atualizar tabela
* *------------------------------------------------------------------
          IF lv_erro NE abap_true AND lv_erro_l NE abap_true.
            <fs_item>-vl_unit_fatura  =  <fs_refvalores>-sugestaovalor.
            <fs_item>-vl_total_fatura =  <fs_refvalores>-totalfatura.
            <fs_item>-vl_bruto_fatura =  <fs_refvalores>-brutofatura.
            DATA(lv_modify) = abap_true.
          ENDIF.

        ENDIF.
      ENDLOOP.

* *------------------------------------------------------------------
* * Atualiza Tabela
* *------------------------------------------------------------------
      IF lv_modify IS NOT INITIAL.
        MODIFY ztsd_devolucao_i FROM TABLE lt_devolucao_i.
      ENDIF.

** ---------------------------------------------------------------------------
** Retornar mensagens
** ---------------------------------------------------------------------------
    ELSE.

      APPEND VALUE #(

                               %msg       = new_message(
                                 id       = 'ZSD_COCKPIT_DEVOL'
                                 number   = '001'
                                 severity = CONV #( 'E' ) ) ) TO reported-refval.

    ENDIF.

  ENDMETHOD.

  METHOD atualizamaterial.

    AUTHORITY-CHECK OBJECT 'ZDEV_DEVOL' FOR USER sy-uname
    ID 'ACTVT' FIELD '01'.    "Criar

    IF sy-subrc IS INITIAL.

      READ ENTITIES OF zi_sd_cockpit_devolucao_gerdev IN LOCAL MODE
      ENTITY geradevolucao BY \_refval ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_refvalores)
      FAILED DATA(lt_failed).

      CHECK lt_refvalores IS NOT INITIAL.

      DELETE lt_refvalores WHERE fatura IS INITIAL AND itemfatura IS INITIAL.

      DATA(lv_lines_old) = lines( lt_refvalores ).

      SORT lt_refvalores BY fatura itemfatura.
      DELETE ADJACENT DUPLICATES FROM lt_refvalores COMPARING fatura itemfatura.

      DATA(lv_lines_new) = lines( lt_refvalores ).

      "Já existe uma seleção com este documento de faturamento e item.
      IF  lv_lines_new < lv_lines_old.
        APPEND VALUE #( %msg     = new_message(
                        id       = 'ZSD_COCKPIT_DEVOL'
                        number   = '023'
                        severity = CONV #( 'E' ) ) ) TO reported-refval.
      ELSE.

        SELECT docfaturamento, item, material, textomat, quantidade, quantidadependente, unvenda
        FROM zi_sd_cockpit_devolucao_docfat
        FOR ALL ENTRIES IN @lt_refvalores
        WHERE docfaturamento EQ @lt_refvalores-fatura
          AND item           EQ @lt_refvalores-itemfatura
          AND faturadev      = ''
          INTO TABLE @DATA(lt_fatura).


        SELECT *                                   "#EC CI_EMPTY_SELECT
        FROM ztsd_devolucao_i
        INTO TABLE @DATA(lt_devolucao_i)
        FOR ALL ENTRIES IN @lt_refvalores
        WHERE guid   EQ @lt_refvalores-guid
          AND item   EQ @lt_refvalores-item.



        SORT lt_fatura BY docfaturamento item.
        SORT lt_devolucao_i BY guid item.

        LOOP AT lt_refvalores ASSIGNING FIELD-SYMBOL(<fs_refvalores>).
          READ TABLE lt_fatura ASSIGNING FIELD-SYMBOL(<fs_fatura>) WITH KEY docfaturamento = <fs_refvalores>-fatura
                                                                            item           = <fs_refvalores>-itemfatura BINARY SEARCH.
          IF <fs_fatura> IS ASSIGNED.

            READ TABLE lt_devolucao_i ASSIGNING FIELD-SYMBOL(<fs_devolucao_i>) WITH KEY guid = <fs_refvalores>-guid
                                                                                        item = <fs_refvalores>-item BINARY SEARCH.
            IF <fs_devolucao_i> IS ASSIGNED AND <fs_devolucao_i>-fatura <> <fs_refvalores>-fatura.
              <fs_devolucao_i>-material         = <fs_fatura>-material.
              <fs_devolucao_i>-texto_material   = <fs_fatura>-textomat.
              <fs_devolucao_i>-qtd_fatura       = <fs_fatura>-quantidadependente.
              <fs_devolucao_i>-un_fatura        = <fs_fatura>-unvenda.
              <fs_devolucao_i>-aceita_val       = abap_false.
              <fs_devolucao_i>-vl_sugestao      = ''.
            ELSE.
              DELETE lt_devolucao_i INDEX sy-tabix.
            ENDIF.

          ENDIF.

        ENDLOOP.

        IF lt_devolucao_i IS NOT INITIAL.
          MODIFY ztsd_devolucao_i FROM TABLE  lt_devolucao_i. "#EC CI_IMUD_NESTED
        ENDIF.

      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD verificaquantidade.

    READ ENTITIES OF zi_sd_cockpit_devolucao_gerdev IN LOCAL MODE
     ENTITY refval
     ALL FIELDS
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_refvalores).


    IF lt_refvalores IS NOT INITIAL.

      SELECT *                                     "#EC CI_EMPTY_SELECT
      FROM zi_sd_cockpit_devolucao_docfat
      FOR ALL ENTRIES IN @lt_refvalores
      WHERE docfaturamento EQ @lt_refvalores-fatura
        AND item           EQ @lt_refvalores-itemfatura
      INTO TABLE @DATA(lt_docfat).
      SORT lt_docfat BY docfaturamento item.

      LOOP AT lt_refvalores ASSIGNING FIELD-SYMBOL(<fs_refvalores>).

        READ TABLE lt_docfat ASSIGNING FIELD-SYMBOL(<fs_docfat>) WITH KEY docfaturamento = <fs_refvalores>-fatura
                                                                          item           = <fs_refvalores>-itemfatura BINARY SEARCH.
        IF <fs_docfat> IS ASSIGNED.
          IF <fs_refvalores>-fatura IS NOT INITIAL AND <fs_refvalores>-quantidade <> <fs_docfat>-quantidadependente.

            APPEND VALUE #(  %tky = VALUE #( guid     = <fs_refvalores>-guid
                                             item     = <fs_refvalores>-item )
                        %element-quantidadefatura     = if_abap_behv=>mk-on
                                             %msg     = new_message(
                                              id      = 'ZSD_COCKPIT_DEVOL'
                                          number      = 035
                                              v1      = <fs_refvalores>-item
                                       severity       = if_abap_behv_message=>severity-information ) )  TO reported-refval.
          ENDIF.

          convert_quantidade(
            EXPORTING
              is_refvalores = <fs_refvalores>
              is_docfat     = <fs_docfat>
            IMPORTING
              ev_menge      = DATA(lv_quantidade)
          ).

          IF <fs_refvalores>-fatura IS NOT INITIAL AND  lv_quantidade > <fs_docfat>-quantidadependente.

*
            APPEND VALUE #(  %tky = VALUE #( guid     = <fs_refvalores>-guid
                                             item     = <fs_refvalores>-item )
                        %element-quantidadefatura     = if_abap_behv=>mk-on
                                             %msg     = new_message(
                                              id      = 'ZSD_COCKPIT_DEVOL'
                                          number      = 036
                                              v1      = <fs_refvalores>-item
                                       severity       = if_abap_behv_message=>severity-information ) )  TO reported-refval.


          ENDIF.
*
          conversion_exit_cunit( CHANGING cs_docfat = <fs_docfat> ).

          IF <fs_refvalores>-fatura IS NOT INITIAL AND <fs_refvalores>-unmedida <> <fs_docfat>-unmedida.

            APPEND VALUE #(  %tky = VALUE #( guid     = <fs_refvalores>-guid
                                             item     = <fs_refvalores>-item )
                        %element-quantidadefatura     = if_abap_behv=>mk-on
                                             %msg     = new_message(
                                              id      = 'ZSD_COCKPIT_DEVOL'
                                          number      = 037
                                              v1      = <fs_refvalores>-item
                                       severity       = if_abap_behv_message=>severity-information ) )  TO reported-refval.

          ENDIF.
        ENDIF.
      ENDLOOP.

    ENDIF.

  ENDMETHOD.

  METHOD convert_quantidade.

    DATA: lv_quantidade TYPE bstmg.

    IF is_refvalores-unmedidafatura <> is_refvalores-unmedida.

      lv_quantidade = is_refvalores-quantidade.

      CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
        EXPORTING
          i_matnr              = is_refvalores-material
          i_in_me              = convert_unit( is_refvalores )
          i_out_me             = is_refvalores-unmedidafatura
          i_menge              = lv_quantidade
        IMPORTING
          e_menge              = ev_menge
        EXCEPTIONS
          error_in_application = 1
          error                = 2
          OTHERS               = 3.

      IF sy-subrc NE 0.
        ev_menge = is_docfat-quantidade.
      ENDIF.

    ELSE.
      ev_menge = is_docfat-quantidade.
    ENDIF.


  ENDMETHOD.

  METHOD convert_unit.

    CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
      EXPORTING
        input          = is_refvalores-unmedida
        language       = sy-langu
      IMPORTING
        output         = rv_unmedida
      EXCEPTIONS
        unit_not_found = 1
        OTHERS         = 2.

    IF sy-subrc <> 0.
      rv_unmedida = is_refvalores-unmedida.
    ENDIF.

  ENDMETHOD.

  METHOD conversion_exit_cunit.

    DATA(lv_unidade) = cs_docfat-unmedida.

    CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
      EXPORTING
        input          = lv_unidade
        language       = sy-langu
      IMPORTING
        output         = cs_docfat-unmedida
      EXCEPTIONS
        unit_not_found = 1
        OTHERS         = 2.

    IF sy-subrc <> 0.
      cs_docfat-unmedida = lv_unidade.
    ENDIF.

  ENDMETHOD.


*  METHOD get_refvalores.
*    r_result = me->gt_refvalores.
*  ENDMETHOD.


ENDCLASS.
