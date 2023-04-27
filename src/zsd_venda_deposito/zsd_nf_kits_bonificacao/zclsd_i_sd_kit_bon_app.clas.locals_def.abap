*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section
  types: BEGIN OF ty_draft_order,
           competencia(7) type c,
          Plant       type werks_d,
          DocKit      type vbeln,
          MatnrKit    type matnr,
          MatnrFree   type matnr,
          kunnr       type kunnr,
          Vbeln       type vbeln,
           end OF ty_draft_order.
