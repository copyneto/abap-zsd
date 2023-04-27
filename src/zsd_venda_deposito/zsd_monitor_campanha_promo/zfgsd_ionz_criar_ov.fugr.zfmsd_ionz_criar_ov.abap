FUNCTION zfmsd_ionz_criar_ov.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_ID) TYPE  ZTSD_SINT_PROCES-ID
*"  TABLES
*"      ET_RETURN TYPE  BAPIRET2_TAB
*"----------------------------------------------------------------------

  DATA : ls_id  TYPE RANGE OF ztsd_sint_proces-id.

  APPEND VALUE #( sign   = 'I'
                  option = 'EQ'
                  low    = iv_id ) TO ls_id.


  DATA(lo_cria_ov) = NEW zclsd_ionz_criar_ov( ).
  GET REFERENCE OF ls_id[] INTO lo_cria_ov->gs_refdata-id.
  lo_cria_ov->seleciona_dados( ).
  lo_cria_ov->executar( ).

  APPEND LINES OF lo_cria_ov->gt_message TO et_return.

ENDFUNCTION.
