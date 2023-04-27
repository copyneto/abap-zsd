*&--------------------------------------------------------------------*
*& Include          ZSDI_INSERCAO_CPF_ECOMMERCE
*&--------------------------------------------------------------------*
***********************************************************************
*** © 3corações ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Inserção CPF cliente ocasional das vendas e-commerce   *
*** AUTOR : Luís Gustavo Schepp – Meta                                *
*** FUNCIONAL: Cleverson Faria  – Meta                                *
*** DATA : 14/10/2022                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO                                          *
***-------------------------------------------------------------------*
*** | |                                                               *
***********************************************************************
  DATA: lv_objecttype TYPE swo_objtyp,
        lv_objectkey  TYPE swo_typeid.


  IF call_bapi EQ abap_true AND
     vbak-auart EQ 'Z003' OR vbak-auart EQ 'ZRP3' OR  vbak-auart EQ 'ZR03'.

    lv_objecttype = 'BUS2032'.

    READ TABLE xvbpa ASSIGNING FIELD-SYMBOL(<fs_xvbpa>) WITH KEY parvw = 'WE'.
    IF NOT <fs_xvbpa> IS INITIAL AND
       <fs_xvbpa>-xcpdk = abap_true.

      SELECT SINGLE stcd2
        FROM kna1
        INTO <fs_xvbpa>-stcd2
        WHERE kunnr = knvp-kunnr.

      IF NOT <fs_xvbpa>-stcd2 IS INITIAL.
        <fs_xvbpa>-stkzn = abap_true.
      ENDIF.

      CALL FUNCTION 'SD_PARTNER_DATA_PUT'
        EXPORTING
          fic_objecttype              = lv_objecttype
          fic_objectkey               = lv_objectkey
        TABLES
          frt_xvbpa                   = xvbpa[]
          frt_yvbpa                   = yvbpa[]
          frt_xvbuv                   = xvbuv[]
          frt_hvbuv                   = hvbuv[]
          frt_xvbadr                  = xvbadr[]
          frt_yvbadr                  = yvbadr[]
        EXCEPTIONS
          no_object_specified         = 1
          no_object_creation_possible = 2
          OTHERS                      = 3.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

    ENDIF.
  ENDIF.
