sap.ui.define(["sap/ui/core/util/MockServer"],function(e){"use strict";var t,r="br/com/trescoracoes/cadastrogrupomercadorias/",a=r+"localService/mockdata";return{init:function(){var o=jQuery.sap.getUriParameters(),n=jQuery.sap.getModulePath(a),s=jQuery.s+
ap.getModulePath(r+"manifest",".json"),i="ZC_SD_GP_MERCADOR",u=o.get("errorType"),c=u==="badRequest"?400:500,p=jQuery.sap.syncGetJSON(s).data,l=p["sap.app"].dataSources,d=l.mainService,f=jQuery.sap.getModulePath(r+d.settings.localUri.replace(".xml",""),"+
.xml"),g=/.*\/$/.test(d.uri)?d.uri:d.uri+"/",m=d.settings.annotations;t=new e({rootUri:g});e.config({autoRespond:true,autoRespondAfter:o.get("serverDelay")||1e3});t.simulate(f,{sMockdataBaseUrl:n,bGenerateMissingMockData:true});var y=t.getRequests(),h=fu+
nction(e,t,r){r.response=function(r){r.respond(e,{"Content-Type":"text/plain;charset=utf-8"},t)}};if(o.get("metadataError")){y.forEach(function(e){if(e.path.toString().indexOf("$metadata")>-1){h(500,"metadata Error",e)}})}if(u){y.forEach(function(e){if(e+
.path.toString().indexOf(i)>-1){h(c,u,e)}})}t.start();jQuery.sap.log.info("Running the app with mock data");if(m&&m.length>0){m.forEach(function(t){var a=l[t],o=a.uri,n=jQuery.sap.getModulePath(r+a.settings.localUri.replace(".xml",""),".xml");new e({root+
Uri:o,requests:[{method:"GET",path:new RegExp("([?#].*)?"),response:function(e){jQuery.sap.require("jquery.sap.xml");var t=jQuery.sap.sjax({url:n,dataType:"xml"}).data;e.respondXML(200,{},jQuery.sap.serializeXML(t));return true}}]}).start()})}},getMockSe+
rver:function(){return t}}});                                                                                                                                                                                                                                  