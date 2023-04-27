*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTSD_T048.......................................*
DATA:  BEGIN OF STATUS_ZTSD_T048                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTSD_T048                     .
CONTROLS: TCTRL_ZTSD_T048
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZTSD_T048                     .
TABLES: ZTSD_T048                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
