*&---------------------------------------------------------------------*
*& Include          ZSDI_FILL_RESP_TEC
*&---------------------------------------------------------------------*

*** Ini
    CONSTANTS: lc_modulo        TYPE ztca_param_mod-modulo VALUE 'SD',
               lc_chave1        TYPE ztca_param_par-chave1 VALUE 'RESPONSAVEL_NFE',
               lc_chave1_cnpj   TYPE ztca_param_par-chave1 VALUE 'RESPONSAVEL_TECNICO',
               lc_chave2_cnpj   TYPE ztca_param_par-chave1 VALUE 'CNPJ',
               lc_chave2_pessoa TYPE ztca_param_par-chave1 VALUE 'PESSOA',
               lc_chave2_tel    TYPE ztca_param_par-chave1 VALUE 'TELEFONE',
               lc_chave2_email  TYPE ztca_param_par-chave1 VALUE 'EMAIL'.

    DATA: lr_cnpj    TYPE RANGE OF j_1bnfe_cnpj,
          lr_contact TYPE RANGE OF j_1bnfe_contact,
          lr_email   TYPE RANGE OF j_1bnfe_email,
          lr_phone   TYPE RANGE OF j_1bnfe_phone.

    DATA(lo_param) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 20.07.2023

    "CNPJ
    TRY.
        lo_param->m_get_range(
          EXPORTING
            iv_modulo = lc_modulo
            iv_chave1 = lc_chave1_cnpj
            iv_chave2 = lc_chave2_cnpj
          IMPORTING
            et_range  = lr_cnpj
        ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

    READ TABLE lr_cnpj ASSIGNING FIELD-SYMBOL(<fs_cnpj>) INDEX 1.
    IF sy-subrc IS INITIAL.

      cs_tec_resp-cnpj = <fs_cnpj>-low.

    ENDIF.

    "PESSOA
    TRY.
        lo_param->m_get_range(
          EXPORTING
            iv_modulo = lc_modulo
            iv_chave1 = lc_chave1
            iv_chave2 = lc_chave2_pessoa
          IMPORTING
            et_range  = lr_contact
        ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

    READ TABLE lr_contact ASSIGNING FIELD-SYMBOL(<fs_contact>) INDEX 1.
    IF sy-subrc IS INITIAL.

      cs_tec_resp-contact = <fs_contact>-low.

    ENDIF.

    "TELEFONE
    TRY.
        lo_param->m_get_range(
          EXPORTING
            iv_modulo = lc_modulo
            iv_chave1 = lc_chave1
            iv_chave2 = lc_chave2_tel
          IMPORTING
            et_range  = lr_phone
        ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

    READ TABLE lr_phone ASSIGNING FIELD-SYMBOL(<fs_phone>) INDEX 1.
    IF sy-subrc IS INITIAL.

      cs_tec_resp-phone = <fs_phone>-low.

    ENDIF.

    "EMAIL
    TRY.
        lo_param->m_get_range(
          EXPORTING
            iv_modulo = lc_modulo
            iv_chave1 = lc_chave1
            iv_chave2 = lc_chave2_email
          IMPORTING
            et_range  = lr_email
        ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

    READ TABLE lr_email ASSIGNING FIELD-SYMBOL(<fs_email>) INDEX 1.
    IF sy-subrc IS INITIAL.

      cs_tec_resp-email = <fs_email>-low.

    ENDIF.

*** Fim

*    DATA lr_tec_resp  TYPE RANGE OF text150.
*
*    CHECK is_header-direct = '2'.
*
*    DATA(lo_tvarv) = NEW zcacl_stvarv( ).
*
*
*    CALL METHOD lo_tvarv->get_range
*      EXPORTING
*        name  = 'ZSD_NFE_TEC_RESP'
*      IMPORTING
*        range = lr_tec_resp.
*
*    IF is_header-branch = 'CV04'  OR
*       is_header-branch = 'CV13'.
*
*      LOOP AT lr_tec_resp INTO DATA(ls_tec_resp).
*
**      '19116002000179'.
**      'ELOI PRADO DE ASSIS'.
**      'resp_tecnico_dfe_bematech@totvs.com.br'.
**      '1128593903'.
*
*        CASE sy-tabix.
*          WHEN 1.
*            cs_tec_resp-cnpj    = ls_tec_resp-low.
*          WHEN 2.
*            cs_tec_resp-contact = ls_tec_resp-low.
*          WHEN 3.
*            TRANSLATE ls_tec_resp-low TO LOWER CASE.
*            cs_tec_resp-email   = ls_tec_resp-low.
*          WHEN 4.
*            cs_tec_resp-phone   = ls_tec_resp-low.
*        ENDCASE.
*
*      ENDLOOP.
*
*    ENDIF.
