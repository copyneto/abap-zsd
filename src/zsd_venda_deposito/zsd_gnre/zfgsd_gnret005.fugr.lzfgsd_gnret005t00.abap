*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_GNRET005...................................*
TABLES: ZVSD_GNRET005, *ZVSD_GNRET005. "view work areas
CONTROLS: TCTRL_ZVSD_GNRET005
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_GNRET005. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_GNRET005.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_GNRET005_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET005.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET005_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_GNRET005_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET005.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET005_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_GNRET005                  .
