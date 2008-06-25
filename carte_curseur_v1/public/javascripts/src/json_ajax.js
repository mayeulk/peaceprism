/**
 * @author guy et mk
 */

 function requestjson(dataset1, variable1){
 	var xhr_object = null;
 	
 	if (window.XMLHttpRequest) // Firefox 
			xhr_object = new XMLHttpRequest();
		else 
			if (window.ActiveXObject) // Internet Explorer 
				xhr_object = new ActiveXObject("Microsoft.XMLHTTP");
			else { // XMLHttpRequest non supporte par le navigateur 
				alert("Votre navigateur ne supporte pas les objets XMLHTTPRequest...");
				return;
			}
		
		
		var filename = 'json/data6_' + variable1 + '.json';
		var data = null;
				
		data = null;
				
		xhr_object.open("GET", filename, true);
		
		xhr_object.onreadystatechange = function(){
			if (xhr_object.readyState == 4) {
				eval('tab=' + xhr_object.responseText);
				initdiscretisation(); 
				//var tab = xhr_object.responseText.evalJSON();
			}
		}
		
		xhr_object.setRequestHeader("Cache-Control","public");
		xhr_object.send(data);
		
		
	}
 
