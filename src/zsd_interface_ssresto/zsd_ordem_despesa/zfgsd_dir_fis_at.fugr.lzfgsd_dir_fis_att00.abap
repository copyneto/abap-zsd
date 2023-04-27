*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_DIR_FIS_ATV................................*
TABLES: ZVSD_DIR_FIS_ATV, *ZVSD_DIR_FIS_ATV. "view work areas
CONTROLS: TCTRL_ZVSD_DIR_FIS_ATV
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_DIR_FIS_ATV. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_DIR_FIS_ATV.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_DIR_FIS_ATV_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_DIR_FIS_ATV.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_DIR_FIS_ATV_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_DIR_FIS_ATV_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_DIR_FIS_ATV.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_DIR_FIS_ATV_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_DIR_FIS_ATV               .
