***********************************************************************
***                           © 3corações                           ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Ajuste Inventário Diferimento                          *
*** AUTOR : Luís Gustavo Schepp – META                                *
*** FUNCIONAL: Sandro Seixas Schanchinski – META                      *
*** DATA : 11/04/2023                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR        | DESCRIÇÃO                             *
***-------------------------------------------------------------------*
***   /  /     |              |                                       *
***********************************************************************
*&--------------------------------------------------------------------*
*& Include ZSDI_INVENTARIO_DIF
*&--------------------------------------------------------------------*
    DATA: ls_vake  TYPE vakekond,
          ls_sdica TYPE j_1bsdica.

    CONSTANTS: lc_kvewe TYPE t685-kvewe VALUE 'A',
               lc_kappl TYPE komk-kappl VALUE 'V',
               lc_lei   TYPE t685-kschl VALUE 'ICLW',
               lc_xsubt TYPE komk-xsubt VALUE '05'.

    DATA: lv_regio    TYPE ztmm_regio_difer-regio,
          lv_knuma_bo TYPE konp-knuma_bo.

    CLEAR: lv_regio,
           lv_knuma_bo.


*  REGIÃO E MENSAGENS PARA REGRA DO DIFERIMENTO.
    SELECT SINGLE regio
      FROM ztmm_regio_difer
      INTO lv_regio
      WHERE regio EQ tkomk-regio.
* Verificar se é uma saída intraestadual para os estados com diferimento ou ajuste de inventário
    IF NOT lv_regio IS INITIAL AND
       tkomk-wkreg = lv_regio AND
       tkomk-regio = lv_regio AND
       tkomk-taxk3 = ' ' OR
      ( tkomk-xsubt = lc_xsubt ).
      CLEAR ls_vake.
* Verificar grupo de impostos da lei fiscal
      CALL FUNCTION 'CONDITION_RECORD_READ'
        EXPORTING
          pi_kvewe        = lc_kvewe "Utilização
          pi_kappl        = lc_kappl "Aplicação
          pi_kschl        = lc_lei    "Tipo de Condição - ICLW
          pi_i_komk       = tkomk    "Estrutura de comunicação - Cabeçalho
          pi_i_komp       = tkomp    "Estrutura de comunicação - Item
        IMPORTING
          pe_i_vake       = ls_vake "Estrura de registro de condições
        EXCEPTIONS
          no_record_found = 1
          OTHERS          = 2.
* Recuperar lei fiscal para a condição ICLW para o grupo de impostos diferentes de 87
      IF sy-subrc IS INITIAL AND
         NOT ls_vake IS INITIAL.
        SELECT SINGLE knuma_bo
          INTO lv_knuma_bo
          FROM konp
          WHERE knumh = ls_vake-knumh
            AND kopos = ls_vake-kopos.
* Se encontrar nas exceções dinâmicas, redeterminar lei fiscal
        IF sy-subrc IS INITIAL AND
           NOT lv_knuma_bo IS INITIAL AND
           NOT vbap-j_1btaxlw1 = lv_knuma_bo .
          vbap-j_1btaxlw1 = lv_knuma_bo.
        ENDIF.
* Se não, buscar na dica
      ELSE.
* Recuperar lei fiscal "Default" por tipo de ordem e categoria de item
        CALL FUNCTION 'J_1BSDICA_READ'
          EXPORTING
            order_type           = vbak-auart
            item_category        = vbap-pstyv
          IMPORTING
            e_j_1bsdica          = ls_sdica
          EXCEPTIONS
            not_found            = 1
            parameters_incorrect = 2
            OTHERS               = 3.
        IF sy-subrc IS INITIAL AND
           NOT ls_sdica-taxlw1 IS INITIAL AND
           NOT vbap-j_1btaxlw1 = lv_knuma_bo .
          vbap-j_1btaxlw1 = ls_sdica-taxlw1.
        ENDIF.
      ENDIF.
    ENDIF.
