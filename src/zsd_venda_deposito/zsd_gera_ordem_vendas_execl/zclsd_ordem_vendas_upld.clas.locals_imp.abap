CLASS lcl_sd_ordem_vendas_upld DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    TYPES: BEGIN OF ty_header,
             salesdocumenttype   TYPE auart,
             salesorganization   TYPE vkorg,
             distributionchannel TYPE vtweg,
             sddocumentreason    TYPE augru,
           END OF ty_header.

    DATA gs_header TYPE ty_header.

    "! Mensagem retorno
    DATA gt_return TYPE  bapiret2_tab.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE createsalesorder.
*
    METHODS read FOR READ
      IMPORTING keys FOR READ createsalesorder RESULT result.

ENDCLASS.

CLASS lcl_sd_ordem_vendas_upld IMPLEMENTATION.

  METHOD create.

    "//AuthorityCreate.
    DATA(ls_entities) = entities[ 1 ].

    IF zclsd_auth_zsdvkorg=>vkorg_create( ls_entities-SalesOrganization ) EQ abap_false.

      APPEND VALUE #(  %msg        = NEW zcxca_authority_check(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = zcxca_authority_check=>gc_create )
                      %element-SalesOrganization = if_abap_behv=>mk-on )
        TO reported-createsalesorder.

      RETURN.

    ENDIF.

*    DELETE FROM ztsd_logmsg_ov WHERE message IS NOT INITIAL.

    SELECT * FROM ztsd_arq_ordvend INTO TABLE @DATA(lt_arquivo)
      WHERE numclient NE @space
        AND created_by = @sy-uname.

    IF NOT lt_arquivo IS INITIAL.

      SORT lt_arquivo BY numclient refclient.

      READ TABLE entities ASSIGNING FIELD-SYMBOL(<fs_entity>) INDEX 1.
      CHECK sy-subrc = 0.

      IF  <fs_entity>-sddocumentreason IS NOT INITIAL.
        SELECT SINGLE modulo, chave1, chave2, low  FROM ztca_param_val INTO @DATA(ls_param) WHERE modulo = 'SD'
                                                              AND chave1 =  @<fs_entity>-salesdocumenttype.
        IF ls_param IS INITIAL.
          SELECT SINGLE modulo, chave1, chave2 FROM ztca_param_par INTO @DATA(ls_param_par) WHERE modulo = 'SD'
                                                     AND chave1 =  @<fs_entity>-salesdocumenttype.
        ENDIF.
        IF sy-subrc IS INITIAL.
          IF ls_param-chave2 = 'X'.
            gs_header-salesdocumenttype   =  <fs_entity>-salesdocumenttype.
            gs_header-salesorganization   =  <fs_entity>-salesorganization.
            gs_header-distributionchannel =  <fs_entity>-distributionchannel.
            gs_header-sddocumentreason    =  <fs_entity>-sddocumentreason.

            DATA(lo_gera_ordem_vendas) = NEW zclsd_gera_ordem_vendas_upld(  ).
            lo_gera_ordem_vendas->main( EXPORTING is_header = gs_header
                                                  it_file   = lt_arquivo
                                        IMPORTING et_return = gt_return ).

            SORT gt_return BY type.
            READ TABLE gt_return ASSIGNING FIELD-SYMBOL(<fs_mensagem>) WITH KEY type = 'E' BINARY SEARCH.
            IF sy-subrc = 0.
              APPEND VALUE #(
          %msg        = new_message(
              id       = <fs_mensagem>-id
              number   = <fs_mensagem>-number
              severity = CONV #( <fs_mensagem>-type )
              v1       = <fs_mensagem>-message_v1
              v2       = <fs_mensagem>-message_v2
              v3       = <fs_mensagem>-message_v3
              v4       = <fs_mensagem>-message_v4 ) ) TO reported-createsalesorder.

            ENDIF.

          ELSE.

            APPEND VALUE #(
*                        %tky       = <fs_entity>-%tky
                            %msg       = new_message(
                              id       = 'ZSD_ARQ_EXCEL'
                              number   = '001'
                              severity = CONV #( 'E' ) ) ) TO reported-createsalesorder.

          ENDIF.

        ELSE.

          APPEND VALUE #(
*                        %tky       = <fs_entity>-%tky
                          %msg       = new_message(
                            id       = 'ZSD_ARQ_EXCEL'
                            number   = '004'
                            severity = CONV #( 'E' ) ) ) TO reported-createsalesorder.

        ENDIF.

      ELSE.

        SELECT SINGLE modulo, chave1, chave2, low
           FROM ztca_param_val INTO @ls_param WHERE modulo = 'SD'
                                              AND chave1 =  @<fs_entity>-salesdocumenttype.

        IF ls_param IS INITIAL.
          SELECT SINGLE modulo chave1 chave2 FROM ztca_param_par INTO ls_param_par WHERE modulo = 'SD'
                                                     AND chave1 =  <fs_entity>-salesdocumenttype.
        ENDIF.

        IF sy-subrc IS INITIAL.
          IF ls_param-chave2 = ''.
            gs_header-salesdocumenttype   =  <fs_entity>-salesdocumenttype.
            gs_header-salesorganization   =  <fs_entity>-salesorganization.
            gs_header-distributionchannel =  <fs_entity>-distributionchannel.
            gs_header-sddocumentreason    =  <fs_entity>-sddocumentreason.

            lo_gera_ordem_vendas = NEW zclsd_gera_ordem_vendas_upld(  ).
            lo_gera_ordem_vendas->main(
              EXPORTING
                is_header = gs_header
                it_file   = lt_arquivo
              IMPORTING
                et_return = DATA(lt_retorno_ov)
            ).
*            ( is_header = gs_header it_file = lt_arquivo  ).
*            DATA(lt_retorno_ov) = lo_gera_ordem_vendas->main( is_header = gs_header it_file = lt_arquivo  ).



            LOOP AT lt_retorno_ov ASSIGNING <fs_mensagem>.
              IF <fs_mensagem>-type = 'S' AND
                 <fs_mensagem>-id = 'V1' AND
                 <fs_mensagem>-number = '311'.
                APPEND VALUE #(
                  %msg        = new_message(
                    id       = <fs_mensagem>-id
                    number   = <fs_mensagem>-number
                    severity = CONV #( <fs_mensagem>-type )
                    v1       = <fs_mensagem>-message_v1
                    v2       = <fs_mensagem>-message_v2
                    v3       = <fs_mensagem>-message_v3
                    v4       = <fs_mensagem>-message_v4 ) ) TO reported-createsalesorder.
              ENDIF.
            ENDLOOP.

            SORT lt_retorno_ov BY type.
            READ TABLE lt_retorno_ov ASSIGNING <fs_mensagem> WITH KEY type = 'E' BINARY SEARCH.
            IF sy-subrc = 0.
              APPEND VALUE #(
                %msg        = new_message(
                  id       = <fs_mensagem>-id
                  number   = <fs_mensagem>-number
                  severity = CONV #( <fs_mensagem>-type )
                  v1       = <fs_mensagem>-message_v1
                  v2       = <fs_mensagem>-message_v2
                  v3       = <fs_mensagem>-message_v3
                  v4       = <fs_mensagem>-message_v4 ) ) TO reported-createsalesorder.
            ENDIF.

*            reported-createsalesorder = VALUE #(
*              FOR ls_retorno_ov IN lt_retorno_ov WHERE ( type = 'E' OR type = 'S' )
*                (
*                 "%tky = VALUE #( salesorder = ls_key-salesorder salesorderitem = ls_key-salesorderitem )
*                  %msg        =
*                  new_message(
*                    id       = ls_retorno_ov-id
*                    number   = ls_retorno_ov-number
*                    severity = CONV #( ls_retorno_ov-type )
*                    v1       = ls_retorno_ov-message_v1
*                    v2       = ls_retorno_ov-message_v2
*                    v3       = ls_retorno_ov-message_v3
*                    v4       = ls_retorno_ov-message_v4 )
*            ) ).
          ELSE.

            APPEND VALUE #(
*                        %tky       = <fs_entity>-%tky
                            %msg       = new_message(
                              id       = 'ZSD_ARQ_EXCEL'
                              number   = '001'
                              severity = CONV #( 'E' ) ) ) TO reported-createsalesorder.

          ENDIF.

        ELSE.

          APPEND VALUE #(
*                        %tky       = <fs_entity>-%tky
                          %msg       = new_message(
                            id       = 'ZSD_ARQ_EXCEL'
                            number   = '004'
                            severity = CONV #( 'E' ) ) ) TO reported-createsalesorder.

        ENDIF.

      ENDIF.



    ELSE.
      APPEND VALUE #(
*                        %tky       = <fs_entity>-%tky
                      %msg       = new_message(
                        id       = 'ZSD_ARQ_EXCEL'
                        number   = '002'
                        severity = CONV #( 'E' ) ) ) TO reported-createsalesorder.
    ENDIF.

  ENDMETHOD.

  METHOD read.
    RETURN.
  ENDMETHOD.


ENDCLASS.

CLASS lcl_ordem_vendas_upld_saver DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

*    METHODS check_before_save REDEFINITION.

*    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

    DATA gt_arquivo TYPE TABLE OF ztsd_arq_ordvend.

ENDCLASS.

CLASS lcl_ordem_vendas_upld_saver IMPLEMENTATION.

*  METHOD check_before_save.
*  ENDMETHOD.

*  METHOD finalize.
*
*  ENDMETHOD.

  METHOD save.
    DELETE FROM ztsd_arq_ordvend WHERE numclient IS NOT INITIAL.
  ENDMETHOD.

ENDCLASS.
