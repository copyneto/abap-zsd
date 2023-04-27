function zfmsd_b2b_gera_gnre.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IT_NFLIN) TYPE  J_1BNFLIN_TAB
*"  EXPORTING
*"     REFERENCE(ET_RETURN) TYPE  BAPIRET2_TAB
*"----------------------------------------------------------------------
data(lo_gera_gnre) = new lcl_gera_gnre( ).
et_return = lo_gera_gnre->execute( it_nflin ).

ENDFUNCTION.
