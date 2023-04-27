@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Aprovadores do Workflow por Time'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_WORKFLOW_APRV
  as select from I_RespyMgmtTeamHeaderDetail as _Team
    inner join   P_RespyMgmtTeamDetail       as _Bp  on _Team.RespyMgmtTeamID = _Bp.RespyMgmtTeamID
    inner join   but0id                      as _But on _Bp.RespyMgmtBusinessPartner = _But.partner
    inner join   pa0105                      as _Pa  on  _But.idnumber = _Pa.pernr
                                                     and _Pa.usrty     = '0001'
{
  _Team.RespyMgmtTeamID        as TeamId,
  _Team.TeamName,
  _Bp.RespyMgmtBusinessPartner as BusinessPartner,
  _But.idnumber,  
  _Pa.usrid

}
