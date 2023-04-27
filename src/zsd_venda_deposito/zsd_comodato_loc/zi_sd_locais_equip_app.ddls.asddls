@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Locais/Equipamentos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_LOCAIS_EQUIP_APP
  as select from    I_SalesContractItem as _ContratoItem

    inner join      I_SalesContract     as _Contrato   on _Contrato.SalesContract = _ContratoItem.SalesContract


    left outer join vbap                as _OrdemItem  on  _OrdemItem.vbeln = _ContratoItem.SalesContract
                                                       and _OrdemItem.posnr = _ContratoItem.SalesContractItem

    left outer join vbap                as _OrdemRem   on  _OrdemRem.vgbel = _ContratoItem.SalesContract
                                                       and _OrdemRem.posnr = _ContratoItem.SalesContractItem

    left outer join lips                as _remessa    on  _remessa.vgbel = _OrdemRem.vbeln
                                                       and _remessa.vgpos = _OrdemRem.posnr

    left outer join ser02               as _Ser02      on  _Ser02.sdaufnr = _OrdemItem.vbeln
                                                       and _Ser02.posnr   = _OrdemItem.posnr

    left outer join ser01               as _Ser01      on  _Ser01.lief_nr = _remessa.vbeln
                                                       and _Ser01.posnr   = _remessa.posnr

    left outer join objk                as _Objk       on _Objk.obknr = _Ser02.obknr
    left outer join eqbs                as _Eqbs       on _Eqbs.equnr = _Objk.equnr
    left outer join I_Plant             as _Plant      on _Plant.Plant = _Eqbs.b_werk

    left outer join objk                as _ObjkRem    on _ObjkRem.obknr = _Ser01.obknr
    left outer join eqbs                as _EqbsRem    on _EqbsRem.equnr = _ObjkRem.equnr
    left outer join I_Plant             as _PlantRem   on _PlantRem.Plant = _EqbsRem.b_werk

  association [0..1] to I_Customer as _CustomerMov     on _CustomerMov.Customer = _Eqbs.kunnr

  association [0..1] to I_Customer as _CustomerDefault on _CustomerDefault.Customer = _Contrato.SoldToParty



{
  key _ContratoItem.SalesContract     as Contrato,
  key _ContratoItem.SalesContractItem as ContratoItem,
  key _remessa.vbeln                  as Remessa,

      case coalesce( _remessa.vbeln, '' )
      when ''
      then cast (_Objk.sernr    as abap.char( 18 ))
      else cast (_ObjkRem.sernr as abap.char( 18 ))
      end                             as Serie,

      _OrdemItem.matnr                as CodigoEquip,
      _OrdemItem.arktx                as DescricaoEquip,
      //      _ContratoItem.Plant             as Centro,
      //      _ContratoItem._Plant.PlantName  as DescricaoCentro,

      case coalesce( _remessa.vbeln, '' )
      when ''
      then _Eqbs.b_werk
      else _EqbsRem.b_werk
      end                             as Centro,

      case coalesce( _remessa.vbeln, '' )
      when ''
      then _Plant.PlantName
      else _PlantRem.PlantName
      end                             as DescricaoCentro,

      case _remessa.bwart
        when '631'
            then _Eqbs.kunnr
        when '632'
            then _Eqbs.kunnr
        else
           _Contrato.SoldToParty
      end                             as Cliente,

      case _remessa.bwart
        when '631'
            then _CustomerMov.CustomerName
        when '632'
            then _CustomerMov.CustomerName
        else
           _CustomerDefault.CustomerName
      end                             as RazaoSocial
      
//      _OrdemItem.vbeln,
//      _OrdemItem.vgbel,
//      _Ser02.sdaufnr,
//      _Ser02.obknr,
//      _Objk.obknr as ObknrObjk,
//      _Objk.equnr,
//      _Eqbs.equnr as EqunrEqbs,
//      _Eqbs.kunnr

}
