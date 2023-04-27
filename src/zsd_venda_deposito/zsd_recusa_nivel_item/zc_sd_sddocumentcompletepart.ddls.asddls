@AbapCatalog.sqlViewName: 'ZVSD_PARVW_ITEM'
@AccessControl.authorizationCheck: #CHECK
@AbapCatalog.preserveKey: true
@EndUserText.label: 'Desconto do item da ordem'

define root view ZC_SD_SDDocumentCompletePart
  as select from    I_SDDocumentCompletePartners as i
    inner join      ZC_SD_PARAM_PARVW            as z on i.PartnerFunction = z.low
    left outer join pa0002                       as a on a.pernr = i.Personnel
    left outer join lfa1                         as b on b.lifnr = i.Supplier
{
  key i.SDDocument,
  key i.SDDocumentItem,
      case
        when i.Personnel is initial then b.lifnr
        else i.Personnel
      end as Supplier,
      case
        when i.Personnel is initial then b.name1
        else a.cname
      end as SupplierName
}
group by
  i.SDDocument,
  i.SDDocumentItem,
  i.Personnel,
  b.lifnr,
  a.cname,
  b.name1
