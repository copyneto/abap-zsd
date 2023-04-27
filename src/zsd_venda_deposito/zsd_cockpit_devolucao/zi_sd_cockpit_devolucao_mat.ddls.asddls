@EndUserText.label: 'Cockpit Devolução Material'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_SD_COCKPIT_DEVOLUCAO_MAT 
as select from mean as _Material 
association to makt as _Texto on _Texto.matnr = $projection.Material 
                             and _Texto.spras = $session.system_language {
key _Material.matnr as Material,
key _Material.meinh as UnMedida,
key _Material.lfnum as Sequencial, 
    _Material.ean11 as Ean,
    _Texto.maktx    as TextoMaterial
    
}
