*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_GNRET013...................................*
TABLES: ZVSD_GNRET013, *ZVSD_GNRET013. "view work areas
CONTROLS: TCTRL_ZVSD_GNRET013
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_GNRET013. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_GNRET013.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_GNRET013_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET013.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET013_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_GNRET013_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET013.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET013_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_GNRET013                  .
