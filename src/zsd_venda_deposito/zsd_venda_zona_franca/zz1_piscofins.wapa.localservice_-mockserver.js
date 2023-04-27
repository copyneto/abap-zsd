sap.ui.define(["sap/ui/core/util/MockServer"],function(e){"use strict";var t,a="br/com/trescoracoes/cadastropiscofins/cadastropiscofins/",r=a+"localService/mockdata";return{init:function(){var s=jQuery.sap.getUriParameters(),n=jQuery.sap.getModulePath(r)+
,o=jQuery.sap.getModulePath(a+"manifest",".json"),i="ZC_SD_PIS_COFINS",u=s.get("errorType"),c=u==="badRequest"?400:500,p=jQuery.sap.syncGetJSON(o).data,f=p["sap.app"].dataSources,l=f.mainService,d=jQuery.sap.getModulePath(a+l.settings.localUri.replace(".+
xml",""),".xml"),g=/.*\/$/.test(l.uri)?l.uri:l.uri+"/",m=l.settings.annotations;t=new e({rootUri:g});e.config({autoRespond:true,autoRespondAfter:s.get("serverDelay")||1e3});t.simulate(d,{sMockdataBaseUrl:n,bGenerateMissingMockData:true});var y=t.getReque+
sts(),h=function(e,t,a){a.response=function(a){a.respond(e,{"Content-Type":"text/plain;charset=utf-8"},t)}};if(s.get("metadataError")){y.forEach(function(e){if(e.path.toString().indexOf("$metadata")>-1){h(500,"metadata Error",e)}})}if(u){y.forEach(functi+
on(e){if(e.path.toString().indexOf(i)>-1){h(c,u,e)}})}t.start();jQuery.sap.log.info("Running the app with mock data");if(m&&m.length>0){m.forEach(function(t){var r=f[t],s=r.uri,n=jQuery.sap.getModulePath(a+r.settings.localUri.replace(".xml",""),".xml");n+
ew e({rootUri:s,requests:[{method:"GET",path:new RegExp("([?#].*)?"),response:function(e){jQuery.sap.require("jquery.sap.xml");var t=jQuery.sap.sjax({url:n,dataType:"xml"}).data;e.respondXML(200,{},jQuery.sap.serializeXML(t));return true}}]}).start()})}}+
,getMockServer:function(){return t}}});                                                                                                                                                                                                                        