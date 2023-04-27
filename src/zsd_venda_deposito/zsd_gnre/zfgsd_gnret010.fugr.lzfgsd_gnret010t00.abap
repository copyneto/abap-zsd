*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_GNRET010...................................*
TABLES: ZVSD_GNRET010, *ZVSD_GNRET010. "view work areas
CONTROLS: TCTRL_ZVSD_GNRET010
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_GNRET010. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_GNRET010.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_GNRET010_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET010.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET010_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_GNRET010_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET010.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET010_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_GNRET010                  .
