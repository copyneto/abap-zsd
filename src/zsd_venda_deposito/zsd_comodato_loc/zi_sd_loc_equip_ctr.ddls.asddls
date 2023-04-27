@AbapCatalog.sqlViewName: 'ZV_SD_LOC_EQUIP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Contratos - Locais/equipamentos'
@OData.publish: true

define view ZI_SD_LOC_EQUIP_CTR
  as select from    I_SalesContractItem as Contrato
    left outer join ser01 on ser01.lief_nr = Contrato.ReferenceSDDocument
    left outer join objk  on objk.obknr = ser01.obknr
{
  key Contrato.SalesContract                                as Contrato,
  key Contrato.SalesContractItem                            as ContratoItem,
      Contrato.ReferenceSDDocument                          as Remessa,
      Contrato.ReferenceSDDocumentItem                      as RemessaItem,
      Contrato.Product                                      as Produto,
      Contrato.SalesContractItemText                        as ProdutoTexto,
      max(objk.sernr)                                       as Serie,
      Contrato.Plant                                        as Centro,
      Contrato._Plant.PlantName                             as CentroTexto,
      Contrato._SalesContract.SoldToParty                   as Cliente,
      Contrato._SalesContract._SoldToParty.CustomerFullName as ClienteTexto
}
group by
  Contrato.SalesContract,
  Contrato.SalesContractItem,
  Contrato.ReferenceSDDocument,
  Contrato.ReferenceSDDocumentItem,
  Contrato.Product,
  Contrato.SalesContractItemText,
  Contrato.Plant,
  Contrato._Plant.PlantName,
  Contrato._SalesContract.SoldToParty,
  Contrato._SalesContract._SoldToParty.CustomerFullName
