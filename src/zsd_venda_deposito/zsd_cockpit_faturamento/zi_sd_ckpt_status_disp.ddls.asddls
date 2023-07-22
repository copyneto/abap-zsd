@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Status disponibilidade estoque'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_STATUS_DISP
  as select from ZI_SD_CKPT_FAT_DISP_ESTOQUE_V2 as _DispEstoque
{
  key _DispEstoque.SalesDocument,
  key _DispEstoque.SalesDocumentItem,

      case when _DispEstoque.MaterialCent <> ''
      then
      case when _DispEstoque.SDProcessStatus = 'C' or _DispEstoque.SaldoLivre > 0
      then cast( 'Disponível' as abap.char(15)  )
      else cast( 'Indisponível' as abap.char(15)  )
      end
      else cast( 'Indisponível' as abap.char(15)  )
      end as Status,

      case when _DispEstoque.MaterialCent <> ''
      then
      case when _DispEstoque.SDProcessStatus = 'C' or _DispEstoque.SaldoLivre > 0
      then 3 //Disponível
      else 1 //Indisponível
      end
      else 1 //Indisponível
      end as ColorStatus,

      case when _DispEstoque.MaterialDF <> ''
      then
      case when _DispEstoque.SaldoDf > 0
      then cast( 'Disponível' as abap.char(15)  )
      else cast( 'Indisponível' as abap.char(15)  )
      end
      else cast( 'Indisponível' as abap.char(15)  )
      end as StatusDf,

      case when _DispEstoque.MaterialDF <> ''
      then
      case when _DispEstoque.SaldoDf > 0
      then 3 //Disponível
      else 1 //Indisponível
      end
      else 1 //Indisponível
      end as ColorStatusDf

}
