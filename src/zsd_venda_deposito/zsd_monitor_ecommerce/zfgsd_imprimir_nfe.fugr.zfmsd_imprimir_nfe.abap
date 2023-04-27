FUNCTION zfmsd_imprimir_nfe.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_DOCNUM) TYPE  J_1BDOCNUM
*"  TABLES
*"      ET_RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------

  DATA: ls_printer TYPE rsponame.

  DATA ls_return TYPE bapiret2.

*  APPEND INITIAL LINE TO et_return ASSIGNING FIELD-SYMBOL(ls_return).

  SELECT SINGLE *
    INTO @DATA(ls_active)
    FROM j_1bnfe_active
    WHERE docnum = @iv_docnum.

  IF sy-subrc IS INITIAL.

    SELECT SINGLE *
      INTO @DATA(ls_b120)
      FROM b120
      WHERE kappl = 'NF'
        AND kschl = 'ZF55'
        AND bukrs = @ls_active-bukrs
        AND j_1bbranch = @ls_active-branch
        AND j_1bform = @ls_active-form.

    IF sy-subrc IS INITIAL.

      SELECT SINGLE *
        INTO @DATA(ls_nach)
        FROM nach
        WHERE knumh = @ls_b120-knumh.

      IF sy-subrc  IS INITIAL AND ls_nach-ldest IS NOT INITIAL.

        ls_printer = ls_nach-ldest.

        IF ls_active-code EQ '100' "NF-e autorizada
        AND ls_active-cancel IS INITIAL "NF-e não cancelada
        AND ls_active-conting_s IS INITIAL. "Não  imprimir autom. se ela foi alternada

          CALL FUNCTION 'J_1BNFE_CALL_RSNAST00'
            EXPORTING
              i_active    = ls_active
              i_kappl     = 'NF'
              i_nacha     = '1'
              i_dimme     = 'X'
              i_printer   = ls_printer
            EXCEPTIONS
              print_error = 1
              OTHERS      = 2.

        ELSE.
          sy-subrc = 4.
        ENDIF.

        IF sy-subrc <> 0.

*          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO ls_return-message.

*          ls_return-message = |{ TEXT-001 } { iv_docnum }: { ls_return-message }|.

          ls_return-type = 'E'.
          ls_return-id = 'ZSD_MONITOR_ECOMM'.
          ls_return-number = '007'.
          ls_return-message_v1 = iv_docnum.

          MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number
          WITH ls_return-message_v1 ls_return-message_v2 ls_return-message_v3 ls_return-message_v4 INTO ls_return-message.
        ELSE.

          ls_return-type = 'S'.
          ls_return-id = 'ZSD_MONITOR_ECOMM'.
          ls_return-number = '005'.
          ls_return-message_v1 = iv_docnum.
          ls_return-message_v2 = ls_printer.

          MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number
          WITH ls_return-message_v1 ls_return-message_v2 ls_return-message_v3 ls_return-message_v4 INTO ls_return-message.

        ENDIF.
      ELSE.
        ls_return-type = 'E'.
        ls_return-id = 'ZSD_MONITOR_ECOMM'.
        ls_return-number = '004'.
        ls_return-message_v1 = iv_docnum.

        MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number
        WITH ls_return-message_v1 ls_return-message_v2 ls_return-message_v3 ls_return-message_v4 INTO ls_return-message.
      ENDIF.

    ELSE.
      ls_return-type = 'E'.
      ls_return-id = 'ZSD_MONITOR_ECOMM'.
      ls_return-number = '003'.
      ls_return-message_v1 = iv_docnum.

      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number
      WITH ls_return-message_v1 ls_return-message_v2 ls_return-message_v3 ls_return-message_v4 INTO ls_return-message.

    ENDIF.

  ELSE.
    ls_return-type = 'E'.
    ls_return-id = 'ZSD_MONITOR_ECOMM'.
    ls_return-number = '002'.
    ls_return-message_v1 = iv_docnum.

    MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number
    WITH ls_return-message_v1 ls_return-message_v2 ls_return-message_v3 ls_return-message_v4 INTO ls_return-message.

  ENDIF.

  APPEND ls_return TO et_return[].

ENDFUNCTION.
