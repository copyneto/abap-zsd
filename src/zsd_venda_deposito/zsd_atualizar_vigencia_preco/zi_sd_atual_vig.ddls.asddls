@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Atualizar vigência'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zi_sd_atual_vig
  as select from    zi_sd_atualizar_vigencia_preco as I_Vigencia
  //  association [1..1] to konp                         as _Monto    on $projection.knumh = _Monto.knumh
    inner join      ZI_SD_ATUAL_VIG_KONP           as _Monto  on  _Monto.vtweg = I_Vigencia.vtweg
                                                              and _Monto.pltyp = I_Vigencia.pltyp
                                                              and _Monto.werks = I_Vigencia.werks
                                                              and _Monto.matnr = I_Vigencia.matnr
                                                              and _Monto.datbi = I_Vigencia.datbi
                                                              and _Monto.knumh = I_Vigencia.knumh

    left outer join konm                           as _Escala on I_Vigencia.knumh = _Escala.knumh
  //  association [1..1] to mara                         as _Mara     on $projection.matnr = _Mara.matnr
  association [0..1] to ZI_CA_VH_MATERIAL            as _Material on $projection.matnr = _Material.Material
  association [0..1] to ZI_SD_ATUAL_VIG_MATKL        as _Grupo    on $projection.matnr = _Grupo.matnr
  //association [0..1] to mara                         as _Grupo     on $projection.matnr = _Grupo.matnr
  //association [0..1] to ZI_CA_VH_MATKL               as _GrupoText on $projection.GrupoMercadoria = _GrupoText.Matkl
  association [0..1] to ZI_CA_VH_PLTYP               as _Lista    on $projection.pltyp = _Lista.PriceList
  association [0..1] to ZI_CA_VH_DISTRIBUTIONCHANNEL as _Canal    on $projection.vtweg = _Canal.OrgUnidID
  association [0..1] to ZI_CA_VH_WERKS               as _Filial   on $projection.werks = _Filial.WerksCode
{
  key    I_Vigencia.vtweg,
         @EndUserText.label: 'Lista de Preço'
  key    I_Vigencia.pltyp,
         @EndUserText.label: 'Centro'
  key    I_Vigencia.werks,
  key    I_Vigencia.matnr,
  key    I_Vigencia.datbi,
  key    case
         when _Escala.kstbm is null
         then  cast( _Monto.kstbm as abap.dec( 15,3 ))
         else  cast( _Escala.kstbm as abap.dec( 15,3 ))
         end                                    as kstbm,
  key    _Escala.klfn1,
  key    cast( _Monto.mxwrt as abap.dec(11,2))  as mxwrt,
         //         cast( _Monto.kbetr as abap.dec(11,2))  as kbetr,
  key    cast( _Monto.gkwrt  as abap.dec(11,2)) as gkwrt,
         @EndUserText.label: 'Válido desde'
         I_Vigencia.datab,
         I_Vigencia.knumh,
         _Escala.kopos,
         /*Campos da CDS Abstract */
         ''                                     as kodatbi,
         ''                                     as kodatab,

         //@Semantics.amount.currencyCode: 'konwa'
         //_Monto.kbetr,
         _Monto.konwa,
         case
         when _Escala.kbetr is null
         then  cast( _Monto.kbetr as abap.dec(11,2))
         else  cast( _Escala.kbetr as abap.dec(11,2))
         end                                    as kbetr,

         _Monto.kmein                           as meins,
         //         _Mara.meins,

         _Material.Text                         as MaterialText,
         _Lista.PriceListText                   as PriceText,
         _Filial.WerksCodeName                  as WerksText,
         _Canal.Text                            as CanalText,

         _Grupo.matkl                           as Grupo,
         _Grupo.matklText                       as GrupoText,
         //_Grupo.matkl as GrupoMercadoria,
         //_GrupoText.Text as GrupoMercadoriaText,
         _Monto.loevm_ko,

         _Material,
         _Lista,
         _Canal,
         _Filial
}
group by
  I_Vigencia.vtweg,
  I_Vigencia.pltyp,
  I_Vigencia.werks,
  I_Vigencia.matnr,
  I_Vigencia.datbi,
  _Escala.kstbm,
  _Monto.kstbm,
  _Escala.klfn1,
  I_Vigencia.datab,
  I_Vigencia.knumh,
  _Escala.kopos,
  _Monto.konwa,
  _Monto.gkwrt,
  _Escala.kbetr,
  _Monto.kbetr,
  _Monto.mxwrt,
  _Monto.kmein,
  _Material.Text,
  _Lista.PriceListText,
  _Filial.WerksCodeName,
  _Canal.Text,
  _Grupo.matkl,
  _Grupo.matklText,
  _Monto.loevm_ko
