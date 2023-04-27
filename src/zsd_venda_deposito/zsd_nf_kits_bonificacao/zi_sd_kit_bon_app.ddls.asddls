@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS APP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_KIT_BON_APP
  //as select from    ZI_SD_KIT_BON_NOTAITEM    as _sd_kit
    as select from    ZI_SD_KIT_BON_NOTA_ITEM_V2  as _sd_kit

    inner join      ZI_SD_KIT_BON_TP_MOV      as _TpMov      on  _TpMov.TpMov  = _sd_kit.GoodsMovementType
                                                             and _TpMov.chave3 = ' '

    left outer join ZI_SD_KIT_BON_DOCESTORNO  as _DocEstorno on  _DocEstorno.smbln = _sd_kit.DocKit
                                                             and _DocEstorno.matnr = _sd_kit.MatnrFree

    //left outer join I_BR_NFDocument           as _NfRetorno  on  _NfRetorno.BR_NFReferenceDocument = _sd_kit.Nfe_Output
                                                             //and _NfRetorno.BR_NFType              = 'IL'
    left outer join ZI_SD_KIT_BON_NF_RET      as _NfRetorno  on  _NfRetorno.BR_NFReferenceDocument = _sd_kit.Nfe_Output                                                             
    

    left outer join ZI_SD_KIT_BON_ESTORNO_FAT as _SemEstorno on  _SemEstorno.competencia = _sd_kit.competencia
                                                             and _SemEstorno.Plant       = _sd_kit.Plant
                                                             and _SemEstorno.DocKit      = _sd_kit.DocKit
                                                             and _SemEstorno.MatnrKit    = _sd_kit.MatnrKit
                                                             and _SemEstorno.MatnrFree   = _sd_kit.MatnrFree
                                                             and _SemEstorno.kunnr       = _sd_kit.kunnr
                                                             and _SemEstorno.Posnr       = _sd_kit.Posnr
                                                               
  
  association to ZI_SalesDocumentQuiqkView as _ZI_SalesDocumentQuiqkView on _ZI_SalesDocumentQuiqkView.SalesDocument = _sd_kit.Vbeln
  association to I_BR_NFeDocumentStatusText as _I_BR_NFeDocStatusTxt_NF_E on _I_BR_NFeDocStatusTxt_NF_E.BR_NFeDocumentStatus = $projection.NfRetorno_Status //_NfRetorno.NfRetorno_Status //_NfRetorno.BR_NFeDocumentStatus  
                                                                          and _I_BR_NFeDocStatusTxt_NF_E.Language = 'P'
  association to I_BR_NFeDocumentStatusText as _I_BR_NFeDocStatusTxt_NF on _I_BR_NFeDocStatusTxt_NF.BR_NFeDocumentStatus =  $projection.BR_NFeDocumentStatus  
                                                                          and _I_BR_NFeDocStatusTxt_NF.Language = 'P'
                                                                          
                                                                                                                                                        
{
  key _sd_kit.competencia,
  key _sd_kit.Plant,
  key _sd_kit.DocKit,
  key _sd_kit.MatnrKit,
  key _sd_kit.MatnrFree,
  key _sd_kit.kunnr,
  key cast(_sd_kit.Posnr as abap.char( 4 ) )                               as Posnr,
  key _NfRetorno.NfRetorno,
      @Consumption.semanticObject: 'SalesDocument'
      @ObjectModel.foreignKey.association: '_ZI_SalesDocumentQuiqkView'
      _sd_kit.Vbeln,
      _sd_kit.PostingDate,
      _sd_kit.matkl,
      _sd_kit.BaseUnit,
      _sd_kit.EntryUnit,
      //      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
      cast(_sd_kit.QuantityInEntryUnit as abap.dec(13,3))                  as QuantityInEntryUnit,
      _sd_kit.CompanyCodeCurrency,
      //     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(_sd_kit.TotalGoodsMvtAmtInCCCrcy as abap.dec(13,2))             as TotalGoodsMvtAmtInCCCrcy,
      _sd_kit.ManufacturingOrder,
      _sd_kit.GoodsMovementType,
      _sd_kit.CreatedBy,
      _sd_kit.CreatedAt,
      _sd_kit.LastChangedBy,
      _sd_kit.LastChangedAt,
      _sd_kit.LocalLastChangedAt,
      //      _sd_kit.SubsequentDocument,
      lpad(cast( _sd_kit.SubsequentDocument as abap.numc( 10 ) ), 10, '0') as SubsequentDocument,

      //_sd_kit.NotaFiscal,
      case when _sd_kit.NotaFiscal is not initial then ltrim( _sd_kit.NotaFiscal, '0' ) else cast('' as abap.char( 10 )) end as NotaFiscal,
       
      //_NfRetorno.BR_NotaFiscal                                             as NfRetorno,
      //_NfRetorno.NfRetorno,
      

      //_NfRetorno.BR_NFeDocumentStatus                                      as NfRetorno_Status,
      _NfRetorno.NfRetorno_Status,
      /*case
      when _NfRetorno.BR_NFeDocumentStatus = '1' then 3 //Vermelho
      when _NfRetorno.BR_NFeDocumentStatus = '2' then 1 //Vermelho
      when _NfRetorno.BR_NFeDocumentStatus = '3' then 1 //Vermelho
      else 0
      end                                                                  as NfRetorno_StatusColor,*/
      _NfRetorno.NfRetorno_StatusColor,
      _sd_kit.vlricms,
      _sd_kit.baseicms,
      _sd_kit.vlricss,
      _sd_kit.baseicss,
      _sd_kit.vlripi,
      _sd_kit.baseipi,
      //      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'

      //sum(cast(_sd_kit._icm3.BR_NFItemTaxAmount as abap.dec(13,2)))             as vlricms,
      //      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'

      //sum(cast(_sd_kit._icm3.BR_NFItemBaseAmount as abap.dec(13,2)))            as baseicms,

      //      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'

      //sum(cast(_sd_kit._ics3.BR_NFItemTaxAmount as abap.dec(13,2)))             as vlricss,
      //      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'

      //sum(cast(_sd_kit._ics3.BR_NFItemBaseAmount as abap.dec(13,2)))            as baseicss,

      //      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'

      //sum(cast(_sd_kit._ipi3.BR_NFItemTaxAmount as abap.dec(13,2)))             as vlripi,
      //      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'

      //sum(cast(_sd_kit._ipi3.BR_NFItemBaseAmount as abap.dec(13,2)))            as baseipi,

      _sd_kit._nf_document.BR_NFeDocumentStatus                             as BR_NFeDocumentStatus,

      //_NfRetorno.BR_NFeDocumentStatus                                      as Nf_Status, inutilizado

      case
      when _sd_kit._nf_document.BR_NFeDocumentStatus = '1' then 3 //Vermelho
      when _sd_kit._nf_document.BR_NFeDocumentStatus = '2' then 1 //Vermelho
      when _sd_kit._nf_document.BR_NFeDocumentStatus = '3' then 1 //Vermelho
      else 0
      end         as BR_NFeDocumentStatusColor,      
      
      _sd_kit._nf_document.BR_NFPostingDate,
      //      @Semantics.amount.currencyCode: 'BR_NFCurrency'
      cast(_sd_kit._nf_document.BR_NFTotalAmount as abap.dec(13,2))        as BR_NFTotalAmount,
      _sd_kit._nf_document.SalesDocumentCurrency                           as BR_NFCurrency,
      _sd_kit.MaterialName_kit,
      _sd_kit.MaterialName_free,
      _DocEstorno.DocEstorno,
      _sd_kit.PediSubc,

      case
      when _DocEstorno.DocEstorno is not initial
      then 1 //Vermelho
      end                                                                  as EstornoColor,
      _ZI_SalesDocumentQuiqkView,
      _I_BR_NFeDocStatusTxt_NF_E,
      _I_BR_NFeDocStatusTxt_NF
}
where
 _sd_kit.PostingDate != '00000000' and
 ( ( _DocEstorno.DocEstorno is not initial and ( _sd_kit.Vbeln is not initial or _sd_kit.NotaFiscal is not initial ) ) or _SemEstorno.SemEstorno = 'X' )
/*group by
  _sd_kit.competencia,
  _sd_kit.Plant,
  _sd_kit.DocKit,
  _sd_kit.MatnrKit,
  _sd_kit.MatnrFree,
  _sd_kit.kunnr,
  _sd_kit.Posnr,
  _sd_kit.Vbeln,
  _sd_kit.PostingDate,
  _sd_kit.matkl,
  _sd_kit.BaseUnit,
  _sd_kit.EntryUnit,
  _sd_kit.QuantityInEntryUnit,
  _sd_kit.CompanyCodeCurrency,
  _sd_kit.TotalGoodsMvtAmtInCCCrcy,
  _sd_kit.ManufacturingOrder,
  _sd_kit.GoodsMovementType,
  _sd_kit.CreatedBy,
  _sd_kit.CreatedAt,
  _sd_kit.LastChangedBy,
  _sd_kit.LastChangedAt,
  _sd_kit.LocalLastChangedAt,
  _sd_kit.SubsequentDocument,
  _sd_kit.NotaFiscal,
  _sd_kit.SubsequentDocument,
  _sd_kit.NotaFiscal,
  _NfRetorno.BR_NotaFiscal,
  _NfRetorno.BR_NFeDocumentStatus,
  //_sd_kit._icm3.BR_NFItemTaxAmount,
  //_sd_kit._icm3.BR_NFItemBaseAmount,
  //_sd_kit._ics3.BR_NFItemTaxAmount,
  //_sd_kit._ics3.BR_NFItemBaseAmount,
  //_sd_kit._ipi3.BR_NFItemTaxAmount,
  //_sd_kit._ipi3.BR_NFItemBaseAmount,
  _sd_kit._nf_document.BR_NFeDocumentStatus,
  _sd_kit._nf_document.BR_NFPostingDate,
  _sd_kit._nf_document.BR_NFTotalAmount,
  _sd_kit._nf_document.SalesDocumentCurrency,
  _sd_kit.MaterialName_kit,
  _sd_kit.MaterialName_free,
  _DocEstorno.DocEstorno,
  _sd_kit._nf_document.BR_NFeDocumentStatus,
  _sd_kit._nf_document.BR_NFPostingDate,
  _sd_kit._nf_document.BR_NFTotalAmount,
  _sd_kit.MaterialName_kit,
  _sd_kit.MaterialName_free,
  _sd_kit.PediSubc*/
