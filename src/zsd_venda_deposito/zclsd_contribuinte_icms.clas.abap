"! <p class="shorttext synchronized" lang="pt">Regra Contribuinte ICMS</p>
CLASS zclsd_contribuinte_icms DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! Regra para Contribuinte ICMS
    "! @parameter iv_icmstaxpay | Contribuinte ICMS
    "! @parameter it_komv       | Lista de Condições
    "! @parameter it_xkomv      | Lista de Condições
    "! @parameter iv_kposn      | Item condição
    "! @parameter iv_kozgf      | Condição de substituição tributária
    "! @parameter rv_retorno    | Retorno da regra de Contribuinte ICMS
    METHODS regra_contribuinte_icms
      IMPORTING
        !iv_icmstaxpay    TYPE j_1bicmstaxpay
        !it_komv          TYPE komv_t OPTIONAL
        !it_xkomv         TYPE tax_xkomv_tab
        !iv_kposn         TYPE komp-kposn
        !iv_kozgf         TYPE t682i-kozgf
      RETURNING
        VALUE(rv_retorno) TYPE sy-subrc .
  PRIVATE SECTION.
    CONSTANTS:
      gc_modulo_sd         TYPE ze_param_modulo VALUE 'SD',
      gc_chave1_contr_icms TYPE ze_param_chave  VALUE 'CONTRIBUINTE DE ICMS',
      gc_chave1_reg_mg     TYPE ze_param_chave  VALUE 'REGIME_MG',
      gc_chave2_icms       TYPE ze_param_chave  VALUE 'ICMS',
      gc_kschl             TYPE konp-kschl      VALUE 'ZREG'.
ENDCLASS.



CLASS ZCLSD_CONTRIBUINTE_ICMS IMPLEMENTATION.


  METHOD regra_contribuinte_icms.
    DATA lr_icms TYPE RANGE OF j_1bicmstaxpay.
    DATA lr_kozgf TYPE RANGE OF t682i-kozgf.
    TRY.
        DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).    " INSERT - JWSILVA - 22.07.2023

        lo_param->m_get_range(                                        " CHANGE - JWSILVA - 22.07.2023
          EXPORTING
            iv_modulo = gc_modulo_sd
            iv_chave1 = gc_chave1_contr_icms
          IMPORTING
            et_range  = lr_icms
        ).
        lo_param->m_get_range(                                        " CHANGE - JWSILVA - 22.07.2023
          EXPORTING
            iv_modulo = gc_modulo_sd
            iv_chave1 = gc_chave1_reg_mg
            iv_chave2 = gc_chave2_icms
          IMPORTING
            et_range  = lr_kozgf
        ).

        IF iv_icmstaxpay IN lr_icms.

          DATA(lv_existe_zreg) = COND #(
            WHEN line_exists( it_komv[ kposn = iv_kposn kschl = gc_kschl ] )
              OR line_exists( it_xkomv[ kposn = iv_kposn kschl = gc_kschl ] )
            THEN abap_true
            ELSE abap_false
          ).
          rv_retorno = COND #(
            WHEN lv_existe_zreg = abap_true AND iv_kozgf IN lr_kozgf
            THEN 0
            ELSE 4
          ).
        ELSE.
          rv_retorno = 0.
        ENDIF.
      CATCH zcxca_tabela_parametros.
        rv_retorno = 0.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
