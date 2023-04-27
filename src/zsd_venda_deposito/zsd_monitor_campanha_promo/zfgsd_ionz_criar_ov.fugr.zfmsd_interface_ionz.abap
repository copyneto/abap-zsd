function zfmsd_interface_ionz.
*"----------------------------------------------------------------------
*"*"Interface local:
*"----------------------------------------------------------------------
   if sy-sysid = 'S4D'.
   new zclsd_interface_ionz( )->processo_ionz( 1 ).
   else.
   new zclsd_interface_ionz( )->processo_ionz( 100 ).
   endif.

ENDFUNCTION.
