class ZCXSD_NFCE_SSRESTO definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

public section.

  interfaces IF_T100_DYN_MSG .
  interfaces IF_T100_MESSAGE .

  constants:
    begin of ZCXSD_NFCE_SSRESTO,
      msgid type symsgid value 'ZSD_NFCE_SSRESTO',
      msgno type symsgno value '000',
      attr1 type scx_attrname value 'GV_MSGV1',
      attr2 type scx_attrname value 'GV_MSGV2',
      attr3 type scx_attrname value 'GV_MSGV3',
      attr4 type scx_attrname value 'GV_MSGV4',
    end of ZCXSD_NFCE_SSRESTO .
  constants:
    begin of SALES_ORDER_CREATE_ERRO,
      msgid type symsgid value 'ZSD_NFCE_SSRESTO',
      msgno type symsgno value '001',
      attr1 type scx_attrname value 'GV_MSGV1',
      attr2 type scx_attrname value 'GV_MSGV2',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of SALES_ORDER_CREATE_ERRO .
  constants:
    begin of PARAMETER_NOT_FOUND,
      msgid type symsgid value 'ZSD_NFCE_SSRESTO',
      msgno type symsgno value '002',
      attr1 type scx_attrname value 'GV_MSGV1',
      attr2 type scx_attrname value 'GV_MSGV2',
      attr3 type scx_attrname value 'GV_MSGV3',
      attr4 type scx_attrname value 'GV_MSGV4',
    end of PARAMETER_NOT_FOUND .
  constants:
    begin of ERRO_SAVE_TB_DB,
      msgid type symsgid value 'ZSD_NFCE_SSRESTO',
      msgno type symsgno value '003',
      attr1 type scx_attrname value 'GV_MSGV1',
      attr2 type scx_attrname value 'GV_MSGV2',
      attr3 type scx_attrname value 'GV_MSGV3',
      attr4 type scx_attrname value '',
    end of ERRO_SAVE_TB_DB .
  constants:
    begin of CUPOM_SEM_FORM_PG,
      msgid type symsgid value 'ZSD_NFCE_SSRESTO',
      msgno type symsgno value '004',
      attr1 type scx_attrname value 'GV_MSGV1',
      attr2 type scx_attrname value 'GV_MSGV2',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of CUPOM_SEM_FORM_PG .
  constants:
    begin of CUPOM_SEM_ITEM,
      msgid type symsgid value 'ZSD_NFCE_SSRESTO',
      msgno type symsgno value '005',
      attr1 type scx_attrname value 'GV_MSGV1',
      attr2 type scx_attrname value 'GV_MSGV2',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of CUPOM_SEM_ITEM .
  constants:
    begin of CUPOM_JA_REGISTRADO,
      msgid type symsgid value 'ZSD_NFCE_SSRESTO',
      msgno type symsgno value '006',
      attr1 type scx_attrname value 'GV_MSGV1',
      attr2 type scx_attrname value 'GV_MSGV2',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of CUPOM_JA_REGISTRADO .
  constants:
    begin of CUPOM_SEM_CENTRO,
      msgid type symsgid value 'ZSD_NFCE_SSRESTO',
      msgno type symsgno value '007',
      attr1 type scx_attrname value 'GV_MSGV1',
      attr2 type scx_attrname value 'GV_MSGV2',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of CUPOM_SEM_CENTRO .
  constants:
    begin of STATUS_NAO_PREVISTO,
      msgid type symsgid value 'ZSD_NFCE_SSRESTO',
      msgno type symsgno value '008',
      attr1 type scx_attrname value 'GV_MSGV1',
      attr2 type scx_attrname value 'GV_MSGV2',
      attr3 type scx_attrname value 'GV_MSGV3',
      attr4 type scx_attrname value '',
    end of STATUS_NAO_PREVISTO .
  data GV_MSGV1 type MSGV1 .
  data GV_MSGV2 type MSGV2 .
  data GV_MSGV3 type MSGV3 .
  data GV_MSGV4 type MSGV4 .
  data GT_BAPIRET2 type BAPIRET2_TAB .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !GV_MSGV1 type MSGV1 optional
      !GV_MSGV2 type MSGV2 optional
      !GV_MSGV3 type MSGV3 optional
      !GV_MSGV4 type MSGV4 optional
      !GT_BAPIRET2 type BAPIRET2_TAB optional .
  methods GET_BAPIRETRETURN
    importing
      !IV_INTERNAL_MESSAGES type ABAP_BOOL optional
    returning
      value(RT_BAPIRET2) type BAPIRET2_TAB .
protected section.
private section.
ENDCLASS.



CLASS ZCXSD_NFCE_SSRESTO IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->GV_MSGV1 = GV_MSGV1 .
me->GV_MSGV2 = GV_MSGV2 .
me->GV_MSGV3 = GV_MSGV3 .
me->GV_MSGV4 = GV_MSGV4 .
me->GT_BAPIRET2 = GT_BAPIRET2 .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = ZCXSD_NFCE_SSRESTO .
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.


  METHOD get_bapiretreturn.

*    IF iv_internal_messages = abap_true.
    IF gv_msgv1 IS NOT INITIAL OR gv_msgv2 IS NOT INITIAL.
      APPEND INITIAL LINE TO rt_bapiret2 ASSIGNING FIELD-SYMBOL(<fs_s_bapiret2>).

      <fs_s_bapiret2>-id         = if_t100_message~t100key-msgid.
      <fs_s_bapiret2>-number     = if_t100_message~t100key-msgno.
      <fs_s_bapiret2>-type       = 'E'.
      <fs_s_bapiret2>-message_v1 = gv_msgv1.
      <fs_s_bapiret2>-message_v2 = gv_msgv2.
      <fs_s_bapiret2>-message_v3 = gv_msgv3.
      <fs_s_bapiret2>-message_v4 = gv_msgv4.
    ENDIF.

    LOOP AT gt_bapiret2 ASSIGNING FIELD-SYMBOL(<fs_bapiret2>).
      APPEND INITIAL LINE TO rt_bapiret2 ASSIGNING <fs_s_bapiret2>.

      MOVE-CORRESPONDING <fs_bapiret2> TO <fs_s_bapiret2>.
    ENDLOOP.


  ENDMETHOD.
ENDCLASS.
