@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Nfe de devoluçao cancelada'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_NOTA_FISCAIS_DEVOLUCAO
  as select from ZI_SD_LOCAL_NEGOCIO as _Negocio
{
  key _Negocio.Centro       as Centro,
      _Negocio.LocalNegocio as LocalNegocio,
      _Negocio.Empresa      as Empresa,
      _Negocio.LocalNegCnpj as LocalNegCnpj,
      _Negocio.CodFiscal,
      _Negocio.CodMunicipal,
      _Negocio.Cnae
      //   @ObjectModel.virtualElement: true
      //   @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CNPJ_LOCAL_NEGOCIO'
      //   cast ( _Negocio.CnpjNunber as abap.numc(14) ) as CnpjDest
}
where
      _Negocio.LocalNegocio <> ' '
  and _Negocio.Empresa      <> ' '
