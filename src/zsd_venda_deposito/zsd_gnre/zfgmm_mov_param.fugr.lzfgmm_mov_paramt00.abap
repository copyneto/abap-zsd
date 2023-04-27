*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVMM_MOV_PARAM..................................*
TABLES: ZVMM_MOV_PARAM, *ZVMM_MOV_PARAM. "view work areas
CONTROLS: TCTRL_ZVMM_MOV_PARAM
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVMM_MOV_PARAM. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVMM_MOV_PARAM.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVMM_MOV_PARAM_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVMM_MOV_PARAM.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVMM_MOV_PARAM_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVMM_MOV_PARAM_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVMM_MOV_PARAM.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVMM_MOV_PARAM_TOTAL.

*.........table declarations:.................................*
TABLES: ZTMM_MOV_PARAM                 .
