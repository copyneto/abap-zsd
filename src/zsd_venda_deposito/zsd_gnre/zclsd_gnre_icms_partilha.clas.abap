class ZCLSD_GNRE_ICMS_PARTILHA definition
  public
  final
  create public .

public section.

  types:
    ty_taxamount(12) TYPE p DECIMALS 6 .
  types:
    BEGIN OF ty_tax_result,
        icms_amt                    TYPE ty_taxamount,  "ICMS amount
        icms_dsc100                 TYPE ty_taxamount,  "ICMS discount Convênio
        icop_amt                    TYPE ty_taxamount,  "ICMS complement amount
        ipi_amt                     TYPE ty_taxamount,  "IPI amount
        ipio_amt                    TYPE ty_taxamount,  "IPI offset in IPI spli
        st_amt                      TYPE ty_taxamount,  "Sub.Trib. amount
        icfr_amt                    TYPE ty_taxamount,  "ICMS on freight amount
        icfs_amt                    TYPE ty_taxamount,  "Sub.Trib. on freight a
        conh_icm_bas                TYPE ty_taxamount,  "ICMS Conhe Base
        conh_icm_oth                TYPE ty_taxamount,  "ICMS Conhe Other Base
        conh_icm_exc                TYPE ty_taxamount,  "ICMS Conhe Excluded Bs
        conh_icm_amt                TYPE ty_taxamount,  "ICMS Conhe Amount
        conh_st_bas                 TYPE ty_taxamount,  "Sub.Trib. Conhe Base
        conh_st_amt                 TYPE ty_taxamount,  "Sub.Trib. Conhe Amnt
        conh_st_exc                 TYPE ty_taxamount,  "S.Trib.Conh Excl Base
        iss_amt                     TYPE ty_taxamount,  "ISS amount
        icms_cbas                   TYPE ty_taxamount,  "ICMS calculation base
        icms_bas                    TYPE ty_taxamount,  "ICMS normal base
        icms_exc                    TYPE ty_taxamount,  "ICMS exclude base
        icms_oth                    TYPE ty_taxamount,  "ICMS other base
        icms_rate                   TYPE ty_taxamount,  "ICMS rate (norm./freig
        icms_fcp_amt                TYPE ty_taxamount,  "ICMS Special Fund Amou
        icms_fcp_obas               TYPE ty_taxamount,  "ICMS Special Fund Othe
        icms_fcp_base               TYPE ty_taxamount,  "ICMS Special Fund Base
        icms_fcp_ebas               TYPE ty_taxamount,  "ICMS Special Fund Excl
        icms_fcp_rate               TYPE ty_taxamount,  "ICMS Special Fund Rate
        icms_fcp_partilha_base      TYPE ty_taxamount, "ICMS Partilha FCP Base
        icms_fcp_partilha_ebas      TYPE ty_taxamount, "ICMS Partilha FCP Exclu
        icms_fcp_partilha_amt       TYPE ty_taxamount, "ICMS Partilha FCP Amoun
        icms_orig_part_amt          TYPE ty_taxamount,  "ICMS Partilha Intersat
        icms_dest_part_amt          TYPE ty_taxamount,  "ICMS Partilha Intrasta
        icms_orig_part_rate         TYPE ty_taxamount,  "ICMS Partilha Intersat
        icms_dest_part_rate         TYPE ty_taxamount,  "ICMS Partilha Intrasta
        icms_orig_part_base         TYPE ty_taxamount,  "ICMS Partilha Intersat
        icms_dest_part_base         TYPE ty_taxamount,  "ICMS Partilha Intrasta
        icms_orig_part_exc          TYPE ty_taxamount,   "ICMS Partilha Intrast
        icms_dest_part_exc          TYPE ty_taxamount,   "ICMS Partilha Intrast
        ipi_cbas                    TYPE ty_taxamount,  "IPI calculation base
        ipi_bas                     TYPE ty_taxamount,  "IPI normal base
        ipi_exc                     TYPE ty_taxamount,  "IPI exclude base
        ipi_oth                     TYPE ty_taxamount,  "IPI other base
        ipio_bas                    TYPE ty_taxamount,  "IPI base in IPI split
        icop_bas                    TYPE ty_taxamount,  "ICMS complement base
        icop_rate                   TYPE ty_taxamount,  "ICMS complement rate
        icms_comp_fcp_amt           TYPE ty_taxamount, "ICMS Complement FCP Amo
        icms_comp_fcp_base          TYPE ty_taxamount, "ICMS Complement FCP Bas
        icms_comp_fcp_rate          TYPE ty_taxamount, "ICMS Complement FCP Rat
        st_bas                      TYPE ty_taxamount,  "Sub.Trib. base
        st_rate                     TYPE ty_taxamount,  "Sub.Trib. rate on nota
        subtrib_fcp_amt             TYPE ty_taxamount,  "Sub.Trib. FCP rate on
        subtrib_fcp_rate            TYPE ty_taxamount,  "Sub.Trib. FCP rate on
        subtrib_fcp_base            TYPE ty_taxamount,  "Sub.Trib. FCP base on
        icfr_bas                    TYPE ty_taxamount,  "ICMS on freight base
        icfs_bas                    TYPE ty_taxamount,  "Sub.Trib. on freight b
        iss_bas                     TYPE ty_taxamount,  "ISS base
        iss_amt_prov                TYPE ty_taxamount,  "ISS amount at loc. of
        iss_wta_prov                TYPE ty_taxamount,  "ISS WT amount at provi
        iss_bas_prov                TYPE ty_taxamount,  "ISS normal base at pro
        iss_exc_prov                TYPE ty_taxamount,  "ISS exclude base at pr
        iss_wt_prov                 TYPE xfeld,          "ISS indicator WT at pr
        iss_amt_serv                TYPE ty_taxamount,  "ISS amount at loc. of
        iss_wta_serv                TYPE ty_taxamount,  "ISS WT amount at servi
        iss_bas_serv                TYPE ty_taxamount,  "ISS normal base at ser
        iss_exc_serv                TYPE ty_taxamount,  "ISS exclude base at se
        iss_wt_serv                 TYPE xfeld,          "ISS indicator WT at se
        iss_offset                  TYPE ty_taxamount,  "ISS offsets due to tax
        iss_offset_service_location TYPE ty_taxamount, "ISS Offset for Service
        iss_offset_provider         TYPE ty_taxamount, "ISS Offset for Provider
        cofins_amt                  TYPE ty_taxamount,  "COFINS amount
        cofins_amt_res              TYPE ty_taxamount,  "COFINS amount resale"9
        cofins_bas                  TYPE ty_taxamount,  "COFINS normal base
        cofins_exc                  TYPE ty_taxamount,  "COFINS exclude base
        cofins_off                  TYPE ty_taxamount,  "COFINS offset tax incl
        pis_amt                     TYPE ty_taxamount,  "PIS amount
        pis_amt_res                 TYPE ty_taxamount,  "PIS amount resale "947
        pis_bas                     TYPE ty_taxamount,  "PIS normal base
        pis_exc                     TYPE ty_taxamount,  "PIS exclude base
        pis_off                     TYPE ty_taxamount,  "PIS offset due to tax
        piscof_config_base2         TYPE ty_taxamount, "configured PIS/COFINS b
        "2. base calculation               "1717837
        ipi_pauta_base              TYPE ty_taxamount,      "1818634
        pis_pauta_base              TYPE ty_taxamount,      "1818634
        cofins_pauta_base           TYPE ty_taxamount,      "1818634
      END OF ty_tax_result .

  class-methods CALCULATE
    importing
      !IS_KOMK type KOMK
      !IS_KOMP type KOMP
      !IT_KOMV type TAX_XKOMV_TAB
      !IS_TAX_RESULT type TY_TAX_RESULT
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
  class-methods GET_SCENARIO_CONFIG
    importing
      !IS_KOMK type KOMK
      !IS_KOMP type KOMP
    returning
      value(RS_ZGNRET007) type ZTSD_CALC_DIFAL .
  class-methods GET_COND_VALUES
    importing
      !IS_SCENARIO_CONFIG type ZTSD_CALC_DIFAL
      !IT_KOMV type TAX_XKOMV_TAB
    exporting
      !EV_ICVA type TY_TAXAMOUNT
      !EV_ISIC type TY_TAXAMOUNT
      !EV_ISIB type TY_TAXAMOUNT
      !EV_IBRX type TY_TAXAMOUNT
      !EV_ISFR type TY_TAXAMOUNT
      !EV_ISFB type TY_TAXAMOUNT .
  class-methods CALCULATE_SAVE
    importing
      !IS_KOMK type KOMK
      !IS_KOMP type KOMP
      !IS_KOMV type TAX_XKOMV_TAB
      !IS_VBRK type VBRK
      !IS_VBRP type VBRP .
  PROTECTED SECTION.

private section.

  class-methods CALCULATE_FORM_2
    importing
      !IV_ICVA type TY_TAXAMOUNT
      !IV_ISIC type TY_TAXAMOUNT
      !IV_IBRX type TY_TAXAMOUNT
      !IV_ISFR type TY_TAXAMOUNT
      !IV_ISFB type TY_TAXAMOUNT
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
  class-methods CALCULATE_FORM_3
    importing
      !IV_ICVA type TY_TAXAMOUNT
      !IV_ISIC type TY_TAXAMOUNT
      !IV_IBRX type TY_TAXAMOUNT
      !IV_ISFR type TY_TAXAMOUNT
      !IV_ISFB type TY_TAXAMOUNT
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
  class-methods CALCULATE_FORM_4
    importing
      !IV_ICVA type TY_TAXAMOUNT
      !IV_ISIC type TY_TAXAMOUNT
      !IV_ISIB type TY_TAXAMOUNT
      !IV_IBRX type TY_TAXAMOUNT
      !IV_ISFR type TY_TAXAMOUNT
      !IV_ISFB type TY_TAXAMOUNT
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
  class-methods CALCULATE_FORM_5
    importing
      !IV_ICVA type TY_TAXAMOUNT
      !IV_ISIC type TY_TAXAMOUNT
      !IV_ISIB type TY_TAXAMOUNT
      !IV_IBRX type TY_TAXAMOUNT
      !IV_ISFR type TY_TAXAMOUNT
      !IV_ISFB type TY_TAXAMOUNT
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
  class-methods CALCULATE_FORM_6
    importing
      !IV_ICVA type TY_TAXAMOUNT
      !IV_ISIC type TY_TAXAMOUNT
      !IV_ISIB type TY_TAXAMOUNT
      !IV_IBRX type TY_TAXAMOUNT
      !IV_ISFR type TY_TAXAMOUNT
      !IV_ISFB type TY_TAXAMOUNT
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
  class-methods CALCULATE_FORM_7
    importing
      !IV_ICVA type TY_TAXAMOUNT
      !IV_ISIC type TY_TAXAMOUNT
      !IV_ISIB type TY_TAXAMOUNT
      !IV_IBRX type TY_TAXAMOUNT
      !IV_ISFR type TY_TAXAMOUNT
      !IV_ISFB type TY_TAXAMOUNT
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
  class-methods CALCULATE_FCP
    importing
      !IV_DEST_PARTILHA_BASE type TY_TAXAMOUNT
      !IV_ISFR type TY_TAXAMOUNT
      !IV_ISFB type TY_TAXAMOUNT
    changing
      !CV_FCP_PARTILHA_BASE type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_EBASE type TY_TAXAMOUNT
      !CV_FCP_PARTILHA_AMOUNT type TY_TAXAMOUNT .
ENDCLASS.



CLASS ZCLSD_GNRE_ICMS_PARTILHA IMPLEMENTATION.


  METHOD calculate.

    "Constantes
    CONSTANTS: lc_kvewe TYPE c VALUE 'A' LENGTH 1,
               lc_kschl TYPE c VALUE 'ICMI' LENGTH 4,
               lc_kofrm TYPE c VALUE '921' LENGTH 3.

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
    ).

    "Verifica se o cálculo da condição ICMI é feito através da fórmula 320
    SELECT SINGLE kvewe
    INTO @DATA(ls_t683s)
    FROM t683s
    WHERE kvewe = @lc_kvewe
    AND kappl = @is_komk-kappl
    AND kalsm = @is_komk-kalsm
    AND kschl = @lc_kschl
    AND kofrm = @lc_kofrm.

    IF sy-subrc IS INITIAL.
      lv_ibrx = is_tax_result-ipi_amt + is_komp-netwr.
    ENDIF.


    IF ls_scenario_config-partilha_icms IS INITIAL.

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
    ELSE.
      cv_orig_partilha_amount = 0.
      cv_dest_partilha_amount = 0.
      cv_fcp_partilha_amount  = 0.
      cv_orig_partilha_base   = 0.
      cv_dest_partilha_base   = 0.
      cv_fcp_partilha_base    = 0.
      cv_orig_partilha_ebase  = 0.
      cv_dest_partilha_ebase  = 0.
      cv_fcp_partilha_ebase   = 0.
    ENDIF.
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


  METHOD calculate_form_2.

    "Embutindo o DIFAL no Débito
    cv_orig_partilha_base   = 0.
    cv_orig_partilha_amount = 0.
    cv_orig_partilha_ebase  = ( iv_ibrx * ( 1 - iv_icva ) ) / ( 1 - iv_isic ).

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

  ENDMETHOD.


  METHOD calculate_form_3.

    "Embutindo o DIFAL no Débito e no Crédito
    cv_orig_partilha_base   = 0.
    cv_orig_partilha_amount = 0.
    cv_orig_partilha_ebase  = ( iv_ibrx * ( 1 - iv_icva ) ) / ( 1 - iv_isic ).

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
    cv_orig_partilha_ebase  = iv_ibrx.

    cv_dest_partilha_base   = iv_ibrx * iv_isib.
    cv_dest_partilha_amount = ( cv_dest_partilha_base * ( iv_isic - iv_isfr ) ) - ( iv_ibrx * iv_icva ).
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


  METHOD calculate_form_5.

    "Igualando as Bases Com Redução no Destino
    cv_orig_partilha_base   = 0.
    cv_orig_partilha_amount = 0.
    cv_orig_partilha_ebase  = iv_ibrx.

    cv_dest_partilha_base   = iv_ibrx * iv_isib.
    cv_dest_partilha_amount = ( cv_dest_partilha_base * ( iv_isic - iv_isfr ) ) - ( cv_dest_partilha_base * iv_icva ).
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


  METHOD calculate_form_6.

    "Embutindo o DIFAL no Débito e Reduzindo Base do Débito
    cv_orig_partilha_base   = 0.
    cv_orig_partilha_amount = 0.
    cv_orig_partilha_ebase  = ( iv_ibrx * ( 1 - iv_icva ) ) / ( 1 - iv_isic ).

    cv_dest_partilha_base   = cv_orig_partilha_ebase * iv_isib.
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
    cv_orig_partilha_ebase  = ( iv_ibrx * ( 1 - iv_icva ) ) / ( 1 - iv_isic ).

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

    ls_zgnret019-vbeln  = is_vbrk-vbeln.
    ls_zgnret019-posnr  = is_vbrp-posnr.
    ls_zgnret019-aubel  = is_vbrp-aubel.
    ls_zgnret019-aupos  = is_vbrp-aupos.
    ls_zgnret019-credat = sy-datum.
    ls_zgnret019-cretim = sy-uzeit.
    ls_zgnret019-crenam = sy-uname.
    INSERT ztsd_gnret019 FROM ls_zgnret019.
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

      IF sy-subrc IS INITIAL.
        ev_icva = <fs_s_komv>-kwert / <fs_s_komv>-kawrt.
      ENDIF.
    ENDIF.

    "Obtêm o valor da condição já convertido
    READ TABLE lt_komv ASSIGNING <fs_s_komv> WITH KEY kschl = 'ISIC' BINARY SEARCH.

    IF sy-subrc IS INITIAL.
      ev_isic = <fs_s_komv>-kwert / <fs_s_komv>-kawrt.
    ENDIF.

    "Obtêm o valor da condição já convertido
    READ TABLE lt_komv ASSIGNING <fs_s_komv> WITH KEY kschl = 'ISIB' BINARY SEARCH.

    IF sy-subrc IS INITIAL.
      ev_isib = <fs_s_komv>-kbetr / 1000.
    ENDIF.

    "Obtêm o valor da condição já convertido
    READ TABLE lt_komv ASSIGNING <fs_s_komv> WITH KEY kschl = 'ISFR' BINARY SEARCH.

    IF sy-subrc IS INITIAL.
      ev_isfr = <fs_s_komv>-kwert / <fs_s_komv>-kawrt.
    ENDIF.

    READ TABLE lt_komv ASSIGNING <fs_s_komv> WITH KEY kschl = 'ISFB' BINARY SEARCH.

    IF sy-subrc IS INITIAL.
      ev_isfb = <fs_s_komv>-kbetr / 1000.
    ENDIF.

    READ TABLE lt_komv ASSIGNING <fs_s_komv> WITH KEY kschl = 'IBRX' BINARY SEARCH.

    IF sy-subrc IS INITIAL.
      ev_ibrx = <fs_s_komv>-kwert.
    ENDIF.

    READ TABLE lt_komv ASSIGNING <fs_s_komv> WITH KEY kschl = 'BX23' BINARY SEARCH.

    IF sy-subrc IS INITIAL.
      ev_ibrx = ev_ibrx + <fs_s_komv>-kwert.
    ENDIF.

  ENDMETHOD.


  METHOD get_scenario_config.
    "Constantes
    CONSTANTS: lc_h TYPE c VALUE 'H',
               lc_m TYPE c VALUE 'M',
               lc_2 TYPE c VALUE '2' LENGTH 1,
               lc_x TYPE c VALUE 'X' LENGTH 1.
    "Variaveis
    DATA: lv_data  TYPE j_1btxdatf,
          lv_vbtyp TYPE tvak-vbtyp,
          lv_vgbel TYPE vbelv,
          lv_vgpos TYPE komp-vgpos,
          lv_prsdt TYPE vbrp-prsdt.

    FIELD-SYMBOLS: <fs_vbkd> TYPE vbkd,
                   <fs_vbrp> TYPE vbrp.
    "Se não for documento de vendas, auart estará vazio.
    IF is_komk-auart IS NOT INITIAL.
      "Verifica se é uma devolução / Seleciona a categoria do documento SD
      SELECT SINGLE vbtyp
               INTO lv_vbtyp
               FROM tvak
              WHERE auart = is_komk-auart.

      IF lv_vbtyp EQ lc_h.
        "Busca o documento de fatura
        MOVE: is_komp-vgbel TO lv_vgbel,
              is_komp-vgpos TO lv_vgpos.

      ELSE.

        ASSIGN ('(SAPFV45P)VBKD') TO <fs_vbkd>.
        IF <fs_vbkd> IS ASSIGNED.
          lv_data = <fs_vbkd>-prsdt.
        ENDIF.

      ENDIF.

    ELSEIF is_komk-fkart IS NOT INITIAL.
      "Verifica se é uma devolução
      SELECT COUNT(*) UP TO 1 ROWS
        FROM vbak
        WHERE vbeln = is_komp-aubel
          AND vbtyp EQ lc_h.

      IF sy-subrc IS INITIAL.
        "Busca o documento de fatura
        SELECT vbelv posnv UP TO 1 ROWS
          INTO ( lv_vgbel , lv_vgpos )
          FROM vbfa
          WHERE vbeln EQ is_komp-aubel
          AND posnn EQ is_komp-aupos
          AND vbtyp_n EQ lc_h
          AND vbtyp_v EQ lc_m.
        ENDSELECT.

        IF lv_vgbel IS INITIAL.
          "Quando não for documento SD, será fatura. Lógica para os casos de doc. de fatura SD
          ASSIGN ('(SAPFV45P)VBRP') TO <fs_vbrp>.

          IF <fs_vbrp> IS ASSIGNED.
            lv_data = <fs_vbrp>-prsdt.
          ELSE.
            ASSIGN ('(SAPLV60A)VBRP') TO <fs_vbrp>.
            IF <fs_vbrp> IS ASSIGNED.
              lv_data = <fs_vbrp>-prsdt.
            ENDIF.
          ENDIF.

        ENDIF.

      ELSE.
        "Quando não for documento SD, será fatura. Lógica para os casos de doc. de fatura SD
        ASSIGN ('(SAPFV45P)VBRP') TO <fs_vbrp>.
        IF <fs_vbrp> IS ASSIGNED.
          lv_data = <fs_vbrp>-prsdt.
        ELSE.
          ASSIGN ('(SAPLV60A)VBRP') TO <fs_vbrp>.
          IF <fs_vbrp> IS ASSIGNED.
            lv_data = <fs_vbrp>-prsdt.
          ENDIF.
        ENDIF.

      ENDIF.

    ENDIF.

    IF lv_vgbel IS NOT INITIAL AND lv_vgpos IS NOT INITIAL.
      "Busca data da fatura
      SELECT SINGLE prsdt
      FROM vbrp
      INTO lv_prsdt
      WHERE vbeln = lv_vgbel
      AND posnr = lv_vgpos.

      IF sy-subrc IS INITIAL.
        lv_data = lv_prsdt.
      ENDIF.

    ENDIF.
    "Converte a data para formato interno
    IF lv_data IS NOT INITIAL.
      CONCATENATE lv_data+6(2) lv_data+4(2) lv_data(4) INTO lv_data.
      CALL FUNCTION 'CONVERSION_EXIT_INVDT_INPUT'
        EXPORTING
          input  = lv_data
        IMPORTING
          output = lv_data.

    ENDIF.
    "Cenário de venda com código de imposto para consumo, com cálculo do ICMS?
    SELECT SINGLE taxcode
    INTO @DATA(ls_j1btxsdc)
    FROM j_1btxsdc
    WHERE taxcode = @is_komp-j_1btxsdc
    AND custusage = @lc_2
    AND icms      = @lc_x.

    "IS_KOMK-WKREG = UF Origem
    "IS_KOMK-REGIO = UF Destino
    CHECK sy-subrc IS INITIAL AND is_komk-wkreg <> is_komk-regio.
    "Checar se existe registro com as chaves UF Orig., UF Dest. e Cód. Produto

    SELECT SINGLE *
            FROM ztsd_calc_difal
            INTO rs_zgnret007
           WHERE shipto   = is_komk-regio
             AND matkl    = space
             AND matnr    = is_komp-matnr.
*             AND ( validfrom GE lv_data   "Campos comentados para melhoria GNRE 2.0
*             AND validto   LE lv_data ).  "Campos comentados para melhoria GNRE 2.0

    IF sy-subrc IS NOT INITIAL.
      "Caso não exista registro, checar com UF Orig., UF Dest. e Grp. Materiais
      SELECT SINGLE *
               FROM ztsd_calc_difal
               INTO rs_zgnret007
              WHERE shipto = is_komk-regio
                AND matkl  = is_komp-matkl
                AND matnr  = space.
*               AND ( validfrom GE lv_data   "Campos comentados para melhoria GNRE 2.0
*               AND validto   LE lv_data ).   "Campos comentados para melhoria GNRE 2.0

      IF sy-subrc IS NOT INITIAL.
        "Caso não exista registro, checar com UF Orig., UF Dest.
        SELECT SINGLE *
                FROM ztsd_calc_difal
                INTO rs_zgnret007
               WHERE shipto = is_komk-regio
                 AND matkl    = space
                 AND matnr    = space.
*                 AND ( validfrom GE lv_data   "Campos comentados para melhoria GNRE 2.0
*                 AND validto LE lv_data ).    "Campos comentados para melhoria GNRE 2.0

        IF sy-subrc IS NOT INITIAL.
          "Caso não exista, considerar a fórmula de cálculo 1 (forma como é calculado atualmente)
          rs_zgnret007-formula_difal = '1'. "Tradicional
        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
