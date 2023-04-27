*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_MATERIAL_GC................................*
TABLES: ZVSD_MATERIAL_GC, *ZVSD_MATERIAL_GC. "view work areas
CONTROLS: TCTRL_ZVSD_MATERIAL_GC
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_MATERIAL_GC. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_MATERIAL_GC.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_MATERIAL_GC_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_MATERIAL_GC.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_MATERIAL_GC_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_MATERIAL_GC_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_MATERIAL_GC.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_MATERIAL_GC_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_MATERIAL_GC               .
