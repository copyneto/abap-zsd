REPORT zsdr_monitor_gnre MESSAGE-ID zsd_gnre.


* Includes
*-----------------------------------------------------------------------
INCLUDE: zsdi_monitor_gnre_top,   "Variáveis globais
         zsdi_monitor_gnre_sc01,  "Telas de seleção
         zsdi_monitor_gnre_cd01,  "Definição de classes locais
         zsdi_monitor_gnre_ci01,  "Implementação de classes locais
         zsdi_monitor_gnre_o01,   "Módulos PBO
         zsdi_monitor_gnre_i01.   "Módulos PAI

INITIALIZATION.
  gt_excluding_9000 = lcl_gnre_cockpit=>check_auth_buttons_9000( ).
*  MOVE 'Add NF + Guia' TO sscrfields-functxt_02.

  IF NOT line_exists( gt_excluding_9000[ table_line = 'GUIACOMPL' ] ).

    "Criar Guia Complementar
    sscrfields-functxt_01 = VALUE smp_dyntxt( text      = TEXT-bt1
                                              icon_id   = icon_new_task
                                              icon_text = TEXT-bt1 ).

  ENDIF.


AT SELECTION-SCREEN.
  CASE sscrfields-ucomm.
    WHEN 'FC01'.
      lcl_gnre_cockpit=>create_instance( )->add_guia_compl( ).
*    WHEN 'FC02'.
*
*     lcl_gnre_cockpit=>create_instance( )->popup_confirm( ).

  ENDCASE.

START-OF-SELECTION.
  lcl_gnre_cockpit=>create_instance( )->main( ).
