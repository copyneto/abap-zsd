sap.ui.define([],function(){"use strict";return{ExibirHistorico:function(e){var a=this.extensionAPI.getSelectedContexts();var t=[];var r=[];var i=[];for(let e=0;e<a.length;e++){t[e]=a[e].getObject().SalesOrder;r[e]=a[e].getObject().Remessa;i[e]=a[e].getO+
bject().NotaFiscal}sap.ushell.Container.getService("CrossApplicationNavigation").isNavigationSupported([{target:{shellHash:"histagendamento-display?SalesOrder="+t+",Remessa="+r+",DocNum="+i}}]).done(function(e){e.map(function(e,a){if(e.supported===true){+
var s=sap.ushell&&sap.ushell.Container&&sap.ushell.Container.getService("CrossApplicationNavigation").hrefForExternal({target:{semanticObject:"histagendamento",action:"display"},params:{SalesOrder:t,Remessa:r,DocNum:i}});sap.m.URLHelper.redirect(s,false)+
}else{alert("Usuário sem permissão para acessar o link")}})}).fail(function(){alert("Falha ao acessar o link")})},ExibirOcorrencia:function(e){var a=this.extensionAPI.getSelectedContexts();var t=a[0].getObject().OrdemFrete;sap.ushell.Container.getService+
("CrossApplicationNavigation").isNavigationSupported([{target:{shellHash:"FreightOrder-displayRoad?FreightOrder="+t}}]).done(function(e){e.map(function(e,a){if(e.supported===true){var r=sap.ushell&&sap.ushell.Container&&sap.ushell.Container.getService("C+
rossApplicationNavigation").hrefForExternal({target:{semanticObject:"FreightOrder",action:"display"},params:{FreightOrder:t}});sap.m.URLHelper.redirect(r,false)}else{alert("Usuário sem permissão para acessar o link")}})}).fail(function(){alert("Falha ao +
acessar o link")})},ExibirOcorrencia:function(e){var a=this.extensionAPI.getSelectedContexts();var t=a[0].getObject().OrdemFrete;sap.ushell.Container.getService("CrossApplicationNavigation").isNavigationSupported([{target:{shellHash:"FreightOrder-display+
Road?FreightOrder="+t}}]).done(function(e){e.map(function(e,a){if(e.supported===true){var r=sap.ushell&&sap.ushell.Container&&sap.ushell.Container.getService("CrossApplicationNavigation").hrefForExternal({target:{semanticObject:"FreightOrder",action:"dis+
play"},params:{FreightOrder:t}});sap.m.URLHelper.redirect(r,false)}else{alert("Usuário sem permissão para acessar o link")}})}).fail(function(){alert("Falha ao acessar o link")})},ExibirCabecalho:function(e){var a=this.extensionAPI.getSelectedContexts();+
var t=[];for(let e=0;e<a.length;e++){t[e]=a[e].getObject().SalesOrder}sap.ushell.Container.getService("CrossApplicationNavigation").isNavigationSupported([{target:{shellHash:"ckptagendamento-display?SalesOrder="+t}}]).done(function(e){e.map(function(e,a)+
{if(e.supported===true){var r=sap.ushell&&sap.ushell.Container&&sap.ushell.Container.getService("CrossApplicationNavigation").hrefForExternal({target:{semanticObject:"ckptagendamento",action:"display"},params:{SalesOrder:t}});sap.m.URLHelper.redirect(r,f+
alse)}else{alert("Usuário sem permissão para acessar o link")}})}).fail(function(){alert("Falha ao acessar o link")})}}});                                                                                                                                     