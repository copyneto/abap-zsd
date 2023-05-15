CLASS zclsd_saga_devolv_picking DEFINITION
  PUBLIC
  INHERITING FROM zclsd_saga_integracoes
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_proxy_wa,
        vbeln       TYPE vbeln_vl,
        anzpk       TYPE anzpk,
        zordemfrete TYPE char12,
        traid       TYPE traid,
        ztraid      TYPE char2,
      END OF ty_proxy_wa .
    TYPES:
      BEGIN OF ty_proxy_tab,
        vbeln TYPE vbeln_vl,
        posnn TYPE posnr_vl,
        matnr TYPE matnr,
        ndifm TYPE mengealt,
        pikmg TYPE pikmg,
      END OF ty_proxy_tab .
    TYPES ty_s_proxy TYPE ty_proxy_wa .
    TYPES:
      ty_t_proxy TYPE TABLE OF ty_proxy_tab .

    DATA gv_erro TYPE abap_bool .

    METHODS set_proxy_data
      IMPORTING
        !is_proxy TYPE ty_s_proxy
        !it_proxy TYPE ty_t_proxy .
    METHODS executar
      RETURNING
        VALUE(rt_return) TYPE bapiret2_tab .

    METHODS zifsd_saga_integracoes~build
        REDEFINITION .
    METHODS zifsd_saga_integracoes~execute
        REDEFINITION .
  PROTECTED SECTION.

    DATA: gs_vbkok TYPE vbkok,
          gt_vbpok TYPE vbpok_t.

  PRIVATE SECTION.

    METHODS is_suppl_qty_diff_from_pick
      RETURNING
        VALUE(result) TYPE abap_bool .
ENDCLASS.



CLASS ZCLSD_SAGA_DEVOLV_PICKING IMPLEMENTATION.


  METHOD zifsd_saga_integracoes~build.

* TODO: Verificação de Subitem
    SELECT vbeln, posnr, uecha, xchpf, charg, lfimg
      FROM lips
       FOR ALL ENTRIES IN @gt_vbpok
     WHERE vbeln = @gt_vbpok-vbeln
       AND uecha = @gt_vbpok-posnn
      INTO TABLE @DATA(lt_lips).

*    IF sy-subrc EQ 0 OR ls_lips-uecha <> <fs_vbpok>-posnn.
*      <fs_vbpok>-posnn = ls_lips-posnr.
*    ENDIF.

    LOOP AT gt_vbpok ASSIGNING FIELD-SYMBOL(<fs_vbpok>).

      READ TABLE lt_lips ASSIGNING FIELD-SYMBOL(<fs_lips>) WITH KEY vbeln = <fs_vbpok>-vbeln uecha = <fs_vbpok>-posnn.
      IF <fs_lips> IS ASSIGNED AND sy-subrc IS INITIAL.

        IF <fs_lips>-xchpf = 'X' AND <fs_lips>-charg IS INITIAL AND <fs_lips>-lfimg > 0.
          gv_erro = abap_true.
          EXIT.
        ENDIF.

        <fs_vbpok>-posnn = COND #( WHEN <fs_lips>-uecha <> <fs_vbpok>-posnn THEN <fs_lips>-posnr ELSE <fs_vbpok>-posnn ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD zifsd_saga_integracoes~execute.

    CONSTANTS: lc_vbtyp     TYPE vbtypl VALUE 'T',
               lc_erro      TYPE bapi_mtype VALUE 'E',
               lc_dlv_block TYPE lifsk VALUE '41'.

    DATA: BEGIN OF ls_param,
            modulo TYPE ztca_param_par-modulo VALUE 'SD',
            chave1 TYPE ztca_param_par-chave1 VALUE 'ADM DEVOLUÇÃO',
            chave2 TYPE ztca_param_par-chave2 VALUE 'TP_OV_DEVOLUCAO',
            chave3 TYPE ztca_param_par-chave3 VALUE 'FKART',
          END OF ls_param.

    DATA: lt_ret TYPE STANDARD TABLE OF bapiret2.
    DATA(lo_parametros) = NEW  zclca_tabela_parametros( ).
    DATA: lr_lfart TYPE RANGE OF likp-lfart.

    TRY.

        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = ls_param-modulo
            iv_chave1 = ls_param-chave1
            iv_chave2 = ls_param-chave2
            iv_chave3 = ls_param-chave3
          IMPORTING
            et_range  = lr_lfart ).

      CATCH zcxca_tabela_parametros.

    ENDTRY.


    IF gv_erro IS INITIAL.

      CALL FUNCTION 'WS_DELIVERY_UPDATE'
        EXPORTING
          vbkok_wa       = gs_vbkok
          synchron       = abap_true
          commit         = abap_true
          delivery       = gs_vbkok-vbeln
          update_picking = abap_true
          nicht_sperren  = abap_true
        TABLES
          vbpok_tab      = gt_vbpok
        EXCEPTIONS
          error_message  = 1
          OTHERS         = 2.
      IF sy-subrc NE 0.
        RETURN.
      ENDIF.

      SELECT SINGLE * FROM likp
      INTO @DATA(ls_likp)
      WHERE vbeln = @gs_vbkok-vbeln
        AND vbtyp = @lc_vbtyp.
      IF sy-subrc EQ 0.

        IF lr_lfart IS NOT INITIAL AND ls_likp IS NOT INITIAL.
          READ TABLE lr_lfart WITH KEY high = ls_likp-lfart INTO DATA(ls_lfart).
        ENDIF.

        CALL FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
          EXPORTING
            header_data    = VALUE bapiobdlvhdrchg( deliv_numb = gs_vbkok-vbeln
                                                    dlv_block  = COND #( WHEN ls_lfart IS NOT INITIAL AND ls_lfart-high IS NOT INITIAL THEN lc_dlv_block
                                                                         ELSE abap_false ) )
            header_control = VALUE bapiobdlvhdrctrlchg( deliv_numb    = gs_vbkok-vbeln
                                                        dlv_block_flg = abap_true )
            delivery       = gs_vbkok-vbeln
          TABLES
            return         = lt_ret
          EXCEPTIONS
            error_message  = 1
            OTHERS         = 2.
        IF sy-subrc NE 0.
          RETURN.
        ENDIF.

        IF NOT line_exists( lt_ret[ type = lc_erro ] ).

          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = abap_true.

        ENDIF.

      ENDIF.
    ELSE.
      MESSAGE 'Inconsistência entre a determinação de lote e quantidade da remessa.' TYPE 'E'.
    ENDIF.


  ENDMETHOD.


  METHOD set_proxy_data.

    DATA lv_vbeln TYPE lips-vbeln.

    DATA lt_doc_type TYPE tms_t_auart_range.

    CLEAR: gt_vbpok[],
           gs_badi_nfe,
           gs_likp,
           gs_nfenum,
           gs_proxy,
           gs_vbkok.

    lv_vbeln = is_proxy-vbeln.
    gs_vbkok-vbeln_vl = |{ lv_vbeln ALPHA = IN  }|.

    CLEAR lv_vbeln.
    lv_vbeln = is_proxy-vbeln.
    gs_vbkok-vbeln    = |{ lv_vbeln ALPHA = IN  }|.

    gs_vbkok-kzntg    = abap_true.
    gs_vbkok-wabuc    = abap_true.
    SELECT COUNT(*) FROM lips WHERE vbeln = @gs_vbkok-vbeln AND pstyv = 'ZDLN'.
    IF sy-subrc <> 0.
      gs_vbkok-traid    = |{ is_proxy-traid } / { is_proxy-ztraid }|.
    ENDIF.

* LSCHEPP - 8000006985 - CORE 1 - Quantidade DANFE - 05.05.2023 Início
*    gs_vbkok-anzpk    = is_proxy-anzpk.
    TRY.
        NEW zclca_tabela_parametros( )->m_get_range(
          EXPORTING
            iv_modulo = 'SD'
            iv_chave1 = 'SAGA'
            iv_chave2 = 'VOLUME'
          IMPORTING
            et_range  = lt_doc_type
        ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.

    SELECT SINGLE lfart
      FROM likp
      INTO @DATA(lv_lfart)
      WHERE vbeln EQ @gs_vbkok-vbeln_vl.
    IF sy-subrc EQ 0.
      IF lv_lfart IN lt_doc_type.
        gs_vbkok-anzpk = is_proxy-anzpk.
      ENDIF.
    ENDIF.
* LSCHEPP - 8000006985 - CORE 1 - Quantidade DANFE - 05.05.2023 Fim

    gs_vbkok-kzapk    = abap_true.

    gt_vbpok = VALUE #( BASE gt_vbpok FOR ls_proxy
                                       IN it_proxy
                                        ( vbeln_vl = |{ is_proxy-vbeln ALPHA = IN }|
                                          vbeln    = |{ is_proxy-vbeln ALPHA = IN }|
                                          posnn    = ls_proxy-posnn
                                          posnr_vl = ls_proxy-posnn
                                          pikmg    = ls_proxy-pikmg  ) ).

    gs_vbkok-komue = is_suppl_qty_diff_from_pick( ).

  ENDMETHOD.


  METHOD executar.

    DATA lt_return TYPE bapiret2_tab.

    CONSTANTS: lc_vbtyp     TYPE vbtypl VALUE 'T',
               lc_erro      TYPE bapi_mtype VALUE 'E',
               lc_dlv_block TYPE lifsk VALUE '41'.

    DATA: BEGIN OF ls_param,
            modulo TYPE ztca_param_par-modulo VALUE 'SD',
            chave1 TYPE ztca_param_par-chave1 VALUE 'ADM DEVOLUÇÃO',
            chave2 TYPE ztca_param_par-chave2 VALUE 'TP_OV_DEVOLUCAO',
            chave3 TYPE ztca_param_par-chave3 VALUE 'FKART',
          END OF ls_param.

    DATA: lt_ret TYPE STANDARD TABLE OF bapiret2.
    DATA(lo_parametros) = NEW  zclca_tabela_parametros( ).
    DATA: lr_lfart TYPE RANGE OF likp-lfart.

    TRY.

        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = ls_param-modulo
            iv_chave1 = ls_param-chave1
            iv_chave2 = ls_param-chave2
            iv_chave3 = ls_param-chave3
          IMPORTING
            et_range  = lr_lfart ).

      CATCH zcxca_tabela_parametros.

    ENDTRY.


    IF gv_erro IS INITIAL.

      CALL FUNCTION 'WS_DELIVERY_UPDATE'
        EXPORTING
          vbkok_wa       = gs_vbkok
          synchron       = abap_true
          commit         = abap_true
          delivery       = gs_vbkok-vbeln
          update_picking = abap_true
          nicht_sperren  = abap_true
        TABLES
          vbpok_tab      = gt_vbpok
        EXCEPTIONS
          error_message  = 1
          OTHERS         = 2.
      IF sy-subrc NE 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO DATA(lv_message).
        APPEND VALUE #( type       = sy-msgty
                        id         = sy-msgid
                        number     = sy-msgno
                        message    = lv_message
                        message_v1 = sy-msgv1
                        message_v2 = sy-msgv2
                        message_v3 = sy-msgv3
                        message_v4 = sy-msgv4
                       ) TO rt_return.
        RETURN.
      ENDIF.

      SELECT SINGLE * FROM likp
      INTO @DATA(ls_likp)
      WHERE vbeln = @gs_vbkok-vbeln
        AND vbtyp = @lc_vbtyp.
      IF sy-subrc EQ 0.

        IF lr_lfart IS NOT INITIAL AND ls_likp IS NOT INITIAL.
          READ TABLE lr_lfart WITH KEY high = ls_likp-lfart INTO DATA(ls_lfart).
        ENDIF.

        CALL FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
          EXPORTING
            header_data    = VALUE bapiobdlvhdrchg( deliv_numb = gs_vbkok-vbeln
                                                    dlv_block  = COND #( WHEN ls_lfart IS NOT INITIAL AND ls_lfart-high IS NOT INITIAL THEN lc_dlv_block
                                                                         ELSE abap_false ) )
            header_control = VALUE bapiobdlvhdrctrlchg( deliv_numb    = gs_vbkok-vbeln
                                                        dlv_block_flg = abap_true )
            delivery       = gs_vbkok-vbeln
          TABLES
            return         = lt_ret
          EXCEPTIONS
            error_message  = 1
            OTHERS         = 2.
        IF sy-subrc NE 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO lv_message.
          APPEND VALUE #( type       = sy-msgty
                          id         = sy-msgid
                          number     = sy-msgno
                          message    = lv_message
                          message_v1 = sy-msgv1
                          message_v2 = sy-msgv2
                          message_v3 = sy-msgv3
                          message_v4 = sy-msgv4
                         ) TO rt_return.
          RETURN.
        ENDIF.

        IF NOT line_exists( lt_ret[ type = lc_erro ] ).

          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = abap_true.

        ENDIF.

      ENDIF.
    ELSE.
      MESSAGE TEXT-t01 TYPE 'E'. "Inconsistência entre a determinação de lote e quantidade da remessa.
    ENDIF.


  ENDMETHOD.


  METHOD is_suppl_qty_diff_from_pick.

    SELECT vbeln,
           posnr,
           lfimg
      FROM lips
      FOR ALL ENTRIES IN @gt_vbpok
      WHERE vbeln = @gt_vbpok-vbeln
        AND posnr = @gt_vbpok-posnn
      INTO TABLE @DATA(lt_lips).

    LOOP AT lt_lips REFERENCE INTO DATA(ls_lips).
      TRY.
          IF ls_lips->lfimg <> gt_vbpok[ vbeln = ls_lips->vbeln
                                         posnn = ls_lips->posnr ]-pikmg.
            result = abap_true.
            RETURN.
          ENDIF.

        CATCH cx_sy_itab_line_not_found.
          CONTINUE.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
