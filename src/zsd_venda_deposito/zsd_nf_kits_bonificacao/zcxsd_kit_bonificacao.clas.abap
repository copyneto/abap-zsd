CLASS zcxsd_kit_bonificacao DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_abap_behv_message .
    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .

    data:
            gv_param TYPE ztca_param_val-chave1.

    CONSTANTS:
      BEGIN OF gc_erro_linha_sel,
        msgid TYPE symsgid VALUE 'ZSD_KIT_BONIFICACAO',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_erro_linha_sel,

      BEGIN OF gc_erro_ordem_sel,
        msgid TYPE symsgid VALUE 'ZSD_KIT_BONIFICACAO',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_erro_ordem_sel,

       BEGIN OF gc_linhas_removidas,
        msgid TYPE symsgid VALUE 'ZSD_KIT_BONIFICACAO',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_linhas_removidas,

      BEGIN OF gc_linhas_marcadas,
        msgid TYPE symsgid VALUE 'ZSD_KIT_BONIFICACAO',
        msgno TYPE symsgno VALUE '007',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_linhas_marcadas,

      BEGIN OF gc_linhas_erro_order,
        msgid TYPE symsgid VALUE 'ZSD_KIT_BONIFICACAO',
        msgno TYPE symsgno VALUE '008',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_linhas_erro_order,

      BEGIN OF gc_linhas_order_criada,
        msgid TYPE symsgid VALUE 'ZSD_KIT_BONIFICACAO',
        msgno TYPE symsgno VALUE '009',
        attr1 TYPE scx_attrname VALUE 'GV_PARAM',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_linhas_order_criada.

    METHODS constructor
      IMPORTING
        iv_severity  TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
        !iv_textid   LIKE if_t100_message=>t100key OPTIONAL
        !iv_previous LIKE previous OPTIONAL
        IV_PARAM  TYPE ztca_param_val-chave1 OPTIONAL.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.

CLASS zcxsd_kit_bonificacao IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.

    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = iv_textid.
    ENDIF.

    me->if_abap_behv_message~m_severity = iv_severity.

  ENDMETHOD.

ENDCLASS.
