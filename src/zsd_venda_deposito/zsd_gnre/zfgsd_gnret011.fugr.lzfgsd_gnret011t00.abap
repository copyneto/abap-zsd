*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_GNRET011...................................*
TABLES: ZVSD_GNRET011, *ZVSD_GNRET011. "view work areas
CONTROLS: TCTRL_ZVSD_GNRET011
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_GNRET011. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_GNRET011.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_GNRET011_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET011.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET011_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_GNRET011_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET011.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET011_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_GNRET011                  .
