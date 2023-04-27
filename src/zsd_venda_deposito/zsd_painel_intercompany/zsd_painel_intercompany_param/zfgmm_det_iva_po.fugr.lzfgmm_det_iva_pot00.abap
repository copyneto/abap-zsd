*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTMM_DET_IVA_PO.................................*
DATA:  BEGIN OF STATUS_ZTMM_DET_IVA_PO               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTMM_DET_IVA_PO               .
CONTROLS: TCTRL_ZTMM_DET_IVA_PO
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZTMM_DET_IVA_PO               .
TABLES: ZTMM_DET_IVA_PO                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
