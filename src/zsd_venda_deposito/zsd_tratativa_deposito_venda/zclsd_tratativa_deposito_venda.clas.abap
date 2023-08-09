class ZCLSD_TRATATIVA_DEPOSITO_VENDA definition
  public
  final
  create public .

public section.

    "! Método principal
    "! @parameter IS_VBAK | Dados da VBAK
    "! @parameter IS_VBKD | Dados da VBKD
    "! @parameter IV_DWERK | Dados do Centro Fornecedor
    "! @parameter CS_VBAP | Dados da VBAP
  methods EXECUTE
    importing
      !IS_VBAK type VBAK
      !IS_VBKD type VBKD
      !IV_DWERK type RV45A-DWERK
    changing
      !CS_VBAP type VBAP .
  PROTECTED SECTION.
private section.

  data GS_VBAK type VBAK .
  data GS_VBKD type VBKD .
  data GS_VBAP type VBAP .
  data GV_DWERK type RV45A-DWERK .
  data GT_CTR_DEP type ZCTGSD_CTR_DET_DEP .

    "! Método para setar os dados globais
    "! @parameter IS_VBAK | Dados da VBAK
    "! @parameter IS_VBKD | Dados da VBKD
    "! @parameter IV_DWERK | Dados do Centro Fornecedor
    "! @parameter IS_VBAP | Dados da VBAP
  methods SET_INPUT
    importing
      !IS_VBAK type VBAK
      !IS_VBKD type VBKD
      !IS_VBAP type VBAP
      !IV_DWERK type RV45A-DWERK .
    "! Método para selecionar o depósito na tabela z
  methods GET_DEPOSITO .
    "! Método para setar setar o depósito da VBAP
  methods SET_DEPOSITO .
    "! Método de retorno
    "! @parameter RS_VBAP | Dados da VBAP
  methods SET_OUTPUT
    returning
      value(RS_VBAP) type VBAP .
ENDCLASS.



CLASS ZCLSD_TRATATIVA_DEPOSITO_VENDA IMPLEMENTATION.


  METHOD execute.

    set_input( EXPORTING is_vbak = is_vbak
                         is_vbkd = is_vbkd
                         iv_dwerk = iv_dwerk
                         is_vbap = cs_vbap ).

    get_deposito( ).
    set_deposito( ).
    cs_vbap = set_output( ).

  ENDMETHOD.


  METHOD get_deposito.

    SELECT *
      INTO TABLE gt_ctr_dep
      FROM ztsd_ctr_det_dep
      WHERE auart = gs_vbak-auart.

  ENDMETHOD.


  METHOD set_deposito.

* as validações abaixo serão realizadas apenas se o centro estiver preenchido.

    IF gs_vbap-werks IS NOT INITIAL.
      DATA(lv_werks) = gs_vbap-werks.
    ELSEIF gv_dwerk IS NOT INITIAL.
      lv_werks = gv_dwerk.
    ENDIF.

    CHECK lv_werks IS NOT INITIAL.

    IF gs_vbkd-bsark IS NOT INITIAL.
      SORT gt_ctr_dep BY auart bsark.
      READ TABLE gt_ctr_dep ASSIGNING FIELD-SYMBOL(<fs_ctr_dep>) WITH KEY auart = gs_vbak-auart
                                                                          bsark = gs_vbkd-bsark
* LSCHEPP - SD - 8000007852 - [YD62]Trazendo_DP_1019_divergente_2601 - 24.05.2023 Início
                                                                          kunnr = space
                                                                          augru = space
                                                                          matkl = space
                                                                          werks = space
* LSCHEPP - SD - 8000007852 - [YD62]Trazendo_DP_1019_divergente_2601 - 24.05.2023 Fim
                                                                          BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        gs_vbap-lgort = <fs_ctr_dep>-lgort.
        RETURN.
      ENDIF.
    ENDIF.

* SD - Ajuste incluindo o centro na chave - 18/07/2023 - Inicio
    SORT gt_ctr_dep BY auart kunnr werks.
    READ TABLE gt_ctr_dep ASSIGNING <fs_ctr_dep> WITH KEY auart = gs_vbak-auart
                                                          kunnr = gs_vbak-kunnr
                                                          werks = lv_werks
                                                          bsark = space
                                                          augru = space
                                                          matkl = space
                                                          BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      gs_vbap-lgort = <fs_ctr_dep>-lgort.
      RETURN.
    ENDIF.

* SD - Ajuste incluindo o centro na chave - 18/07/2023 - Fim

    SORT gt_ctr_dep BY auart kunnr.
    READ TABLE gt_ctr_dep ASSIGNING <fs_ctr_dep> WITH KEY auart = gs_vbak-auart
                                                          kunnr = gs_vbak-kunnr
* LSCHEPP - SD - 8000007852 - [YD62]Trazendo_DP_1019_divergente_2601 - 24.05.2023 Início
                                                          bsark = space
                                                          augru = space
                                                          matkl = space
                                                          werks = space
* LSCHEPP - SD - 8000007852 - [YD62]Trazendo_DP_1019_divergente_2601 - 24.05.2023 Fim
                                                          BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      gs_vbap-lgort = <fs_ctr_dep>-lgort.
      RETURN.
    ENDIF.

    IF gs_vbap-matkl IS NOT INITIAL.
      SORT gt_ctr_dep BY auart matkl werks.
      READ TABLE gt_ctr_dep ASSIGNING <fs_ctr_dep> WITH KEY auart = gs_vbak-auart
                                                            matkl = gs_vbap-matkl
                                                            werks = lv_werks
* LSCHEPP - SD - 8000007852 - [YD62]Trazendo_DP_1019_divergente_2601 - 24.05.2023 Início
                                                            kunnr = space
                                                            bsark = space
                                                            augru = space
* LSCHEPP - SD - 8000007852 - [YD62]Trazendo_DP_1019_divergente_2601 - 24.05.2023 Fim
                                                            BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        gs_vbap-lgort = <fs_ctr_dep>-lgort.
        RETURN.
      ENDIF.
    ENDIF.

    IF lv_werks IS NOT INITIAL.
      IF gs_vbak-augru IS NOT INITIAL.
        SORT gt_ctr_dep BY auart augru werks.
        READ TABLE gt_ctr_dep ASSIGNING <fs_ctr_dep> WITH KEY auart = gs_vbak-auart
                                                              augru = gs_vbak-augru
                                                              werks = lv_werks
                                                              matkl = space
                                                              kunnr = space
                                                              bsark = space
                                                              BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          gs_vbap-lgort = <fs_ctr_dep>-lgort.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.


    IF gs_vbak-augru IS NOT INITIAL.
      SORT gt_ctr_dep BY auart augru.
      READ TABLE gt_ctr_dep ASSIGNING <fs_ctr_dep> WITH KEY auart = gs_vbak-auart
                                                            augru = gs_vbak-augru
* LSCHEPP - SD - 8000007852 - [YD62]Trazendo_DP_1019_divergente_2601 - 24.05.2023 Início
                                                            matkl = space
                                                            werks = space
                                                            kunnr = space
                                                            bsark = space
* LSCHEPP - SD - 8000007852 - [YD62]Trazendo_DP_1019_divergente_2601 - 24.05.2023 Fim
                                                            BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        gs_vbap-lgort = <fs_ctr_dep>-lgort.
        RETURN.
      ENDIF.
    ENDIF.

    IF lv_werks IS NOT INITIAL.
      SORT gt_ctr_dep BY auart werks.
      READ TABLE gt_ctr_dep ASSIGNING <fs_ctr_dep> WITH KEY auart = gs_vbak-auart
                                                            werks = lv_werks
* LSCHEPP - SD - 8000007852 - [YD62]Trazendo_DP_1019_divergente_2601 - 24.05.2023 Início
                                                            matkl = space
                                                            augru = space
                                                            kunnr = space
                                                            bsark = space
* LSCHEPP - SD - 8000007852 - [YD62]Trazendo_DP_1019_divergente_2601 - 24.05.2023 Fim
                                                            BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        gs_vbap-lgort = <fs_ctr_dep>-lgort.
        RETURN.
      ENDIF.
    ENDIF.


    SORT gt_ctr_dep BY auart.
    READ TABLE gt_ctr_dep ASSIGNING <fs_ctr_dep> WITH KEY auart = gs_vbak-auart
* LSCHEPP - SD - 8000007852 - [YD62]Trazendo_DP_1019_divergente_2601 - 24.05.2023 Início
                                                          werks = space
                                                          matkl = space
                                                          augru = space
                                                          kunnr = space
                                                          bsark = space
* LSCHEPP - SD - 8000007852 - [YD62]Trazendo_DP_1019_divergente_2601 - 24.05.2023 Fim
                                                          BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      gs_vbap-lgort = <fs_ctr_dep>-lgort.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD set_input.

    gs_vbak	 = is_vbak.
    gs_vbkd	 = is_vbkd.
    gs_vbap	 = is_vbap.
    gv_dwerk = iv_dwerk.

    IF gs_vbap-matkl IS INITIAL.
      SELECT SINGLE matkl
        FROM mara
        INTO @gs_vbap-matkl
        WHERE matnr = @gs_vbap-matnr.
    ENDIF.

  ENDMETHOD.


  METHOD set_output.

    rs_vbap = gs_vbap.

  ENDMETHOD.
ENDCLASS.
