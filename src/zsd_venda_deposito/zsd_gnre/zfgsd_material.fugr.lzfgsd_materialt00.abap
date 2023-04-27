*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSD_MATERIAL...................................*
TABLES: ZVSD_MATERIAL, *ZVSD_MATERIAL. "view work areas
CONTROLS: TCTRL_ZVSD_MATERIAL
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVSD_MATERIAL. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSD_MATERIAL.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSD_MATERIAL_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSD_MATERIAL.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_MATERIAL_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSD_MATERIAL_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSD_MATERIAL.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSD_MATERIAL_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSD_MATERIAL                  .
