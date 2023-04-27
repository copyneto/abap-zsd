"Name: \FU:RV_CHECK_CONDITION_VALUE\SE:BEGIN\EI
ENHANCEMENT 0 ZEISD_RV_CHECK_CONDITION_VALUE.
FIELD-SYMBOLS <fs_vbak> TYPE vbak.

"Tratamento para não exibir mensagem de limite superior ou inferior de preço - Devoluções
ASSIGN ('(SAPMV45A)VBAK') TO <fs_vbak>.
IF <fs_vbak> IS ASSIGNED AND
   <fs_vbak>-vbtyp EQ 'H'.
  check_krech = 'G'.
ENDIF.

ENDENHANCEMENT.
