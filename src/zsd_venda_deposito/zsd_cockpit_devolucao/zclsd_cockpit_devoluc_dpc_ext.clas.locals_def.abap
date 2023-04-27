*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section
* ======================================================================
* Global constants
* ======================================================================

    CONSTANTS:
      BEGIN OF gc_fields,
        guid TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'Guid' ##NO_TEXT,
        line TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'Line' ##NO_TEXT,
      END OF gc_fields,

      BEGIN OF gc_entity,
        file     TYPE string VALUE 'fileSet' ##NO_TEXT,
        fileshow TYPE string VALUE 'fileShowSet' ##NO_TEXT,
      END OF gc_entity.
