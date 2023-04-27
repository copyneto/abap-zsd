@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Docnum de entrada e saida'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_DOC_ENTRADA_SAIDA   as select from    j_1bnflin as _NfItem

    left outer join j_1bnfdoc as _NFEntrada on  _NFEntrada.docnum = _NfItem.docnum
                                            and _NFEntrada.direct = '1'

    left outer join j_1bnfdoc as _NFSaida   on _NFSaida.docnum = _NfItem.docnum
                                            and _NFSaida.direct = '2' 

{

  key _NfItem.docnum    as Doc,
  key _NfItem.itmnum    as Item,
      _NFEntrada.docnum as DocEntrada,
      
      case
        when _NFEntrada.docref <> '0000000000' then _NFEntrada.docref
        else _NFSaida.docnum
      end as DocSaida
      
  
    
}
