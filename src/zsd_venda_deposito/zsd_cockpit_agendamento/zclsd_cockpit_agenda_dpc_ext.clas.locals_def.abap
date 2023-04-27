*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

* ===========================================================================
* CONSTANTES
* ===========================================================================

CONSTANTS:
  BEGIN OF gc_fields,
    guid TYPE string VALUE 'Guid' ##NO_TEXT,
  END OF gc_fields,

  BEGIN OF gc_entity,
    document TYPE string VALUE 'document' ##NO_TEXT,
    layout   TYPE string VALUE 'layout' ##NO_TEXT,
  END OF gc_entity.
