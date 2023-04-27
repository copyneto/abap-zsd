*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_GNRET012...................................*
TABLES: ZVSD_GNRET012, *ZVSD_GNRET012. "view work areas
CONTROLS: TCTRL_ZVSD_GNRET012
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_GNRET012. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_GNRET012.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_GNRET012_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET012.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET012_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_GNRET012_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET012.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET012_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_GNRET012                  .
