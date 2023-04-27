*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_INCL_USER..................................*
TABLES: ZVSD_INCL_USER, *ZVSD_INCL_USER. "view work areas
CONTROLS: TCTRL_ZVSD_INCL_USER
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_INCL_USER. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_INCL_USER.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_INCL_USER_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_INCL_USER.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_INCL_USER_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_INCL_USER_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_INCL_USER.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_INCL_USER_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_INCL_USER                 .
