*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_CTR_DET_DEP................................*
TABLES: ZVSD_CTR_DET_DEP, *ZVSD_CTR_DET_DEP. "view work areas
CONTROLS: TCTRL_ZVSD_CTR_DET_DEP
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_CTR_DET_DEP. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_CTR_DET_DEP.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_CTR_DET_DEP_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_CTR_DET_DEP.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_CTR_DET_DEP_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_CTR_DET_DEP_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_CTR_DET_DEP.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_CTR_DET_DEP_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_CTR_DET_DEP               .
