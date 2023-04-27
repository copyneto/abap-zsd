*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_GNRET020...................................*
TABLES: ZVSD_GNRET020, *ZVSD_GNRET020. "view work areas
CONTROLS: TCTRL_ZVSD_GNRET020
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_GNRET020. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_GNRET020.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_GNRET020_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET020.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET020_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_GNRET020_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET020.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET020_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_GNRET020                  .
