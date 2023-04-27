*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_GNRET018...................................*
TABLES: ZVSD_GNRET018, *ZVSD_GNRET018. "view work areas
CONTROLS: TCTRL_ZVSD_GNRET018
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_GNRET018. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_GNRET018.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_GNRET018_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET018.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET018_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_GNRET018_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET018.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET018_TOTAL.

*.........table declarations:.................................*
TABLES: J_1BTXJUR                      .
TABLES: J_1BTXJURT                     .
TABLES: ZTSD_GNRET018                  .
