*&---------------------------------------------------------------------*
*& Include          ZXVVAU05
*&---------------------------------------------------------------------*

DATA lt_komv TYPE TABLE OF komv.
FIELD-SYMBOLS <fs_komv> TYPE ANY TABLE.

ASSIGN ('(SAPMV45A)XKOMV[]') TO <fs_komv>.

CHECK <fs_komv> IS ASSIGNED.

lt_komv = <fs_komv>.

SELECT *
  FROM t683s
  INTO TABLE @DATA(lt_t683s)
  WHERE kzwiw IN ('@','#','$','%','&','*','(',')','^','[',']','{','}','<','>')
  AND kvewe = 'A'
  AND   kappl = 'V'
  AND  kalsm = @xvbak-kalsm.

LOOP AT xvbap ASSIGNING FIELD-SYMBOL(<fs_vbap>).

  LOOP AT lt_t683s ASSIGNING FIELD-SYMBOL(<fs_t683s>).

    TRY.
        DATA(lv_value) = lt_komv[ kschl = <fs_t683s>-kschl kposn = <fs_vbap>-posnr ]-kwert.
      CATCH cx_sy_itab_line_not_found.
        EXIT.
    ENDTRY.

    CASE <fs_t683s>-kzwiw.
      WHEN '@'.  "Transfer.valores para KOMP-ZKZWI1
        ADD lv_value TO <fs_vbap>-zzkzwi1.
      WHEN '#'.  "  Transfer.valores para KOMP-ZKZWI2
        ADD lv_value TO <fs_vbap>-zzkzwi2.
      WHEN '$'.  "  Transfer.valores para KOMP-ZKZWI3
        ADD lv_value TO <fs_vbap>-zzkzwi3.
      WHEN '%'.  "  Transfer.valores para KOMP-ZKZWI4
        ADD lv_value TO <fs_vbap>-zzkzwi4.
      WHEN '&'.  "  Transfer.valores para KOMP-ZKZWI5
        ADD lv_value TO <fs_vbap>-zzkzwi5.
      WHEN '*'.  "  Transfer.valores para KOMP-ZKZWI6
        ADD lv_value TO <fs_vbap>-zzkzwi6.
      WHEN '('.  "  Transfer.valores para KOMP-ZKZWI7
        ADD lv_value TO <fs_vbap>-zzkzwi7.
      WHEN ')'.  "  Transfer.valores para KOMP-ZKZWI8
        ADD lv_value TO <fs_vbap>-zzkzwi8.
      WHEN '^'.  "  Transfer.valores para KOMP-ZKZWI9
        ADD lv_value TO <fs_vbap>-zzkzwi9.
      WHEN '['.  "  Transfer.valores para KOMP-ZKZWI10
        ADD lv_value TO <fs_vbap>-zzkzwi10.
      WHEN ']'.  "  Transfer.valores para KOMP-ZKZWI11
        ADD lv_value TO <fs_vbap>-zzkzwi11.
      WHEN '{'.  "  Transfer.valores para KOMP-ZKZWI12
        ADD lv_value TO <fs_vbap>-zzkzwi12.
      WHEN '}'.  "  Transfer.valores para KOMP-ZKZWI13
        ADD lv_value TO <fs_vbap>-zzkzwi13.
      WHEN '<'.  "  Transfer.valores para KOMP-ZKZWI14
        ADD lv_value TO <fs_vbap>-zzkzwi14.
      WHEN '>'.  "  Transfer.valores para KOMP-ZKZWI15
        ADD lv_value TO <fs_vbap>-zzkzwi15.
    ENDCASE.

  ENDLOOP.

ENDLOOP.
