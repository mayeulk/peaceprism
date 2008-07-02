 /*********************************************************************************************
 * fonctions pour remettre a jour la carte
 * 
 * @param {Object} val
 * @param {Object} box
 **********************************************************************************************/

annee_old =2003 ; // global variable
annee_en_cours = 1946 ;
nb_conflits_old = 0 ;
sliderDate = null ;
lireFilm = 0 ;
tab =""  ;// il faut definir la variable au chargement pour pouvoir y acceder apres modification par AJAX.
//discretize = new Array() ;
// Any variable that is initialized inside a function using the var keyword will have a local scope. If a variable is initialized inside a function without var, it will have a global scope. A local variable can have the same name as a global variable.
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

// reInit1 est la fonction d'origine, qui pour une date affiche les zones de conflits
// val est l'annee, renvoyee par le curseur
function reInit(val){
	val = Math.round(val);
	// $('choix_annee').innerHTML = val;
	// $('info_date').innerHTML = val;
	// $('info_date').style.left = (($('handle_date_debut').style.left.replace(/px$/, "")) - 15) + 'px';
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

// fonction reInit2, qui met � jour la carte, en fonction des donnees contenues dans 
// le tableau du DOM 'tab', pour l'annee 'val' envoyee par le slider
 
function reInit2(annee){
	// val est l'annee, renvoyee par le curseur
	annee_en_cours = annee ;
	val = Math.round(annee);
	val2 = Math.round(annee);
	$('choix_annee').innerHTML = val;
	$('info_date').innerHTML = val;
	$('info_date').style.left = (($('handle_date_debut').style.left.replace(/px$/, "")) - 15) + 'px';

	// recuperation des donnees a afficher (le tableau de pays et le hash de donnees par dates
	var t_pays = tab['pays'];
	var t_data = tab['data'];
	// le tableau de donnees pour la date selectionnee
	data_year = t_data[val];
	
	// affichage des donnees sur la carte
	//for (k in t_pays) {
	for(k=0; k < t_pays.length; k++){
		var paysSVG = document.getElementById(t_pays[k]);
	
		if (data_year[k] == '#') {		// le pays n'existe pas a cette date
			
			paysSVG.setAttribute("visibility", "hidden");
			//truc.style.visibility = 'hidden';
		}
		else {
			var info = [] ;
			paysSVG.setAttribute("visibility", "visible");
			//paysSVG.setAttribute("opacity", "0.5");
			//truc.style.visibility = 'visible';
			if ((data_year[k] == 'null') || (data_year[k] == null)){
				info = discretize[0] ;
				//paysSVG.setAttribute("fill", "#"+ info['couleur']); // en gris
				// appel de fonction javascript, par exemple:
				// paysSVG.colorierPays("#C3C3C3")
				colorierPays(paysSVG, "#"+ info['couleur']) ;
			}
			else {
				var nbClas = parseInt($('nbClasses').innerHTML) ;
				// var info = [] ;
				for (var e = 0; e <= nbClas; e++) {
					//if (parseInt(data_year[k]) == parseInt($('val' + e).innerHTML)) {
					//	paysSVG.setAttribute("fill", '#' + $('colorfield' + e).value);
					//}
					info = discretize[e] ;
					if (info['isFirstValue'] == 1){
						if ((parseInt(data_year[k]) <= info['maxi'])&&(parseInt(data_year[k]) >= info['mini'])){
							//paysSVG.setAttribute("fill", '#'+ info['couleur']);
							colorierPays(paysSVG, '#' + info['couleur']);
						}
					}
					else{
						if ((parseInt(data_year[k]) <= info['maxi'])&&(parseInt(data_year[k]) > info['mini'])){
							colorierPays(paysSVG, '#' + info['couleur']);
						}
					}
				}
			}
		}
	};
	
	////////////////////////////////////////////////////////////////////
	// affichage des zones de conflits si la case est cochee
	if ($('conflitsAffiche').checked) {
		nb_conflits = (window["AN" + val2]).length;
		$('nompays').innerHTML = nb_conflits;
		
		for (un_conflit = 0; un_conflit < nb_conflits_old; un_conflit++) {
			var svgobj = document.getElementById((window["AN" + annee_old])[un_conflit]);
			document.getElementById((window["AN" + annee_old])[un_conflit]).style.visibility = 'hidden';
		}
		for (un_conflit = 0; un_conflit < nb_conflits; un_conflit++) {
			var svgobj = document.getElementById((window["AN" + val2])[un_conflit]);
			document.getElementById((window["AN" + val2])[un_conflit]).style.visibility = 'visible';
			colorierPays(document.getElementById((window["AN" + val2])[un_conflit]), '#C3C3C3');
			document.getElementById((window["AN" + val2])[un_conflit]).setAttribute("opacity", "0.5");
		}
		annee_old = val2;
		nb_conflits_old = nb_conflits;
	}
}

function film() {
	if (lire_film==1 && 2003 > annee_en_cours){
		
		annee_en_cours = annee_en_cours + 1 ;
		
  		var timer = setTimeout("film()",500);
  		sliderDate.setValue(annee_en_cours);
  		//reInit2(annee_en_cours);
  		
  		//b.value=slider[1].val;
  		
  	}
	else{
		alert(lire_film + '___' + sliderDate.sliderValue)
	}
}
