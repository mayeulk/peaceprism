 /*********************************************************************************************
 * fonctions pour remettre a jour la carte
 * 
 * @param {Object} val
 * @param {Object} box
 **********************************************************************************************/
// variables globales
// il faut definir les variables au chargement pour pouvoir y acceder apres modification par AJAX.
annee_old =2003 ; 
annee_en_cours = 1946 ;
nb_conflits_old = 0 ;
sliderDate = null ;
lireFilm = 0 ;
nbClasses = 0 ;
tab =""  ;

// fonction reInit2, qui met a jour la carte, en fonction des donnees contenues dans 
// le tableau du DOM 'tab', pour l'annee 'annee' envoyee par le slider 
function reInit2(annee){
		
	annee_en_cours = annee ;
		
	// affichage de l'information 'date' sur la page et sur le curseur du slider
	
	$('info_date').style.left = (($('handle_date_debut').style.left.replace(/px$/, "")) - 17) + 'px';
	$('info_date').innerHTML = annee_en_cours; //.toString();
	
//	if ($('variable').value != 0){		
		// recuperation des donnees a afficher (le tableau de pays et le hash de donnees par dates)
		var t_pays = tab['pays'];
		var t_data = tab['data'];
		// le tableau de donnees pour la date selectionnee
		data_year = t_data[annee_en_cours];
		
		// affichage des donnees sur la carte
		//for (k in t_pays) {
		for(k=0; k < t_pays.length; k++){
			var paysSVG = document.getElementById(t_pays[k]);
		
			if (data_year[k] == '#') {		// le pays n'existe pas a cette date
				masquerPays(paysSVG);
			}
			else {				
				var info = [] ;
				afficherPays(paysSVG) ;
				
				if ((data_year[k] == 'null') || (data_year[k] == null)){     // pas de donnees a cette date
					info = discretize[0] ;
					colorierPays(paysSVG, "#"+ info['couleur']) ;
				}
				else {					
					// var nbClas = parseInt($('nbClasses').innerHTML) ;
					for (var e = 1; e <= nbClasses; e++) {
						info = discretize[e] ;
			
						if (info['isFirstValue'] == 1){
							if ((parseInt(data_year[k]) <= info['maxi'])&&(parseInt(data_year[k]) >= info['mini'])){
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
		}
//	}
	
	
	// affichage des zones de conflits si la case est cochee
	if ($('conflitsAffiche').checked) {
		nb_conflits = (window["AN" + annee_en_cours]).length;
		//$('nompays').innerHTML = nb_conflits;
		// effacage des zones de conflits precedentes...
		for (un_conflit = 0; un_conflit < nb_conflits_old; un_conflit++) {
			var svgobj = document.getElementById((window["AN" + annee_old])[un_conflit]);
			document.getElementById((window["AN" + annee_old])[un_conflit]).style.visibility = 'hidden';
		}
		// ...et affichage des nouvelles pour cette date
		for (un_conflit = 0; un_conflit < nb_conflits; un_conflit++) {
			var svgobj = document.getElementById((window["AN" + annee_en_cours])[un_conflit]);
			document.getElementById((window["AN" + annee_en_cours])[un_conflit]).style.visibility = 'visible';
			colorierPays(document.getElementById((window["AN" + annee_en_cours])[un_conflit]), '#A200C3');
			//document.getElementById((window["AN" + annee_en_cours])[un_conflit]).setAttribute("opacity", "0.5");
		}
		annee_old = annee_en_cours;
		nb_conflits_old = nb_conflits;
	}
	else{
		// effacage des zones de conflits precedentes...
		for (un_conflit = 0; un_conflit < nb_conflits_old; un_conflit++) {
			var svgobj = document.getElementById((window["AN" + annee_old])[un_conflit]);
			document.getElementById((window["AN" + annee_old])[un_conflit]).style.visibility = 'hidden';
		}
		annee_old = annee_en_cours;
		nb_conflits_old = 0;
	}
}

// la fonction film incremente l'annee toutes les demi-secondes ; en
// incrementant le slider, la carte se met-a-jour automatiquement
function film() {
	if (lire_film==1 && 2003 > annee_en_cours){		
		annee_en_cours = annee_en_cours + 1 ;
		
  		var timer = setTimeout("film()",500);
  		sliderDate.setValue(annee_en_cours);  		
  	}
}
