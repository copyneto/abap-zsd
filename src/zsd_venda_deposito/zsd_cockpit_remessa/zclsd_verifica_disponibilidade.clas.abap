CLASS zclsd_verifica_disponibilidade DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
      INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS CHECK FOR TABLE FUNCTION ZI_SD_TF_VERIF_DISP.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclsd_verifica_disponibilidade IMPLEMENTATION.
  METHOD check    BY DATABASE FUNCTION FOR HDB
    LANGUAGE SQLSCRIPT
    OPTIONS READ-ONLY
    USING ztsd_solic_log.

        rank_table =
      SELECT mandt  as Client,
             data_solic,
             material,
             centro,
             ordem,
             acaolog,
             data_solic_logist,
             motivo_indisp,
             acao,
             RANK ( ) OVER ( PARTITION BY mandt, material, centro
                                 ORDER BY data_solic_logist DESC ) AS rank
        FROM ztsd_solic_log;

    RETURN
      SELECT client,
             data_solic,
             material,
             centro,
             acaolog,
             data_solic_logist,
             motivo_indisp,
             acao
        FROM :rank_table
        WHERE rank = 1;


  ENDMETHOD.

ENDCLASS.
