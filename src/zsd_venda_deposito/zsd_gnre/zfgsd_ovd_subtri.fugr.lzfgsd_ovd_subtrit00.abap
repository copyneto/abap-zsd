*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTSD_OVD_SUBTRIB................................*
DATA:  BEGIN OF STATUS_ZTSD_OVD_SUBTRIB              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTSD_OVD_SUBTRIB              .
CONTROLS: TCTRL_ZTSD_OVD_SUBTRIB
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZTSD_OVD_SUBTRIB              .
TABLES: ZTSD_OVD_SUBTRIB               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
