class ZCLSD_NFE_PRINT definition
  public
  final
  create public .

public section.

  interfaces IF_EX_CL_NFE_PRINT .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_NFE_PRINT IMPLEMENTATION.


  METHOD if_ex_cl_nfe_print~call_rsnast00.

****Impressão automática da Danfe Simplificada
    INCLUDE zsde_imprimir_nfe_auto IF FOUND.

****Integração GKO
    INCLUDE ztme_integracao_gko IF FOUND.

****Automação GNRE
    INCLUDE zsdi_automacao_gnre IF FOUND.

  ENDMETHOD.


  method IF_EX_CL_NFE_PRINT~CHECK_SUBSEQUENT_DOCUMENTS.
  endmethod.


  method IF_EX_CL_NFE_PRINT~DETERMINE_MATDOC_CANCEL_DATE.
  endmethod.


  method IF_EX_CL_NFE_PRINT~EXCLUDE_NFES_FROM_BATCH.
  endmethod.


  method IF_EX_CL_NFE_PRINT~FILL_AUTXML.
  endmethod.


  method IF_EX_CL_NFE_PRINT~FILL_CTE.
  endmethod.


  method IF_EX_CL_NFE_PRINT~FILL_CTE_200.
  endmethod.


  method IF_EX_CL_NFE_PRINT~FILL_CTE_300.
  endmethod.


  method IF_EX_CL_NFE_PRINT~FILL_EXPORT.
  endmethod.


  method IF_EX_CL_NFE_PRINT~FILL_FUEL.
  endmethod.


  method IF_EX_CL_NFE_PRINT~FILL_HEADER.
  endmethod.


  method IF_EX_CL_NFE_PRINT~FILL_IMPORT.
  endmethod.


METHOD IF_EX_CL_NFE_PRINT~FILL_ITEM.

ENDMETHOD.


  method IF_EX_CL_NFE_PRINT~FILL_NVE.
  endmethod.


  method IF_EX_CL_NFE_PRINT~FILL_TRACE.
  endmethod.


  method IF_EX_CL_NFE_PRINT~GET_SERVER.
  endmethod.


  method IF_EX_CL_NFE_PRINT~GET_SERVER_DFE.
  endmethod.


  method IF_EX_CL_NFE_PRINT~IS_ICMS_PART_IN_EXCEPTION_LIST.
  endmethod.


  method IF_EX_CL_NFE_PRINT~RESET_SUBRC.
  endmethod.


  method IF_EX_CL_NFE_PRINT~SET_COMMIT.
  endmethod.


  method IF_EX_CL_NFE_PRINT~SET_ORDER_FOR_BATCH.
  endmethod.


  method IF_EX_CL_NFE_PRINT~FILL_ADD_INFLIN.
  endmethod.
ENDCLASS.
