/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

annee_old =2003 // global variable
nb_conflits_old = 0
// Any variable that is initialized inside a function using the var keyword will have a local scope. If a variable is initialized inside a function without var, it will have a global scope. A local variable can have the same name as a global variable.
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
function reInit(val, box){
	// val est l'annee, renvoyee par le curseur
	val = Math.round(val);
	$('choix_annee').innerHTML = val;
	$('info_date').innerHTML = val;
	$('info_date').style.left = (($('handle_date_debut').style.left.replace(/px$/, "")) - 15) + 'px';
	nb_conflits = (window["AN" + val]).length;
	$('nompays').innerHTML = nb_conflits;
	
	for (un_conflit = 0; un_conflit < nb_conflits_old; un_conflit++) {
		var svgobj = document.getElementById((window["AN" + annee_old])[un_conflit]);
		document.getElementById((window["AN" + annee_old])[un_conflit]).style.visibility = 'hidden';
		//if (annee_old == 1988) {alert((window["AN"+annee_old])[un_conflit])};
	}
	//alert("old:" + un_conflit_old+" sur " + nb_conflits_old);
	
	for (un_conflit = 0; un_conflit < nb_conflits; un_conflit++) {
		var svgobj = document.getElementById((window["AN" + val])[un_conflit]);
		//	svgobj.setAttributeNS(null,'fill','green');
		//svgobj.setAttributeNS(null,'visibility','visible');
		document.getElementById((window["AN" + val])[un_conflit]).style.visibility = 'visible';
		//c.value=un_conflit+' '+(window["AN"+val])[un_conflit]; // montre où on en est
	}
	//alert(un_conflit+" sur " + nb_conflits);
	annee_old = val;
	//alert("Après encours/old "+val +" "+annee_old);
	nb_conflits_old = nb_conflits;
}
function reInit2(val, box){
	// val est l'annee, renvoyee par le curseur
	val = Math.round(val);
	$('choix_annee').innerHTML = val;
	$('info_date').innerHTML = val;
	$('info_date').style.left = (($('handle_date_debut').style.left.replace(/px$/, "")) - 15) + 'px';
	nb_pays = (window["AN" + val]).length;
	//$('nompays').innerHTML = nb_conflits;
	
	//for (un_conflit = 0; un_conflit < nb_conflits_old; un_conflit++) {
	//	var svgobj = document.getElementById((window["AN" + annee_old])[un_conflit]);
	//	document.getElementById((window["AN" + annee_old])[un_conflit]).style.visibility = 'hidden';
		//if (annee_old == 1988) {alert((window["AN"+annee_old])[un_conflit])};
	//}
	//alert("old:" + un_conflit_old+" sur " + nb_conflits_old);
	
	//for (un_pays = 0; un_pays < nb_pays; un_pays++) {
		
		//var svgobj = document.getElementById((window["AN" + val])[un_pays]);
		//	svgobj.setAttributeNS(null,'fill','green');
		//svgobj.setAttributeNS(null,'visibility','visible');
		/////document.getElementById((window["AN" + val])[un_conflit]).style.visibility = 'visible';
		//c.value=un_conflit+' '+(window["AN"+val])[un_conflit]; // montre où on en est
	//}
	annee_en_cours = document.getElementById((window["AN" + val])
	for (un_pays = 0; un_pays < nb_pays; un_pays++) {
		if (annee_en_cours[un_pays].to_f > 5.0) {document.getElementById((window["AN" + val])[un_conflit]).style.fill = 'lightcoral'};
	}
	
	
	//alert(un_conflit+" sur " + nb_conflits);
	annee_old = val;
	//alert("Après encours/old "+val +" "+annee_old);
	nb_conflits_old = nb_conflits;

	//alert( (window["AN"+val]).length);
	//Appeler une variable nommée par un string : ['nomdevariable'] ou window['nom'+'devariable']
	// cf. http://www.thescripts.com/forum/thread89035.html
	/*	
	for (un_pays=0;un_pays<161;un_pays++){
	var svgobj = document.embeds['world_map'].getSVGDocument().getElementById(pays[un_pays]);
	svgobj.setAttributeNS(null,'fill',couleurs[donnees[val-1945][un_pays]-1])
	*/


	//if (un_pays==val) {svgobj.setAttributeNS(null,'fill','#e02948');}
	//else {svgobj.setAttributeNS(null,'fill',couleurs[15- Math.round((val+un_pays)/25)])}
}


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */





/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */