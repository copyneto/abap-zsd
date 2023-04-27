*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_ICMSDIF....................................*
TABLES: ZVSD_ICMSDIF, *ZVSD_ICMSDIF. "view work areas
CONTROLS: TCTRL_ZVSD_ICMSDIF
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_ICMSDIF. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_ICMSDIF.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_ICMSDIF_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_ICMSDIF.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_ICMSDIF_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_ICMSDIF_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_ICMSDIF.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_ICMSDIF_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_ICMSDIF                   .
