*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

* ===========================================================================
* Constantes globais
* ===========================================================================

CONSTANTS:
  BEGIN OF gc_status,
    rascunho         TYPE ztsd_preco_h-status VALUE '00',
    em_processamento TYPE ztsd_preco_h-status VALUE '01',
    pendente         TYPE ztsd_preco_h-status VALUE '02',
    erro             TYPE ztsd_preco_h-status VALUE '03',
    aprovado         TYPE ztsd_preco_h-status VALUE '04',
    alerta           TYPE ztsd_preco_h-status VALUE '05',
    divergencia      TYPE ztsd_preco_h-status VALUE '06',
    reprovado        TYPE ztsd_preco_h-status VALUE '07',
    eliminado        TYPE ztsd_preco_h-status VALUE '08',
    validado         TYPE ztsd_preco_h-status VALUE '09',
    alertaexp        TYPE ztsd_preco_h-status VALUE '10',
  END OF gc_status.
