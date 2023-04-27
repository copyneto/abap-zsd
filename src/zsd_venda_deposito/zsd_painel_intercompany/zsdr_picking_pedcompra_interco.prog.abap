*&---------------------------------------------------------------------*
*& Report ZSDR_JOB_INTERCOMPANY_REMESSA
*&---------------------------------------------------------------------*
*& Programa utilizado no processo de intercompany
*& executa o programa WS_MONITOR_OUTB_DEL_GDSI
*&
*& Execução feita por configuração de JOB
*&---------------------------------------------------------------------*
REPORT zsdr_picking_pedcompra_interco.

*********************************************************************
* TABLES                                                            *
*********************************************************************
TABLES: likp.
*********************************************************************
* TELA DE SELEÇÃO                                                   *
*********************************************************************
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS:
   s_remess FOR likp-vbeln.

SELECTION-SCREEN END OF BLOCK b1.
**********************************************************************
* EVENTOS                                                            *
**********************************************************************

INITIALIZATION.

  TYPES: BEGIN OF ty_text,
           data TYPE c LENGTH 2000,
         END OF ty_text.

  DATA: lt_bdcdata    TYPE STANDARD TABLE OF bdcdata,
        lt_bdcmsgcoll TYPE STANDARD TABLE OF bdcmsgcoll.

  DATA: lv_mode TYPE char1 VALUE 'A'.


  DATA: lt_text TYPE STANDARD TABLE OF ty_text,
        lt_mem  TYPE STANDARD TABLE OF abaplist.

  CONSTANTS: gc_lfart TYPE likp-lfart  VALUE 'Z004',
             gc_wbstk TYPE likp-wbstk  VALUE 'A',
             gc_vbtyp TYPE likp-vbtyp  VALUE 'J'
             .

**********************************************************************
* LOGICA PRINCIPAL
**********************************************************************
START-OF-SELECTION.

  IF s_remess[] IS INITIAL.

    SELECT vbeln
      FROM likp
      INTO TABLE @DATA(lt_likp)
      WHERE lfart = @gc_lfart
      AND   wbstk = @gc_wbstk
      AND   vbtyp = @gc_vbtyp
      AND   lifsk = @space
      .

  ELSE.

    SELECT vbeln
      FROM likp
      INTO TABLE @lt_likp
      WHERE vbeln IN @s_remess
      AND lfart = @gc_lfart
      AND wbstk = @gc_wbstk
      AND vbtyp = @gc_vbtyp
      AND lifsk = @space
      .

  ENDIF.

  LOOP AT lt_likp INTO DATA(ls_likp).

*    SUBMIT ws_monitor_outb_del_gdsi EXPORTING LIST TO MEMORY AND RETURN
*      WITH it_vbeln-low = ls_likp.
*
*    CALL FUNCTION 'LIST_FROM_MEMORY'
*      TABLES
*        listobject = lt_mem.
*
*    IF lt_mem[] IS NOT INITIAL.
*
*      CALL FUNCTION 'LIST_TO_ASCI'
*        EXPORTING
*          list_index = -1
*        TABLES
*          listasci   = lt_text
*          listobject = lt_mem.
*
*    ENDIF.

    lt_bdcdata = VALUE #( BASE lt_bdcdata ( program  = 'SAPMV50A'
                                            dynpro   = '4004'
                                            dynbegin = 'X' ) ).
    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_CURSOR'
                                            fval = 'LIKP-VBELN' ) ).

    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_OKCODE'
                                            fval = '=WABU_T' ) ).
    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'LIKP-VBELN'
                                        fval = '80014029' ) ).


*
*    lt_bdcdata = VALUE #( BASE lt_bdcdata ( program  = 'WS_MONITOR_OUTB_DEL_GDSI'
*                                            dynpro   = '1000'
*                                            dynbegin = 'X' ) ).
*
*    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_CURSOR'
*                                            fval = 'IF_VSTEL-LOW' ) ).
*
*    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_OKCODE'
*                                            fval = '=ALLS' ) ).
*
*    lt_bdcdata = VALUE #( BASE lt_bdcdata ( program  = 'WS_MONITOR_OUTB_DEL_GDSI'
*                                        dynpro   = '1000'
*                                        dynbegin = 'X' ) ).
*
*    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_CURSOR'
*                                            fval = 'IT_VBELN-LOW' ) ).
*
*    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_OKCODE'
*                                            fval = '=ONLI' ) ).
*
*    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'IT_WADAT-LOW'
*                                            fval = '07.02.2023' ) ).
*
*    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'IT_WADAT-HIGH'
*                                            fval = '15.02.2023' ) ).
*
*    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'IT_VBELN-LOW'
*                                            fval = ls_likp ) ).
*
*    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'I_KSCHLN-LOW'
*                                            fval = 'LD00' ) ).
*
*    lt_bdcdata = VALUE #( BASE lt_bdcdata ( program  = 'SAPMSSY0'
*                                            dynpro   = '0120'
*                                            dynbegin = 'X' ) ).
*
**    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_CURSOR'
**                                            fval = '04/03' ) ).
*
*    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_OKCODE'
*                                            fval = '=&ALL' ) ).
*
*    lt_bdcdata = VALUE #( BASE lt_bdcdata ( program  = 'SAPMSSY0'
*                                        dynpro   = '0120'
*                                        dynbegin = 'X' ) ).
*
*    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_CURSOR'
*                                            fval = '04/03' ) ).
*
*    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_OKCODE'
*                                            fval = '=WABU' ) ).
*
*    lt_bdcdata = VALUE #( BASE lt_bdcdata ( program  = 'SAPLV50Q'
*                                            dynpro   = '1100'
*                                            dynbegin = 'X' ) ).
*
*    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_CURSOR'
*                                            fval = 'LIKP-WADAT_IST' ) ).
*
*    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_OKCODE'
*                                            fval = '=WEIT' ) ).
*    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'LIKP-WADAT_IST'
*                                            fval = '07.02.2023' ) ).
*
*    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'LIKP-SPE_WAUHR_IST'
*                                            fval = '12:04' ) ).

*    lt_bdcdata = VALUE #( BASE lt_bdcdata ( program  = 'SAPMSSY0'
*                                            dynpro   = '0120'
*                                           dynbegin = 'X' ) ).
*
*    lt_bdcdata = VALUE #( BASE lt_bdcdata ( fnam = 'BDC_OKCODE'
*                                        fval = '=&ONT' ) ).
*
    CALL TRANSACTION 'VL02N'
               USING lt_bdcdata
                MODE lv_mode
       MESSAGES INTO lt_bdcmsgcoll.

  ENDLOOP.
  LOOP AT lt_bdcmsgcoll INTO DATA(ls_text).
    WRITE: / ls_text .
  ENDLOOP.
