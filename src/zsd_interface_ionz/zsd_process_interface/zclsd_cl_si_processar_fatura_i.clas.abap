CLASS zclsd_cl_si_processar_fatura_i DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zclsd_ii_si_processar_fatura_i .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclsd_cl_si_processar_fatura_i IMPLEMENTATION.


  METHOD zclsd_ii_si_processar_fatura_i~si_processar_fatura_in.

    DATA(ls_input) = input.

    LOOP AT ls_input-mt_fatura-nfs REFERENCE INTO DATA(ls_r_nfs).
      REPLACE ALL OCCURRENCES OF REGEX '[^0-9]' IN ls_r_nfs->docdat_nf WITH ''.
      CONDENSE ls_r_nfs->docdat_nf NO-GAPS.
    ENDLOOP.

    "Preenche estrutura da fatura para processamento
    DATA(ls_invoice) = VALUE zstm_gko_002( invoice_number     = ls_input-mt_fatura-xblnr
                                       invoice_issue_date     = ls_input-mt_fatura-docdat
                                       invoice_due_date       = ls_input-mt_fatura-dzfbdt
                                       cnpj_issue             = ls_input-mt_fatura-stcd1
                                       invoice_value          = ls_input-mt_fatura-netwr
                                       invoice_discount_value = ls_input-mt_fatura-netdis
                                       user_approval          = ls_input-mt_fatura-user_approv
                                       cte                    = VALUE zctgtm_gko001( FOR ls_cte IN ls_input-mt_fatura-cte
                                                                                     WHERE ( cteid IS NOT INITIAL )
                                                                                   ( CONV zstm_gko_003( ls_cte-cteid ) ) ) "Percorrendo tabelas de chaves CTE's
                                       nfs                    = VALUE zctgtm_gko002( FOR ls_nfs IN ls_input-mt_fatura-nfs
                                                                                     WHERE ( nfnum IS NOT INITIAL  )
                                                                                   ( issue_date   = ls_nfs-docdat_nf     "Percorrendo tabelas de NFS's
                                                                                     prefno       = ls_nfs-nfnum
                                                                                     series       = ls_nfs-series
                                                                                     stcd1_transp = ls_nfs-stcd1_transp ) ) ). "#EC CI_STDSEQ

    "Verifica se houve erro no processamento
    DATA(lo_invoice) = NEW zclfi_gko_incoming_invoice( ).

    lo_invoice->set_invoice( is_invoice = ls_invoice
                             iv_tpprocess = zcltm_gko_process=>gc_tpprocess-automatico ).

    lo_invoice->check_status( IMPORTING et_return = DATA(lt_return) ).

    "Lançar exceção para SXI_MONITOR
    IF lt_return IS NOT INITIAL.
      CALL METHOD cl_proxy_fault=>raise
        EXPORTING
          exception_class_name = 'ZCLSD_CX_FMT_FATURA'
          bapireturn_tab       = lt_return.
    ENDIF.

    lo_invoice->start( ).

    DATA(lt_errors) = lo_invoice->get_errors(  ).

*    DATA(lt_errors) = NEW zclfi_gko_incoming_invoice( )->set_invoice( is_invoice = ls_invoice
*                                                                      iv_tpprocess = zcltm_gko_process=>gc_tpprocess-automatico
*                                                                    )->start( )->get_errors(  ).
    CHECK lt_errors IS NOT INITIAL.

    TRY.
        lt_return = NEW zcxtm_gko_incoming_invoice( gt_errors = lt_errors )->get_bapi_return( ).
      CATCH cx_root INTO DATA(lo_root).
    ENDTRY.

    "Recupera Chave de acesso.
    SELECT acckey, num_fatura, emit_cnpj_cpf
        FROM zttm_gkot001
        INTO TABLE @DATA(lt_gkot001)
        WHERE num_fatura    = @ls_input-mt_fatura-xblnr
          AND emit_cnpj_cpf = @ls_input-mt_fatura-stcd1.

    IF sy-subrc NE 0.
      CLEAR lt_gkot001.
    ENDIF.

    " Atualiza status
    LOOP AT lt_gkot001 ASSIGNING FIELD-SYMBOL(<fs_gkot001>).
      TRY.
          DATA(lr_gko_process) = NEW zcltm_gko_process( iv_acckey       = <fs_gkot001>-acckey
                                                        iv_tpprocess    = zcltm_gko_process=>gc_tpprocess-automatico ).
          lr_gko_process->set_status( iv_status   = COND #( WHEN NOT line_exists( lt_return[ type = 'E' ] )
                                                            THEN zcltm_gko_process=>gc_codstatus-agrupamento_efetuado
                                                            WHEN sy-batch EQ abap_true
                                                            THEN zcltm_gko_process=>gc_codstatus-erro_agrupamento
                                                            ELSE zcltm_gko_process=>gc_codstatus-erro_agrupamento_manual )
                                      it_bapi_ret = lt_return ). "#EC CI_STDSEQ
          lr_gko_process->persist( ).
          lr_gko_process->free( ).
        CATCH cx_root.
      ENDTRY.
    ENDLOOP.

    "Lançar exceção para SXI_MONITOR
    IF lt_return IS NOT INITIAL.
      CALL METHOD cl_proxy_fault=>raise
        EXPORTING
          exception_class_name = 'ZCLSD_CX_FMT_FATURA'
          bapireturn_tab       = lt_return.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
