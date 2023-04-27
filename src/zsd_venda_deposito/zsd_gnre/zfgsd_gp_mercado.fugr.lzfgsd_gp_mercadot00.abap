*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_GP_MERCADOR................................*
TABLES: ZVSD_GP_MERCADOR, *ZVSD_GP_MERCADOR. "view work areas
CONTROLS: TCTRL_ZVSD_GP_MERCADOR
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_GP_MERCADOR. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_GP_MERCADOR.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_GP_MERCADOR_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GP_MERCADOR.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GP_MERCADOR_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_GP_MERCADOR_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GP_MERCADOR.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GP_MERCADOR_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_GP_MERCADOR               .
