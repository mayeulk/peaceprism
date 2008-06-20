/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

annee_old =2003 // global variable
nb_conflits_old = 0
tab ="" // il faut définir la variable au chargement pour pouvoir y accéder après modification par AJAX.
discretize = new Array() ;
// Any variable that is initialized inside a function using the var keyword will have a local scope. If a variable is initialized inside a function without var, it will have a global scope. A local variable can have the same name as a global variable.
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
// reInit1 est la fonction d'origine, qui pour une date affiche les zones de conflits

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
		//c.value=un_conflit+' '+(window["AN"+val])[un_conflit]; // montre oÃ¹ on en est
	}
	//alert(un_conflit+" sur " + nb_conflits);
	annee_old = val;
	//alert("AprÃ¨s encours/old "+val +" "+annee_old);
	nb_conflits_old = nb_conflits;
}

// fonction reInit2 qui affiche des donnees monadic en 2 classes seulement
 
function reInit2(val, box){
	// val est l'annee, renvoyee par le curseur
	val = Math.round(val);
	$('choix_annee').innerHTML = val;
	$('info_date').innerHTML = val;
	$('info_date').style.left = (($('handle_date_debut').style.left.replace(/px$/, "")) - 15) + 'px';

	// recuperation des donnees a afficher (le tableau de pays et le hash de donnees par dates
	var t_pays = tab['pays'];
	var t_data = tab['data'];
	// le tableau de donnees pour la date selectionnee
	data_year = t_data[val];
	// recuperation des couleurs choisies
	
	coul1 = $('colorfield1').value;
	coul2 = $('colorfield2').value;
	//coul1 = "FF0000"
	//coul2 = "0000FF"
	
	// affichage des donnees sur la carte
	for (k in t_pays) {
		var truc = document.getElementById(t_pays[k]);
		if (data_year[k] == '#') {		// le pays n'existe pas a cette date	
			truc.setAttribute("visibility", "hidden");
			//truc.style.visibility = 'hidden';
		}
		else {
			truc.setAttribute("visibility", 'visible');
			//truc.style.visibility = 'visible';
			if ((data_year[k] == 'null') || (data_year[k] == null)){
				var donne = discretize[0];
				truc.setAttribute("fill", '#' + donne['couleur']); // en gris
			}
			else {
				var nbClas = parseInt($('nbClasses').innerHTML) ;
				var donne = [] ;
				for (var e = 1; e <= nbClas; e++) {
					donne = discretize[e] ;
					if ((parseInt(data_year[k]) <= donne['maxi'])&&(parseInt(data_year[k]) >= donne['mini'])){
						truc.setAttribute("fill", '#'+ donne['couleur']);
					}
				}
			}
		}
	}

}


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */





/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */