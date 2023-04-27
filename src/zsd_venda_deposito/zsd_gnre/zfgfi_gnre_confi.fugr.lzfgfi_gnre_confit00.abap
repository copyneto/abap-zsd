*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_GNRE_CONFIG................................*
TABLES: ZVSD_GNRE_CONFIG, *ZVSD_GNRE_CONFIG. "view work areas
CONTROLS: TCTRL_ZVSD_GNRE_CONFIG
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_GNRE_CONFIG. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_GNRE_CONFIG.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_GNRE_CONFIG_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRE_CONFIG.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRE_CONFIG_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_GNRE_CONFIG_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRE_CONFIG.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRE_CONFIG_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_GNRE_CONFIG               .
