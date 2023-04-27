define abstract entity ZI_SD_TYPE_VAL_SAVE_UPLOAD
{
  FileDirectory                : abap.string(256);
  GuidDocument                 : abap.char( 32 );
  Processo                     : ze_processo;
  TipoOperacao                 : bsark;
  CentroOrigem                 : werks_ext;
  DepositoOrigem               : lgort_d;
  CentroDestino                : uname;
  DepositoDestino              : lgort_d;
  CentroReceptor               : werks_d;
  Incoterms                    : ze_tpfrete;
  TipoExpedicao                : vsarttr;
  CondicaoExpedicao            : vsbed;
  AgenteFrete                  : kunnr;
  Motorista                    : kunnr;
  Placa                        : traid;
  PlacaSemiReboque1            : traid;
  PlacaSemiReboque2            : traid;
  PlacaSemiReboque3            : traid;
  ID3Cargo                     : ze_idsaga;
  OrganizacaoCompras           : ekorg;
  GrupoCompradores             : ekgrp;
  RemessaTranferenciaDevolucao : vbeln_vl;
  UtilizacaoGraoVerde          : abrvw;
  Fracionado                   : ze_fracionado;
  Material                     : matnr;
  UnidadeBase                  : meins;
  @Semantics.quantity.unitOfMeasure : 'UnidadeBase'
  Quantidade                   : nsdm_stock_qty;
}
