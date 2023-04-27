@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Seleciona material conforme EAN'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_DEVOLUCAO_MATEAN
  as select from    ZI_SD_NOTA                  as _NfeDev
    left outer join ZI_SD_COCKPIT_DEVOLUCAO_MAT as _Material on  _Material.Ean      = _NfeDev.CodEan //_NfeDev.Material
                                                             and _Material.UnMedida = _NfeDev.UnidMedida
{

  key _NfeDev.ChaveAcesso,
  key _NfeDev.Item,


      case
      when _NfeDev.CodEan = 'SEM GTIN' or _NfeDev.CodEan = ' '
      then _NfeDev.Material
      when _NfeDev.CodEan <> 'SEM GTIN' and cast( coalesce( _Material.Material, ' ' ) as matnr ) = ' '
      then _NfeDev.Material
      else _Material.Material
      end               as Material,

      case
      when _NfeDev.CodEan = 'SEM GTIN' or _NfeDev.CodEan = ' '
      then _NfeDev.UnidMedida
      when _NfeDev.CodEan <> 'SEM GTIN' and _Material.UnMedida is null
      then _NfeDev.UnidMedida
      else _Material.UnMedida
      end               as UnMedida,

      case
      when _NfeDev.CodEan = 'SEM GTIN' or _NfeDev.CodEan = ' '
      then _NfeDev.TextoMaterial
      when _NfeDev.CodEan <> 'SEM GTIN' and _Material.TextoMaterial is null
      then _NfeDev.TextoMaterial
      else _Material.TextoMaterial
      end               as TextoMaterial,

      case
      when _NfeDev.CodEan = 'SEM GTIN' or _NfeDev.CodEan = ' '
      then ' '
      when _NfeDev.CodEan <> 'SEM GTIN' and _Material.Ean is null
      then _NfeDev.CodEan
      else _Material.Ean
      end               as CodEan, 
      //      _NfeDev.CodEan,
      _NfeDev.Quantidade,
      _NfeDev.UnidMedida,
      case
       when _NfeDev.Quantidade = 0
        then 0
       else
      fltp_to_dec( ( cast( _NfeDev.ValorUnit as abap.fltp ) /  cast( _NfeDev.Quantidade as abap.fltp ) ) as abap.dec( 15, 2 ) )
      end               as ValorUnit,
      @Semantics.amount.currencyCode: 'CodMoeda'
      _NfeDev.ValorUnit as ValorTotal,
      _NfeDev.CodMoeda

}
