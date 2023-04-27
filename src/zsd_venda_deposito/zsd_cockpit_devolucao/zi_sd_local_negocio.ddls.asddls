@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Selecionar CNPJ do local de negócio.'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_LOCAL_NEGOCIO
  as select from t001w as _CentroFilial
  association to j_1bbranch as _LocalNeg on _LocalNeg.branch = $projection.LocalNegocio
{
  key _CentroFilial.werks      as Centro,
      _CentroFilial.j_1bbranch as LocalNegocio,
      _LocalNeg.bukrs          as Empresa,
      _LocalNeg.branch         as LocalNegCnpj,
      _LocalNeg.state_insc     as CodFiscal,
      _LocalNeg.munic_insc     as CodMunicipal,
      _LocalNeg.cnae           as Cnae,
      _LocalNeg.stcd1          as CnpjNunber

}
where
      _CentroFilial.j_1bbranch <> ''
  and _LocalNeg.bukrs          <> ''
