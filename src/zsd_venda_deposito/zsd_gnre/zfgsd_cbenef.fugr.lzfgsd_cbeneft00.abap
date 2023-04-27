*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_CBENEF.....................................*
TABLES: ZVSD_CBENEF, *ZVSD_CBENEF. "view work areas
CONTROLS: TCTRL_ZVSD_CBENEF
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_CBENEF. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_CBENEF.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_CBENEF_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_CBENEF.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_CBENEF_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_CBENEF_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_CBENEF.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_CBENEF_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_CBENEF                    .
