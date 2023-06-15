@EndUserText.label: 'Get j_1btxic1'
define table function ZTF_SD_REL_FISCAL_SAIDA_TXIC1
returns
{
  Client         : abap.clnt;
  Land1          : land1;
  Shipfrom       : j_1btxshpf;
  Shipto         : j_1btxshpt;
  Validfrom      : j_1btxdatf;
  Rate           : j_1btxrate;
  RateF          : j_1btxratf;
  SpecfRate      : j_1bspecfrate;
  SpecfBase      : j_1bspecfbase;
  PartilhaExempt : j_1bpartexempt;
  SpecfResale    : j_1bspecfresale;

}
implemented by method
  zcl_get_valid_j_1btxic1=>exec_method;
