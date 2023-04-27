@AbapCatalog.sqlViewName: 'ZVSDKBONORDERVW'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'SalesDocument Quick View'
define view ZI_SD_KIT_BON_ORDER_VIEW as select from I_SalesDocument {
    
       @UI.facet: [ {
                purpose:    #QUICK_VIEW,
                type:       #FIELDGROUP_REFERENCE,
                targetQualifier: 'SalesDocumentQV',
                label: 'Ordem'
              }
            ]

  key  SalesDocument


}
    
