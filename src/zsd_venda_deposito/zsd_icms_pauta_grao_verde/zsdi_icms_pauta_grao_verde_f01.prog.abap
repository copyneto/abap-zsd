***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: ICMS Pauta grão verde                                  *
*** AUTOR    : FLÁVIA LEITE –[META]                                   *
*** FUNCIONAL: SANDRO SEIXAS –[META]                                  *
*** DATA     : 30.08.2021                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
IF xworkm IS NOT INITIAL.

  IF komk-auart <> 'Z020'.
    IF xkomv-kschl = 'BX10'.

      xkawrt = ykmeng.
      xkwert = xworkm.

    ENDIF.
  ENDIF.

  IF xkomv-kschl = 'BX13'.

*    xkawrt = ( xworkm * ( komp-umvkn / komp-umvkz ) ) / '1000'.
*    xkwert = ( xkawrt * xkomv-kbetr ) / '100'.
    xkwert = ( xworkm * xkomv-kbetr ) / '100000'.


  ENDIF.

ENDIF.
