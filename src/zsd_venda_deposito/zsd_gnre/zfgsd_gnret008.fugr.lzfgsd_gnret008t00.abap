*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_GNRET008...................................*
TABLES: ZVSD_GNRET008, *ZVSD_GNRET008. "view work areas
CONTROLS: TCTRL_ZVSD_GNRET008
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_GNRET008. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_GNRET008.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_GNRET008_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET008.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET008_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_GNRET008_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET008.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET008_TOTAL.

*.........table declarations:.................................*
TABLES: J_1BAA                         .
TABLES: J_1BAAT                        .
TABLES: J_1BAGN                        .
TABLES: J_1BAGNT                       .
TABLES: ZTSD_GNRET008                  .
