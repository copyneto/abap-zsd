CLASS zclsd_rank DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_udate
        FOR TABLE FUNCTION ztb_sd_rank .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclsd_rank IMPLEMENTATION.
  METHOD get_udate BY DATABASE FUNCTION FOR HDB LANGUAGE
                     SQLSCRIPT OPTIONS READ-ONLY
                     USING cdpos cdhdr.

    rank_table =
        select
        C.mandant,
        c.objectid,
        d.username,
        d.udate,
        d.utime,
        RANK ( ) OVER ( PARTITION BY  d.mandant, d.username
                             ORDER BY udate, d.utime ASC ) AS rank
        from   cdpos as C
        inner join         cdhdr as d ON  d.objectclas = c.objectclas
                        and d.objectid   = c.objectid
                        and d.objectclas = 'VERKBELEG'
                        and d.changenr   = c.changenr;
  return
  select mandant,
         objectid,
         username,
         udate,
         utime
    from :rank_table
   where rank = 1;

  endmethod.

ENDCLASS.
