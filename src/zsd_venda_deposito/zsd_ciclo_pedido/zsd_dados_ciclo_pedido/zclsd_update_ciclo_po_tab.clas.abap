"!<p>Essa classe é utilizada para fazer update na tabela <strong>ZTSD_CICLO_PO</strong>
"!<p><strong>Autor:</strong> Schinaider Sá - Meta</p>
"!<p><strong>Data:</strong> 27/01/2022</p>
CLASS zclsd_update_ciclo_po_tab DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    "! Update da tabela ZTSD_CICLO_PO
    "! @parameter it_ciclo_po | Tabela ZTSD_CICLO_PO
    METHODS update_ciclo_po_tab
      IMPORTING
        it_ciclo_po TYPE zttsd_ciclo_po.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zclsd_update_ciclo_po_tab IMPLEMENTATION.
  METHOD update_ciclo_po_tab.
    CHECK it_ciclo_po IS NOT INITIAL.
    MODIFY ztsd_ciclo_po FROM TABLE it_ciclo_po.
  ENDMETHOD.
ENDCLASS.
