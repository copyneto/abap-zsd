@AbapCatalog.sqlViewName: 'ZVWSDPARC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Busca parceiro da nota'
define view ZI_SD_BUSCA_PARCEIRO
  as select distinct from  j_1bnfdoc  as _doc
  //  left outer join j_1bnfnad      as _nad on _doc.docnum = _nad.docnum

    left outer to one join j_1bbranch as J_1BBRANCH on  j_1bbranch.bukrs  = substring(
      _doc.parid, 1, 4
    )
                                                    and j_1bbranch.branch = substring(
      _doc.parid, 5, 8
    )
    left outer join        kna1       as _kna1      on _kna1.kunnr = _doc.parid

    left outer join        lfa1       as _lfa1      on _lfa1.lifnr = _doc.parid

    left outer join        j_1bnfcpd  as _j_1bnfcpd on _j_1bnfcpd.docnum = _doc.docnum


{
  key _doc.docnum,
      _doc.parid,

      case
        when _doc.partyp = 'B'
          then j_1bbranch.icmstaxpay
        when _doc.partyp = 'C'
          then _kna1.icmstaxpay
        else
           _lfa1.icmstaxpay
      end as icmstaxpay,

      case
        when _doc.partyp = 'B'
          then j_1bbranch.indtyp
        when _doc.partyp = 'C'
          then _kna1.indtyp
        else
           _lfa1.indtyp
      end as indtyp,


      case
        when _doc.partyp = 'B'
          then j_1bbranch.state_insc
        when _doc.partyp = 'C'
          then _kna1.stcd3
        else
           _lfa1.stcd3
      end as stcd3,

      case
        when _doc.partyp = 'B'
          then j_1bbranch.stcd2
        when _doc.partyp = 'C'
          then 
          
            case 
                when _kna1.stcd2 is initial or _kna1.stcd2 is null
                    then _j_1bnfcpd.stcd2
                else _kna1.stcd2 
            end
            
        else
           _lfa1.stcd2
      end as stcd2

}
