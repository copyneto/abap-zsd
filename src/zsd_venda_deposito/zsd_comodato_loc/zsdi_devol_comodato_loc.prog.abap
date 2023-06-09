***********************************************************************
***                     © 3Corações                                 ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Movimentação MM - Processo Comodato/Locação            *
*** AUTOR    : Alysson Anjos - META                                   *
*** FUNCIONAL: Nicholas Menin - META                                  *
*** DATA     : 03.11.2022                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR      | DESCRIÇÃO                               *
***-------------------------------------------------------------------*
*** DD.MM.AAAA |            |                                         *
***********************************************************************
*&---------------------------------------------------------------------*
*& Include ZSDI_DEVOL_COMODATO_LOC
*&---------------------------------------------------------------------*

 DATA(lo_object) = NEW zclsd_cmdloc_devol_mercadoria( ).

 lo_object->chamada_exit( EXPORTING is_vbak = xvbak
                                    it_vbap = xvbap[] ).
