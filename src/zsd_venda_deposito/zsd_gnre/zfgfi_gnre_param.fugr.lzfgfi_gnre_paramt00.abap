*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_GNRET015...................................*
TABLES: ZVSD_GNRET015, *ZVSD_GNRET015. "view work areas
CONTROLS: TCTRL_ZVSD_GNRET015
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_GNRET015. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_GNRET015.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_GNRET015_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET015.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET015_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_GNRET015_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET015.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET015_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_GNRET015                  .
