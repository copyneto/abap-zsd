*&---------------------------------------------------------------------*
*& Include          ZXVVAU09
*&---------------------------------------------------------------------*

TABLES: bseg.

DATA: lv_bukrs TYPE bukrs,
      lv_vbelv TYPE vbelv,
      lt_bseg  TYPE bseg,
      lv_auart LIKE vbak-auart,
      lv_vbtyp LIKE tvak-vbtyp.

CONSTANTS:
  lc_vbtyp_v LIKE vbfa-vbtyp_v VALUE 'C',
  lc_vbtyp_n LIKE vbfa-vbtyp_n VALUE 'H'.

GET PARAMETER ID 'AAT' FIELD lv_auart.

SELECT SINGLE vbtyp INTO lv_vbtyp FROM tvak WHERE auart = lv_auart.

IF sy-subrc = 0.
  IF lv_vbtyp = 'H'.  "Devolução

    SELECT SINGLE vbelv
      FROM vbfa
      INTO lv_vbelv
      WHERE vbeln = i_vbap-vgbel AND
            vbtyp_v = lc_vbtyp_v.

    SELECT SINGLE bukrs_vf
      FROM vbak
      INTO lv_bukrs
      WHERE vbeln = lv_vbelv.

    SELECT COUNT(*)
        FROM bseg
        WHERE bukrs = lv_bukrs AND
              belnr = i_vbap-vgbel AND
              augbl NE ''.

    IF sy-subrc = 0.
      MESSAGE s002(zsd) DISPLAY LIKE 'E'.
      LEAVE TO TRANSACTION sy-tcode.
    ENDIF.
  ENDIF.


*Validação de devolução em duplicidade

  CHECK lv_vbtyp = 'H'.  "Devolução

  CHECK i_screen_name EQ 'RV45A-KWMENG'.

  TABLES: vbak,
          vbrk,
          vbap.


  DATA: BEGIN OF lt_vbrk OCCURS 0.
          INCLUDE STRUCTURE vbrk.
  DATA: END OF lt_vbrk.

  DATA: BEGIN OF lt_vbak OCCURS 0.
          INCLUDE STRUCTURE vbak.
  DATA: END OF lt_vbak.

  SELECT *
    FROM vbrk
    INTO TABLE lt_vbrk
    WHERE vbeln EQ i_vbap-vgbel.

  CHECK NOT lt_vbrk[] IS INITIAL.
  SORT lt_vbrk BY vbeln.
  READ TABLE lt_vbrk WITH KEY vbeln = i_vbap-vgbel BINARY SEARCH.


  IF lt_vbrk-fksto EQ 'X'.
    MESSAGE i001(zsd).
    LEAVE TO TRANSACTION sy-tcode. "retornar p a transação atual
  ELSE.
    IF sy-tcode = 'VA01'.
      SELECT posnv, rfmng
        FROM vbfa
        INTO TABLE @DATA(lt_venda)
        WHERE vbtyp_v = @lc_vbtyp_v
          AND vbeln = @lt_vbrk-vbeln.
      IF sy-subrc EQ 0.
        SELECT posnv, SUM( rfmng ) AS rfmng
          FROM vbfa
          INTO TABLE @DATA(lt_devol)
          WHERE vbtyp_n = @lc_vbtyp_n
            AND vbeln = @lt_vbrk-vbeln
            GROUP BY posnv.
        IF sy-subrc EQ 0.
          SORT lt_devol BY posnv.
          LOOP AT lt_venda ASSIGNING FIELD-SYMBOL(<fs_venda>).
            READ TABLE lt_devol ASSIGNING FIELD-SYMBOL(<fs_devol>)
            WITH KEY posnv = <fs_venda>-posnv BINARY SEARCH.
            IF sy-subrc EQ 0.
              IF <fs_devol>-rfmng GE <fs_venda>-rfmng.
                MESSAGE i000(zsd).
                LEAVE TO TRANSACTION sy-tcode. "retornar p a transação atual
              ELSE.
                CHECK i_screen_name EQ 'RV45A-KWMENG'. "????
                c_screen_input = 0.                    "????
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
*      DATA: lv_qtd TYPE i.
*      SELECT SINGLE COUNT( * )
*        FROM vbak AS a
*        JOIN vbap AS b ON a~vbeln EQ b~vbeln
*        INTO lv_qtd
*        WHERE a~vbeln NE i_vbap-vbeln AND
*              a~zuonr EQ lt_vbrk-vbeln AND
*              b~abgru EQ ''.
*      IF lv_qtd GT 0.
*        MESSAGE i000(zsd).
*        LEAVE TO TRANSACTION sy-tcode. "retornar p a transação atual
*      ELSE.
*        SELECT SINGLE COUNT( * )
*          FROM vbfa
*          INTO lv_qtd
*          WHERE vbelv = lt_vbrk-vbeln
*            AND vbtyp_n = lc_vbtyp_n.                   "#EC CI_NOFIELD
*
*        IF lv_qtd GT 0.
*          MESSAGE i000(zsd).
*          LEAVE TO TRANSACTION sy-tcode. "retornar p a transação atual
*        ELSE.
*          CHECK i_screen_name EQ 'RV45A-KWMENG'.
*          c_screen_input = 0.
*        ENDIF.
*      ENDIF.
    ENDIF.
  ENDIF.
  FREE: lt_vbrk, lt_vbak.
ENDIF.
