@AbapCatalog.sqlViewName: 'ZI_ORDPEND'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ordens Pendentes de Atendimento - Seleção'
define view ZI_SD_CKPT_FAT_ORD_PENDENDENTE as select from vbak as _SalesOrder
//    association to vbpa as _SalesOrderPartner on _SalesOrderPartner.vbeln = _SalesOrder.vbeln
    
{
    key _SalesOrder.vbeln,
        _SalesOrder.kunnr,
        _SalesOrder.erdat,
        _SalesOrder.auart,
        _SalesOrder.vkorg,
        _SalesOrder.vtweg,
        _SalesOrder.vkbur,
        _SalesOrder.vkgrp
}
