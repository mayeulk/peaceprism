/**
 * @author guy et mk
 */
// requete ajax qui charge le tableau JSON de la variable choisie en memoire du
// navigateur, puis appel initdiscretisation pour creer la legende (puis afficher...)
function requestjson(dataset1, variable1){
 	var xhr_object = null;
 	
 	if (window.XMLHttpRequest) { 
		// Firefox 
		xhr_object = new XMLHttpRequest();
	}
	else {
		if (window.ActiveXObject) {
			// Internet Explorer 
			xhr_object = new ActiveXObject("Microsoft.XMLHTTP");
		}
		else { // XMLHttpRequest non supporte par le navigateur 
			alert("Votre navigateur ne supporte pas les objets XMLHTTPRequest...");
			return;
		}
	}
		
	var filename = 'json/data'+ dataset1 +'_' + variable1 + '.json';
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

// requete ajax qui charge le tableau JSON pour un pays clique : DYADIC
// puis recharge la carte par reInit2()	
function requestjson_dyadic(pays){
 	var pays_choisi = pays
	var dataset_choisi = dataset_courant
	var variable_choisie = variable_courante
 	var xhr_object = null;
 	
 	if (window.XMLHttpRequest) // Firefox 
		xhr_object = new XMLHttpRequest();
	else {
		if (window.ActiveXObject) // Internet Explorer 
			xhr_object = new ActiveXObject("Microsoft.XMLHTTP");
		else { // XMLHttpRequest non supporte par le navigateur 
			alert("Votre navigateur ne supporte pas les objets XMLHTTPRequest...");
			return;
		}
	}		
		
	var filename = 'json/data'+ dataset_choisi +'_' + variable_choisie + '_' + pays_choisi + '.json';
	var data = null;
	data = null;
			
	xhr_object.open("GET", filename, true);
	
	xhr_object.onreadystatechange = function(){
		if (xhr_object.readyState == 4) {
			eval('tab=' + xhr_object.responseText);
			reInit2(annee_en_cours);
			//initdiscretisation(); 
			//var tab = xhr_object.responseText.evalJSON();
		}
	}
		
	xhr_object.setRequestHeader("Cache-Control","public");
	xhr_object.send(data);		
}