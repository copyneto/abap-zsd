*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_GNRET016...................................*
TABLES: ZVSD_GNRET016, *ZVSD_GNRET016. "view work areas
CONTROLS: TCTRL_ZVSD_GNRET016
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_GNRET016. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_GNRET016.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_GNRET016_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET016.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET016_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_GNRET016_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET016.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET016_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_GNRET016                  .
