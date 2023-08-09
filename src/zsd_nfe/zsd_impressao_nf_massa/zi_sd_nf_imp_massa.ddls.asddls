@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Impressão NF-e e MDF-e'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_NF_IMP_MASSA
  as select from j_1bnfdoc as _Doc

  association [0..1] to ZI_IMP_NOTAFISCAL_MASSA_SCR as _Items on  _Items.Docnum = _Doc.docnum
  association [0..1] to j_1bnfe_event  as _Event on  _Event.docnum    = _Doc.docnum
                                                 and _Event.int_event = 'EV_CCE'
                                                 and (
                                                    _Event.code       = '100'
                                                    or _Event.code    = '135'
                                                  )

{
  key _Doc.docnum               as Docnum,
      _Doc.direct               as Direct,
      @EndUserText.label: 'Ordem de Frete'
      _Items.Tor_id             as TorId,
      _Items.StopOrder          as StopOrder,      
      _Doc.credat               as Credat,
      //      model  as Model,
      case _Doc.model
      when '55' then 'NF-e'
      when '58' then 'MDF-e'
      else ' '
      end                       as Model,
      _Doc.parid                as Parid,
      _Doc.nfenum               as Nfenum,
      _Doc.printd               as Printd,
      case _Doc.printd
      when 'X' then 3
      when ' ' then 1
      else 0
      end                       as Criticality,
      _Items.Belnr              as Contabilizado,
      case _Items.Belnr
      when ' ' then 1
      else 3
      end                       as Criticality_c,
      _Doc.branch               as Branch,
      _Items.Werks              as Werks,
      _Doc.code                 as Code,
      _Doc.name1                as Name1,
      //      _Doc.stras     as Stras,
      _Doc.ort01                as Ort01,

      @EndUserText.label: 'Carta de Correção'
      case _Event.code
      when '100' then 'X'
      when '135' then 'X'
      else ''
          end                   as CCe,
      cast( '' as abap.char(4)) as Printer,
      _Items,
      _Event

}

where
       _Doc.cancel  <> 'X'
  and(
       _Doc.model   =  '55' -- NF-e
    or _Doc.model   =  '58' -- MDF-e
  )
  and(
       _Items.Vbtyp <> 'N'  -- Estorno de fatura
    or _Items.Fkart <> 'S1' -- Estorno de fatura
  )
