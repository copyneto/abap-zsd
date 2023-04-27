*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTSD_NFE_USUARIO................................*
DATA:  BEGIN OF STATUS_ZTSD_NFE_USUARIO              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTSD_NFE_USUARIO              .
CONTROLS: TCTRL_ZTSD_NFE_USUARIO
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZTSD_NFE_USUARIO              .
TABLES: ZTSD_NFE_USUARIO               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
