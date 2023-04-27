*&---------------------------------------------------------------------*
*& Include          ZSDI_REF_DEV
*&---------------------------------------------------------------------*
* Se documento H = Devolução atribuimos o numero do faturamento ao campo ZUONR.
IF VBAK-VBTYP = 'H'.
VBAK-ZUONR = CVBRK-VBELN.
ENDIF.
