*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTSD_IONZ.......................................*
DATA:  BEGIN OF STATUS_ZTSD_IONZ                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTSD_IONZ                     .
CONTROLS: TCTRL_ZTSD_IONZ
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZTSD_SINT_PROCES................................*
DATA:  BEGIN OF STATUS_ZTSD_SINT_PROCES              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTSD_SINT_PROCES              .
CONTROLS: TCTRL_ZTSD_SINT_PROCES
            TYPE TABLEVIEW USING SCREEN '0002'.
*.........table declarations:.................................*
TABLES: *ZTSD_IONZ                     .
TABLES: *ZTSD_SINT_PROCES              .
TABLES: ZTSD_IONZ                      .
TABLES: ZTSD_SINT_PROCES               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
