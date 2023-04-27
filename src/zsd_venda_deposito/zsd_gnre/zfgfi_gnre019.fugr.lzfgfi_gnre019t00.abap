*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_GNRET019...................................*
TABLES: ZVSD_GNRET019, *ZVSD_GNRET019. "view work areas
CONTROLS: TCTRL_ZVSD_GNRET019
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_GNRET019. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_GNRET019.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_GNRET019_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET019.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET019_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_GNRET019_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_GNRET019.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_GNRET019_TOTAL.

*.........table declarations:.................................*
TABLES: ZTFI_050                       .
