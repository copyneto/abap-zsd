@AbapCatalog.sqlViewName: 'ZVSDTPATO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS - Ato Concessório'
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define root view ZI_SD_NFE_TPATO as select from ztsd_nfe_tpato 
    association to t023t as _TextGrpMerc on  _TextGrpMerc.matkl = $projection.Matkl
                                        and _TextGrpMerc.spras = $session.system_language
                                        
    association to I_MaterialText as _MaterialText on  _MaterialText.Material = $projection.Matnr
                                                   and _MaterialText.Language = $session.system_language
    
    association to ZI_SD_VH_TPATO as _TpAto on _TpAto.TPATO = $projection.TpAto
                                  
    association to j_1bbrancht as _Brancht on _Brancht.branch = $projection.Branch  
                                          and _Brancht.language = $session.system_language                           
    
{       @ObjectModel.text.element: ['BranchtDesc']
    key branch as Branch,
    key opint as Opint,
        @ObjectModel.text.element: ['GrpMercDesc']
    key matkl as Matkl,
        @ObjectModel.text.element: ['MaterialDesc']
    key matnr as Matnr,
        @ObjectModel.text.element: ['TpAtoDesc']
        tpato as TpAto,
        atcon as Atcon,
        text1 as Text1,
        
        _Brancht.name as BranchtDesc,
        _TextGrpMerc.wgbez as GrpMercDesc,
        _MaterialText.MaterialName as MaterialDesc,
        _TpAto.Descricao as TpAtoDesc,
        
        @Semantics.user.createdBy: true
        created_by            as CreatedBy,
    
        @Semantics.systemDateTime.createdAt: true
        created_at            as CreatedAt,
    
        @Semantics.user.lastChangedBy: true
        last_changed_by       as LastChangedBy,
    
        @Semantics.systemDateTime.lastChangedAt: true
        last_changed_at       as LastChangedAt,
    
        @Semantics.systemDateTime.localInstanceLastChangedAt: true
        local_last_changed_at as LocalLastChangedAt
}
