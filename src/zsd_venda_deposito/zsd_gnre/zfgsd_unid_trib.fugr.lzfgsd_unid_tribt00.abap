*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_UNID_TRIB..................................*
TABLES: ZVSD_UNID_TRIB, *ZVSD_UNID_TRIB. "view work areas
CONTROLS: TCTRL_ZVSD_UNID_TRIB
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_UNID_TRIB. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_UNID_TRIB.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_UNID_TRIB_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_UNID_TRIB.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_UNID_TRIB_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_UNID_TRIB_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_UNID_TRIB.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_UNID_TRIB_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_UNID_TRIB                 .
