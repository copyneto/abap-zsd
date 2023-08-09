*&---------------------------------------------------------------------*
*& Include          ZSDI_TRATAR_DEVOLUCAO_ST_RS
*&---------------------------------------------------------------------*
***********************************************************************
*** © 3corações ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Tratar devolução com ST no RS                          *
*** AUTOR : Zenilda Lima       – Meta                                 *
*** FUNCIONAL: Jana Castilho   – Meta                                 *
*** DATA : 26/10/2021                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO                                          *
***-------------------------------------------------------------------*
*** | |                                                               *
***********************************************************************
 CONSTANTS: lc_modulo TYPE ztca_param_mod-modulo VALUE 'SD',
            lc_chave1 TYPE ztca_param_par-chave1 VALUE 'ADM DEVOLUÇÃO',
            lc_chave2 TYPE ztca_param_par-chave2 VALUE 'TP_OV_DEV_CLIENTE'.

 CONSTANTS: lc_modulo_0 TYPE ztca_param_mod-modulo VALUE 'SD',
            lc_chave_1  TYPE ztca_param_par-chave1 VALUE 'ADM DEVOLUÇÃO',
            lc_chave_2  TYPE ztca_param_par-chave2 VALUE 'REGIAO_NOTASEP'.

 CONSTANTS: lc_modulo_00 TYPE ztca_param_mod-modulo VALUE 'SD',
            lc_chave_01  TYPE ztca_param_par-chave1 VALUE 'ADM DEVOLUÇÃO',
            lc_chave_02  TYPE ztca_param_par-chave2 VALUE 'CATEGORIA_ITEM',
            lc_chave_03  TYPE ztca_param_par-chave3 VALUE 'PSTYV'.

 DATA: lr_cliente        TYPE RANGE OF auart,
       lv_minimo_cli     TYPE char50,
       lr_notasep        TYPE RANGE OF regio,
       lv_minimo_notasep TYPE char50,
       lr_item           TYPE RANGE OF pstyv,
       lv_minimo_item    TYPE char50,
*       ls_kna1           TYPE kna1,
       lv_regio          TYPE regio,
       ls_t001w          TYPE t001w.

 CLEAR: lr_cliente, lr_notasep, lr_item.
** Seleçao dos parametros
 DATA(lo_parametros) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 24.07.2023
*Buscar ORD cliente
 TRY.
     lo_parametros->m_get_range(
       EXPORTING
         iv_modulo = lc_modulo
         iv_chave1 = lc_chave1
         iv_chave2 = lc_chave2
       IMPORTING
         et_range  = lr_cliente ).
   CATCH zcxca_tabela_parametros.
     "handle exception
 ENDTRY.

*Buscar local de negócio
 TRY.
     lo_parametros->m_get_range(
         EXPORTING
           iv_modulo = lc_modulo_0
           iv_chave1 = lc_chave_1
           iv_chave2 = lc_chave_2
         IMPORTING
           et_range  = lr_notasep ).
   CATCH zcxca_tabela_parametros.
     "handle exception
 ENDTRY.

*Buscar categoria de item
 TRY.
     lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_modulo_00
            iv_chave1 = lc_chave_01
            iv_chave2 = lc_chave_02
            iv_chave3 = lc_chave_03
          IMPORTING
            et_range  = lr_item ).
   CATCH zcxca_tabela_parametros.
     "handle exception
 ENDTRY.

**Quando local de negócio for no Rio Grande do Sul - Seleçao para buscar REGIO
 IF vbap-werks IS NOT INITIAL.
   SELECT SINGLE * FROM t001w INTO ls_t001w WHERE werks = vbap-werks.
 ENDIF.

**  Quando o cliente for do Rio Grande do sul -Seleçao para buscar REGIO
 IF vbak-kunnr IS NOT INITIAL.
*   SELECT SINGLE * FROM kna1 INTO ls_kna1 WHERE kunnr = vbak-kunnr.
   SELECT SINGLE regio FROM kna1 INTO lv_regio WHERE kunnr = vbak-kunnr.
 ENDIF.

 READ TABLE lr_cliente ASSIGNING FIELD-SYMBOL(<fs_cliente>) INDEX 1.
 IF sy-subrc EQ 0.
   lv_minimo_cli = <fs_cliente>-low.
 ENDIF.

 READ TABLE lr_notasep ASSIGNING FIELD-SYMBOL(<fs_notasep>) INDEX 1.
 IF sy-subrc EQ 0.
   lv_minimo_notasep = <fs_notasep>-low.
 ENDIF.

 READ TABLE lr_item ASSIGNING FIELD-SYMBOL(<fs_item>) INDEX 1.
 IF sy-subrc EQ 0.
   lv_minimo_item = <fs_item>-low.
 ENDIF.

 IF vbak-auart EQ lv_minimo_cli.
   IF ls_t001w-regio EQ lv_minimo_notasep.
*     IF ls_kna1-regio EQ lv_minimo_notasep.
     IF lv_regio EQ lv_minimo_notasep.

*       DATA(ls_konv) = VALUE konv( kschl = 'BX41').
       CLEAR vbak-zz1_soma_icms.
       DATA(lt_xkomv) = xkomv[].
       SORT lt_xkomv BY kschl.
       DATA lv_soma_icms TYPE  komv-kwert.
       READ TABLE lt_xkomv WITH KEY kschl = 'BX41'  TRANSPORTING NO FIELDS BINARY SEARCH.
       LOOP AT lt_xkomv ASSIGNING FIELD-SYMBOL(<fs_xkomv>) FROM sy-tabix.
         IF  <fs_xkomv>-kschl = 'BX41'.
*         vbap-pstyv = lv_minimo_item.
           lv_soma_icms = vbak-zz1_soma_icms + <fs_xkomv>-kwert. "ls_konv-kbetr.
           vbak-zz1_soma_icms = lv_soma_icms.
           CONDENSE  vbak-zz1_soma_icms.
         ELSE.
           EXIT.
         ENDIF.
       ENDLOOP.

     ENDIF.
   ENDIF.
 ENDIF.
