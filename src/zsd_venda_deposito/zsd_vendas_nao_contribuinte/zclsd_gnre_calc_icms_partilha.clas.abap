class ZCLSD_GNRE_CALC_ICMS_PARTILHA definition
  public
  final
  create public .

public section.

  types:
    ty_taxamount(12) TYPE p DECIMALS 6 .

      "! Método principal
      "! @parameter is_komk                     | Determinação de preço - cabeçalho comunicação
      "! @parameter is_komp                     | Determinação de preço item de comunicação
      "! @parameter it_komv                     | Registro de condição de comunicação p/determinação de preço
      "! @parameter CV_ORIG_PARTILHA_AMOUNT     | Saída do cálculo
      "! @parameter CV_DEST_PARTILHA_AMOUNT     | Saída do cálculo
      "! @parameter CV_FCP_PARTILHA_AMOUNT      | Saída do cálculo
      "! @parameter CV_ORIG_PARTILHA_BASE       | Saída do cálculo
      "! @parameter CV_DEST_PARTILHA_BASE       | Saída do cálculo
      "! @parameter CV_FCP_PARTILHA_BASE        | Saída do cálculo
      "! @parameter CV_ORIG_PARTILHA_EBASE      | Saída do cálculo
      "! @parameter CV_DEST_PARTILHA_EBASE      | Saída do cálculo
      "! @parameter CV_FCP_PARTILHA_EBASE       | Saída do cálculo
  methods CALCULATE
    importing
      !IS_KOMK type KOMK
      !IS_KOMP type KOMP
      !IT_KOMV type TAX_XKOMV_TAB
    changing
      !CV_ORIG_PARTILHA_AMOUNT type TY_TAXAMOUNT
      !CV_DEST_PARTILHA_AMOUNT type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_AMOUNT type TY_TAXAMOUNT
      !CV_ORIG_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_DEST_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_ORIG_PARTILHA_EBASE type TY_TAXAMOUNT
      !CV_DEST_PARTILHA_EBASE type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_EBASE type TY_TAXAMOUNT .
  methods CALCULATE_SAVE
    importing
      !IS_KOMK type KOMK
      !IS_KOMP type KOMP
      !IS_KOMV type TAX_XKOMV_TAB
      !IS_VBRK type VBRK
      !IS_VBRP type VBRP .
protected section.
private section.

      "! Busca registro na tabela Z
      "! @parameter is_komk                     | Determinação de preço - cabeçalho comunicação
      "! @parameter is_komp                     | Determinação de preço item de comunicação
      "! @parameter rs_calc_difal               | retorno da estrutura de parametrização
  methods GET_SCENARIO_CONFIG
    importing
      !IS_KOMK type KOMK
      !IS_KOMP type KOMP
    returning
      value(RS_CALC_DIFAL) type ZTSD_CALC_DIFAL .
      "! Calcula o valor das condições
      "! @parameter IS_SCENARIO_CONFIG          | Parâmetros de configuração
      "! @parameter IT_KOMV                     | Determinação de preço item de comunicação
      "! @parameter EV_ICVA                     | Saída do cálculo
      "! @parameter EV_ISIC                     | Saída do cálculo
      "! @parameter EV_ISIB                     | Saída do cálculo
      "! @parameter EV_IBRX                     | Saída do cálculo
      "! @parameter EV_ISFR                     | Saída do cálculo
      "! @parameter EV_ISFB                     | Saída do cálculo
  methods GET_COND_VALUES
    importing
      !IS_SCENARIO_CONFIG type ZTSD_CALC_DIFAL
      !IT_KOMV type TAX_XKOMV_TAB
    exporting
      !EV_ICVA type TY_TAXAMOUNT
      !EV_ISIC type TY_TAXAMOUNT
      !EV_ISIB type TY_TAXAMOUNT
      !EV_IBRX type TY_TAXAMOUNT
      !EV_ISFR type TY_TAXAMOUNT
      !EV_ISFB type TY_TAXAMOUNT
      !EV_ZFEC type TY_TAXAMOUNT .
      "! Forma de cálculo 2
      "! @parameter IV_ICVA                     | Valor da condição
      "! @parameter IV_ISIC                     | Valor da condição
      "! @parameter IV_IBRX                     | Valor da condição
      "! @parameter IV_ISFR                     | Valor da condição
      "! @parameter IV_ISFB                     | Valor da condição
      "! @parameter CV_ORIG_PARTILHA_AMOUNT     | Saída do cálculo
      "! @parameter CV_DEST_PARTILHA_AMOUNT     | Saída do cálculo
      "! @parameter CV_FCP_PARTILHA_AMOUNT      | Saída do cálculo
      "! @parameter CV_ORIG_PARTILHA_BASE       | Saída do cálculo
      "! @parameter CV_DEST_PARTILHA_BASE       | Saída do cálculo
      "! @parameter CV_FCP_PARTILHA_BASE        | Saída do cálculo
      "! @parameter CV_ORIG_PARTILHA_EBASE      | Saída do cálculo
      "! @parameter CV_DEST_PARTILHA_EBASE      | Saída do cálculo
      "! @parameter CV_FCP_PARTILHA_EBASE       | Saída do cálculo
  methods CALCULATE_FORM_2
    importing
      !IV_ICVA type TY_TAXAMOUNT
      !IV_ISIC type TY_TAXAMOUNT
      !IV_IBRX type TY_TAXAMOUNT
      !IV_ISFR type TY_TAXAMOUNT
      !IV_ISFB type TY_TAXAMOUNT
      !IV_ZFEC type TY_TAXAMOUNT
    changing
      !CV_ORIG_PARTILHA_AMOUNT type TY_TAXAMOUNT
      !CV_DEST_PARTILHA_AMOUNT type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_AMOUNT type TY_TAXAMOUNT
      !CV_ORIG_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_DEST_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_ORIG_PARTILHA_EBASE type TY_TAXAMOUNT
      !CV_DEST_PARTILHA_EBASE type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_EBASE type TY_TAXAMOUNT .
  methods CALCULATE_FCP
    importing
      !IV_DEST_PARTILHA_BASE type TY_TAXAMOUNT
      !IV_ISFB type TY_TAXAMOUNT
      !IV_ISFR type TY_TAXAMOUNT
    changing
      !CV_FCP_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_EBASE type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_AMOUNT type TY_TAXAMOUNT .
      "! Forma de cálculo 3
      "! @parameter IV_ICVA                     | Valor da condição
      "! @parameter IV_ISIC                     | Valor da condição
      "! @parameter IV_IBRX                     | Valor da condição
      "! @parameter IV_ISFR                     | Valor da condição
      "! @parameter IV_ISFB                     | Valor da condição
      "! @parameter CV_ORIG_PARTILHA_AMOUNT     | Saída do cálculo
      "! @parameter CV_DEST_PARTILHA_AMOUNT     | Saída do cálculo
      "! @parameter CV_FCP_PARTILHA_AMOUNT      | Saída do cálculo
      "! @parameter CV_ORIG_PARTILHA_BASE       | Saída do cálculo
      "! @parameter CV_DEST_PARTILHA_BASE       | Saída do cálculo
      "! @parameter CV_FCP_PARTILHA_BASE        | Saída do cálculo
      "! @parameter CV_ORIG_PARTILHA_EBASE      | Saída do cálculo
      "! @parameter CV_DEST_PARTILHA_EBASE      | Saída do cálculo
      "! @parameter CV_FCP_PARTILHA_EBASE       | Saída do cálculo
  methods CALCULATE_FORM_3
    importing
      !IV_ICVA type TY_TAXAMOUNT
      !IV_ISIC type TY_TAXAMOUNT
      !IV_IBRX type TY_TAXAMOUNT
      !IV_ISFR type TY_TAXAMOUNT
      !IV_ISFB type TY_TAXAMOUNT
      !IV_ZFEC type TY_TAXAMOUNT
    changing
      !CV_ORIG_PARTILHA_AMOUNT type TY_TAXAMOUNT
      !CV_DEST_PARTILHA_AMOUNT type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_AMOUNT type TY_TAXAMOUNT
      !CV_ORIG_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_DEST_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_ORIG_PARTILHA_EBASE type TY_TAXAMOUNT
      !CV_DEST_PARTILHA_EBASE type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_EBASE type TY_TAXAMOUNT .
      "! Forma de cálculo 4
      "! @parameter IV_ICVA                     | Valor da condição
      "! @parameter IV_ISIC                     | Valor da condição
      "! @parameter IV_IBRX                     | Valor da condição
      "! @parameter IV_ISFR                     | Valor da condição
      "! @parameter IV_ISFB                     | Valor da condição
      "! @parameter CV_ORIG_PARTILHA_AMOUNT     | Saída do cálculo
      "! @parameter CV_DEST_PARTILHA_AMOUNT     | Saída do cálculo
      "! @parameter CV_FCP_PARTILHA_AMOUNT      | Saída do cálculo
      "! @parameter CV_ORIG_PARTILHA_BASE       | Saída do cálculo
      "! @parameter CV_DEST_PARTILHA_BASE       | Saída do cálculo
      "! @parameter CV_FCP_PARTILHA_BASE        | Saída do cálculo
      "! @parameter CV_ORIG_PARTILHA_EBASE      | Saída do cálculo
      "! @parameter CV_DEST_PARTILHA_EBASE      | Saída do cálculo
      "! @parameter CV_FCP_PARTILHA_EBASE       | Saída do cálculo
  methods CALCULATE_FORM_4
    importing
      !IV_ICVA type TY_TAXAMOUNT
      !IV_ISIC type TY_TAXAMOUNT
      !IV_ISIB type TY_TAXAMOUNT
      !IV_IBRX type TY_TAXAMOUNT
      !IV_ISFR type TY_TAXAMOUNT
      !IV_ISFB type TY_TAXAMOUNT
      !IV_ZFEC type TY_TAXAMOUNT
    changing
      !CV_ORIG_PARTILHA_AMOUNT type TY_TAXAMOUNT
      !CV_DEST_PARTILHA_AMOUNT type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_AMOUNT type TY_TAXAMOUNT
      !CV_ORIG_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_DEST_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_ORIG_PARTILHA_EBASE type TY_TAXAMOUNT
      !CV_DEST_PARTILHA_EBASE type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_EBASE type TY_TAXAMOUNT .
      "! Forma de cálculo 5
      "! @parameter IV_ICVA                     | Valor da condição
      "! @parameter IV_ISIC                     | Valor da condição
      "! @parameter IV_IBRX                     | Valor da condição
      "! @parameter IV_ISFR                     | Valor da condição
      "! @parameter IV_ISFB                     | Valor da condição
      "! @parameter CV_ORIG_PARTILHA_AMOUNT     | Saída do cálculo
      "! @parameter CV_DEST_PARTILHA_AMOUNT     | Saída do cálculo
      "! @parameter CV_FCP_PARTILHA_AMOUNT      | Saída do cálculo
      "! @parameter CV_ORIG_PARTILHA_BASE       | Saída do cálculo
      "! @parameter CV_DEST_PARTILHA_BASE       | Saída do cálculo
      "! @parameter CV_FCP_PARTILHA_BASE        | Saída do cálculo
      "! @parameter CV_ORIG_PARTILHA_EBASE      | Saída do cálculo
      "! @parameter CV_DEST_PARTILHA_EBASE      | Saída do cálculo
      "! @parameter CV_FCP_PARTILHA_EBASE       | Saída do cálculo
  methods CALCULATE_FORM_5
    importing
      !IV_ICVA type TY_TAXAMOUNT
      !IV_ISIB type TY_TAXAMOUNT
      !IV_ISIC type TY_TAXAMOUNT
      !IV_IBRX type TY_TAXAMOUNT
      !IV_ISFR type TY_TAXAMOUNT
      !IV_ISFB type TY_TAXAMOUNT
      !IV_ZFEC type TY_TAXAMOUNT
    changing
      !CV_ORIG_PARTILHA_AMOUNT type TY_TAXAMOUNT
      !CV_DEST_PARTILHA_AMOUNT type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_AMOUNT type TY_TAXAMOUNT
      !CV_ORIG_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_DEST_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_ORIG_PARTILHA_EBASE type TY_TAXAMOUNT
      !CV_DEST_PARTILHA_EBASE type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_EBASE type TY_TAXAMOUNT .
      "! Forma de cálculo 6
      "! @parameter IV_ICVA                     | Valor da condição
      "! @parameter IV_ISIC                     | Valor da condição
      "! @parameter IV_IBRX                     | Valor da condição
      "! @parameter IV_ISFR                     | Valor da condição
      "! @parameter IV_ISFB                     | Valor da condição
      "! @parameter CV_ORIG_PARTILHA_AMOUNT     | Saída do cálculo
      "! @parameter CV_DEST_PARTILHA_AMOUNT     | Saída do cálculo
      "! @parameter CV_FCP_PARTILHA_AMOUNT      | Saída do cálculo
      "! @parameter CV_ORIG_PARTILHA_BASE       | Saída do cálculo
      "! @parameter CV_DEST_PARTILHA_BASE       | Saída do cálculo
      "! @parameter CV_FCP_PARTILHA_BASE        | Saída do cálculo
      "! @parameter CV_ORIG_PARTILHA_EBASE      | Saída do cálculo
      "! @parameter CV_DEST_PARTILHA_EBASE      | Saída do cálculo
      "! @parameter CV_FCP_PARTILHA_EBASE       | Saída do cálculo
  methods CALCULATE_FORM_6
    importing
      !IV_ICVA type TY_TAXAMOUNT
      !IV_ISIB type TY_TAXAMOUNT
      !IV_ISIC type TY_TAXAMOUNT
      !IV_IBRX type TY_TAXAMOUNT
      !IV_ISFR type TY_TAXAMOUNT
      !IV_ISFB type TY_TAXAMOUNT
      !IV_ZFEC type TY_TAXAMOUNT
    changing
      !CV_ORIG_PARTILHA_AMOUNT type TY_TAXAMOUNT
      !CV_DEST_PARTILHA_AMOUNT type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_AMOUNT type TY_TAXAMOUNT
      !CV_ORIG_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_DEST_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_ORIG_PARTILHA_EBASE type TY_TAXAMOUNT
      !CV_DEST_PARTILHA_EBASE type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_EBASE type TY_TAXAMOUNT .
      "! Forma de cálculo 7
      "! @parameter IV_ICVA                     | Valor da condição
      "! @parameter IV_ISIC                     | Valor da condição
      "! @parameter IV_IBRX                     | Valor da condição
      "! @parameter IV_ISFR                     | Valor da condição
      "! @parameter IV_ISFB                     | Valor da condição
      "! @parameter CV_ORIG_PARTILHA_AMOUNT     | Saída do cálculo
      "! @parameter CV_DEST_PARTILHA_AMOUNT     | Saída do cálculo
      "! @parameter CV_FCP_PARTILHA_AMOUNT      | Saída do cálculo
      "! @parameter CV_ORIG_PARTILHA_BASE       | Saída do cálculo
      "! @parameter CV_DEST_PARTILHA_BASE       | Saída do cálculo
      "! @parameter CV_FCP_PARTILHA_BASE        | Saída do cálculo
      "! @parameter CV_ORIG_PARTILHA_EBASE      | Saída do cálculo
      "! @parameter CV_DEST_PARTILHA_EBASE      | Saída do cálculo
      "! @parameter CV_FCP_PARTILHA_EBASE       | Saída do cálculo
  methods CALCULATE_FORM_7
    importing
      !IV_ICVA type TY_TAXAMOUNT
      !IV_ISIB type TY_TAXAMOUNT
      !IV_ISIC type TY_TAXAMOUNT
      !IV_IBRX type TY_TAXAMOUNT
      !IV_ISFR type TY_TAXAMOUNT
      !IV_ISFB type TY_TAXAMOUNT
      !IV_ZFEC type TY_TAXAMOUNT
    changing
      !CV_ORIG_PARTILHA_AMOUNT type TY_TAXAMOUNT
      !CV_DEST_PARTILHA_AMOUNT type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_AMOUNT type TY_TAXAMOUNT
      !CV_ORIG_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_DEST_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_ORIG_PARTILHA_EBASE type TY_TAXAMOUNT
      !CV_DEST_PARTILHA_EBASE type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_EBASE type TY_TAXAMOUNT .
ENDCLASS.



CLASS ZCLSD_GNRE_CALC_ICMS_PARTILHA IMPLEMENTATION.


  METHOD calculate.
    DATA(ls_scenario_config) = get_scenario_config( is_komk = is_komk
                                                    is_komp = is_komp ).

    "Obtêm os valores das condições utilizadas no cálculo
    get_cond_values(
      EXPORTING
        is_scenario_config = ls_scenario_config
        it_komv            = it_komv
      IMPORTING
        ev_icva           = DATA(lv_icva)
        ev_isic           = DATA(lv_isic)
        ev_isib           = DATA(lv_isib)
        ev_ibrx           = DATA(lv_ibrx)
        ev_isfr           = DATA(lv_isfr)
        ev_isfb           = DATA(lv_isfb)
        ev_zfec           = DATA(lv_zfec)
    ).


    "Chama o procedimento de cálculo
    CASE ls_scenario_config-formula_difal.

      WHEN '1'. "Tradicional

        "Não modifica o cálculo atual
        RETURN.

      WHEN '2'. "Embutindo o DIFAL no Débito

        calculate_form_2(
          EXPORTING
            iv_icva                 = lv_icva
            iv_isic                 = lv_isic
            iv_ibrx                 = lv_ibrx
            iv_isfr                 = lv_isfr
            iv_isfb                 = lv_isfb
            iv_zfec                 = lv_zfec
          CHANGING
            cv_orig_partilha_amount = cv_orig_partilha_amount
            cv_dest_partilha_amount = cv_dest_partilha_amount
            cv_fcp_partilha_amount  = cv_fcp_partilha_amount
            cv_orig_partilha_base   = cv_orig_partilha_base
            cv_dest_partilha_base   = cv_dest_partilha_base
            cv_fcp_partilha_base    = cv_fcp_partilha_base
            cv_orig_partilha_ebase  = cv_orig_partilha_ebase
            cv_dest_partilha_ebase  = cv_dest_partilha_ebase
            cv_fcp_partilha_ebase   = cv_fcp_partilha_ebase
        ).

      WHEN '3'. "Embutindo o DIFAL no Débito e no Crédito

        calculate_form_3(
          EXPORTING
            iv_icva                 = lv_icva
            iv_isic                 = lv_isic
            iv_ibrx                 = lv_ibrx
            iv_isfr                 = lv_isfr
            iv_isfb                 = lv_isfb
            iv_zfec                 = lv_zfec
          CHANGING
            cv_orig_partilha_amount = cv_orig_partilha_amount
            cv_dest_partilha_amount = cv_dest_partilha_amount
            cv_fcp_partilha_amount  = cv_fcp_partilha_amount
            cv_orig_partilha_base   = cv_orig_partilha_base
            cv_dest_partilha_base   = cv_dest_partilha_base
            cv_fcp_partilha_base    = cv_fcp_partilha_base
            cv_orig_partilha_ebase  = cv_orig_partilha_ebase
            cv_dest_partilha_ebase  = cv_dest_partilha_ebase
            cv_fcp_partilha_ebase   = cv_fcp_partilha_ebase
        ).

      WHEN '4'. "Tradicional com Redução no Destino

        calculate_form_4(
          EXPORTING
            iv_icva                 = lv_icva
            iv_isic                 = lv_isic
            iv_ibrx                 = lv_ibrx
            iv_isib                 = lv_isib
            iv_isfr                 = lv_isfr
            iv_isfb                 = lv_isfb
            iv_zfec                 = lv_zfec
          CHANGING
            cv_orig_partilha_amount = cv_orig_partilha_amount
            cv_dest_partilha_amount = cv_dest_partilha_amount
            cv_fcp_partilha_amount  = cv_fcp_partilha_amount
            cv_orig_partilha_base   = cv_orig_partilha_base
            cv_dest_partilha_base   = cv_dest_partilha_base
            cv_fcp_partilha_base    = cv_fcp_partilha_base
            cv_orig_partilha_ebase  = cv_orig_partilha_ebase
            cv_dest_partilha_ebase  = cv_dest_partilha_ebase
            cv_fcp_partilha_ebase   = cv_fcp_partilha_ebase
        ).

      WHEN '5'. "Igualando as Bases Com Redução no Destino

        calculate_form_5(
          EXPORTING
            iv_icva                 = lv_icva
            iv_isic                 = lv_isic
            iv_ibrx                 = lv_ibrx
            iv_isib                 = lv_isib
            iv_isfr                 = lv_isfr
            iv_isfb                 = lv_isfb
            iv_zfec                 = lv_zfec
          CHANGING
            cv_orig_partilha_amount = cv_orig_partilha_amount
            cv_dest_partilha_amount = cv_dest_partilha_amount
            cv_fcp_partilha_amount  = cv_fcp_partilha_amount
            cv_orig_partilha_base   = cv_orig_partilha_base
            cv_dest_partilha_base   = cv_dest_partilha_base
            cv_fcp_partilha_base    = cv_fcp_partilha_base
            cv_orig_partilha_ebase  = cv_orig_partilha_ebase
            cv_dest_partilha_ebase  = cv_dest_partilha_ebase
            cv_fcp_partilha_ebase   = cv_fcp_partilha_ebase
        ).

      WHEN '6'. "Embutindo o DIFAL no Débito e Reduzindo Base do Débito

        calculate_form_6(
          EXPORTING
            iv_icva                 = lv_icva
            iv_isic                 = lv_isic
            iv_ibrx                 = lv_ibrx
            iv_isib                 = lv_isib
            iv_isfr                 = lv_isfr
            iv_isfb                 = lv_isfb
            iv_zfec                 = lv_zfec
          CHANGING
            cv_orig_partilha_amount = cv_orig_partilha_amount
            cv_dest_partilha_amount = cv_dest_partilha_amount
            cv_fcp_partilha_amount  = cv_fcp_partilha_amount
            cv_orig_partilha_base   = cv_orig_partilha_base
            cv_dest_partilha_base   = cv_dest_partilha_base
            cv_fcp_partilha_base    = cv_fcp_partilha_base
            cv_orig_partilha_ebase  = cv_orig_partilha_ebase
            cv_dest_partilha_ebase  = cv_dest_partilha_ebase
            cv_fcp_partilha_ebase   = cv_fcp_partilha_ebase
        ).

      WHEN '7'. "Embutindo o DIFAL no Débito e Crédito e Reduzindo as Duas Bases

        calculate_form_7(
          EXPORTING
            iv_icva                 = lv_icva
            iv_isic                 = lv_isic
            iv_ibrx                 = lv_ibrx
            iv_isib                 = lv_isib
            iv_isfr                 = lv_isfr
            iv_isfb                 = lv_isfb
            iv_zfec                 = lv_zfec
          CHANGING
            cv_orig_partilha_amount = cv_orig_partilha_amount
            cv_dest_partilha_amount = cv_dest_partilha_amount
            cv_fcp_partilha_amount  = cv_fcp_partilha_amount
            cv_orig_partilha_base   = cv_orig_partilha_base
            cv_dest_partilha_base   = cv_dest_partilha_base
            cv_fcp_partilha_base    = cv_fcp_partilha_base
            cv_orig_partilha_ebase  = cv_orig_partilha_ebase
            cv_dest_partilha_ebase  = cv_dest_partilha_ebase
            cv_fcp_partilha_ebase   = cv_fcp_partilha_ebase
        ).

      WHEN OTHERS.

        "Não modifica o cálculo atual
        RETURN.

    ENDCASE.

  ENDMETHOD.


  METHOD calculate_fcp.

    cv_fcp_partilha_base   = iv_dest_partilha_base * iv_isfb.
    cv_fcp_partilha_ebase  = iv_dest_partilha_base * ( 1 - iv_isfb ).
    cv_fcp_partilha_amount = cv_fcp_partilha_base * iv_isfr.

    IF cv_fcp_partilha_amount <= 0.
      cv_fcp_partilha_ebase  = cv_fcp_partilha_ebase + cv_fcp_partilha_base.
      cv_fcp_partilha_amount = 0.
      cv_fcp_partilha_base   = 0.
    ENDIF.


  ENDMETHOD.


  method CALCULATE_FORM_2.

*Embutindo o DIFAL no Débito

    cv_orig_partilha_base   = 0.
    cv_orig_partilha_amount = 0.
    IF ( 1 - iv_isic ) <> 0.
      cv_orig_partilha_ebase  = ( ( iv_ibrx ) * ( 1 - iv_icva ) ) / ( 1 - iv_isic ).
*      cv_orig_partilha_ebase  = ( ( iv_zfec + iv_ibrx ) * ( 1 - iv_icva ) ) / ( 1 - iv_isic ).
    ENDIF.

    cv_dest_partilha_base   = cv_orig_partilha_ebase.
    cv_dest_partilha_amount = ( cv_dest_partilha_base * ( iv_isic - iv_isfr ) ) - ( iv_ibrx * iv_icva ).

    cv_dest_partilha_ebase  = 0.

    IF cv_orig_partilha_ebase < 0.
      cv_orig_partilha_ebase = 0.
    ENDIF.

    IF cv_dest_partilha_amount <= 0.
      cv_dest_partilha_ebase  = cv_dest_partilha_ebase + cv_dest_partilha_base.
      cv_dest_partilha_amount = 0.
      cv_dest_partilha_base   = 0.
    ENDIF.

    IF cv_dest_partilha_ebase < 0.
      cv_dest_partilha_ebase = 0.
    ENDIF.

    calculate_fcp(
      EXPORTING
        iv_dest_partilha_base  = cv_dest_partilha_base
        iv_isfb                = iv_isfb
        iv_isfr                = iv_isfr
      CHANGING
        cv_fcp_partilha_base   = cv_fcp_partilha_base
        cv_fcp_partilha_ebase  = cv_fcp_partilha_ebase
        cv_fcp_partilha_amount = cv_fcp_partilha_amount
    ).


  endmethod.


  METHOD calculate_form_3.

    "Embutindo o DIFAL no Débito e no Crédito

    cv_orig_partilha_base   = 0.
    cv_orig_partilha_amount = 0.
    IF ( 1 - iv_isic ) <> 0.
*      cv_orig_partilha_ebase  = ( ( iv_zfec + iv_ibrx ) * ( 1 - iv_icva ) ) / ( 1 - iv_isic ).
      cv_orig_partilha_ebase  = ( iv_ibrx * ( 1 - iv_icva ) ) / ( 1 - iv_isic ).

    ENDIF.

    cv_dest_partilha_base   = cv_orig_partilha_ebase.
    cv_dest_partilha_amount = ( cv_dest_partilha_base * ( iv_isic - iv_isfr ) ) - ( cv_dest_partilha_base * iv_icva ).
    cv_dest_partilha_ebase  = 0.

    IF cv_orig_partilha_ebase < 0.
      cv_orig_partilha_ebase = 0.
    ENDIF.

    IF cv_dest_partilha_amount <= 0.
      cv_dest_partilha_ebase  = cv_dest_partilha_ebase + cv_dest_partilha_base.
      cv_dest_partilha_amount = 0.
      cv_dest_partilha_base   = 0.
    ENDIF.

    IF cv_dest_partilha_ebase < 0.
      cv_dest_partilha_ebase = 0.
    ENDIF.

    calculate_fcp(
      EXPORTING
        iv_dest_partilha_base  = cv_dest_partilha_base
        iv_isfb                = iv_isfb
        iv_isfr                = iv_isfr
      CHANGING
        cv_fcp_partilha_base   = cv_fcp_partilha_base
        cv_fcp_partilha_ebase  = cv_fcp_partilha_ebase
        cv_fcp_partilha_amount = cv_fcp_partilha_amount
    ).


  ENDMETHOD.


  METHOD calculate_form_4.

    "Tradicional com Redução no Destino
    cv_orig_partilha_base   = 0.
    cv_orig_partilha_amount = 0.
*    cv_orig_partilha_ebase  = ( iv_zfec + iv_ibrx ).
    cv_orig_partilha_ebase  = iv_ibrx.

*    cv_dest_partilha_base   = ( iv_zfec + iv_ibrx ) * iv_isib.
    cv_dest_partilha_base   = iv_ibrx * iv_isib.
*    cv_dest_partilha_amount = ( cv_dest_partilha_base * ( iv_isic - iv_isfr ) ) - ( ( iv_zfec + iv_ibrx ) * iv_icva ).
    cv_dest_partilha_amount = ( cv_dest_partilha_base * ( iv_isic - iv_isfr ) ) - ( iv_ibrx * iv_icva ).
*    cv_dest_partilha_ebase  = ( iv_zfec + iv_ibrx ) * ( 1 - iv_isib ).
    cv_dest_partilha_ebase  = iv_ibrx * ( 1 - iv_isib ).


    IF cv_orig_partilha_ebase < 0.
      cv_orig_partilha_ebase = 0.
    ENDIF.

    IF cv_dest_partilha_amount <= 0.
      cv_dest_partilha_ebase  = cv_dest_partilha_ebase + cv_dest_partilha_base.
      cv_dest_partilha_amount = 0.
      cv_dest_partilha_base   = 0.
    ENDIF.

    IF cv_dest_partilha_ebase < 0.
      cv_dest_partilha_ebase = 0.
    ENDIF.

    calculate_fcp(
      EXPORTING
        iv_dest_partilha_base  = cv_dest_partilha_base
        iv_isfb                = iv_isfb
        iv_isfr                = iv_isfr
      CHANGING
        cv_fcp_partilha_base   = cv_fcp_partilha_base
        cv_fcp_partilha_ebase  = cv_fcp_partilha_ebase
        cv_fcp_partilha_amount = cv_fcp_partilha_amount
    ).


  ENDMETHOD.


  method CALCULATE_FORM_5.

"Igualando as Bases Com Redução no Destino
    cv_orig_partilha_base   = 0.
    cv_orig_partilha_amount = 0.
*    cv_orig_partilha_ebase  = ( iv_zfec + iv_ibrx ).
    cv_orig_partilha_ebase  = iv_ibrx.

*    cv_dest_partilha_base   = ( iv_zfec + iv_ibrx ) * iv_isib.
    cv_dest_partilha_base   = iv_ibrx * iv_isib.
    cv_dest_partilha_amount = ( cv_dest_partilha_base * ( iv_isic - iv_isfr ) ) - ( cv_dest_partilha_base * iv_icva ).
*    cv_dest_partilha_ebase  = ( iv_zfec + iv_ibrx ) * ( 1 - iv_isib ).
    cv_dest_partilha_ebase  = iv_ibrx * ( 1 - iv_isib ).

    IF cv_orig_partilha_ebase < 0.
      cv_orig_partilha_ebase = 0.
    ENDIF.

    IF cv_dest_partilha_amount <= 0.
      cv_dest_partilha_ebase  = cv_dest_partilha_ebase + cv_dest_partilha_base.
      cv_dest_partilha_amount = 0.
      cv_dest_partilha_base   = 0.
    ENDIF.

    IF cv_dest_partilha_ebase < 0.
      cv_dest_partilha_ebase = 0.
    ENDIF.

    calculate_fcp(
      EXPORTING
        iv_dest_partilha_base  = cv_dest_partilha_base
        iv_isfb                = iv_isfb
        iv_isfr                = iv_isfr
      CHANGING
        cv_fcp_partilha_base   = cv_fcp_partilha_base
        cv_fcp_partilha_ebase  = cv_fcp_partilha_ebase
        cv_fcp_partilha_amount = cv_fcp_partilha_amount
    ).


  endmethod.


  METHOD calculate_form_6.

    "Embutindo o DIFAL no Débito e Reduzindo Base do Débito
    cv_orig_partilha_base   = 0.
    cv_orig_partilha_amount = 0.
    IF ( 1 - iv_isic ) <> 0.
*      cv_orig_partilha_ebase  = ( ( iv_zfec + iv_ibrx ) * ( 1 - iv_icva ) ) / ( 1 - iv_isic ).
      cv_orig_partilha_ebase  = ( iv_ibrx * ( 1 - iv_icva ) ) / ( 1 - iv_isic ).
    ENDIF.

    cv_dest_partilha_base   = cv_orig_partilha_ebase * iv_isib.
*    cv_dest_partilha_amount = ( cv_dest_partilha_base * ( iv_isic - iv_isfr ) ) - ( ( iv_zfec + iv_ibrx ) * iv_icva ).
    cv_dest_partilha_amount = ( cv_dest_partilha_base * ( iv_isic - iv_isfr ) ) - ( iv_ibrx * iv_icva ).
    cv_dest_partilha_ebase  = cv_orig_partilha_ebase * ( 1 - iv_isib ).

    IF cv_orig_partilha_ebase < 0.
      cv_orig_partilha_ebase = 0.
    ENDIF.

    IF cv_dest_partilha_amount <= 0.
      cv_dest_partilha_ebase  = cv_dest_partilha_ebase + cv_dest_partilha_base.
      cv_dest_partilha_amount = 0.
      cv_dest_partilha_base   = 0.
    ENDIF.

    IF cv_dest_partilha_ebase < 0.
      cv_dest_partilha_ebase = 0.
    ENDIF.

    calculate_fcp(
      EXPORTING
        iv_dest_partilha_base  = cv_dest_partilha_base
        iv_isfb                = iv_isfb
        iv_isfr                = iv_isfr
      CHANGING
        cv_fcp_partilha_base   = cv_fcp_partilha_base
        cv_fcp_partilha_ebase  = cv_fcp_partilha_ebase
        cv_fcp_partilha_amount = cv_fcp_partilha_amount
    ).


  ENDMETHOD.


  METHOD calculate_form_7.

    "Embutindo o DIFAL no Débito e Crédito e Reduzindo as Duas Bases
    cv_orig_partilha_base   = 0.
    cv_orig_partilha_amount = 0.
    IF ( 1 - iv_isic ) <> 0.
*      cv_orig_partilha_ebase  = ( ( iv_zfec + iv_ibrx ) * ( 1 - iv_icva ) ) / ( 1 - iv_isic ).
      cv_orig_partilha_ebase  = ( iv_ibrx * ( 1 - iv_icva ) ) / ( 1 - iv_isic ).
    ENDIF.

    cv_dest_partilha_base   = cv_orig_partilha_ebase * iv_isib.
    cv_dest_partilha_amount = ( cv_dest_partilha_base * ( iv_isic - iv_isfr ) ) - ( cv_dest_partilha_base * iv_icva ).
    cv_dest_partilha_ebase  = cv_orig_partilha_ebase * ( 1 - iv_isib ).

    IF cv_orig_partilha_ebase < 0.
      cv_orig_partilha_ebase = 0.
    ENDIF.

    IF cv_dest_partilha_amount <= 0.
      cv_dest_partilha_ebase  = cv_dest_partilha_ebase + cv_dest_partilha_base.
      cv_dest_partilha_amount = 0.
      cv_dest_partilha_base   = 0.
    ENDIF.

    IF cv_dest_partilha_ebase < 0.
      cv_dest_partilha_ebase = 0.
    ENDIF.

    calculate_fcp(
      EXPORTING
        iv_dest_partilha_base  = cv_dest_partilha_base
        iv_isfb                = iv_isfb
        iv_isfr                = iv_isfr
      CHANGING
        cv_fcp_partilha_base   = cv_fcp_partilha_base
        cv_fcp_partilha_ebase  = cv_fcp_partilha_ebase
        cv_fcp_partilha_amount = cv_fcp_partilha_amount
    ).


  ENDMETHOD.


  METHOD get_cond_values.

    DATA(lt_komv) = it_komv[].
    SORT lt_komv BY kschl.

    "Caso o cenário possua alíquota fixa, substitui o valor do ICVA
    IF is_scenario_config-aliq_fixa IS NOT INITIAL.

      ev_icva = is_scenario_config-aliq_fixa / 100.

    ELSE.

      "Obtêm o valor da condição já convertido
      READ TABLE lt_komv ASSIGNING FIELD-SYMBOL(<fs_s_komv>) WITH KEY kschl = 'ICVA' BINARY SEARCH.
*      ASSIGN it_komv[ kschl = 'ICVA' ] TO FIELD-SYMBOL(<fs_s_komv>).
      IF sy-subrc IS INITIAL.
        IF <fs_s_komv>-kawrt > 0.
          ev_icva = <fs_s_komv>-kwert / <fs_s_komv>-kawrt.
        ENDIF.
      ENDIF.

    ENDIF.

    "Obtêm o valor da condição já convertido
    READ TABLE lt_komv ASSIGNING <fs_s_komv> WITH KEY kschl = 'ISIC' BINARY SEARCH.
*    ASSIGN it_komv[ kschl = 'ISIC' ] TO <fs_s_komv>.
    IF sy-subrc IS INITIAL.
      IF <fs_s_komv>-kawrt > 0.
        ev_isic = <fs_s_komv>-kwert / <fs_s_komv>-kawrt.
      ENDIF.
    ENDIF.

    IF is_scenario_config-redbase IS NOT INITIAL.
      ev_isib = is_scenario_config-redbase / 100.
    ELSE.

      "Obtêm o valor da condição já convertido
      READ TABLE lt_komv ASSIGNING <fs_s_komv> WITH KEY kschl = 'ISIB' BINARY SEARCH.
*    ASSIGN it_komv[ kschl = 'ISIB' ] TO <fs_s_komv>.
      IF sy-subrc IS INITIAL.
        ev_isib = <fs_s_komv>-kbetr / 1000.
      ENDIF.

    ENDIF.

    "Obtêm o valor da condição já convertido
    READ TABLE lt_komv ASSIGNING <fs_s_komv> WITH KEY kschl = 'ISFR' BINARY SEARCH.
*    ASSIGN it_komv[ kschl = 'ISFR' ] TO <fs_s_komv>.
    IF sy-subrc IS INITIAL.
      IF <fs_s_komv>-kawrt > 0.
        ev_isfr = <fs_s_komv>-kwert / <fs_s_komv>-kawrt.
      ENDIF.
    ENDIF.

    READ TABLE lt_komv ASSIGNING <fs_s_komv> WITH KEY kschl = 'ISFB' BINARY SEARCH.
*    ASSIGN it_komv[ kschl = 'ISFB' ] TO <fs_s_komv>.
    IF sy-subrc IS INITIAL.
      ev_isfb = <fs_s_komv>-kbetr / 1000.
    ENDIF.

    READ TABLE lt_komv ASSIGNING <fs_s_komv> WITH KEY kschl = 'IBRX' BINARY SEARCH.
*    ASSIGN it_komv[ kschl = 'IBRX' ] TO <fs_s_komv>.
    IF sy-subrc IS INITIAL.
      ev_ibrx = <fs_s_komv>-kwert.
    ENDIF.

    READ TABLE lt_komv ASSIGNING <fs_s_komv> WITH KEY kschl = 'BX23' BINARY SEARCH.
*    ASSIGN it_komv[ kschl = 'BX23' ] TO <fs_s_komv>.
    IF sy-subrc IS INITIAL.
      ev_ibrx = ev_ibrx + <fs_s_komv>-kwert.
    ENDIF.

* Frete do e-commerce somado ao valor da venda para o calculo.
    READ TABLE lt_komv ASSIGNING <fs_s_komv> WITH KEY kschl = 'ZFEC' BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      ev_zfec = <fs_s_komv>-kwert.
    ENDIF.


  ENDMETHOD.


  METHOD get_scenario_config.

    CONSTANTS: lc_2 TYPE char1 VALUE '2',
               lc_x TYPE char1 VALUE 'X'.

    "Cenário de venda com código de imposto para consumo, com cálculo do ICMS?
    SELECT SINGLE taxcode
      INTO @DATA(ls_j1btxsdc)
      FROM j_1btxsdc
      WHERE taxcode   = @is_komp-j_1btxsdc
        AND custusage = @lc_2
        AND icms      = @lc_x.

    "gs_komk-regio   "Receptor
    "gs_komp-matkl  "GrpMercads.
    "gs_komp-matnr.  "Material

    CHECK sy-subrc IS INITIAL AND is_komk-wkreg <> is_komk-regio.

    "Teremos que verificar na tabela Z se o cenário tem alíquota fixa.
    SELECT SINGLE shipto
                  matkl
                  matnr
                  formula_difal
                  aliq_fixa
                  redbase
      INTO CORRESPONDING FIELDS OF rs_calc_difal
      FROM ztsd_calc_difal
      WHERE shipto = is_komk-regio
*        AND matkl = is_komp-matkl
        AND matnr = is_komp-matnr.

    IF sy-subrc IS NOT INITIAL.

      SELECT SINGLE shipto
              matkl
              matnr
              formula_difal
              aliq_fixa
              redbase
      INTO CORRESPONDING FIELDS OF rs_calc_difal
      FROM ztsd_calc_difal
      WHERE shipto = is_komk-regio
         AND matkl = is_komp-matkl.

      IF sy-subrc IS NOT INITIAL.

          SELECT SINGLE shipto
              matkl
              matnr
              formula_difal
              aliq_fixa
              redbase
         INTO CORRESPONDING FIELDS OF rs_calc_difal
         FROM ztsd_calc_difal
         WHERE shipto = is_komk-regio
           AND matkl = ' '
           AND matnr = ' '.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD calculate_save.
    DEFINE _get_value_from_komv.
      TRY.
          &4 = is_komv[ kposn = is_vbrp-posnr
                        kschl = &1 ]-&2 / &3.
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.
    END-OF-DEFINITION.

    DATA(ls_zgnret007) = get_scenario_config( is_komk = is_komk
                                              is_komp = is_komp ).

    CHECK ls_zgnret007-formula_difal IS NOT INITIAL.

    DATA(ls_zgnret019) = CORRESPONDING ztsd_gnret019( ls_zgnret007 ).

    "Obtêm os valores das condições
    _get_value_from_komv: 'ISIC' kbetr 10 ls_zgnret019-isic,
                          'BX91' kwert 1  ls_zgnret019-dest_part_bas,
                          'BX95' kwert 1  ls_zgnret019-dest_part_amt,
                          'BX9B' kwert 1  ls_zgnret019-dest_part_ebas,
                          'ICVA' kbetr 10 ls_zgnret019-icva,
                          'BX90' kwert 1  ls_zgnret019-orig_part_bas,
                          'BX94' kwert 1  ls_zgnret019-orig_part_amt,
                          'BX9A' kwert 1  ls_zgnret019-orig_part_ebas,
                          'ISFR' kbetr 10 ls_zgnret019-isfr,
                          'BX98' kwert 1  ls_zgnret019-fcp_part_bas,
                          'BX96' kwert 1  ls_zgnret019-fcp_part_amt,
                          'BX9C' kwert 1  ls_zgnret019-fcp_part_ebas.

    ls_zgnret019-isic   = ls_zgnret019-isic - ls_zgnret019-isfr.
    ls_zgnret019-vbeln  = is_vbrk-vbeln.
    ls_zgnret019-posnr  = is_vbrp-posnr.
    ls_zgnret019-aubel  = is_vbrp-aubel.
    ls_zgnret019-aupos  = is_vbrp-aupos.
    ls_zgnret019-credat = sy-datum.
    ls_zgnret019-cretim = sy-uzeit.
    ls_zgnret019-crenam = sy-uname.
    INSERT ztsd_gnret019 FROM ls_zgnret019.
  ENDMETHOD.
ENDCLASS.
