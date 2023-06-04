"! <p>Entrada de mercadorias</p>
CLASS zclsd_entrada_mercadoria DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! Executar a Entrada de mercadorias
    "! @parameter iv_docnum        | Nr. Documento de entrada
    "! @parameter iv_docfatura     | Nr. Documento de faturamente
    "! @parameter iv_centro        | Centro
    "! @parameter rt_mensagens     | Retorno de mensagens da BAPI
    METHODS executar
      IMPORTING
        !iv_docnum          TYPE j_1bdocnum
        !iv_docfatura       TYPE vbeln_nach
        !iv_centro          TYPE werks_d
        !iv_centro_orig     TYPE werks_d OPTIONAL
      RETURNING
        VALUE(rt_mensagens) TYPE bapiret2_tab .
    "! Método executado após chamada da função background
    "! @parameter p_task | Parametro obrigatório do método
    METHODS task_finish
      IMPORTING
        !p_task TYPE clike .
  PRIVATE SECTION.
    METHODS:
      "! Método para filtrar mensagens de retorno
      "! @parameter rt_mensagens | Mensagens válidas para retornar
      mensagens
        RETURNING
          VALUE(rt_mensagens) TYPE bapiret2_tab,

      "! <p class="shorttext synchronized">Busca parâmetros</p>
      "! @parameter iv_key1  | <p class="shorttext synchronized">Parâmetro chave 1</p>
      "! @parameter iv_key2  | <p class="shorttext synchronized">Parâmetro chave 2</p>
      "! @parameter iv_key3  | <p class="shorttext synchronized">Parâmetro chave 3</p>
      "! @parameter ev_param | <p class="shorttext synchronized">Parâmetro tipo</p>
      get_param
        IMPORTING
          iv_key1  TYPE ztca_param_par-chave1
          iv_key2  TYPE ztca_param_par-chave2
          iv_key3  TYPE ztca_param_par-chave3
        EXPORTING
          ev_param TYPE any.

    DATA:
      "! <p class="shorttext synchronized">Tabela de retorno de mensagens</p>
      gt_return TYPE STANDARD TABLE OF bapiret2 .

    CONSTANTS:
      "! <p class="shorttext synchronized">Constantes da tabela de Parâmetros</p>
      BEGIN OF gc_param,
        modulo           TYPE ztca_param_par-modulo VALUE 'SD',
        contrato_food    TYPE ztca_param_par-chave1 VALUE 'CONTRATOS FOOD',
        cockpit_sd       TYPE ztca_param_par-chave1 VALUE 'COCKPIT_SD',
        entr_mercadoria  TYPE ztca_param_par-chave2 VALUE 'ENTRADA MERCADORIA',
        tipo_operacao    TYPE ztca_param_par-chave2 VALUE 'TIPO_OPERACAO',
        ch2_move_type    TYPE ztca_param_par-chave2 VALUE 'MOVE_TYPE',
        ch2_ret_comodato TYPE ztca_param_par-chave2 VALUE 'RET_COMODATO',
        ch2_ret_locacao  TYPE ztca_param_par-chave2 VALUE 'RET_LOCACAO',
        stge_loc         TYPE ztca_param_par-chave3 VALUE 'STGE_LOC',
        mov_type         TYPE ztca_param_par-chave3 VALUE 'MOV_TYPE',
        tax_code         TYPE ztca_param_par-chave3 VALUE 'TAXCODE',
        comodato         TYPE ztca_param_par-chave3 VALUE 'COMODATO',
        locacao          TYPE ztca_param_par-chave3 VALUE 'LOCACAO',
      END OF gc_param,
      "! <p class="shorttext synchronized">Mensagens de retorno</p>
      BEGIN OF gc_mensagem_erro,
        type         TYPE bapi_mtype VALUE 'E',
        id           TYPE symsgid    VALUE 'ZSD_COMODATO_LOC',
        sem_doc_nf   TYPE symsgno    VALUE '004',
        sem_nr_serie TYPE symsgno    VALUE '005',
      END OF gc_mensagem_erro,

      BEGIN OF gc_mensagem_sucess,
        type_sucess  TYPE bapi_mtype VALUE 'S',
        id           TYPE symsgid    VALUE 'ZSD_COMODATO_LOC',
        ciado_sucess TYPE symsgno    VALUE '007',
      END OF gc_mensagem_sucess,

      BEGIN OF gc_fkart,
        y077 TYPE fkart VALUE 'Y077',
        y076 TYPE fkart VALUE 'Y076',
        yr77 TYPE fkart VALUE 'YR77',
        yd77 TYPE fkart VALUE 'YD77',
        yr76 TYPE fkart VALUE 'YR76',
        yd76 TYPE fkart VALUE 'YD76',
      END OF gc_fkart,

      gc_goodsmvt_code TYPE bapi2017_gm_code VALUE '05'.
ENDCLASS.



CLASS ZCLSD_ENTRADA_MERCADORIA IMPLEMENTATION.


  METHOD executar.

    DATA: lt_return                TYPE STANDARD TABLE OF bapiret2,
          lt_goodsmvt_serialnumber TYPE bapi2017_gm_serialnumber_t.

    DATA: lr_locacao  TYPE RANGE OF fkart,
          lr_comodato TYPE RANGE OF fkart.

    DATA: lv_stge_loc  TYPE bapi2017_gm_item_create-stge_loc,
          lv_move_type TYPE bapi2017_gm_item_create-move_type,
          lv_taxcode   TYPE bapi2017_gm_item_create-tax_code.

    SELECT SINGLE docnum,
                  pstdat,
                  docdat,
                  nfenum,
                  series,
                  parid
      FROM j_1bnfdoc
     WHERE docnum = @iv_docnum
      INTO @DATA(ls_nf_documento).

    IF sy-subrc <> 0.
      rt_mensagens = VALUE #( ( type   = gc_mensagem_erro-type
                                id     = gc_mensagem_erro-id
                                number = gc_mensagem_erro-sem_doc_nf ) ).
      RETURN.
    ENDIF.

    SELECT docnum,
           itmnum,
           nf_item~matnr,
           menge,
           nf_item~netwr,
           refkey,
           objk~sernr,
           vbap_contrato~lgort
      FROM j_1bnflin AS nf_item
     INNER JOIN vbfa AS vbfa_remessa  ON vbfa_remessa~vbeln = nf_item~refkey
                                     AND vbfa_remessa~posnn = nf_item~refitm
                                     AND vbfa_remessa~vbtyp_v = 'J'
     INNER JOIN ser01                 ON ser01~lief_nr = vbfa_remessa~vbelv
                                     AND posnr = vbfa_remessa~posnv
     INNER JOIN objk                  ON objk~obknr = ser01~obknr
     LEFT JOIN vbfa AS vbfa_contrato  ON vbfa_contrato~vbeln = nf_item~refkey
                                     AND vbfa_contrato~posnn = nf_item~refitm
                                     AND vbfa_contrato~vbtyp_v = 'G'
      LEFT JOIN vbap AS vbap_contrato ON vbap_contrato~vbeln = vbfa_contrato~vbelv
                                     AND vbap_contrato~posnr = vbfa_contrato~posnv
     WHERE docnum = @iv_docnum
      INTO TABLE @DATA(lt_nf_itens).

    IF sy-subrc <> 0.
      rt_mensagens = VALUE #( ( type   = gc_mensagem_erro-type
                                id     = gc_mensagem_erro-id
                                number = gc_mensagem_erro-sem_nr_serie ) ).
      RETURN.
    ENDIF.

    SELECT SINGLE vbeln,
                  fkart
      FROM vbrk
     WHERE vbeln = @iv_docfatura
      INTO @DATA(ls_vbrk).

    IF sy-subrc IS INITIAL.
      IF ls_vbrk-fkart EQ gc_fkart-y077. " Saída Comodato

        get_param( EXPORTING iv_key1  = gc_param-cockpit_sd
                             iv_key2  = gc_param-ch2_move_type
                             iv_key3  = gc_param-comodato
                   IMPORTING ev_param = lv_move_type ).

      ELSEIF ls_vbrk-fkart EQ gc_fkart-y076. " Saída Locação

        get_param( EXPORTING iv_key1  = gc_param-cockpit_sd
                             iv_key2  = gc_param-ch2_move_type
                             iv_key3  = gc_param-locacao
                   IMPORTING ev_param = lv_move_type ).

      ELSEIF ls_vbrk-fkart EQ gc_fkart-yr77
          OR ls_vbrk-fkart EQ gc_fkart-yd77. " Retorno Comodato

        get_param( EXPORTING iv_key1  = gc_param-cockpit_sd
                             iv_key2  = gc_param-ch2_ret_comodato
                             iv_key3  = gc_param-mov_type
                   IMPORTING ev_param = lv_move_type ).

      ELSEIF ls_vbrk-fkart EQ gc_fkart-yr76
          OR ls_vbrk-fkart EQ gc_fkart-yd76. " Retorno Locação

        get_param( EXPORTING iv_key1  = gc_param-cockpit_sd
                             iv_key2  = gc_param-ch2_ret_locacao
                             iv_key3  = gc_param-mov_type
                   IMPORTING ev_param = lv_move_type ).

      ENDIF.
    ENDIF.

*    get_param( EXPORTING iv_key1  = gc_param-contrato_food
*                         iv_key2  = gc_param-entr_mercadoria
*                         iv_key3  = gc_param-stge_loc
*               IMPORTING ev_param = lv_stge_loc ).
*
*    get_param( EXPORTING iv_key1  = gc_param-contrato_food
*                         iv_key2  = gc_param-entr_mercadoria
*                         iv_key3  = gc_param-move_type
*               IMPORTING ev_param = lv_move_type ).

    get_param( EXPORTING iv_key1  = gc_param-contrato_food
                         iv_key2  = gc_param-entr_mercadoria
                         iv_key3  = gc_param-tax_code
               IMPORTING ev_param = lv_taxcode ).

    DATA(ls_goodsmvt_header) = VALUE bapi2017_gm_head_01( pstng_date    = sy-datum "ls_nf_documento-pstdat
                                                          doc_date      = ls_nf_documento-docdat
                                                          ref_doc_no    = ls_nf_documento-nfenum && ls_nf_documento-series
                                                          gr_gi_slip_no = iv_docfatura
                                                         ).

    SELECT SINGLE werks,
                  kunnr
      FROM t001w
     WHERE werks = @iv_centro_orig
      INTO @DATA(ls_t001w).
    IF sy-subrc IS INITIAL.

      DATA(lt_goodsmvt_item) = VALUE bapi2017_gm_item_create_t(
                                FOR ls_nf_item IN lt_nf_itens ( material        = ls_nf_item-matnr
                                                                entry_qnt       = ls_nf_item-menge
                                                                ext_base_amount = ls_nf_item-netwr
*                                                              vendor          = ls_nf_documento-parid
                                                                vendor          = ls_t001w-kunnr
                                                                plant           = iv_centro
                                                                stge_loc        = ls_nf_item-lgort
                                                                move_type       = lv_move_type
                                                                tax_code        = lv_taxcode
                                                                amount_lc       = ls_nf_item-netwr
                                                               ) ).

    ENDIF.

*    DATA(lt_goodsmvt_serialnumber) = VALUE bapi2017_gm_serialnumber_t(
*                                       FOR ls_nf_item IN lt_nf_itens ( matdoc_itm = sy-tabix
*                                                                       serialno = ls_nf_item-sernr
*                                                                      ) ).

    LOOP AT lt_nf_itens ASSIGNING FIELD-SYMBOL(<fs_nf_itens>).
      lt_goodsmvt_serialnumber = VALUE #( BASE lt_goodsmvt_serialnumber ( matdoc_itm = sy-tabix
                                                                          serialno   = <fs_nf_itens>-sernr ) ).
    ENDLOOP.

    CLEAR me->gt_return.

    CALL FUNCTION 'ZFMSD_ENTRADA_MERCADORIA'
      STARTING NEW TASK 'ENTR_MERCADORIA'
      CALLING task_finish ON END OF TASK
      EXPORTING
        is_goodsmvt_header       = ls_goodsmvt_header
        iv_goodsmvt_code         = gc_goodsmvt_code
      TABLES
        et_return                = lt_return
        et_goodsmvt_item         = lt_goodsmvt_item
        et_goodsmvt_serialnumber = lt_goodsmvt_serialnumber.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL lt_return IS NOT INITIAL.

    rt_mensagens = mensagens( ).

    IF rt_mensagens[] IS INITIAL.
      MESSAGE ID gc_mensagem_sucess-id TYPE gc_mensagem_sucess-type_sucess NUMBER gc_mensagem_sucess-ciado_sucess INTO DATA(lv_msg_sucess).
      rt_mensagens[] = VALUE #( BASE rt_mensagens[] ( type    = gc_mensagem_sucess-type_sucess
                                                      id      = gc_mensagem_sucess-id
                                                      number  = gc_mensagem_sucess-ciado_sucess
                                                      message = lv_msg_sucess ) ).
    ENDIF.

    LOOP AT rt_mensagens ASSIGNING FIELD-SYMBOL(<fs_mensagens>).
      IF <fs_mensagens>-type EQ 'A'.
        <fs_mensagens>-type = 'I'.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD task_finish.
    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_ENTRADA_MERCADORIA'
      TABLES
        et_return = gt_return.
    RETURN.
  ENDMETHOD.


  METHOD mensagens.
    LOOP AT me->gt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
      IF NOT ( ( <fs_return>-type = 'S' AND ( <fs_return>-id <> 'V1' AND <fs_return>-number <> '311' ) )
              OR <fs_return>-type = 'W' ).
        APPEND <fs_return> TO rt_mensagens.
      ENDIF.
    ENDLOOP.
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
