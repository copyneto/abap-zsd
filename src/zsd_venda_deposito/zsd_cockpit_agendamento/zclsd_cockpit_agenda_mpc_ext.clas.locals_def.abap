*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

* ======================================================================
* Global constants
* ======================================================================

    CONSTANTS:
      BEGIN OF gc_fields,
        guid TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name VALUE 'Guid' ##NO_TEXT,
      END OF gc_fields,

      BEGIN OF gc_entity,
        layout TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name VALUE 'layout' ##NO_TEXT,
        upload TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name VALUE 'upload' ##NO_TEXT,
      END OF gc_entity.
