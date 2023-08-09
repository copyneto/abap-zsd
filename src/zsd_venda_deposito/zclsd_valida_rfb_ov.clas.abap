"! <p class="shorttext synchronized">Classe para Validação de Produtos RFB na OV</p>
"! Autor: Jefferson Fujii
"! <br>Data: 09/08/2021
"!
CLASS zclsd_valida_rfb_ov DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    "! <p class="shorttext synchronized">Método estático para Validação de Catálogo RFB</p>
    "! @parameter is_vbak   | <p class="shorttext synchronized">Cabeçalho da OV</p>
    "! @parameter it_xvbap  | <p class="shorttext synchronized">Itens da OV</p>
    "! @parameter rv_result | <p class="shorttext synchronized">Flag resultado para abort do processo</p>
    CLASS-METHODS check IMPORTING is_vbak          TYPE vbak
                                  it_xvbap         TYPE tab_xyvbap
                        RETURNING VALUE(rv_result) TYPE flag.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS:
      "! <p class="shorttext synchronized">Cconstante Erro</p>
      gc_erro TYPE msgty VALUE 'E',
      "! <p class="shorttext synchronized">Cconstantes de Status</p>
      BEGIN OF gc_status,
        ativado    TYPE ze_status_rfb VALUE 'A',
        desativado TYPE ze_status_rfb VALUE 'D',
        rascunho   TYPE ze_status_rfb VALUE 'R',
      END OF gc_status,
      "! <p class="shorttext synchronized">Cconstantes da tabela de Parâmetros</p>
      BEGIN OF gc_param,
        modulo  TYPE ztca_param_par-modulo VALUE 'MM',
        key1    TYPE ztca_param_par-chave1 VALUE 'CATALOGO_PRODUTO_RFB',
        key2    TYPE ztca_param_par-chave2 VALUE 'ORDEM_VENDAS',
        vtweg   TYPE ztca_param_par-chave3 VALUE 'VTWEG',
        ativado TYPE ztca_param_par-chave3 VALUE 'ATIVADO',
      END OF gc_param.


    "! <p class="shorttext synchronized">Método para seleção de Catálogos RFB</p>
    "! @parameter it_vbap | <p class="shorttext synchronized">Itens da OV</p>
    "! @parameter rt_rfb  | <p class="shorttext synchronized">Catálogos RFB</p>
    CLASS-METHODS get_rfb IMPORTING it_vbap       TYPE tab_xyvbap
                          RETURNING VALUE(rt_rfb) TYPE zctgmm_catalogo_rfb.

    "! <p class="shorttext synchronized">Busca parâmetros</p>
    "! @parameter iv_key1  | <p class="shorttext synchronized">Parâmetro chave 1</p>
    "! @parameter iv_key2  | <p class="shorttext synchronized">Parâmetro chave 2</p>
    "! @parameter iv_key3  | <p class="shorttext synchronized">Parâmetro chave 3</p>
    "! @parameter et_range | <p class="shorttext synchronized">Parâmetro range</p>
    CLASS-METHODS get_param IMPORTING iv_key1  TYPE ztca_param_par-chave1
                                      iv_key2  TYPE ztca_param_par-chave2
                                      iv_key3  TYPE ztca_param_par-chave3
                            EXPORTING et_range TYPE ANY TABLE.
ENDCLASS.



CLASS ZCLSD_VALIDA_RFB_OV IMPLEMENTATION.


  METHOD check.

    RETURN.
    DATA: lr_vtweg   TYPE RANGE OF vtweg,
          lr_ativado TYPE RANGE OF xfeld.

    get_param( EXPORTING iv_key1  = gc_param-key1
                         iv_key2  = gc_param-key2
                         iv_key3  = gc_param-ativado
               IMPORTING et_range = lr_ativado ).

    IF abap_true NOT IN lr_ativado
    OR lr_ativado IS INITIAL.
      RETURN.
    ENDIF.

    get_param( EXPORTING iv_key1  = gc_param-key1
                         iv_key2  = gc_param-key2
                         iv_key3  = gc_param-vtweg
               IMPORTING et_range = lr_vtweg ).


    IF is_vbak-vtweg NOT IN lr_vtweg
    OR lr_vtweg IS INITIAL.
      RETURN.
    ENDIF.

    IF it_xvbap IS INITIAL.
      RETURN.
    ENDIF.

    DATA(lt_rfb) = get_rfb( it_xvbap ).

    LOOP AT it_xvbap ASSIGNING FIELD-SYMBOL(<fs_vbap>).
      CHECK <fs_vbap>-abgru IS INITIAL.

      READ TABLE lt_rfb INTO DATA(ls_rfb)
        WITH KEY material = <fs_vbap>-matnr BINARY SEARCH.
      IF ls_rfb IS INITIAL.
        MESSAGE s001 WITH <fs_vbap>-matnr DISPLAY LIKE gc_erro.
        rv_result = abap_true.
        EXIT.
      ENDIF.
      CLEAR ls_rfb.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_rfb.
    RETURN.

    IF it_vbap IS INITIAL.
      RETURN.
    ENDIF.

    SELECT idrfb,
           material,
           materialtype,
           supplier,
           status,
           datefrom,
           dateto
      FROM ztmm_catalogorfb
      INTO CORRESPONDING FIELDS OF TABLE @rt_rfb
      FOR ALL ENTRIES IN @it_vbap
      WHERE material EQ @it_vbap-matnr
        AND status   EQ @gc_status-ativado
        AND datefrom LE @sy-datum
        AND dateto   GE @sy-datum.
    SORT rt_rfb BY material.

  ENDMETHOD.


  METHOD get_param.

    FREE et_range.

    TRY.
        zclca_tabela_parametros=>get_instance( )->m_get_range( EXPORTING iv_modulo = gc_param-modulo " CHANGE - LSCHEPP - 24.07.2023
                                                                         iv_chave1 = iv_key1
                                                                         iv_chave2 = iv_key2
                                                                         iv_chave3 = iv_key3
                                                               IMPORTING et_range  = et_range ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
