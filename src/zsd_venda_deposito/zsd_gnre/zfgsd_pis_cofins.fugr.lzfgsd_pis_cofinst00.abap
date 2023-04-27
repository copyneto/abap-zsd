*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_PIS_COFINS.................................*
TABLES: ZVSD_PIS_COFINS, *ZVSD_PIS_COFINS. "view work areas
CONTROLS: TCTRL_ZVSD_PIS_COFINS
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_PIS_COFINS. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_PIS_COFINS.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_PIS_COFINS_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_PIS_COFINS.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_PIS_COFINS_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_PIS_COFINS_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_PIS_COFINS.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_PIS_COFINS_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_PIS_COFINS                .
