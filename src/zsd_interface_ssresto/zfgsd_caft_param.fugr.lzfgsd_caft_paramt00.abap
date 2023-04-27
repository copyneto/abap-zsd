*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTSD_CAFT_PARAM.................................*
DATA:  BEGIN OF STATUS_ZTSD_CAFT_PARAM               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTSD_CAFT_PARAM               .
CONTROLS: TCTRL_ZTSD_CAFT_PARAM
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZTSD_CAFT_PARAM               .
TABLES: ZTSD_CAFT_PARAM                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
