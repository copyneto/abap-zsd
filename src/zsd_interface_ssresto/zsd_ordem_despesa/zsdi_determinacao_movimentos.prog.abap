*&---------------------------------------------------------------------*
*& Include          ZSDI_DETERMINACAO_MOVIMENTOS
*&---------------------------------------------------------------------*
***********************************************************************
*** © 3corações ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Determinação dos movimentos                            *
*** AUTOR : Victor Silva     – Meta                                   *
*** FUNCIONAL: Sandro Seixas – Meta                                   *
*** DATA : 18/01/2021                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO                                          *
***-------------------------------------------------------------------*
*** | |                                                               *
***********************************************************************
 CONSTANTS: lc_modulo TYPE ztca_param_mod-modulo VALUE 'SD',
            lc_chave1 TYPE ztca_param_par-chave1 VALUE 'ORDEM DESPESA',
            lc_chave2 TYPE ztca_param_par-chave2 VALUE 'TIPO DOCUMENTO',
            lc_chave3 TYPE ztca_param_par-chave3 VALUE 'SAIDA'.

 CONSTANTS: lc_modulo_1 TYPE ztca_param_mod-modulo VALUE 'SD',
            lc_chave1_1 TYPE ztca_param_par-chave1 VALUE 'ORDEM DESPESA',
            lc_chave2_1 TYPE ztca_param_par-chave2 VALUE 'TIPO DOCUMENTO',
            lc_chave3_1 TYPE ztca_param_par-chave3 VALUE 'ENTRADA'.

 DATA: lr_tipo_ordem_s   TYPE RANGE OF auart,
       lv_minimo_tpdoc_s TYPE char50,
       lr_tipo_ordem_e   TYPE RANGE OF auart,
       lv_minimo_tpdoc_e TYPE char50,
       lv_auart          TYPE vbak-auart,
*       lv_augru          TYPE vbak-augru,
*       lv_tabix          LIKE svbep-tabix,
       lt_ordem_g_s      TYPE TABLE OF ztsd_ordem_g,
       lt_ordem_g_e      TYPE TABLE OF ztsd_ordem_g.

 CLEAR: lr_tipo_ordem_s, lr_tipo_ordem_e.

 DATA(lv_tabix) = svbep-tabix.

** Seleçao dos parametros
 DATA(lo_parametros) = NEW zclca_tabela_parametros( ).

*Buscar Tipo de Ordem Saída
 TRY.
     lo_parametros->m_get_range(
       EXPORTING
         iv_modulo = lc_modulo
         iv_chave1 = lc_chave1
         iv_chave2 = lc_chave2
         iv_chave3 = lc_chave3
       IMPORTING
         et_range  = lr_tipo_ordem_s ).
   CATCH zcxca_tabela_parametros.
     "handle exception
 ENDTRY.

*Buscar Tipo de Ordem Entrada
 TRY.
     lo_parametros->m_get_range(
       EXPORTING
         iv_modulo = lc_modulo_1
         iv_chave1 = lc_chave1_1
         iv_chave2 = lc_chave2_1
         iv_chave3 = lc_chave3_1
       IMPORTING
         et_range  = lr_tipo_ordem_e ).
   CATCH zcxca_tabela_parametros.
     "handle exception
 ENDTRY.

* Saída
 READ TABLE lr_tipo_ordem_s ASSIGNING FIELD-SYMBOL(<fs_tipo_ordem_s>) WITH TABLE KEY sign = 'I'  option = 'EQ' high = ' ' low = vbak-auart.
 IF sy-subrc EQ 0.
   lv_minimo_tpdoc_s = <fs_tipo_ordem_s>-low.
 ENDIF.

* Entrada
 READ TABLE lr_tipo_ordem_e ASSIGNING FIELD-SYMBOL(<fs_tipo_ordem_e>) WITH TABLE KEY sign = 'I'  option = 'EQ' high = ' ' low = vbak-auart.
 IF sy-subrc EQ 0.
   lv_minimo_tpdoc_e = <fs_tipo_ordem_e>-low.
 ENDIF.

* Tratativa ordens de venda de saída
 IF lv_tabix EQ 0 OR lv_tabix GT 1.
   IF lr_tipo_ordem_s IS NOT INITIAL.
     IF vbak-auart IN lr_tipo_ordem_s.
       IF vbak-augru IS INITIAL.
         MESSAGE ID 'ZSD_ORDEM_DESPESA' TYPE 'W' NUMBER '001' WITH vbak-auart.
       ELSE.
         SELECT *
           FROM ztsd_ordem_g
           INTO TABLE lt_ordem_g_s
           WHERE auart EQ vbak-auart
            AND  augru EQ vbak-augru.

         IF lt_ordem_g_s IS NOT INITIAL.
           SORT lt_ordem_g_s BY auart augru.

           READ TABLE lt_ordem_g_s ASSIGNING FIELD-SYMBOL(<fs_ordem_g_s>) WITH KEY auart = vbak-auart
                                                                                   augru = vbak-augru BINARY SEARCH.
           IF sy-subrc = 0.
             vbep-bwart = <fs_ordem_g_s>-bwart.
           ENDIF.
         ELSE.
           MESSAGE ID 'ZSD_ORDEM_DESPESA' TYPE 'W' NUMBER '002' WITH vbak-auart.
         ENDIF.
       ENDIF.
     ENDIF.
   ENDIF.
 ENDIF.

* Tratativa ordens de venda de entrada
 IF lv_tabix EQ 0 OR lv_tabix GT 1.
   IF lr_tipo_ordem_e IS NOT INITIAL.
     IF vbak-auart IN lr_tipo_ordem_e.
       IF vbak-augru IS INITIAL.
         MESSAGE ID 'ZSD_ORDEM_DESPESA' TYPE 'W' NUMBER '001' WITH vbak-auart.
       ELSE.
         SELECT *
         FROM ztsd_ordem_g
         INTO TABLE lt_ordem_g_e
         WHERE auart EQ vbak-auart
          AND  augru EQ vbak-augru.

         IF lt_ordem_g_e IS NOT INITIAL.
           SORT lt_ordem_g_e BY auart augru.

           READ TABLE lt_ordem_g_e ASSIGNING FIELD-SYMBOL(<fs_ordem_g_e>) WITH KEY auart = vbak-auart
                                                                                   augru = vbak-augru BINARY SEARCH.
           IF sy-subrc = 0.
             vbep-bwart = <fs_ordem_g_e>-bwart1.
           ENDIF.
         ELSE.
           MESSAGE ID 'ZSD_ORDEM_DESPESA' TYPE 'W' NUMBER '002' WITH vbak-auart.
         ENDIF.
       ENDIF.
     ENDIF.
   ENDIF.
 ENDIF.
