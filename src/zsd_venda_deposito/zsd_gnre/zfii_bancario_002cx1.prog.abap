*&---------------------------------------------------------------------*
*&  Include           ZFII_BANCARIO_002CX1
*&---------------------------------------------------------------------*

CLASS lcl_exceptions DEFINITION INHERITING FROM cx_static_check FINAL.

  PUBLIC SECTION.

    INTERFACES if_t100_message .

    DATA gv_msgv1 TYPE msgv1.
    DATA gv_msgv2 TYPE msgv2.
    DATA gv_msgv3 TYPE msgv3.
    DATA gv_msgv4 TYPE msgv4.
    DATA gv_type  TYPE bapi_mtype.

    CONSTANTS:
      BEGIN OF gc_generic_error,
        msgid TYPE symsgid VALUE 'ZFI_BANCARIO',
        msgno TYPE symsgno VALUE '000',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_generic_error.

    CONSTANTS:
      BEGIN OF gc_import_directorys_not_found,
        msgid TYPE symsgid VALUE 'ZFI_BANCARIO',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_import_directorys_not_found.

    CONSTANTS:
      BEGIN OF gc_log_save_erro,
        msgid TYPE symsgid VALUE 'ZFI_BANCARIO',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_log_save_erro.

    CONSTANTS:
      BEGIN OF gc_directory_empty,
        msgid TYPE symsgid VALUE 'ZFI_BANCARIO',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_directory_empty.

    CONSTANTS:
      BEGIN OF gc_read_directory_failed,
        msgid TYPE symsgid VALUE 'ZFI_BANCARIO',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_read_directory_failed.

    CONSTANTS:
      BEGIN OF gc_layout_bank_file_not_found,
        msgid TYPE symsgid VALUE 'ZFI_BANCARIO',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_layout_bank_file_not_found.

      CONSTANTS:
      BEGIN OF gc_job_start_erro,
        msgid TYPE symsgid VALUE 'ZFI_BANCARIO',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_job_start_erro.

      CONSTANTS:
      BEGIN OF gc_ff5_import_erro,
        msgid TYPE symsgid VALUE 'ZFI_BANCARIO',
        msgno TYPE symsgno VALUE '008',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_ff5_import_erro,

      BEGIN OF gc_file_exist,
        msgid TYPE symsgid VALUE 'ZFI_BANCARIO',
        msgno TYPE symsgno VALUE '009',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_file_exist.

      CONSTANTS:
      BEGIN OF gc_erro_name_file,
        msgid TYPE symsgid VALUE 'ZFI_BANCARIO',
        msgno TYPE symsgno VALUE '010',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_erro_name_file.

    METHODS constructor
      IMPORTING
        !iv_textid   LIKE if_t100_message=>t100key OPTIONAL
        !iv_previous LIKE previous OPTIONAL
        !iv_msgv1    TYPE msgv1 OPTIONAL
        !iv_msgv2    TYPE msgv2 OPTIONAL
        !iv_msgv3    TYPE msgv3 OPTIONAL
        !iv_msgv4    TYPE msgv4 OPTIONAL
        !iv_type     TYPE bapi_mtype DEFAULT 'E'.

    METHODS get_bapin_return
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t.

ENDCLASS.

CLASS lcl_exceptions IMPLEMENTATION.

  METHOD constructor.

    CALL METHOD super->constructor
      EXPORTING
        previous = previous.

    me->gv_msgv1 = iv_msgv1.
    me->gv_msgv2 = iv_msgv2.
    me->gv_msgv3 = iv_msgv3.
    me->gv_msgv4 = iv_msgv4.
    me->gv_type  = iv_type.

    CLEAR me->textid.
    IF iv_textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = iv_textid.
    ENDIF.

  ENDMETHOD.

  METHOD get_bapin_return.

    DATA: ls_message LIKE LINE OF rt_return.

    ls_message-type        = 'E'.
    ls_message-id          = if_t100_message~t100key-msgid.
    ls_message-number      = if_t100_message~t100key-msgno.
    IF gv_msgv1 IS NOT INITIAL.
      ls_message-message_v1 = gv_msgv1.
    ELSE.
      ls_message-message_v1 = if_t100_message~t100key-attr1.
      IF ls_message-message_v1 CA 'MSG'.
        CLEAR ls_message-message_v1.
      ENDIF.
    ENDIF.
    IF gv_msgv2 IS NOT INITIAL.
      ls_message-message_v2 = gv_msgv2.
    ELSE.
      ls_message-message_v2 = if_t100_message~t100key-attr2.
      IF ls_message-message_v2 CA 'MSG'.
        CLEAR ls_message-message_v2.
      ENDIF.
    ENDIF.
    IF gv_msgv3 IS NOT INITIAL.
      ls_message-message_v3 = gv_msgv3.
    ELSE.
      ls_message-message_v3 = if_t100_message~t100key-attr3.
      IF ls_message-message_v3 CA 'MSG'.
        CLEAR ls_message-message_v3.
      ENDIF.
    ENDIF.
    IF gv_msgv4 IS NOT INITIAL.
      ls_message-message_v4 = gv_msgv4.
    ELSE.
      ls_message-message_v4 = if_t100_message~t100key-attr4.
      IF ls_message-message_v4 CA 'MSG'.
        CLEAR ls_message-message_v4.
      ENDIF.
    ENDIF.

    APPEND ls_message TO rt_return.
    CLEAR ls_message.

  ENDMETHOD.
ENDCLASS.
