 "!<p><h2>Classe para Processar interface de Campanha</h2></p>
 "!<p><strong>Autor:</strong>Heitor Alves</p>
 "!<p><strong>Data:</strong>23 de dez de 2021</p>
 CLASS zclsd_processar_campanha DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

   PUBLIC SECTION.
     METHODS:

       "! Processa Campanha
       "! @parameter is_input | Estrutura com campos para inclusão/alteração na tabela ztsd_sint_proces
       processar_campanha
         IMPORTING
           !is_input TYPE zclsd_mt_processar_campanha
         RAISING
           zcxca_erro_interface,


       "! Reprocessa Campanha
       "! @parameter it_input | Tabela com campos para inclusão/alteração na tabela ztsd_sint_proces
       reprocessar_campanha
         IMPORTING
           !it_input TYPE zclsd_mt_dados_reprocessar
         RAISING
           zcxca_erro_interface.



   PROTECTED SECTION.
   PRIVATE SECTION.

     CONSTANTS: BEGIN OF gc_erros,
                  tabela TYPE string VALUE 'ZTSD_IONZ'                  ##NO_TEXT,
                  metodo TYPE string VALUE 'reprocessar_campanha'       ##NO_TEXT,
                  classe TYPE string VALUE 'ZCLSD_PROCESSAR_CAMPANHA'   ##NO_TEXT,
                END OF gc_erros.
     METHODS:

       "! Return error raising
       error_raise
         IMPORTING
           is_ret TYPE scx_t100key
         RAISING
           zcxca_erro_interface.

 ENDCLASS.


 CLASS zclsd_processar_campanha IMPLEMENTATION.

   METHOD error_raise.
     RAISE EXCEPTION TYPE zcxca_erro_interface
       EXPORTING
         textid = VALUE #(
                           attr1 = is_ret-attr1
                           attr2 = is_ret-attr2
                           attr3 = is_ret-attr3
                           msgid = is_ret-msgid
                           msgno = is_ret-msgno
                           ).
   ENDMETHOD.

   METHOD reprocessar_campanha.

*    Tabelas
     DATA: lt_ionz TYPE TABLE OF ztsd_sint_proces.

     TRY.

         LOOP AT it_input-mt_dados_reprocessar-list-item ASSIGNING FIELD-SYMBOL(<fs_item>).

           APPEND INITIAL LINE TO lt_ionz ASSIGNING FIELD-SYMBOL(<fs_ionz>).

           <fs_ionz>-bairro = <fs_item>-bairro.
           <fs_ionz>-cep = <fs_item>-cep.
           <fs_ionz>-cidade = <fs_item>-cidade.
           <fs_ionz>-codigo = <fs_item>-codigo.
           <fs_ionz>-complemento = <fs_item>-complem.
           <fs_ionz>-cpf = <fs_item>-cpf.
           <fs_ionz>-ddd = <fs_item>-ddd.
           <fs_ionz>-dt_compra = <fs_item>-dt_compra.
           <fs_ionz>-email = <fs_item>-email.
           <fs_ionz>-endereco = <fs_item>-endereco.
           <fs_ionz>-end_loja = <fs_item>-end_loja.
           <fs_ionz>-estado = <fs_item>-estado.
           <fs_ionz>-id = <fs_item>-id.
           <fs_ionz>-local_compra = <fs_item>-local_compra.
           <fs_ionz>-mandt = <fs_item>-mandt.
           <fs_ionz>-nome = <fs_item>-nome.
           <fs_ionz>-numero = <fs_item>-numero.
           <fs_ionz>-nr_serie = <fs_item>-nr_serie.
           <fs_ionz>-promocao = <fs_item>-promocao.
           <fs_ionz>-referencia = <fs_item>-referencia.
           <fs_ionz>-telefone = <fs_item>-telef.

         ENDLOOP.

         MODIFY ztsd_sint_proces FROM TABLE lt_ionz.

       CATCH cx_ai_system_fault.
         me->error_raise( is_ret = VALUE scx_t100key(  attr1 = gc_erros-classe attr2 = gc_erros-tabela attr3 = gc_erros-metodo ) ).
     ENDTRY.

   ENDMETHOD.

   METHOD processar_campanha.
*    Estruturas
     DATA: ls_ionz TYPE ztsd_sint_proces.

     TRY.
         ls_ionz-bairro         = is_input-mt_processar_campanha-zionz-bairro.
         ls_ionz-cep            = is_input-mt_processar_campanha-zionz-cep.
         ls_ionz-cidade         = is_input-mt_processar_campanha-zionz-cidade.
         ls_ionz-codigo         = is_input-mt_processar_campanha-zionz-codigo.
         ls_ionz-complemento    = is_input-mt_processar_campanha-zionz-complem.
         ls_ionz-cpf            = is_input-mt_processar_campanha-zionz-cpf.
         ls_ionz-ddd            = is_input-mt_processar_campanha-zionz-ddd.
         ls_ionz-dt_compra      = is_input-mt_processar_campanha-zionz-dt_compra.
         ls_ionz-email          = is_input-mt_processar_campanha-zionz-email.
         ls_ionz-endereco       = is_input-mt_processar_campanha-zionz-endereco.
         ls_ionz-end_loja       = is_input-mt_processar_campanha-zionz-end_loja.
         ls_ionz-estado         = is_input-mt_processar_campanha-zionz-estado.
         ls_ionz-id             = is_input-mt_processar_campanha-zionz-id.
         ls_ionz-local_compra   = is_input-mt_processar_campanha-zionz-local_compra.
         ls_ionz-mandt          = is_input-mt_processar_campanha-zionz-mandt.
         ls_ionz-nome           = is_input-mt_processar_campanha-zionz-nome.
         ls_ionz-numero         = is_input-mt_processar_campanha-zionz-numero.
         ls_ionz-nr_serie       = is_input-mt_processar_campanha-zionz-nr_serie.
         ls_ionz-promocao       = is_input-mt_processar_campanha-zionz-promocao.
         ls_ionz-referencia     = is_input-mt_processar_campanha-zionz-referencia.
         ls_ionz-telefone       = is_input-mt_processar_campanha-zionz-telef.

         MODIFY ztsd_sint_proces FROM ls_ionz.

       CATCH cx_ai_system_fault.
         me->error_raise( is_ret = VALUE scx_t100key(  attr1 = gc_erros-classe attr2 = gc_erros-tabela attr3 = gc_erros-metodo ) ).
     ENDTRY.

   ENDMETHOD.

 ENDCLASS.
