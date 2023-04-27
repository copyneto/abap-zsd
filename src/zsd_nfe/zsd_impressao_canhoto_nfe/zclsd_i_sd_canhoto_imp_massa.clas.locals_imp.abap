CLASS lcl_CanhotoNF DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

*    METHODS lock FOR LOCK
*      IMPORTING keys FOR LOCK CanhotoNF.

    METHODS read FOR READ
      IMPORTING keys FOR READ CanhotoNF RESULT result.

    METHODS imprimir FOR MODIFY
      IMPORTING keys FOR ACTION CanhotoNF~imprimir.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR CanhotoNF RESULT result.

ENDCLASS.

CLASS lcl_CanhotoNF IMPLEMENTATION.

*  METHOD lock.
*  ENDMETHOD.

  METHOD read.
    IF keys IS NOT INITIAL.
      SELECT * "#EC CI_ALL_FIELDS_NEEDED
            FROM zi_sd_canhoto_imp_massa
            FOR ALL ENTRIES IN @keys
            WHERE docnum   = @keys-docnum
              INTO TABLE @DATA(lt_canhoto).
    ENDIF.

    result = CORRESPONDING #( lt_canhoto ).

  ENDMETHOD.

  METHOD imprimir.

    DATA: lt_return_all TYPE bapiret2_t,
          lS_CANHOTO    TYPE zssd_canhoto.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_sd_canhoto_imp_massa IN LOCAL MODE ENTITY CanhotoNF
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_CanhotosNF)
      FAILED failed.

    CHECK lt_CanhotosNF IS NOT INITIAL.

    lS_CANHOTO-printer      = keys[ 1 ]-%param.
    lS_CANHOTO-canhoto_nf[] =  VALUE #( FOR ls_canhotoNf IN lt_CanhotosNF ( series = ls_canhotoNf-series
                                                                            TorId = ls_canhotoNf-torid
                                                                            bukrs  = ls_canhotoNf-bukrs
                                                                            nfenum = ls_canhotoNf-Nfenum
                                                                            parid = ls_canhotoNf-parid
                                                                            name1 = ls_canhotoNf-Name1
                                                                            lifnr = ls_canhotoNf-BR_NFPartner
                                                                            tpag  = ls_canhotoNf-TPag
                                                                            tpagt = ls_canhotoNf-TPagText
                                                                            nfTot = ls_canhotoNf-nftot
                                                                            auart = ls_canhotoNf-auart
                                                                            bstkd = ls_canhotoNf-OriginReferenceDocument
                                                                            pedcli = ls_canhotoNf-PedidoCliente
                                                                          ) ).

* ---------------------------------------------------------------------------
* Imprime Canhotos
* ---------------------------------------------------------------------------
    DATA(lo_impressao) = NEW zclsd_canhoto_mass_imp( ).

    lo_impressao->imprime_canhoto_nfe(
      EXPORTING
        is_canhoto = ls_canhoto
      IMPORTING
        et_return  = DATA(lt_return)
    ).

    INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].

* ---------------------------------------------------------------------------
*Retorna mensagens de erro
* ---------------------------------------------------------------------------
    LOOP AT lt_return_all INTO DATA(ls_return_all).

      APPEND VALUE #( %msg = new_message( id       = ls_return_all-id
                                          number   = ls_return_all-number
                                          v1       = ls_return_all-message_v1
                                          v2       = ls_return_all-message_v2
                                          v3       = ls_return_all-message_v3
                                          v4       = ls_return_all-message_v4
                                          severity = CONV #( ls_return_all-type ) )
                       )
        TO reported-canhotonf.


    ENDLOOP.

  ENDMETHOD.

  METHOD get_features.

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    result = VALUE #( FOR ls_keys IN keys
                      ( %tky             = ls_keys-%tky
                        %action-imprimir = if_abap_behv=>fc-o-enabled
                      ) ).

  ENDMETHOD.

ENDCLASS.


CLASS lcl_zi_sd_canhoto_imp_massa DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_zi_sd_canhoto_imp_massa IMPLEMENTATION.

  METHOD check_before_save.
    RETURN.
  ENDMETHOD.

  METHOD finalize.
    RETURN.
  ENDMETHOD.

  METHOD save.
    RETURN.
  ENDMETHOD.

ENDCLASS.
