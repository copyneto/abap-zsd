*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section
CONSTANTS:
  BEGIN OF gc_s_bseg,
    structure  TYPE te_struc  VALUE 'BSEG',
    valuepart1 TYPE valuepart VALUE 'BUPLA',
  END OF gc_s_bseg,

  BEGIN OF gc_s_gnre007,
    structure TYPE te_struc  VALUE 'ZSSD_GNREE007',
  END OF gc_s_gnre007.
