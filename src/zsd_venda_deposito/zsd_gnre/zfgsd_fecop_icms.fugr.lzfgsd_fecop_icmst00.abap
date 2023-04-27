*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_FECOP_ICMS.................................*
TABLES: ZVSD_FECOP_ICMS, *ZVSD_FECOP_ICMS. "view work areas
CONTROLS: TCTRL_ZVSD_FECOP_ICMS
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_FECOP_ICMS. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_FECOP_ICMS.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_FECOP_ICMS_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_FECOP_ICMS.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_FECOP_ICMS_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_FECOP_ICMS_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_FECOP_ICMS.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_FECOP_ICMS_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_FECOP_ICMS                .
