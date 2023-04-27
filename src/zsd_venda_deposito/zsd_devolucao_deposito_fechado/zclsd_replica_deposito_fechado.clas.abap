CLASS zclsd_replica_deposito_fechado DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      "! Types referência data para select options
      BEGIN OF ty_refdata,
        docnum TYPE REF TO data,
      END OF ty_refdata .

    DATA:
         "! Tabela referência data para select options
          gs_refdata TYPE ty_refdata .

    DATA:
      "!Data de
      gv_data1 TYPE j_1bnfdoc-docdat,
      "!Data até
      gv_data2 TYPE j_1bnfdoc-docdat.

    "! Método principal que inicia a execução do programa
    "! @parameter iv_data1 | Data de
    "! @parameter iv_data2 | Data até
    METHODS executar IMPORTING iv_data1 TYPE j_1bnfdoc-docdat
                               iv_data2 TYPE j_1bnfdoc-docdat.
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      "! Types para select options
      BEGIN OF ty_selopt,
        docnum TYPE RANGE OF j_1bnfdoc-docnum,
      END OF ty_selopt.

    TYPES:
      "! Types Cabeçalho da nota fiscal
      BEGIN OF ty_header_nf,
        docnum TYPE j_1bnfdoc-docnum,
        nftype TYPE j_1bnfdoc-nftype,
        docdat TYPE j_1bnfdoc-docdat,
        pstdat TYPE j_1bnfdoc-pstdat,
        nftot  TYPE j_1bnfdoc-nftot,
        nfenum TYPE j_1bnfdoc-nfenum,
      END OF ty_header_nf.

    TYPES:
      "! Types Partidas individuais da nota fiscal
      BEGIN OF ty_item_nf,
        docnum TYPE j_1bnflin-docnum,
        itmnum TYPE j_1bnflin-itmnum,
        matnr  TYPE j_1bnflin-matnr,
        charg  TYPE j_1bnflin-charg,
        refkey TYPE j_1bnflin-refkey,
        werks  TYPE j_1bnflin-werks,
        menge  TYPE j_1bnflin-menge,
      END OF ty_item_nf.

    TYPES:
      "! Documento de faturamento: dados de item
      BEGIN OF ty_item_fat,
        vbeln TYPE vbrp-vbeln,
        posnr TYPE vbrp-posnr,
        lgort TYPE vbrp-lgort,
      END OF ty_item_fat.

    TYPES:
      "! Centros/filiais
      BEGIN OF ty_centro,
        werks      TYPE t001w-werks,
        lifnr      TYPE t001w-lifnr,
        j_1bbranch TYPE t001w-j_1bbranch,
      END OF ty_centro,
      "! Type Transferência partidas individuais nota fiscal
      ty_obj_item       TYPE STANDARD TABLE OF bapi_j_1bnflin WITH DEFAULT KEY,
      "! Type transferência nota fiscal imposto por item
      ty_obj_item_tax   TYPE STANDARD TABLE OF bapi_j_1bnfstx WITH DEFAULT KEY,
      "! Type transferência mensagem de cabeçalho nota fiscal
      ty_obj_header_msg TYPE STANDARD TABLE OF bapi_j_1bnfftx WITH DEFAULT KEY.

    CONSTANTS:
      "! Constantes para tabela de parâmetros Ctg.de nota fiscal
      BEGIN OF gc_parametros_ctg_nf,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'ADM DEVOLUÇÃO',
        chave2 TYPE ztca_param_par-chave2 VALUE 'TP_NF_REPLICA',
      END OF gc_parametros_ctg_nf.

    CONSTANTS:
      "! Constantes para tabela de parâmetros Centro
      BEGIN OF gc_parametros_centro,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'ADM DEVOLUÇÃO',
        chave2 TYPE ztca_param_par-chave2 VALUE 'CENTRODF',
        chave3 TYPE ztca_param_par-chave3 VALUE 'WERKS',
      END OF gc_parametros_centro.

    CONSTANTS:
      "! Constantes para tabela de parâmetros Saída Transferência
      BEGIN OF gc_parametros_saida,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'ADM DEVOLUÇÃO',
        chave2 TYPE ztca_param_par-chave2 VALUE 'MVM_DF',
      END OF gc_parametros_saida.

    CONSTANTS:
      "! Constantes para tabela de parâmetros Em Transferência
      BEGIN OF gc_parametros_trans,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'ADM DEVOLUÇÃO',
        chave2 TYPE ztca_param_par-chave2 VALUE 'MVM_DFE',
      END OF gc_parametros_trans.

    CONSTANTS:
      "! Constantes para tabela de parâmetros Em Transferência
      BEGIN OF gc_parametros_iva,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'ADM DEVOLUÇÃO',
        chave2 TYPE ztca_param_par-chave2 VALUE 'TAX_DF',
      END OF gc_parametros_iva.

    CONSTANTS:
      "! Constantes para tabela de parâmetros Depositos
      BEGIN OF gc_parametros_deposito,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'ADM DEVOLUÇÃO',
        chave2 TYPE ztca_param_par-chave2 VALUE 'DEP_DF',
      END OF gc_parametros_deposito.

    CONSTANTS:
      "! Constantes para tabela de parâmetros Depositos
      BEGIN OF gc_parametros_cfpo,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'NFE',
        chave2 TYPE ztca_param_par-chave2 VALUE 'REPLICA_DF',
        chave3 TYPE ztca_param_par-chave3 VALUE 'CFOP',
      END OF gc_parametros_cfpo.

    "!  Tipo de movimento Saída Transferência
    DATA gs_tp_mov_saida TYPE RANGE OF  mseg-bwart.
    "!  Tipo de movimento Em Transferência
    DATA gs_tp_mov_trans TYPE RANGE OF  mseg-bwart.
    "! Ctg.de nota fiscal
    DATA gs_ctg_nf TYPE RANGE OF  j_1bnfdoc-nftype.
    "! Centro
    DATA gs_centro TYPE RANGE OF  j_1bnflin-werks.
    "! Código IVA
    DATA gs_codigo_iva TYPE RANGE OF mwskz.
    "! Depositos
    DATA gs_depositos TYPE RANGE OF lgort_d.
    "! CFPO
    DATA gs_cfpo TYPE RANGE OF j_1bnflin-cfop.

    "! Cabeçalho da nota fiscal
    DATA gt_header_nf  TYPE SORTED TABLE OF ty_header_nf WITH UNIQUE KEY docnum .
    "! Item da nota fiscal
    DATA gt_item_nf  TYPE SORTED TABLE OF ty_item_nf WITH UNIQUE KEY docnum itmnum.
    "! Item da nota faturamento
    DATA gt_item_fat TYPE SORTED TABLE OF ty_item_fat WITH UNIQUE KEY vbeln posnr.
    "! Centros/filiais
    DATA gt_centros TYPE SORTED TABLE OF ty_centro WITH UNIQUE KEY werks.
    "! Estrutura de comunicação BAPI: criar item doc.material - Transferência
    DATA gt_goodsmvt_item_transf TYPE TABLE OF bapi2017_gm_item_create.
    "! Estrutura de comunicação BAPI: criar item doc.material - Entrada Mercadoria
    DATA gt_goodsmvt_item_merc   TYPE TABLE OF bapi2017_gm_item_create.
    "! Retorno BAPIS
    DATA gt_return          TYPE TABLE OF bapiret2.
    "! Retorno Log
    DATA gt_log             TYPE TABLE OF bapiret2.

    "! Estrutura de comunicação BAPI: doc.material dados cabeçalho
    DATA gs_goodsmvt_header TYPE bapi2017_gm_head_01.
    "! MMIM: conversão de chave CM_CODE p/transação na admin.estq.
    DATA gs_goodsmvt_code   TYPE bapi2017_gm_code.
    "! Tabela para select options
    DATA gs_selopt TYPE ty_selopt.
    "!  Nº documento
    DATA gs_docnum TYPE j_1bnfdoc-docnum.

    "!Método trata select options
    METHODS trata_select_options.

    "!Método para seleção de dados
    METHODS selecao_dados.

    "! Método para passar dados globais
    "! @parameter iv_data1 | Data de
    "! @parameter iv_data2 | Data até
    METHODS dados_globais
      IMPORTING
        iv_data1 TYPE j_1bnfdoc-docdat
        iv_data2 TYPE j_1bnfdoc-docdat.

    "! Seleciona as Ctg.de nota fiscal
    METHODS get_param_ctg_nf.

    "! Seleciona as Centro
    METHODS get_param_centro.
    "! Seleciona os Tipos de movimentos Saída Transferência
    METHODS get_param_tp_mov_saida RETURNING VALUE(rv_tp_mov_saida) TYPE mseg-bwart.
    "! Seleciona os Tipos de movimentos Em Transferência
    METHODS get_param_tp_mov_trans RETURNING VALUE(rv_tp_mov_trans) TYPE mseg-bwart.
    "! Seleciona os Tipos de Código IVA
    METHODS get_param_codigo_iva RETURNING VALUE(rv_codigo_iva) TYPE mwskz.
    "! Seleciona os Depositos
    METHODS get_param_deposito RETURNING VALUE(rv_deposito) TYPE lgort.
    "! CFPO
    METHODS get_param_cfpo RETURNING VALUE(rv_cfpo) TYPE j_1bnflin-cfop.

    "! Realiza a Replicação
    METHODS processa_replicacao.
    "! Preenche os dados para chamar a BAPI
    "! @parameter is_header_nf | Cabeçalho da nota fiscal
    METHODS preenche_dados_bapi
      IMPORTING
        is_header_nf TYPE ty_header_nf.

    "! Seleciona Depósitos
    "! @parameter is_item_nf | Partidas individuais da nota fiscal
    "! @parameter rv_lgort   | Depósito
    METHODS seleciona_deposito IMPORTING is_item_nf      TYPE ty_item_nf
                               RETURNING VALUE(rv_lgort) TYPE vbrp-lgort.

    "! Seleciona Fornecedores
    "! @parameter is_item_nf | Partidas individuais da nota fiscal
    "! @parameter rv_lifnr   | Número do fornecedor do centro
    METHODS seleciona_fornecedor IMPORTING is_item_nf      TYPE ty_item_nf
                                 RETURNING VALUE(rv_lifnr) TYPE t001w-lifnr.
    "! Seleciona Local de negócios
    "! @parameter is_item_nf      | Partidas individuais da nota fiscal
    "! @parameter rv_j_1bbranch   | Local de negócios
    METHODS seleciona_local_negocios IMPORTING is_item_nf           TYPE ty_item_nf
                                     RETURNING VALUE(rv_j_1bbranch) TYPE t001w-j_1bbranch.

    "! Preenche dados para Transferência
    "! @parameter is_item_nf | Partidas individuais da nota fiscal
    METHODS preenche_transferencia
      IMPORTING
        is_item_nf TYPE ty_item_nf.
    "! Preenche dados para Entrada de Mercadoria
    "! @parameter is_item_nf | Partidas individuais da nota fiscal
    METHODS preenche_entrada_mercadoria
      IMPORTING
        is_item_nf TYPE ty_item_nf.
    "! Chama BAPI para criar transferência
    METHODS cria_transferencia.
    "! Realiza commit nas BAPIs
    METHODS call_commit.
    "! Cria entrada de mercadorias
    METHODS cria_entrada_mercadoria.
    "! Cria a writer da nota replicada
    "! @parameter is_header_nf |Cabeçalho da nota fiscal
    METHODS cria_writer_nota_replicada IMPORTING is_header_nf TYPE ty_header_nf .
    "! Atualiza dados para gerar nota replicada
    "! @parameter is_header_nf      |  Cabeçalho da nota fiscal
    "! @parameter cs_obj_header     |  Esturtura de transferência dados cabeçalho nota fiscal
    "! @parameter ct_obj_item       |  Type Transferência partidas individuais nota fiscal
    "! @parameter ct_obj_item_tax   |  Type transferência nota fiscal imposto por item
    "! @parameter ct_obj_header_msg |  Type transferência mensagem de cabeçalho nota fiscal
    METHODS atualiza_dados_nota_replicada
      IMPORTING
        is_header_nf      TYPE ty_header_nf
      CHANGING
        cs_obj_header     TYPE bapi_j_1bnfdoc
        ct_obj_item       TYPE ty_obj_item
        ct_obj_item_tax   TYPE ty_obj_item_tax
        ct_obj_header_msg TYPE ty_obj_header_msg.

    "! Limpa variaveis globais
    METHODS limpa_globais.
    "! Processa Log
    METHODS processa_log.

ENDCLASS.

CLASS zclsd_replica_deposito_fechado IMPLEMENTATION.

  METHOD executar.

    dados_globais( iv_data1 = iv_data1 iv_data2 = iv_data2 ).
    trata_select_options(  ).
    selecao_dados(  ).
    processa_replicacao(  ).
    processa_log(  ).

  ENDMETHOD.

  METHOD dados_globais.

    gv_data1 =  iv_data1.
    gv_data2 =  iv_data2.

  ENDMETHOD.

  METHOD trata_select_options.

    DATA: lo_ref_descr   TYPE REF TO cl_abap_structdescr.
    DATA: lt_detail      TYPE abap_compdescr_tab.

    FIELD-SYMBOLS: <fs_table> TYPE STANDARD TABLE,
                   <fs_ref>   TYPE REF TO data.

    lo_ref_descr ?= cl_abap_typedescr=>describe_by_data( me->gs_refdata ).
    lt_detail[] = lo_ref_descr->components.

    LOOP AT lt_detail ASSIGNING FIELD-SYMBOL(<fs_det>)."INTO DATA(ls_det).

      ASSIGN COMPONENT <fs_det>-name OF STRUCTURE me->gs_refdata TO <fs_ref>.
      ASSIGN COMPONENT <fs_det>-name OF STRUCTURE me->gs_selopt  TO FIELD-SYMBOL(<fs_selopt>).

      ASSIGN <fs_ref>->* TO <fs_table>.
      IF <fs_table> IS ASSIGNED.
        <fs_selopt> = <fs_table>.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD selecao_dados.

    get_param_ctg_nf(  ).

    SELECT docnum nftype docdat pstdat nftot nfenum
    FROM j_1bnfdoc
    INTO TABLE gt_header_nf
    WHERE docnum IN gs_selopt-docnum
      AND docdat BETWEEN gv_data1 AND gv_data2
      AND nftype IN gs_ctg_nf.

    CHECK gt_header_nf IS NOT INITIAL.

    SELECT DISTINCT docnum itmnum matnr charg refkey werks menge
    INTO TABLE gt_item_nf
    FROM j_1bnflin
    FOR ALL ENTRIES IN gt_header_nf
    WHERE j_1bnflin~docnum EQ gt_header_nf-docnum
      AND j_1bnflin~werks  IN gs_centro.

    CHECK gt_item_nf IS NOT INITIAL.

    SELECT vbeln posnr lgort
    FROM vbrp
    INTO TABLE gt_item_fat
    FOR ALL ENTRIES IN gt_item_nf
    WHERE vbeln EQ gt_item_nf-refkey(10)
      AND posnr EQ gt_item_nf-itmnum.

    SELECT werks lifnr j_1bbranch
    FROM t001w
    INTO TABLE gt_centros
    FOR ALL ENTRIES IN gt_item_nf
    WHERE werks EQ gt_item_nf-werks.


  ENDMETHOD.

  METHOD get_param_ctg_nf.

    DATA(lo_tabela_parametros) = NEW  zclca_tabela_parametros( ).

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
      iv_modulo = gc_parametros_ctg_nf-modulo
      iv_chave1 = gc_parametros_ctg_nf-chave1
      iv_chave2 = gc_parametros_ctg_nf-chave2
          IMPORTING
            et_range  = gs_ctg_nf
        ).


      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.

  METHOD get_param_centro.

    DATA(lo_tabela_parametros) = NEW  zclca_tabela_parametros( ).

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
      iv_modulo = gc_parametros_centro-modulo
      iv_chave1 = gc_parametros_centro-chave1
      iv_chave2 = gc_parametros_centro-chave2
      iv_chave3 = gc_parametros_centro-chave3
          IMPORTING
            et_range  = gs_centro
        ).


      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.


  METHOD get_param_tp_mov_saida.

    DATA(lo_tabela_parametros) = NEW  zclca_tabela_parametros( ).

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
      iv_modulo = gc_parametros_saida-modulo
      iv_chave1 = gc_parametros_saida-chave1
      iv_chave2 = gc_parametros_saida-chave2
          IMPORTING
            et_range  = gs_tp_mov_saida
        ).

        READ TABLE gs_tp_mov_saida ASSIGNING FIELD-SYMBOL(<fs_tp_mov_saida>) INDEX 1.
        CHECK sy-subrc = 0.
        rv_tp_mov_saida = <fs_tp_mov_saida>-low.

      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.

  METHOD  get_param_codigo_iva.

    DATA(lo_tabela_parametros) = NEW  zclca_tabela_parametros( ).

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
      iv_modulo = gc_parametros_iva-modulo
      iv_chave1 = gc_parametros_iva-chave1
      iv_chave2 = gc_parametros_iva-chave2
          IMPORTING
            et_range  = gs_codigo_iva
        ).

        READ TABLE gs_codigo_iva ASSIGNING FIELD-SYMBOL(<fs_codigo_iva>) INDEX 1.
        CHECK sy-subrc = 0.
        rv_codigo_iva = <fs_codigo_iva>-low.

      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.

  METHOD  get_param_deposito.

    DATA(lo_tabela_parametros) = NEW  zclca_tabela_parametros( ).

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
      iv_modulo = gc_parametros_deposito-modulo
      iv_chave1 = gc_parametros_deposito-chave1
      iv_chave2 = gc_parametros_deposito-chave2
          IMPORTING
            et_range  = gs_depositos
        ).

        READ TABLE gs_depositos ASSIGNING FIELD-SYMBOL(<fs_depositos>) INDEX 1.
        CHECK sy-subrc = 0.
        rv_deposito = <fs_depositos>-low.

      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.

  METHOD   get_param_cfpo.

    DATA(lo_tabela_parametros) = NEW  zclca_tabela_parametros( ).

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
      iv_modulo = gc_parametros_cfpo-modulo
      iv_chave1 = gc_parametros_cfpo-chave1
      iv_chave2 = gc_parametros_cfpo-chave2
      iv_chave3 = gc_parametros_cfpo-chave3
          IMPORTING
            et_range  = gs_cfpo
        ).

        READ TABLE gs_cfpo ASSIGNING FIELD-SYMBOL(<fs_cfpo>) INDEX 1.
        CHECK sy-subrc = 0.
        rv_cfpo = <fs_cfpo>-low.

      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.

  METHOD get_param_tp_mov_trans.

    DATA(lo_tabela_parametros) = NEW  zclca_tabela_parametros( ).

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
      iv_modulo = gc_parametros_trans-modulo
      iv_chave1 = gc_parametros_trans-chave1
      iv_chave2 = gc_parametros_trans-chave2
          IMPORTING
            et_range  = gs_tp_mov_trans
        ).

        READ TABLE gs_tp_mov_trans ASSIGNING FIELD-SYMBOL(<fs_tp_mov_trans>) INDEX 1.
        CHECK sy-subrc = 0.
        rv_tp_mov_trans = <fs_tp_mov_trans>-low.

      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.

  METHOD processa_replicacao.

    DATA ls_header_nf TYPE j_1bnfdoc.
    DATA(lo_retorna_devolucao) = NEW  zclsd_retorna_devolucao_replic( ).

    LOOP AT gt_header_nf ASSIGNING FIELD-SYMBOL(<fs_header_nf>).

      READ TABLE gt_item_nf TRANSPORTING NO FIELDS WITH KEY docnum = <fs_header_nf>-docnum BINARY SEARCH.

      IF sy-subrc = 0.

        ls_header_nf = CORRESPONDING #( <fs_header_nf> ).

        lo_retorna_devolucao->executar(
          EXPORTING
            is_header_nf           = ls_header_nf
          IMPORTING
            ev_saida_transferencia = DATA(lv_saida_transferencia)
            ev_em_transferencia    = DATA(lv_em_transferencia)
            ev_devolucao           = DATA(lv_devolucao)         ).

        IF lv_saida_transferencia IS INITIAL
        AND lv_em_transferencia IS INITIAL
        AND lv_devolucao IS INITIAL.

          preenche_dados_bapi( is_header_nf = <fs_header_nf> ).

        ELSE.

          APPEND VALUE #(  type       = 'S'
                           message    = TEXT-004
                           message_v1 = <fs_header_nf>-docnum ) TO gt_log.

        ENDIF.

        APPEND LINES OF gt_return TO gt_log.

      ENDIF.

      limpa_globais(  ).

    ENDLOOP.

  ENDMETHOD.


  METHOD preenche_dados_bapi.

    gs_goodsmvt_header = VALUE #(  pstng_date     = is_header_nf-pstdat
                                   doc_date       = is_header_nf-docdat
                                   ref_doc_no     = is_header_nf-nfenum
                                   gr_gi_slip_no  = is_header_nf-docnum  ).

    gs_goodsmvt_code-gm_code = '04'.

    LOOP AT gt_item_nf ASSIGNING FIELD-SYMBOL(<fs_item_nf>) FROM sy-tabix.

      IF is_header_nf-docnum <> <fs_item_nf>-docnum.
        EXIT.
      ENDIF.

      preenche_transferencia( <fs_item_nf> ).
      preenche_entrada_mercadoria( <fs_item_nf> ).

    ENDLOOP.

    cria_transferencia(  ).
    cria_writer_nota_replicada( is_header_nf = is_header_nf ).

  ENDMETHOD.

  METHOD preenche_transferencia.

    APPEND VALUE #( material      = is_item_nf-matnr
                    plant         = is_item_nf-werks
                    stge_loc      = seleciona_deposito( is_item_nf = is_item_nf )
                    batch         = is_item_nf-charg
                    move_type     = get_param_tp_mov_saida( )
                    vendor        = seleciona_fornecedor( is_item_nf = is_item_nf )
                    entry_qnt     = is_item_nf-menge
                    tax_code      = get_param_codigo_iva( )
                    move_plant    = is_item_nf-werks
                    move_stloc    = get_param_deposito( )
                    ) TO gt_goodsmvt_item_transf.

  ENDMETHOD.

  METHOD preenche_entrada_mercadoria.

    APPEND VALUE #( material      = is_item_nf-matnr
                    plant         = is_item_nf-werks
                    stge_loc      = seleciona_deposito( is_item_nf = is_item_nf )
                    batch         = is_item_nf-charg
                    move_type     = get_param_tp_mov_trans(  )
                    vendor        = seleciona_fornecedor( is_item_nf = is_item_nf )
                    entry_qnt     = is_item_nf-menge
                    tax_code      = get_param_codigo_iva( )
                    move_plant    = is_item_nf-werks
                    move_stloc    = get_param_deposito( )
                    ) TO gt_goodsmvt_item_merc.

  ENDMETHOD.

  METHOD seleciona_deposito.

    READ TABLE gt_item_fat ASSIGNING FIELD-SYMBOL(<fs_item_fat>) WITH KEY vbeln = is_item_nf-refkey(10)
                                                                          posnr = is_item_nf-itmnum BINARY SEARCH.
    CHECK <fs_item_fat> IS ASSIGNED.
    rv_lgort = <fs_item_fat>-lgort.

  ENDMETHOD.

  METHOD seleciona_fornecedor.

    READ TABLE gt_centros ASSIGNING FIELD-SYMBOL(<fs_centros>) WITH KEY werks = is_item_nf-werks BINARY SEARCH.
    CHECK <fs_centros> IS ASSIGNED.
    rv_lifnr = <fs_centros>-lifnr.

  ENDMETHOD.

  METHOD seleciona_local_negocios.

    READ TABLE gt_centros ASSIGNING FIELD-SYMBOL(<fs_centros>) WITH KEY werks = is_item_nf-werks BINARY SEARCH.
    CHECK <fs_centros> IS ASSIGNED.
    rv_j_1bbranch = <fs_centros>-j_1bbranch.

  ENDMETHOD.

  METHOD cria_transferencia.

    CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
      EXPORTING
        goodsmvt_header = gs_goodsmvt_header
        goodsmvt_code   = gs_goodsmvt_code
      TABLES
        goodsmvt_item   = gt_goodsmvt_item_transf
        return          = gt_return.

    SORT gt_return BY type.
    READ TABLE gt_return TRANSPORTING NO FIELDS WITH KEY type = 'S' BINARY SEARCH.
    CHECK sy-subrc = 0.

    call_commit( ).
    cria_entrada_mercadoria(  ).

  ENDMETHOD.

  METHOD call_commit.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

  ENDMETHOD.

  METHOD cria_entrada_mercadoria.

    CLEAR gt_return.

    CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
      EXPORTING
        goodsmvt_header = gs_goodsmvt_header
        goodsmvt_code   = gs_goodsmvt_code
      TABLES
        goodsmvt_item   = gt_goodsmvt_item_merc
        return          = gt_return.

    SORT gt_return BY type.
    READ TABLE gt_return TRANSPORTING NO FIELDS WITH KEY type = 'S' BINARY SEARCH.
    CHECK sy-subrc = 0.

    call_commit( ).

  ENDMETHOD.

  METHOD cria_writer_nota_replicada.

    DATA ls_obj_header      TYPE bapi_j_1bnfdoc.
    DATA lt_obj_item        TYPE TABLE OF bapi_j_1bnflin.
    DATA lt_obj_item_tax    TYPE TABLE OF bapi_j_1bnfstx.
    DATA lt_obj_header_msg  TYPE TABLE OF bapi_j_1bnfftx.

    SORT gt_return BY type.
    READ TABLE gt_return TRANSPORTING NO FIELDS WITH KEY type = 'S' BINARY SEARCH.
    CHECK sy-subrc = 0.

    CLEAR gt_return.

    CALL FUNCTION 'BAPI_J_1B_NF_GETDETAIL'
      EXPORTING
        docnum         = is_header_nf-docnum
      IMPORTING
        obj_header     = ls_obj_header
      TABLES
        obj_item       = lt_obj_item
        obj_item_tax   = lt_obj_item_tax
        obj_header_msg = lt_obj_header_msg
        return         = gt_return.

    atualiza_dados_nota_replicada( EXPORTING
                                   is_header_nf = is_header_nf
                                   CHANGING
                                   cs_obj_header = ls_obj_header
                                   ct_obj_item = lt_obj_item
                                   ct_obj_item_tax = lt_obj_item_tax
                                   ct_obj_header_msg = lt_obj_header_msg ).

    CALL FUNCTION 'BAPI_J_1B_NF_CREATEFROMDATA'
      EXPORTING
        obj_header     = ls_obj_header
      TABLES
        obj_item       = lt_obj_item
        obj_item_tax   = lt_obj_item_tax
        obj_header_msg = lt_obj_header_msg
        return         = gt_return.


    SORT gt_return BY type.
    READ TABLE gt_return TRANSPORTING NO FIELDS WITH KEY type = 'S' BINARY SEARCH.
    CHECK sy-subrc = 0.

    call_commit( ).

  ENDMETHOD.

  METHOD atualiza_dados_nota_replicada.

    SORT ct_obj_item       BY docnum itmnum.
    SORT ct_obj_item_tax   BY docnum itmnum.
    SORT ct_obj_header_msg BY docnum .

    LOOP AT gt_item_nf ASSIGNING FIELD-SYMBOL(<fs_item_nf>) FROM sy-tabix.

      IF is_header_nf-docnum <> <fs_item_nf>-docnum.
        EXIT.
      ENDIF.

      cs_obj_header = VALUE #( branch   = seleciona_local_negocios( is_item_nf = <fs_item_nf> )
                               observat = gs_docnum ).

      READ TABLE ct_obj_item ASSIGNING FIELD-SYMBOL(<fs_obj_item>) WITH KEY docnum = <fs_item_nf>-docnum
                                                                            itmnum = <fs_item_nf>-itmnum BINARY SEARCH.
      IF sy-subrc = 0.
        <fs_obj_item>-cfop = get_param_cfpo( ).
      ENDIF.

      READ TABLE ct_obj_item_tax ASSIGNING FIELD-SYMBOL(<fs_obj_item_tax>) WITH KEY docnum = <fs_item_nf>-docnum
                                                                                    itmnum = <fs_item_nf>-itmnum BINARY SEARCH.
      IF sy-subrc = 0.
        <fs_obj_item_tax>-base = is_header_nf-nftot.
      ENDIF.

      READ TABLE  ct_obj_header_msg ASSIGNING FIELD-SYMBOL(<fs_obj_header_msg>) WITH KEY docnum = <fs_item_nf>-docnum BINARY SEARCH.
      IF sy-subrc = 0.
        <fs_obj_header_msg>-seqnum = '01'.
        <fs_obj_header_msg>-linnum = '01'.
        <fs_obj_header_msg>-message = TEXT-001.
      ENDIF.

    ENDLOOP.






  ENDMETHOD.


  METHOD limpa_globais.
    CLEAR:gt_goodsmvt_item_transf, gt_goodsmvt_item_merc, gs_goodsmvt_header,gs_goodsmvt_code, gt_return.
  ENDMETHOD.

  METHOD processa_log.

    TYPES: BEGIN OF ty_log,
             icon TYPE icon_d.
             INCLUDE TYPE bapiret2.
    TYPES:   END OF ty_log.

    DATA: lt_table   TYPE REF TO cl_salv_table,
          lt_columns TYPE REF TO cl_salv_columns_table,
          lt_column  TYPE REF TO cl_salv_column_table,
          lt_funct   TYPE REF TO cl_salv_functions,
          lt_log     TYPE TABLE OF ty_log,
          ls_log     TYPE ty_log.

    IF gt_log IS NOT INITIAL.

      LOOP AT gt_log ASSIGNING FIELD-SYMBOL(<fs_log>).

        CHECK <fs_log>-type NE 'W'.
        ls_log = CORRESPONDING #( <fs_log> ).

        IF <fs_log>-type EQ 'S'.
          ls_log-icon    = icon_green_light.
        ELSE.
          ls_log-icon    = icon_red_light.
        ENDIF.

        APPEND ls_log TO lt_log.

      ENDLOOP.
    ELSE.
      APPEND VALUE #(  icon    = icon_yellow_light
                       message = TEXT-003  ) TO lt_log.
    ENDIF.

    TRY.
        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = lt_table
          CHANGING
            t_table      = lt_log.

        lt_columns = lt_table->get_columns( ).
        TRY.
            lt_column ?= lt_columns->get_column( 'ICON' ).
            lt_column->set_icon( if_salv_c_bool_sap=>true ).
            lt_column->set_long_text( TEXT-002 ).
          CATCH cx_salv_not_found.
        ENDTRY.

        lt_funct = lt_table->get_functions( ).
        lt_funct->set_all( abap_true ).
        CALL METHOD lt_table->display.
      CATCH cx_salv_msg.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
