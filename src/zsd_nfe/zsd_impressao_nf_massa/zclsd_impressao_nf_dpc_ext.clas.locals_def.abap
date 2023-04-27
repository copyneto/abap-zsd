*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

* ===========================================================================
* GLOBAL CONSTANTS
* ===========================================================================

TYPES:     ty_t_key_tab TYPE SORTED TABLE OF /iwbep/s_mgw_name_value_pair
                        WITH NON-UNIQUE KEY name.

CONSTANTS: BEGIN OF gc_name,
             docnum  TYPE string VALUE 'Docnum',
             doctype TYPE string VALUE 'Doctype',
           END OF gc_name,

           BEGIN OF gc_entity,
             download      TYPE string VALUE 'download',
             downloadcheck TYPE string VALUE 'downloadCheck',
             print         TYPE string VALUE 'print',
           END OF gc_entity.
