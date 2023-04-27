"! <p class="shorttext synchronized">Classe para Geração de Partidas</p>
"! Autor: Marcos Rubik
"! <br>Data: 13/09/2021
"!
CLASS zclsd_gerar_partidas DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! <p class="shorttext synchronized">Gerar partidas</p>
    "! @parameter iv_vbeln   | <p class="shorttext synchronized">Parâmetro Fatura</p>
    "! @parameter rv_result  | <p class="shorttext synchronized">Parâmetro Resultado</p>
    CLASS-METHODS gerar
      IMPORTING
        VALUE(iv_vbeln)  TYPE vbeln_vf
      RETURNING
        VALUE(rv_result) TYPE flag .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS:
      "! <p class="shorttext synchronized">Cconstantes da tabela de Parâmetros</p>
      BEGIN OF gc_param,
        modulo   TYPE ztca_param_par-modulo VALUE 'SD',
        key1     TYPE ztca_param_par-chave1 VALUE 'CONTRATOS_FOOD',
        key2     TYPE ztca_param_par-chave2 VALUE 'CONTAS_A_RECEBER',
        doctype  TYPE ztca_param_par-chave3 VALUE 'DOCTYPE',
        conta    TYPE ztca_param_par-chave3 VALUE 'CONTA',
        costcent TYPE ztca_param_par-chave3 VALUE 'COSTCENT',
      END OF gc_param .

    "! <p class="shorttext synchronized">Busca parâmetros</p>
    "! @parameter iv_key1  | <p class="shorttext synchronized">Parâmetro chave 1</p>
    "! @parameter iv_key2  | <p class="shorttext synchronized">Parâmetro chave 2</p>
    "! @parameter iv_key3  | <p class="shorttext synchronized">Parâmetro chave 3</p>
    "! @parameter ev_param | <p class="shorttext synchronized">Parâmetro param</p>
    CLASS-METHODS get_param
      IMPORTING
        !iv_key1  TYPE ztca_param_par-chave1
        !iv_key2  TYPE ztca_param_par-chave2
        !iv_key3  TYPE ztca_param_par-chave3
      EXPORTING
        !ev_param TYPE any .
ENDCLASS.



CLASS zclsd_gerar_partidas IMPLEMENTATION.


  METHOD gerar.
    DATA: lt_accountgl      TYPE STANDARD TABLE OF bapiacgl09,
          lt_accountpayable TYPE STANDARD TABLE OF bapiacap09,
          lt_currencyamount TYPE STANDARD TABLE OF bapiaccr09,
          lt_return         TYPE STANDARD TABLE OF bapiret2.

    DATA: lv_type       TYPE bapiache09-obj_type,
          lv_key        TYPE bapiache09-obj_key,
          lv_sys        TYPE bapiache09-obj_sys,
          lv_doc_type   TYPE blart,
          lv_conta      TYPE hkont,
          lv_costcenter TYPE kostl.

    SELECT SINGLE vbeln,
                  zterm,
                  netwr,
                  erdat,
                  kunag,
                  rfbsk
      FROM vbrk
      INTO @DATA(ls_vbrk)
     WHERE vbeln = @iv_vbeln.
    IF sy-subrc EQ 0.
      IF ls_vbrk-rfbsk NE 'C'. "Contabilização da venda já foi efetuada
        CLEAR: syst-msgid, syst-msgno, syst-msgty, syst-msgv1,
               syst-msgv2, syst-msgv3, syst-msgv4.

        syst-msgid = 'ZSD_COMODATO_LOC'.
        syst-msgty = 'E'.
        syst-msgno = 001.
        CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
          EXPORTING
            msg_arbgb              = syst-msgid
            msg_nr                 = syst-msgno
            msg_ty                 = syst-msgty
            msg_v1                 = syst-msgv1
            msg_v2                 = syst-msgv2
            msg_v3                 = syst-msgv3
            msg_v4                 = syst-msgv4
          EXCEPTIONS
            message_type_not_valid = 01
            no_sy_message          = 02.
        CASE sy-subrc.
          WHEN 01.
            rv_result = 4.
          WHEN 02.
            rv_result = 4.
          WHEN OTHERS.
            rv_result = 4.
        ENDCASE.
        rv_result = 4.
        EXIT.

      ENDIF.
    ELSE.
      CLEAR: syst-msgid, syst-msgno, syst-msgty, syst-msgv1,
             syst-msgv2, syst-msgv3, syst-msgv4.

      syst-msgid = 'ZSD_COMODATO_LOC'.
      syst-msgty = 'E'.
      syst-msgno = 002.
      CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
        EXPORTING
          msg_arbgb              = syst-msgid
          msg_nr                 = syst-msgno
          msg_ty                 = syst-msgty
          msg_v1                 = syst-msgv1
          msg_v2                 = syst-msgv2
          msg_v3                 = syst-msgv3
          msg_v4                 = syst-msgv4
        EXCEPTIONS
          message_type_not_valid = 01
          no_sy_message          = 02.
      CASE sy-subrc.
        WHEN 01.
          rv_result = 4.
        WHEN 02.
          rv_result = 4.
        WHEN OTHERS.
          rv_result = 4.
      ENDCASE.

      rv_result = 4.
      EXIT.
    ENDIF.

    SELECT SINGLE werks,
                  vkorg,
                  j_1bbranch
      FROM t001w
      INTO @DATA(ls_t001w)
     WHERE kunnr = @ls_vbrk-kunag.

    SELECT SINGLE vbeln,
                  posnr,
                  werks
      FROM vbrp
      INTO @DATA(ls_vbrp)
     WHERE vbeln = @iv_vbeln.
    IF sy-subrc EQ 0.
      SELECT SINGLE werks,
                    kunnr
        FROM t001w
        INTO @DATA(ls_t001w_vendor)
       WHERE werks = @ls_vbrp-werks.
    ENDIF.

    get_param( EXPORTING iv_key1  = gc_param-key1 "CONTRATOS_FOOD
                         iv_key2  = gc_param-key2 "CONTAS_A_RECEBER
                         iv_key3  = gc_param-doctype
               IMPORTING ev_param = lv_doc_type ).

    get_param( EXPORTING iv_key1  = gc_param-key1 "CONTRATOS_FOOD
                         iv_key2  = gc_param-key2 "CONTAS_A_RECEBER
                         iv_key3  = gc_param-conta
               IMPORTING ev_param = lv_conta ).

    get_param( EXPORTING iv_key1  = gc_param-key1 "CONTRATOS_FOOD
                         iv_key2  = gc_param-key2 "CONTAS_A_RECEBER
                         iv_key3  = gc_param-costcent
               IMPORTING ev_param = lv_costcenter ).

    DATA(ls_documentheader) = VALUE bapiache09(
                                    obj_type    = 'BKPFF'
                                    username    = sy-uname
                                    header_txt  = 'ALUGUEL'
                                    comp_code   = ls_t001w-vkorg
                                    doc_date    = ls_vbrk-erdat
                                    pstng_date  = ls_vbrk-erdat
                                    fisc_year   = ls_vbrk-erdat(4)
                                    fis_period  = ls_vbrk-erdat+4(2)
                                    doc_type    = lv_doc_type
                                    ref_doc_no  = ls_vbrk-vbeln ).

    lt_accountgl = VALUE #( ( itemno_acc = '0000000002'
                              gl_account = lv_conta   "Parâmetro CONTA
                              item_text  = 'ALUGUEL'
                              comp_code  = ls_t001w-vkorg
                              bus_area   = ls_t001w-j_1bbranch
                              plant      = ls_t001w-werks
                              costcenter = lv_costcenter ) ).

    lt_accountpayable = VALUE #( ( itemno_acc    = '0000000001'
                                   vendor_no     = ls_t001w_vendor-kunnr
                                   comp_code     = ls_t001w-vkorg
                                   bus_area      = ls_t001w-j_1bbranch
                                   pmnttrms      = ls_vbrk-zterm
                                   bline_date    = ls_vbrk-erdat
                                   alloc_nmbr    = ls_vbrk-vbeln
                                   item_text     = 'PGTO ALUGUEL FOOD COLIGADAS'
                                   businessplace = ls_t001w-j_1bbranch ) ).

    lt_currencyamount = VALUE #( ( itemno_acc = '0000000001'
                                   currency   = 'BRL'
                                   amt_doccur = ls_vbrk-netwr * -1 )
                                 ( itemno_acc = '0000000002'
                                   currency   = 'BRL'
                                   amt_doccur = ls_vbrk-netwr ) ).

    CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
      EXPORTING
        documentheader = ls_documentheader
      IMPORTING
        obj_type       = lv_type
        obj_key        = lv_key
        obj_sys        = lv_sys
      TABLES
        accountgl      = lt_accountgl
        accountpayable = lt_accountpayable
        currencyamount = lt_currencyamount
        return         = lt_return.

    SORT lt_return BY type.

    READ TABLE lt_return
      WITH KEY type = 'E'
      TRANSPORTING NO FIELDS
      BINARY SEARCH.
    IF sy-subrc NE 0.

      CLEAR: syst-msgid, syst-msgno, syst-msgty, syst-msgv1,
             syst-msgv2, syst-msgv3, syst-msgv4.

      syst-msgid = 'ZSD_COMODATO_LOC'.
      syst-msgty = 'S'.
      syst-msgno = 003.
      syst-msgv1 = lv_key(10).
      CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
        EXPORTING
          msg_arbgb              = syst-msgid
          msg_nr                 = syst-msgno
          msg_ty                 = syst-msgty
          msg_v1                 = syst-msgv1
          msg_v2                 = syst-msgv2
          msg_v3                 = syst-msgv3
          msg_v4                 = syst-msgv4
        EXCEPTIONS
          message_type_not_valid = 01
          no_sy_message          = 02.
      CASE sy-subrc.
        WHEN 01.
          rv_result = 0.
        WHEN 02.
          rv_result = 0.
        WHEN OTHERS.
          rv_result = 0.
      ENDCASE.

      rv_result = 0.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

    ELSE.
      DATA(lv_tabix) = sy-tabix.
      LOOP AT lt_return
         INTO DATA(ls_return)
         FROM lv_tabix
        WHERE type = 'E'.
        CLEAR: syst-msgid, syst-msgno, syst-msgty, syst-msgv1,
               syst-msgv2, syst-msgv3, syst-msgv4.

        syst-msgid = ls_return-id.
        syst-msgty = ls_return-type.
        syst-msgno = ls_return-number.
        syst-msgv1 = ls_return-message_v1.
        syst-msgv2 = ls_return-message_v2.
        syst-msgv3 = ls_return-message_v3.
        syst-msgv4 = ls_return-message_v4.
        CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
          EXPORTING
            msg_arbgb              = syst-msgid
            msg_nr                 = syst-msgno
            msg_ty                 = syst-msgty
            msg_v1                 = syst-msgv1
            msg_v2                 = syst-msgv2
            msg_v3                 = syst-msgv3
            msg_v4                 = syst-msgv4
          EXCEPTIONS
            message_type_not_valid = 01
            no_sy_message          = 02.
        CASE sy-subrc.
          WHEN 01.
            rv_result = 4.
          WHEN 02.
            rv_result = 4.
          WHEN OTHERS.
            rv_result = 4.
        ENDCASE.

      ENDLOOP.

      rv_result = 4.

    ENDIF.
  ENDMETHOD.


  METHOD get_param.

    CLEAR ev_param.

    TRY.
        NEW zclca_tabela_parametros( )->m_get_single( EXPORTING iv_modulo = gc_param-modulo
                                                                iv_chave1 = iv_key1
                                                                iv_chave2 = iv_key2
                                                                iv_chave3 = iv_key3
                                                      IMPORTING ev_param  = ev_param ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
