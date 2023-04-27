*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_CALC_DIFAL.................................*
TABLES: ZVSD_CALC_DIFAL, *ZVSD_CALC_DIFAL. "view work areas
CONTROLS: TCTRL_ZVSD_CALC_DIFAL
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_CALC_DIFAL. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_CALC_DIFAL.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_CALC_DIFAL_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_CALC_DIFAL.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_CALC_DIFAL_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_CALC_DIFAL_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_CALC_DIFAL.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_CALC_DIFAL_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_CALC_DIFAL                .
