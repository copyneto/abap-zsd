@EndUserText.label: 'Pop-up Ação substituir produto'
@Metadata.allowExtensions: true
define abstract entity ZC_SD_VERIF_UTIL_PRODUTO{
  Material : matnr;     
  Plant    : werks_d;
  Ean : ean11;    
}
