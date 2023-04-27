*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

* ======================================================================
* Constantes globais
* ======================================================================

    CONSTANTS:
      BEGIN OF gc_fields,
        tablename TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'Tablename' ##NO_TEXT,
      END OF gc_fields,

      BEGIN OF gc_entity,
        layout       TYPE string VALUE 'layout' ##NO_TEXT,
        upload_price TYPE string VALUE 'uploadPrice' ##NO_TEXT,
      END OF gc_entity.
