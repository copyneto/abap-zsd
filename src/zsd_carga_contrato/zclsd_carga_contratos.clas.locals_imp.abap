*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


CONSTANTS:
  BEGIN OF gc_upld,
    default_extension TYPE string VALUE '*.txt|*.csv|*.*',
    file_filter       TYPE string VALUE ' CSV (*.csv)|*.csv| TXT (*.txt)|*.txt| Todas(*.*)|*.* ' ##NO_TEXT,
  END OF gc_upld,

  gc_contratos TYPE string VALUE 'contratos_sd_'   ##NO_TEXT,
  gc_csv       TYPE string VALUE '.csv'         ##NO_TEXT.
