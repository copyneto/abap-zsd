*&---------------------------------------------------------------------*
*& Include          ZXVVFU02
*&---------------------------------------------------------------------*
DATA lt_t683s TYPE TABLE OF t683s.

SELECT *
  FROM t683s
  INTO TABLE lt_t683s
  WHERE kzwiw IN ('@','#','$','%','&','*','(',')','^','[',']','{','}','<','>')
  AND kvewe = 'A'
  AND   kappl = 'V'
  AND  kalsm = vbrk-kalsm.

LOOP AT cvbrp ASSIGNING FIELD-SYMBOL(<fs_vbrp>).

  "Limpa Valores vindo da VBAP
  CLEAR: <fs_vbrp>-zzkzwi1,
         <fs_vbrp>-zzkzwi2,
         <fs_vbrp>-zzkzwi3,
         <fs_vbrp>-zzkzwi4,
         <fs_vbrp>-zzkzwi5,
         <fs_vbrp>-zzkzwi6,
         <fs_vbrp>-zzkzwi7,
         <fs_vbrp>-zzkzwi8,
         <fs_vbrp>-zzkzwi9,
         <fs_vbrp>-zzkzwi10,
         <fs_vbrp>-zzkzwi11,
         <fs_vbrp>-zzkzwi12,
         <fs_vbrp>-zzkzwi13,
         <fs_vbrp>-zzkzwi14,
         <fs_vbrp>-zzkzwi15.

  LOOP AT lt_t683s ASSIGNING FIELD-SYMBOL(<fs_t683s>).

    TRY.
        DATA(lv_value) = ckomv[ kschl = <fs_t683s>-kschl kposn = <fs_vbrp>-posnr ]-kwert.
      CATCH cx_sy_itab_line_not_found.
        EXIT.
    ENDTRY.

    CASE <fs_t683s>-kzwiw.
      WHEN '@'.  "Transfer.valores para KOMP-ZKZWI1
        ADD lv_value TO <fs_vbrp>-zzkzwi1.
      WHEN '#'.  "  Transfer.valores para KOMP-ZKZWI2
        ADD lv_value TO <fs_vbrp>-zzkzwi2.
      WHEN '$'.  "  Transfer.valores para KOMP-ZKZWI3
        ADD lv_value TO <fs_vbrp>-zzkzwi3.
      WHEN '%'.  "  Transfer.valores para KOMP-ZKZWI4
        ADD lv_value TO <fs_vbrp>-zzkzwi4.
      WHEN '&'.  "  Transfer.valores para KOMP-ZKZWI5
        ADD lv_value TO <fs_vbrp>-zzkzwi5.
      WHEN '*'.  "  Transfer.valores para KOMP-ZKZWI6
        ADD lv_value TO <fs_vbrp>-zzkzwi6.
      WHEN '('.  "  Transfer.valores para KOMP-ZKZWI7
        ADD lv_value TO <fs_vbrp>-zzkzwi7.
      WHEN ')'.  "  Transfer.valores para KOMP-ZKZWI8
        ADD lv_value TO <fs_vbrp>-zzkzwi8.
      WHEN '^'.  "  Transfer.valores para KOMP-ZKZWI9
        ADD lv_value TO <fs_vbrp>-zzkzwi9.
      WHEN '['.  "  Transfer.valores para KOMP-ZKZWI10
        ADD lv_value TO <fs_vbrp>-zzkzwi10.
      WHEN ']'.  "  Transfer.valores para KOMP-ZKZWI11
        ADD lv_value TO <fs_vbrp>-zzkzwi11.
      WHEN '{'.  "  Transfer.valores para KOMP-ZKZWI12
        ADD lv_value TO <fs_vbrp>-zzkzwi12.
      WHEN '}'.  "  Transfer.valores para KOMP-ZKZWI13
        ADD lv_value TO <fs_vbrp>-zzkzwi13.
      WHEN '<'.  "  Transfer.valores para KOMP-ZKZWI14
        ADD lv_value TO <fs_vbrp>-zzkzwi14.
      WHEN '>'.  "  Transfer.valores para KOMP-ZKZWI15
        ADD lv_value TO <fs_vbrp>-zzkzwi15.
    ENDCASE.

  ENDLOOP.

ENDLOOP.
