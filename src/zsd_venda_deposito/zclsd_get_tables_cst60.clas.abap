class ZCLSD_GET_TABLES_CST60 definition
  public
  final
  create public .

public section.

  class-methods GET_INSTANCE
    returning
      value(RO_INSTANCE) type ref to ZCLSD_GET_TABLES_CST60 .
      "! Seleção das tabelas de paramentros
      "! @parameter iv_centro           | Centro
      "! @parameter iv_uf               | Estado
      "! @parameter iv_material         | Nº Material
      "! @parameter iv_gp_mercadoria    | Nº Grupo de Mercadoria
      "! @parameter ev_tabela           | Nome da tabela retornada
      "! @parameter ev_agregado         | Agregado
      "! @parameter ev_icms_dest        | ICMS de Destino
      "! @parameter ev_icms_orig        | ICMS de Origem
      "! @parameter ev_compra_interna   | Compra interna
      "! @parameter ev_base_red_orig    | Base Reduzida da origem
      "! @parameter ev_base_red_dest    | Base Reduzida do destino
      "! @parameter ev_taxa_fcp         | Alíquota FCP
      "! @parameter ev_icms_efet        | Alíquota ICMS efetivo
      "! @parameter ev_baseredefet      | Base reduzida ICMS efetivo
      "! @parameter ev_preco_compar     | Preço para comparação (PautaxMVA)
      "! @parameter ev_preco_pauta      | Preço pauta
      "! @parameter ev_agregado_pauta   | Margem de valor agregada para ICMS pauta
      "! @parameter ev_nro_unids        | Número de unidades por UM informada
      "! @parameter ev_um               | Unidade de medida
      "! @parameter ev_modalidade       | Modalidade
      "! @parameter ev_calc_efetivo     | Não calcular efetivo
  methods EXECUTE
    importing
      !IV_CENTRO type WERKS_EXT
      !IV_UF type ZE_UF_RECEB
      !IV_MATERIAL type MATNR
      !IV_GP_MERCADORIA type MATKL
    exporting
      !EV_TABELA type CHAR20
      !EV_AGREGADO type ZE_AGREGADO
      !EV_ICMS_DEST type ZE_ICMS_DEST
      !EV_ICMS_ORIG type ZE_ICMS_ORIG
      !EV_COMPRA_INTERNA type CHAR1
      !EV_BASE_RED_ORIG type ZE_BASE_RED_ORIG
      !EV_BASE_RED_DEST type ZE_BASE_RED_DEST
      !EV_TAXA_FCP type ZE_TAXA_FCP
      !EV_ICMS_EFET type ZE_ICMS_EFET
      !EV_BASEREDEFET type ZE_BASEREDEFET
      !EV_PRECO_COMPAR type ZE_PRECO_COMPAR
      !EV_PRECO_PAUTA type ZE_PRECO_PAUTA
      !EV_AGREGADO_PAUTA type ZE_AGREGADO_PAUTA
      !EV_NRO_UNIDS type ZE_NRO_UNIDS
      !EV_UM type ZE_UM
      !EV_MODALIDADE type ZE_MODALIDADE
      !EV_CALC_EFETIVO type CHAR1
      !EV_PERC_BC_ICMS type ZE_PERC_BC_ICMS .
  methods CONSTRUCTOR .
  methods GET_TABLE
    importing
      !IV_CENTRO type WERKS_EXT
      !IV_UF type ZE_UF_RECEB
      !IV_MATERIAL type MATNR
      !IV_GP_MERCADORIA type MATKL
    exporting
      !EV_TABELA type CHAR20 .
  PROTECTED SECTION.
private section.

  class-data GO_INSTANCE type ref to ZCLSD_GET_TABLES_CST60 .
  data GV_CENTRO type WERKS_EXT .
  data GV_UF type ZE_UF_RECEB .
  data GV_MATERIAL type MATNR .
  data GV_GP_MERCADORIA type MATKL .
  data GS_MATERIAL type ZTSD_MATERIAL .
  data GS_GP_MERCADORIA type ZTSD_GP_MERCADOR .
  constants GC_MATERIAL type CHAR20 value 'ZTSD_MATERIAL' ##NO_TEXT.
  constants GC_GPMERCADORIA type CHAR20 value 'ZTSD_GP_MERCADOR' ##NO_TEXT.
  class-data:
    gt_material TYPE TABLE OF ztsd_material .
  class-data:
    gt_gp_mercadoria TYPE TABLE OF ztsd_gp_mercador .
  class-data GV_INSTANCE type ABAP_BOOL .

  "! Salva os parametros de entrada em variáveis globais
  "! @parameter iv_centro           | Centro
  "! @parameter iv_uf               | Estado
  "! @parameter iv_material         | Nº Material
  "! @parameter iv_gp_mercadoria    | Nº Grupo de Mercadoria
  methods SET_PARAMETER_INPUT
    importing
      !IV_CENTRO type WERKS_EXT
      !IV_UF type ZE_UF_RECEB
      !IV_MATERIAL type MATNR
      !IV_GP_MERCADORIA type MATKL
    returning
      value(RV_RETURN) type ABAP_BOOL .
  "! Seleciona dados do Material
  "! @parameter rv_return           | Retorno boleano; True = Encontrou registro, False se não encontrou registro
  methods GET_MATERIAL
    returning
      value(RV_RETURN) type ABAP_BOOL .
  "! Seleciona dados do Grupo de Mercadoria
  "! @parameter rv_return           | Retorno boleano; True = Encontrou registro, False se não encontrou registro
  methods GET_GP_MERCADORIA
    returning
      value(RV_RETURN) type ABAP_BOOL .
  "! Retorna os parametros encontrados
  "! @parameter ev_tabela           | Nome da tabela retornada
  "! @parameter ev_agregado         | Agregado
  "! @parameter ev_icms_dest        | ICMS de Destino
  "! @parameter ev_icms_orig        | ICMS de Origem
  "! @parameter ev_compra_interna   | Compra interna
  "! @parameter ev_base_red_orig    | Base Reduzida da origem
  "! @parameter ev_base_red_dest    | Base Reduzida do destino
  "! @parameter ev_taxa_fcp         | Alíquota FCP
  "! @parameter ev_icms_efet        | Alíquota ICMS efetivo
  "! @parameter ev_baseredefet      | Base reduzida ICMS efetivo
  "! @parameter ev_preco_compar     | Preço para comparação (PautaxMVA)
  "! @parameter ev_preco_pauta      | Preço pauta
  "! @parameter ev_agregado_pauta   | Margem de valor agregada para ICMS pauta
  "! @parameter ev_nro_unids        | Número de unidades por UM informada
  "! @parameter ev_um               | Unidade de medida
  "! @parameter ev_modalidade       | Modalidade
  "! @parameter ev_calc_efetivo     | Não calcular efetivo
  methods SET_OUTPUT
    importing
      !IV_TABLE type CHAR20
    exporting
      !EV_TABELA type CHAR20
      !EV_AGREGADO type ZE_AGREGADO
      !EV_ICMS_DEST type ZE_ICMS_DEST
      !EV_ICMS_ORIG type ZE_ICMS_ORIG
      !EV_COMPRA_INTERNA type CHAR1
      !EV_BASE_RED_ORIG type ZE_BASE_RED_ORIG
      !EV_BASE_RED_DEST type ZE_BASE_RED_DEST
      !EV_TAXA_FCP type ZE_TAXA_FCP
      !EV_ICMS_EFET type ZE_ICMS_EFET
      !EV_BASEREDEFET type ZE_BASEREDEFET
      !EV_PRECO_COMPAR type ZE_PRECO_COMPAR
      !EV_PRECO_PAUTA type ZE_PRECO_PAUTA
      !EV_AGREGADO_PAUTA type ZE_AGREGADO_PAUTA
      !EV_NRO_UNIDS type ZE_NRO_UNIDS
      !EV_UM type ZE_UM
      !EV_MODALIDADE type ZE_MODALIDADE
      !EV_CALC_EFETIVO type CHAR1
      !EV_PERC_BC_ICMS type ZE_PERC_BC_ICMS .
ENDCLASS.



CLASS ZCLSD_GET_TABLES_CST60 IMPLEMENTATION.


  METHOD EXECUTE.

    DATA(lv_erro) =  set_parameter_input( EXPORTING  iv_centro           =  iv_centro
                                                     iv_uf               =  iv_uf
                                                     iv_material         =  iv_material
                                                     iv_gp_mercadoria    =  iv_gp_mercadoria  ).

    IF lv_erro IS INITIAL.

      IF get_material(  ) = abap_true.
        set_output( EXPORTING iv_table = gc_material
                    IMPORTING ev_tabela         = ev_tabela
                              ev_agregado       = ev_agregado
                              ev_icms_dest      = ev_icms_dest
                              ev_icms_orig      = ev_icms_orig
                              ev_compra_interna = ev_compra_interna
                              ev_base_red_orig  = ev_base_red_orig
                              ev_base_red_dest  = ev_base_red_dest
                              ev_taxa_fcp       = ev_taxa_fcp
                              ev_icms_efet      = ev_icms_efet
                              ev_baseredefet    = ev_baseredefet
                              ev_preco_compar   = ev_preco_compar
                              ev_preco_pauta    = ev_preco_pauta
                              ev_agregado_pauta = ev_agregado_pauta
                              ev_nro_unids      = ev_nro_unids
                              ev_um             = ev_um
                              ev_modalidade     = ev_modalidade
                              ev_calc_efetivo   = ev_calc_efetivo
                              ev_perc_bc_icms   = ev_perc_bc_icms ).

      ELSEIF get_gp_mercadoria(  ) = abap_true.

        set_output( EXPORTING iv_table = gc_gpmercadoria
                    IMPORTING ev_tabela         = ev_tabela
                              ev_agregado       = ev_agregado
                              ev_icms_dest      = ev_icms_dest
                              ev_icms_orig      = ev_icms_orig
                              ev_compra_interna = ev_compra_interna
                              ev_base_red_orig  = ev_base_red_orig
                              ev_base_red_dest  = ev_base_red_dest
                              ev_taxa_fcp       = ev_taxa_fcp
                              ev_icms_efet      = ev_icms_efet
                              ev_baseredefet    = ev_baseredefet
                              ev_preco_compar   = ev_preco_compar
                              ev_preco_pauta    = ev_preco_pauta
                              ev_agregado_pauta = ev_agregado_pauta
                              ev_nro_unids      = ev_nro_unids
                              ev_um             = ev_um
                              ev_modalidade     = ev_modalidade
                              ev_calc_efetivo   = ev_calc_efetivo
                              ev_perc_bc_icms   = ev_perc_bc_icms ).

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD get_gp_mercadoria.

    IF NOT gv_instance IS INITIAL.

      READ TABLE gt_gp_mercadoria INTO gs_gp_mercadoria WITH KEY centro        = gv_centro
                                                                 uf            = gv_uf
                                                                 grpmercadoria = gv_gp_mercadoria BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        rv_return = abap_true.
      ENDIF.

    ELSE.

      SELECT SINGLE
        centro , uf , grpmercadoria , descricao , agregado ,
        icms_dest , icms_orig , compra_interna , base_red_orig ,
        base_red_dest , taxa_fcp , icms_efet , baseredefet ,
        preco_compar , preco_pauta , agregado_pauta , nro_unids ,
        um , modalidade , calc_efetivo , perc_bc_icms
      INTO CORRESPONDING FIELDS OF @gs_gp_mercadoria
        FROM ztsd_gp_mercador
        WHERE centro = @gv_centro
        AND uf = @gv_uf
        AND grpmercadoria = @gv_gp_mercadoria.

      IF sy-subrc IS INITIAL.
        rv_return = abap_true.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD get_material.

    IF NOT gv_instance IS INITIAL.

      READ TABLE gt_material INTO gs_material WITH KEY centro   = gv_centro
                                                       uf       = gv_uf
                                                       material = gv_material BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        rv_return = abap_true.
      ENDIF.

    ELSE.

      SELECT SINGLE
        centro , uf , material , descricao , agregado ,
        icms_dest , icms_orig , compra_interna , base_red_orig ,
        base_red_dest , taxa_fcp , icms_efet , baseredefet ,
        preco_compar , preco_pauta , agregado_pauta , nro_unids ,
        um , modalidade , calc_efetivo , perc_bc_icms
      INTO CORRESPONDING FIELDS OF @gs_material
        FROM ztsd_material
        WHERE centro = @gv_centro
        AND uf = @gv_uf
        AND material = @gv_material.

      IF sy-subrc IS INITIAL.
        rv_return = abap_true.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD SET_OUTPUT.
    CASE iv_table.
      WHEN gc_material.

        ev_tabela         = gc_material.
        ev_agregado       = gs_material-agregado.
        ev_icms_dest      = gs_material-icms_dest.
        ev_icms_orig      = gs_material-icms_orig.
        ev_compra_interna = gs_material-compra_interna.
        ev_base_red_orig  = gs_material-base_red_orig.
        ev_base_red_dest  = gs_material-base_red_dest.
        ev_taxa_fcp       = gs_material-taxa_fcp.
        ev_icms_efet      = gs_material-icms_efet.
        ev_baseredefet    = gs_material-baseredefet.
        ev_preco_compar   = gs_material-preco_compar.
        ev_preco_pauta    = gs_material-preco_pauta.
        ev_agregado_pauta = gs_material-agregado_pauta.
        ev_nro_unids      = gs_material-nro_unids.
        ev_um             = gs_material-um.
        ev_modalidade     = gs_material-modalidade.
        ev_calc_efetivo   = gs_material-calc_efetivo.
        ev_perc_bc_icms   = gs_material-perc_bc_icms.

      WHEN gc_gpmercadoria.

        ev_tabela         = gc_gpmercadoria.
        ev_agregado       = gs_gp_mercadoria-agregado.
        ev_icms_dest      = gs_gp_mercadoria-icms_dest.
        ev_icms_orig      = gs_gp_mercadoria-icms_orig.
        ev_compra_interna = gs_gp_mercadoria-compra_interna.
        ev_base_red_orig  = gs_gp_mercadoria-base_red_orig.
        ev_base_red_dest  = gs_gp_mercadoria-base_red_dest.
        ev_taxa_fcp       = gs_gp_mercadoria-taxa_fcp.
        ev_icms_efet      = gs_gp_mercadoria-icms_efet.
        ev_baseredefet    = gs_gp_mercadoria-baseredefet.
        ev_preco_compar   = gs_gp_mercadoria-preco_compar.
        ev_preco_pauta    = gs_gp_mercadoria-preco_pauta.
        ev_agregado_pauta = gs_gp_mercadoria-agregado_pauta.
        ev_nro_unids      = gs_gp_mercadoria-nro_unids.
        ev_um             = gs_gp_mercadoria-um.
        ev_modalidade     = gs_gp_mercadoria-modalidade.
        ev_calc_efetivo   = gs_gp_mercadoria-calc_efetivo.
        ev_perc_bc_icms   = gs_gp_mercadoria-perc_bc_icms.

    ENDCASE.
  ENDMETHOD.


  METHOD set_parameter_input.

    IF iv_centro           IS INITIAL OR
       iv_uf               IS INITIAL OR
       iv_material         IS INITIAL OR
       iv_gp_mercadoria    IS INITIAL.
      rv_return = abap_true.
      EXIT.
    ENDIF.

    gv_centro         = iv_centro.
    gv_uf             = iv_uf.
    gv_material       = iv_material.
    gv_gp_mercadoria  = iv_gp_mercadoria.

  ENDMETHOD.


  METHOD constructor.

    IF NOT gv_instance IS INITIAL.

      SELECT
        centro , uf , material , descricao , agregado ,
        icms_dest , icms_orig , compra_interna , base_red_orig ,
        base_red_dest , taxa_fcp , icms_efet , baseredefet ,
        preco_compar , preco_pauta , agregado_pauta , nro_unids ,
        um , modalidade , calc_efetivo , perc_bc_icms
      FROM ztsd_material
      INTO CORRESPONDING FIELDS OF TABLE @gt_material.

      IF sy-subrc IS INITIAL.
        SORT gt_material BY centro uf material.
      ENDIF.

      SELECT
        centro , uf , grpmercadoria , descricao , agregado ,
        icms_dest , icms_orig , compra_interna , base_red_orig ,
        base_red_dest , taxa_fcp , icms_efet , baseredefet ,
        preco_compar , preco_pauta , agregado_pauta , nro_unids ,
        um , modalidade , calc_efetivo , perc_bc_icms
      FROM ztsd_gp_mercador
      INTO CORRESPONDING FIELDS OF TABLE @gt_gp_mercadoria.

      IF sy-subrc IS INITIAL.
        SORT gt_gp_mercadoria BY centro uf grpmercadoria.
      ENDIF.


    ENDIF.

  ENDMETHOD.


  METHOD get_instance.

    IF NOT go_instance IS BOUND.
      gv_instance = abap_true.
      go_instance = NEW zclsd_get_tables_cst60( ).
    ENDIF.

    ro_instance = go_instance.

  ENDMETHOD.


  METHOD get_table.

    SELECT COUNT( * )
      FROM ztsd_material
      WHERE centro = @gv_centro
      AND uf = @gv_uf
      AND material = @gv_material.

    IF sy-subrc IS INITIAL.
      ev_tabela = gc_material.
    ELSE.

      SELECT COUNT( * )
        FROM ztsd_gp_mercador
        WHERE centro = @gv_centro
        AND uf = @gv_uf
        AND grpmercadoria = @gv_gp_mercadoria.

      IF sy-subrc IS INITIAL.
        ev_tabela = gc_gpmercadoria.
      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
