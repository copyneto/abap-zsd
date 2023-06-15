CLASS zcl_get_valid_j_1btxic1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS exec_method FOR TABLE FUNCTION ztf_sd_rel_fiscal_saida_txic1.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_get_valid_j_1btxic1 IMPLEMENTATION.
  METHOD exec_method
      BY DATABASE FUNCTION FOR HDB
      LANGUAGE SQLSCRIPT
      OPTIONS READ-ONLY
      USING j_1btxic1.

    rank_table =
      SELECT mandt      as client,
             land1      as land1,
             shipfrom   as shipfrom,
             shipto     as shipto,
             validfrom  as validfrom,
             rate       as rate,
             rate_f     as ratef,
             specf_rate as specfrate,
             specf_base as specfbase,
             partilha_exempt as partilhaexempt,
             specf_resale    as specfresale,
             RANK ( ) OVER ( PARTITION BY mandt, land1, shipfrom, shipto
                                 ORDER BY validfrom asc ) AS rank
        FROM j_1btxic1;

    RETURN
      SELECT client,
             land1,
             shipfrom,
             shipto,
             validfrom,
             rate,
             ratef,
             specfrate,
             specfbase,
             partilhaexempt,
             specfresale
        FROM :rank_table
       WHERE rank = 1;

  ENDMETHOD.
ENDCLASS.
