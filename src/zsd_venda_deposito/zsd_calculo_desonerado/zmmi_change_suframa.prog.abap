*&---------------------------------------------------------------------*
*& Include          ZMMI_CHANGE_SUFRAMA
*&---------------------------------------------------------------------*

    IF is_header-partyp = lc_partyp_b.

      SELECT SINGLE suframa
        INTO cs_header-isuf
        FROM kna1
        WHERE kunnr = is_header-parid.

    ENDIF.
