CLASS zclsd_form_coleta_avaria DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS: BEGIN OF gc_param,
                 modulo TYPE ze_param_modulo VALUE 'SD',
                 chave1 TYPE ze_param_chave  VALUE 'PRINTER',
                 chave2 TYPE ze_param_chave  VALUE 'SD',
               END OF gc_param.

    CONSTANTS: gc_printer TYPE rspopname VALUE 'LOCL'.

    METHODS:
      execute
        IMPORTING
          iv_salesorder       TYPE vbeln
        RETURNING
          VALUE(rt_mensagens) TYPE bapiret2_tab.
*          VALUE(rv_return) TYPE fpcontent.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      form_job_open,
      form_job_close,

      call_form_coleta_avaria
        IMPORTING
          is_dados_formulario TYPE zssd_dados_form_coleta_avaria
        RETURNING
          VALUE(rt_mensagens) TYPE bapiret2_tab,
*          VALUE(rv_return)    TYPE fpcontent,

      nome_funcao_form_coleta_avaria
        RETURNING
          VALUE(rv_return) TYPE funcname,

      selecionar_dados
        IMPORTING
          iv_salesorder    TYPE vbeln
        RETURNING
          VALUE(rv_return) TYPE zssd_dados_form_coleta_avaria.

ENDCLASS.



CLASS ZCLSD_FORM_COLETA_AVARIA IMPLEMENTATION.


  METHOD execute.
    form_job_open( ).
    rt_mensagens = call_form_coleta_avaria( selecionar_dados( iv_salesorder ) ).
    form_job_close( ).
  ENDMETHOD.


  METHOD selecionar_dados.

    DATA: ls_address     TYPE sadr,
          ls_branch_data TYPE j_1bbranch,
          lv_cgc_number  TYPE  j_1bwfield-cgc_number.

    DATA(lv_salesorder) = |{ iv_salesorder ALPHA = IN }|.

    SELECT SINGLE *
      FROM zi_sd_coleta_avarias
     WHERE salesorder = @lv_salesorder
      INTO @DATA(ls_sd_colega_avarias).

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    SELECT vbap~werks,
           vbap~matnr,
           vbap~arktx,
           vbap~vrkme,
           vbap~kwmeng,
           marc~steuc
      FROM vbap
      LEFT JOIN marc ON marc~matnr = vbap~matnr
                    AND marc~werks = vbap~werks
     WHERE vbeln = @lv_salesorder
      INTO TABLE @DATA(lt_vbap).

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    SELECT SINGLE vbeln,
                  zz1_qtde_sdh
      FROM vbak
     WHERE vbeln = @lv_salesorder
      INTO @DATA(ls_vbak).

    SELECT SINGLE name1, stcd1, stras, ort02, pstlz, ort01, telf1, regio, stcd3
      FROM kna1
      INTO @DATA(ls_kna1)
     WHERE kunnr EQ @ls_sd_colega_avarias-soldtoparty.

    DATA(lv_werks) = VALUE #( lt_vbap[ 1 ]-werks OPTIONAL ).

    SELECT SINGLE k~bukrs , w~j_1bbranch
    BYPASSING BUFFER
      FROM t001k AS k
     INNER JOIN t001w AS w ON k~bwkey = w~bwkey
      INTO @DATA(ls_branch_keys)
     WHERE w~werks = @lv_werks.

    CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
      EXPORTING
        branch            = ls_branch_keys-j_1bbranch
        bukrs             = ls_branch_keys-bukrs
      IMPORTING
        address           = ls_address
        branch_data       = ls_branch_data
        cgc_number        = lv_cgc_number
*       address1          =
      EXCEPTIONS
        branch_not_found  = 1
        address_not_found = 2
        company_not_found = 3
        OTHERS            = 4.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    rv_return-ordem_vendas = ls_sd_colega_avarias-salesorder.
    rv_return-ordem_frete  = ls_sd_colega_avarias-tor_id.
    rv_return-data_coleta  = ls_sd_colega_avarias-salesorderdate.
    rv_return-data_emissao = ls_sd_colega_avarias-creationdate.

    rv_return-razao_social = COND #( WHEN ls_branch_data-name IS NOT INITIAL THEN ls_branch_data-name
                                                                             ELSE ls_address-name1 ).
    rv_return-endereco     = ls_address-stras.
    rv_return-bairro       = ls_address-ort02.
    rv_return-cidade       = ls_address-ort01.
    rv_return-regiao       = ls_address-regio.
    rv_return-cep          = ls_address-pstlz.
    rv_return-telefone     = ls_address-telf1.
*    rv_return-cnpj         = ls_branch_data-stcd1.
    rv_return-cnpj         = lv_cgc_number.
    rv_return-ins_est      = ls_branch_data-state_insc.

    rv_return-razao_dest   = ls_kna1-name1.
    rv_return-cnpj_dest    = ls_kna1-stcd1.

    rv_return-endereco_dest   = ls_kna1-stras.
    rv_return-bairro_dest     = ls_kna1-ort02.
    rv_return-municipio_dest  = ls_kna1-ort01.
    rv_return-regiao_dest     = ls_kna1-regio.
    rv_return-cep_dest        = ls_kna1-pstlz.
    rv_return-telf_dest       = ls_kna1-telf1.
    rv_return-insc_est_dest   = ls_kna1-stcd3.
    rv_return-codigo_cli      = ls_sd_colega_avarias-soldtoparty.

    rv_return-itens = VALUE #( FOR <fs_vbap> IN lt_vbap ( codigo     = <fs_vbap>-matnr
                                                          descricao  = <fs_vbap>-arktx
                                                          ncm        = <fs_vbap>-steuc
                                                          unidade    = <fs_vbap>-vrkme
                                                          quantidade = <fs_vbap>-kwmeng ) ).

*    rv_return-quantidade_total = REDUCE #( INIT lv_quantidade TYPE kwmeng
*                                            FOR <fs_vbap> IN lt_vbap
*                                           NEXT lv_quantidade = lv_quantidade + <fs_vbap>-kwmeng
*                                           ).
    rv_return-quantidade_total = ls_vbak-zz1_qtde_sdh.

  ENDMETHOD.


  METHOD call_form_coleta_avaria.
    DATA:
      ls_formoutput TYPE fpformoutput,
      ls_params     TYPE sfpdocparams.

    DATA(lv_salesorder) = |{ is_dados_formulario-ordem_vendas ALPHA = OUT }|.
    CONDENSE lv_salesorder.

    DATA(lv_nome_funcform_coleta_avaria) = nome_funcao_form_coleta_avaria( ).

    CALL FUNCTION lv_nome_funcform_coleta_avaria
      EXPORTING
        /1bcdwb/docparams  = ls_params
        is_dados           = is_dados_formulario
      IMPORTING
        /1bcdwb/formoutput = ls_formoutput
      EXCEPTIONS
        usage_error        = 1
        system_error       = 2
        internal_error     = 3
        OTHERS             = 4.
    IF sy-subrc = 0.
*      rv_return = ls_formoutput-pdf.

      APPEND VALUE #(  id         = '00'
                       number     = '001'
                       type       = 'S'
                       message_v1 = |{ TEXT-001 }| & || & |{ lv_salesorder }| ) TO rt_mensagens.
    ELSE.
      APPEND VALUE #( id         = '00'
                      number     = '001'
                      type       = 'E'
                      message_v1 = |{ TEXT-002 }| & || & |{ lv_salesorder }| ) TO rt_mensagens.
    ENDIF.
  ENDMETHOD.


  METHOD nome_funcao_form_coleta_avaria.
    CONSTANTS:
      lc_formname TYPE fpname VALUE 'ZAFSD_FORM_COLETA_AVARIA'.
    TRY.
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = lc_formname
          IMPORTING
            e_funcname = rv_return.
      CATCH cx_fp_api_repository.
      CATCH cx_fp_api_usage.
      CATCH cx_fp_api_internal.
    ENDTRY.
  ENDMETHOD.


  METHOD form_job_open.

    DATA: lv_printer TYPE rspopname.

    DATA(lo_object) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_object->m_get_single( EXPORTING iv_modulo = gc_param-modulo
                                           iv_chave1 = gc_param-chave1
                                           iv_chave2 = gc_param-chave2
                                 IMPORTING ev_param  = lv_printer ).
      CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros
    ENDTRY.

    IF lv_printer IS INITIAL.
      lv_printer = gc_printer.
    ENDIF.

* LSCHEPP - Chamado 8000004273 - 28.12.2022 Início
*    DATA(ls_outputparams) = VALUE sfpoutputparams( device     = 'PRINTER'
*                                                   nodialog   = 'X'
*                                                   connection = 'ADS'
*                                                   dest       = lv_printer
*                                                   reqnew     = abap_true ).

    DATA(ls_outputparams) = VALUE sfpoutputparams( device     = 'PRINTER'
                                                   nodialog   = abap_true
                                                   connection = 'ADS'
                                                   dest       = lv_printer
                                                   reqnew     = abap_true
                                                   reqimm     = abap_true
                                                   nopdf      = abap_true
                                                   nopreview  = abap_true ).
* LSCHEPP - Chamado 8000004273 - 28.12.2022 Fim

    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = ls_outputparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.

    IF sy-subrc = 0.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD form_job_close.
    DATA:
      ls_joboutput TYPE sfpjoboutput.

    CALL FUNCTION 'FP_JOB_CLOSE'
      IMPORTING
        e_result       = ls_joboutput
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.
    IF sy-subrc = 0.
      RETURN.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
