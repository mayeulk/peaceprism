/**
 * @author guy
 */
function request01(f){
	var liste1 = f.elements["datasets2"];
	var liste2 = f.elements["variable2"];
	var datChoisi = liste1.value;
	var varChoisie = liste2.value;
	
	var xhr_object = null;
	if(window.XMLHttpRequest)// firefox
		xhr_object = new XMLHttpRequest();
	else if(window.ActiveXObject)//IE
		xhr_object = new ActiveXObject("Microsoft.XMLHTTP");
	else { // XMLHttpRequest non supporté par le navigateur
		alert("Votre navigateur ne supporte pas les objets XMLHTTPRequest...");
		return;
	}
	xhr_object.open("GET", "/json/data6-8.json", true);
	
	xhr_object.onreadystatechange = function() { 
	    if(xhr_object.readyState == 4) 
		alert(datChoisi + varChoisie);
	         //eval(xhr_object.responseText); 
	    } 
		
	//alert(datChoisi + varChoisie);
	
}


 function requestjson(dataset, variable){
 	var xhr_object = null;
 	
 	if (window.XMLHttpRequest) // Firefox 
			xhr_object = new XMLHttpRequest();
		else 
			if (window.ActiveXObject) // Internet Explorer 
				xhr_object = new ActiveXObject("Microsoft.XMLHTTP");
			else { // XMLHttpRequest non supporté par le navigateur 
				alert("Votre navigateur ne supporte pas les objets XMLHTTPRequest...");
				return;
			}
		
		
		var filename = 'essai.js';
		var data = null;
		
		
		data = null;
		
		
		xhr_object.open("GET", filename, true);
		
		xhr_object.onreadystatechange = function(){
			if (xhr_object.readyState == 4) {
				alert("essai");
				eval('tab=' + xhr_object.responseText); 
				//var tab = xhr_object.responseText.evalJSON();
			}
		}
		
		xhr_object.setRequestHeader("Cache-Control","public");
		xhr_object.send(data);
		
		
	}
 
