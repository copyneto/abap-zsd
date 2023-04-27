*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_GNRET021...................................*
TABLES: ZVSD_GNRET021, *ZVSD_GNRET021. "view work areas
CONTROLS: TCTRL_ZVSD_GNRET021
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_GNRET021. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_GNRET021.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_GNRET021_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET021.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET021_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_GNRET021_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET021.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET021_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_GNRET021                  .
