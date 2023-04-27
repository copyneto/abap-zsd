*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTSD_NFE_TPATO..................................*
DATA:  BEGIN OF STATUS_ZTSD_NFE_TPATO                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTSD_NFE_TPATO                .
CONTROLS: TCTRL_ZTSD_NFE_TPATO
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZTSD_NFE_TPATO                .
TABLES: ZTSD_NFE_TPATO                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
