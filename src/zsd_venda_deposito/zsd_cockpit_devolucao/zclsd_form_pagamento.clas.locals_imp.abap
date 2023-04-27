CLASS lhc_notafiscal DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR notafiscal RESULT result.

    "! Verificaçao do meio de pagamento
    METHODS dadosbancarios FOR VALIDATE ON SAVE
      IMPORTING keys FOR notafiscal~dadosbancarios.

    "! Verificaçao de documento anexado
    METHODS verificaanexo FOR VALIDATE ON SAVE
      IMPORTING keys FOR notafiscal~verificaanexo.

    "! Confirmaçao de Dados Bancarios
    METHODS confirmadadosbancarios FOR MODIFY
      IMPORTING keys FOR ACTION notafiscal~confirmadadosbancarios RESULT result.


ENDCLASS.

CLASS lhc_notafiscal IMPLEMENTATION.

  METHOD dadosbancarios.
* *------------------------------------------------------------------
* *Recupera informações e verifica meio de pagamento
* *------------------------------------------------------------------
    READ ENTITIES OF zi_sd_cockpit_devolucao IN LOCAL MODE
    ENTITY notafiscal ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_fpagamento).

    TRY.
        DATA(ls_fp) = lt_fpagamento[ 1 ].
      CATCH cx_root.
    ENDTRY.

    IF ls_fp-formpagamento IS INITIAL.
      APPEND VALUE #( %msg     = new_message(
                  id       = 'ZSD_COCKPIT_DEVOL'
                  number   = '016'
                  severity = CONV #( 'E' ) ) ) TO reported-notafiscal.
    ENDIF.

    LOOP AT lt_fpagamento INTO DATA(ls_fpagamento). "#EC CI_LOOP_INTO_WA
      IF ls_fpagamento-formpagamento = 'X' AND ls_fpagamento-flagdadosbancarios IS INITIAL.
        APPEND VALUE #(  %key = ls_fpagamento-%key ) TO failed-notafiscal.
        APPEND VALUE #(  %key = ls_fpagamento-%key
                         %msg      = new_message( id       = 'ZSD_COCKPIT_DEVOL'
                                                  number   = '007'
                                                  severity = if_abap_behv_message=>severity-error )
                          %element-flagdadosbancarios  = if_abap_behv=>mk-on ) TO reported-notafiscal.
      ENDIF.
    ENDLOOP.


  ENDMETHOD.

  METHOD confirmadadosbancarios.


    READ ENTITIES OF zi_sd_cockpit_devolucao IN LOCAL MODE
    ENTITY cockpit BY \_notafiscal FIELDS ( formpagamento  confirmadadosbancarios )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_fpagamento)
    FAILED failed.


    LOOP AT lt_fpagamento ASSIGNING FIELD-SYMBOL(<fs_fpagamento>).
      IF <fs_fpagamento>-formpagamento = 'X'.
        <fs_fpagamento>-confirmadadosbancarios = 'X'.

        MODIFY ENTITIES OF zi_sd_cockpit_devolucao IN LOCAL MODE ENTITY notafiscal
             UPDATE FIELDS (
                            confirmadadosbancarios )

             WITH VALUE #( ( %key = <fs_fpagamento>-%key
                             confirmadadosbancarios = <fs_fpagamento>-confirmadadosbancarios ) )
             REPORTED DATA(lt_reported)
             FAILED DATA(lt_failed).

      ENDIF.
    ENDLOOP.

    READ ENTITIES OF zi_sd_cockpit_devolucao IN LOCAL MODE
   ENTITY notafiscal FIELDS ( formpagamento  confirmadadosbancarios )
   WITH CORRESPONDING #( keys )
   RESULT DATA(lt_fpag)
   FAILED failed.

    result = VALUE #( FOR ls_fpag IN lt_fpag
                      ( %tky   = ls_fpag-%tky
                       ) ).



  ENDMETHOD.

  METHOD verificaanexo.

** *------------------------------------------------------------------
** *Recupera informações e verifica se foi anexado um documento
** *------------------------------------------------------------------
    READ ENTITIES OF zi_sd_cockpit_devolucao IN LOCAL MODE
    ENTITY notafiscal ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_fpagamento).

    TRY.
        DATA(ls_fpagamento) = lt_fpagamento[ 1 ].
      CATCH cx_root.
    ENDTRY.

    IF NOT ls_fpagamento-guid IS INITIAL.
      SELECT COUNT( * )
      FROM ztsd_anexo_dev
      WHERE guid = ls_fpagamento-guid.
      IF sy-subrc NE 0.
        APPEND VALUE #( %msg     = new_message(
                        id       = 'ZSD_COCKPIT_DEVOL'
                        number   = '015'
                        severity = CONV #( 'E' ) ) ) TO reported-notafiscal.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD get_features.

    RETURN.

  ENDMETHOD.

ENDCLASS.
