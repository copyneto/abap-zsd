*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_IPI........................................*
TABLES: ZVSD_IPI, *ZVSD_IPI. "view work areas
CONTROLS: TCTRL_ZVSD_IPI
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_IPI. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_IPI.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_IPI_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_IPI.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_IPI_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_IPI_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_IPI.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_IPI_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_IPI                       .
