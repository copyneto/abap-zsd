*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_GNRET014...................................*
TABLES: ZVSD_GNRET014, *ZVSD_GNRET014. "view work areas
CONTROLS: TCTRL_ZVSD_GNRET014
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_GNRET014. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_GNRET014.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_GNRET014_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET014.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET014_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_GNRET014_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET014.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET014_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_GNRET014                  .
