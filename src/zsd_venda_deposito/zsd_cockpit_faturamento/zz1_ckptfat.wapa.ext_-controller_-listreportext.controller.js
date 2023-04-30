sap.ui.define(["sap/ui/model/Filter","sap/ui/model/FilterOperator","sap/m/MessageToast","sap/ui/comp/smartfilterbar/SmartFilterBar"],function(e,a,t){"use strict";return sap.ui.controller("br.com.trescoracoes.cockpitfaturamento.ext.controller.ListReportEx+
t",{onInitSmartFilterBarExtension:function(e){var a=new Date;var t=a.toLocaleDateString();var r=t.replace(/\//g,".");var s=r+"-23:59:59";var o={DataLiberacao:{ranges:[{exclude:false,operation:"BT",keyField:"DataLiberacao",value1:"00.00.0000-00:00:00",val+
ue2:s}]}};var l=e.getSource();l.setFilterData(o)},onConsultaDisponibilidade:function(r){var s=this.extensionAPI.getSelectedContexts();var o=[];var l=[];var n=[];var i=[];var u=0;var c=0;var p=0;for(let e=0;e<s.length;e++){o[e]=s[e].getObject().SalesOrder+
}var d="/sap/opu/odata/SAP/ZC_SD_CKPT_FAT_FILTRO_DIP_CDS/";var f=[];var v=[];var g=new sap.ui.model.odata.v2.ODataModel(d,{json:true,loadMetadataAsync:true});for(let t=0;t<o.length;t++){f.push(new e("SalesDocument",a.EQ,o[t]))}v=new e({filters:f,and:fals+
e});g.read("/BuscaMaterialSet",{filters:[v],success:function(e,a){for(let a=0;a<e.results.length;a++){if(!l.includes(e.results[a].Material)&&e.results[a].Material!=null&&e.results[a].Material!=undefined&&e.results[a].Material!=""){l[u]=e.results[a].Mater+
ial;u++}if(!n.includes(e.results[a].Plant)&&e.results[a].Plant!=null&&e.results[a].Plant!=undefined&&e.results[a].Plant!=""){n[c]=e.results[a].Plant;c++}if(!i.includes(e.results[a].StorageLocation)&&e.results[a].StorageLocation!=null&&e.results[a].Storag+
eLocation!=undefined&&e.results[a].StorageLocation!=""){i[p]=e.results[a].StorageLocation;p++}}sap.ushell.Container.getService("CrossApplicationNavigation").isNavigationSupported([{target:{shellHash:"verifdisp-create"}}]).done(function(e){e.map(function(+
e,a){if(e.supported===true){var t=sap.ushell&&sap.ushell.Container&&sap.ushell.Container.getService("CrossApplicationNavigation").hrefForExternal({target:{semanticObject:"verifdisp",action:"create"},params:{Material:l,Plant:n,Deposito:i}});sap.m.URLHelpe+
r.redirect(t,false)}else{alert("Usuário sem permissão para acessar o link")}})}).fail(function(){alert("Falha ao acessar o link")});sap.m.URLHelper.redirect(href_funcao,true)},error:function(e){t.show("Todos os itens estão concluídos!")}})},onEmissaoNF:f+
unction(r){var s=this.extensionAPI.getSelectedContexts();var o=[];var l=[];var n=[];var i=[];var u=[];var c=0;var p=0;var d=0;var f=0;for(let e=0;e<s.length;e++){o[e]=s[e].getObject().SalesOrder}var v="/sap/opu/odata/SAP/ZC_SD_CKPT_FAT_FILTRO_ARM_CDS/";v+
ar g=[];var m=[];var h=new sap.ui.model.odata.v2.ODataModel(v,{json:true,loadMetadataAsync:true});for(let t=0;t<o.length;t++){g.push(new e("SalesDocument",a.EQ,o[t]))}m=new e({filters:g,and:false});h.read("/BuscaMaterialSet",{filters:[m],success:function+
(e,a){for(let a=0;a<e.results.length;a++){if(!l.includes(e.results[a].Material)&&e.results[a].Material!=null&&e.results[a].Material!=undefined&&e.results[a].Material!=""){l[c]=e.results[a].Material;c++}if(!n.includes(e.results[a].Plant)&&e.results[a].Pla+
nt!=null&&e.results[a].Plant!=undefined&&e.results[a].Plant!=""){n[p]=e.results[a].Plant;p++}if(!i.includes(e.results[a].centrofaturamento)&&e.results[a].centrofaturamento!=null&&e.results[a].centrofaturamento!=undefined&&e.results[a].centrofaturamento!=+
""){i[d]=e.results[a].centrofaturamento;d++}if(!u.includes(e.results[a].StorageLocation)&&e.results[a].StorageLocation!=null&&e.results[a].StorageLocation!=undefined&&e.results[a].StorageLocation!=""){u[f]=e.results[a].StorageLocation;f++}}sap.ushell.Con+
tainer.getService("CrossApplicationNavigation").isNavigationSupported([{target:{shellHash:"retArmaz-manage"}}]).done(function(e){e.map(function(e,a){if(e.supported===true){var t=sap.ushell&&sap.ushell.Container&&sap.ushell.Container.getService("CrossAppl+
icationNavigation").hrefForExternal({target:{semanticObject:"retArmaz",action:"manage"},params:{EANType:"00",Material:l,CentroDestino:n,CentroOrigem:i,DepositoDestino:u,DepositoOrigem:u}});sap.m.URLHelper.redirect(t,false)}else{alert("Usuário sem permiss+
ão para acessar o link")}})}).fail(function(){alert("Falha ao acessar o link")});sap.m.URLHelper.redirect(href_funcao,true)},error:function(e){t.show("Todos os itens estão concluídos!")}})},onRecusarOrdem:function(e){var a=this.extensionAPI.getSelectedCo+
ntexts();var t=[];var r=[];var s=[];for(let e=0;e<a.length;e++){if(a[e].getObject().StatusDeliveryBlockReason=="Pendente"){sap.m.MessageToast.show("Impossível recusar, pedido sem liberação comercial");return}t[e]=a[e].getObject().SalesOrder;r[e]=a[e].get+
Object().Plant;s[e]=a[e].getObject().SalesOrganization}sap.ushell.Container.getService("CrossApplicationNavigation").isNavigationSupported([{target:{shellHash:"sdmotivorecitem-change"}}]).done(function(e){e.map(function(e,a){if(e.supported===true){var o=+
sap.ushell&&sap.ushell.Container&&sap.ushell.Container.getService("CrossApplicationNavigation").hrefForExternal({target:{semanticObject:"sdmotivorecitem",action:"change"},params:{SalesOrder:t,Plant:r,SalesOrganization:s}});sap.m.URLHelper.redirect(o,fals+
e)}else{alert("Usuário sem permissão para acessar o link")}})}).fail(function(){alert("Falha ao acessar o link")});sap.m.URLHelper.redirect(href_funcao,true)}})});                                                                                            