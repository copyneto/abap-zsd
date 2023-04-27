@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Seleciona CNPJ e notas fiscais devolução'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_NOTA_FISCAIS
  as select from    ZI_SD_NOTA_FISCAIS_DEVOLUCAO as _Negocio
    left outer join ZI_SD_CFOP_NFE               as _NfeCliente on  _NfeCliente.TipoNfe       = '1'
                                                                and (
                                                                   _NfeCliente.NfeNormal      = '1'
                                                                   or _NfeCliente.NfeNormal   = '4'
                                                                 )
                                                                and _NfeCliente.Centro        = _Negocio.Centro
    //                                  and _NfeCliente.CnpjDest  = _Negocio.CnpjDest
                                                                and _NfeCliente.ChavePrimaria is null

    left outer join ZI_SD_CHAVE_ACESSO_NF_3C     as _Nfe3C      on  _Nfe3C.Centro2      = _Negocio.Centro
                                                                and _Nfe3C.CodFiscal    = _Negocio.CodFiscal
                                                                and _Nfe3C.CodMunicipal = _Negocio.CodMunicipal
                                                                and _Nfe3C.Cnae         = _Negocio.Cnae

  //    left outer join ZI_SD_CHAVE_ACESSO_NF_B2C    as _NfeB2C     on  _NfeB2C.Centro3 = _Negocio.Centro

{
  key  _Negocio.Centro       as Centro,

  key  case
  when _NfeCliente.TpDevolucao = '1'
  then _NfeCliente.CnpjEmissor
  else _Nfe3C.Cnpj2
  end                        as CnpjCliente,

       //  key
       //  case
       //  when _NfeCliente.TpDevolucao = '1'
       //  then _NfeCliente.TpDevolucao
       //  when _NfeCliente.TpDevolucao = ' '
       //  then _Nfe3C.TpDevolucao2
       //  else '3'
       //  end  as TpDevolucao,

  key  case
       when _NfeCliente.TpDevolucao = '1'
       then _NfeCliente.DtSaidaNfe
       else ''
       end                   as DtSaidaNfe,

       _Negocio.LocalNegocio as LocalNegocio,
       _Negocio.Empresa      as Empresa,
       _Negocio.LocalNegCnpj as LocalNegCnpj,

       case
       when _NfeCliente.TpDevolucao = '1'
       then _NfeCliente.CnpjDest
       else ''
       end                   as CnpjDest,

       case
       when _NfeCliente.TpDevolucao = '1'
       then _NfeCliente.ChaveAcesso
       else  _Nfe3C.ChaveAcesso2
       end                   as ChaveAcesso,

       case
       when _NfeCliente.TpDevolucao = '1'
       then _NfeCliente.Nfe
       else _Nfe3C.Nfe2
       end                   as Nfe,

       case
       when _NfeCliente.TpDevolucao = '1'
       then _NfeCliente.Serie
       else _Nfe3C.Serie2
       end                   as Serie,

       case
       when _NfeCliente.TpDevolucao = '1'
       then _NfeCliente.DataEmissao
       else _Nfe3C.DataEmissao2
       end                   as DataEmissao,

       case
       when _NfeCliente.TpDevolucao = '1'
       then _NfeCliente.Cliente
       else _Nfe3C.Cliente2
       end                   as Cliente,

       case
       when _NfeCliente.TpDevolucao = '1'
       then _NfeCliente.NomeCliente
       else _Nfe3C.NomeCliente2
       end                   as NomeCliente,

       case
       when _NfeCliente.TpDevolucao = '1'
       then _NfeCliente.CodMoeda
       else _Nfe3C.Moeda2
       end                   as CodMoeda,

       @Semantics.amount.currencyCode: 'CodMoeda'
       case
       when _NfeCliente.TpDevolucao = '1'
       then cast( _NfeCliente.ValorTotal as abap.dec( 15, 2 ))
       else cast( _Nfe3C.ValorTotal2  as abap.dec( 15, 2 ))
       end                   as ValorTotal,

       case
       when _NfeCliente.TpDevolucao = '1'
       then _NfeCliente.DescriOperacao
       else ''
       end                   as DescriOperacao,

       case
       when _NfeCliente.TpDevolucao = '1'
       then _NfeCliente.GuiOperacao
       end                   as GuiOperacao


       // Tipo Devolução 3
       //       _NfeB2C.TpDevolucao3,
       //       _NfeB2C.Nfe3,
       //       _NfeB2C.Serie3,
       //       _NfeB2C.Centro3,
       //       _NfeB2C.Cnpj3,
       //       _NfeB2C.Moeda3,
       //       @Semantics.amount.currencyCode: 'Moeda3'
       //       _NfeB2C.ValorTotal3,
       //       _NfeB2C.DataEmissao3,
       //       _NfeB2C.Cliente3,
       //       _NfeB2C.NomeCliente3,
       //       _NfeB2C.ChaveAcesso3

}
where
      _Negocio.LocalNegocio <> ' '
  and _Negocio.Empresa      <> ' '
