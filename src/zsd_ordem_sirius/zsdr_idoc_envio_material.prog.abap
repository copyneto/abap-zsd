***********************************************************************
***                           © 3corações                           ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Geração de IDOC de Material                            *
*** AUTOR : Luís Gustavo Schepp – META                                *
*** FUNCIONAL: Cleverson Faria – META                                 *
*** DATA : 25/11/2022                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR        | DESCRIÇÃO                             *
***-------------------------------------------------------------------*
***   /  /     |              |                                       *
***********************************************************************
REPORT zsdr_idoc_envio_material.

DATA gv_matmas TYPE edi_mestyp VALUE 'MATMAS'.

DATA lt_mestyp TYPE RANGE OF edi_mestyp.


SELECT DISTINCT 'I'     AS sign,
                'EQ'    AS option,
                cdobjid AS low,
                cdobjid AS high
  FROM bdcp2
  INTO TABLE @DATA(lt_material)
  WHERE mestype EQ @gv_matmas.

IF sy-subrc EQ 0.

  APPEND VALUE #(
    sign   = 'I'
    option = 'EQ'
    low    = gv_matmas
                ) TO lt_mestyp.

  "Eliminar indicador de modificação
  SUBMIT rbdcpclr WITH testmode EQ abap_false
                  WITH p1_old   EQ abap_true
                  WITH p1_msgty IN lt_mestyp
                  AND RETURN EXPORTING LIST TO MEMORY.

  "Enviar Material
  SUBMIT rbdsemat WITH sendall EQ abap_true
                  WITH matsel  IN lt_material
                  WITH mestyp  EQ gv_matmas
                  AND RETURN EXPORTING LIST TO MEMORY.

ENDIF.
