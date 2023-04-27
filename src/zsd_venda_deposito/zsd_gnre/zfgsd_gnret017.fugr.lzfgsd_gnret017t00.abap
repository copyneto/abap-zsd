*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_GNRET017...................................*
TABLES: ZVSD_GNRET017, *ZVSD_GNRET017. "view work areas
CONTROLS: TCTRL_ZVSD_GNRET017
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_GNRET017. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_GNRET017.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_GNRET017_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET017.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET017_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_GNRET017_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET017.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET017_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_GNRET017                  .
