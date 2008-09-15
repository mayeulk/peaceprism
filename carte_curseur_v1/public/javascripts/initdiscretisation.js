/*****************************************************************************
 * Les fonctions qui gerent la discretisation et la constitution de la legende
 * 
 * @author guy
 ****************************************************************************/

discretize = new Array() ; // variable globale, il contiendra les parametres
							// des variables a afficher (valeur, couleur...)
dataset_courant = '';
variable_courante = '';
// le tableau de couleurs discretisees sera genere par une fonction js automatique
tab_couleur = new Array('FFFFFF', '00FF00', '0000FF', 'FFFF00', '00FFFF', 'FF00FF', '000000');
couleurs_pour_disc = new Array('FFF0F0', 'FF0000');
couleur_null = 'C3C3C3';
// fonction qui rempli le tableau discretize en fonction de la variable choisie,
// c'est a dire en fonction des infos recuperees dans le json associe
function initdiscretisation(){

	var varInfo = tab['info'];
	nodata='?'; //'No Data'
	dataset_courant = varInfo['dataset_id'];
	variable_courante = varInfo['var_id'];
	discretize = [] ;
	nbClasses = 0 ;

	// premier cas : variable booleenne : 2 classes (oui/non)
	if (varInfo['format'] == 'boolean'){
		chaine='';
		var disc_var = new Array() ;
		
		// premiere case pour legende des valeurs 'null'
		disc_var['valeur'] = 'null';
		disc_var['couleur'] = couleur_null;
		discretize[0] = disc_var ;	
		
		// chaine de code HTML a injecter : d'abord un lien pour la description de la variable
		var chaine = '<span style="margin-left:10px;"><b>' + varInfo['name'] + 
			'</b></span> : <a href="/variable/' + dataset_courant + '/' + 
			variable_courante + '" id="lien_desc"><img src="/images/icones/description.png" title="description"/></a>';
			
							
		// lien vers le graphique de cette variable 
		chaine += ' <a href="/graph/dis/' + dataset_courant + '/' + 
					variable_courante + '" id="lien_graph"><img src="/images/icones/graphic.png" title="graph"/></a>';
		// chaine : la legende en tant que tel est affichee dans un div independant
		chaine = chaine + '<div id="legende">';
			
		// chaine : premier interval pour les valeurs 'null'		
		chaine = chaine + '<p><input type="text" id="colorfield0" class="colorfields" value="C3C3C3"/><span id="intitule0"> '+nodata+' </span></p>';

		// autres classes
		nbClasses = 2 ;	
		var u=0;	
		for (var i=0; i<2; i++){
			disc_var = [] ;
			chaine += '<p><span id="val' + i+1 + '"></span> <input type="text" class="colorfields" id="colorfield' + (i+1) + '" value="' + tab_couleur[i+1] + '"/><span id="intitule' + i+1 + '">' + i + '</span></p>';
			disc_var['valeur'] = u;
			disc_var['mini'] = u ;
			disc_var['isFirstValue'] = 1 ;			
			disc_var['maxi'] = u ;			
			disc_var['couleur'] = tab_couleur[u+1];
			discretize[i+1] = disc_var ;
			u = u+1 ;			
		}
		chaine += '</div>' ;
		$('cadre_legende').innerHTML = chaine;		

		//...puis avec les valeurs qualitatives

		var varQual = varInfo['var_qual']; // les autres variables qualitatives
		var c=2 ;
		var o=3;
		for (var i in varQual) {
			alert('varqualbool');
			chaine += '<p><span id="val' + o + '">' + i + '</span> <input type="text" class="colorfields" id="colorfield' + o + '" value="' + tab_couleur[c] + '"/><span id="intitule' + o + '">' + varQual[i] + '</span></p>';
			disc_var = [];
			disc_var['valeur'] = i;
			disc_var['mini'] = i;
			disc_var['isFirstValue'] = 1;
			disc_var['maxi'] = i;
			disc_var['couleur'] = tab_couleur[c];
			discretize[o] = disc_var;
			o += 1;
			c += 1;
			nbClasses = nbClasses + 1 ;
		}

				
		// colorpickers associes aux cases
		new Control.ColorPicker(0);
		for (var i=1;2>=i;i++){
			new Control.ColorPicker(i);
		}
	}

	else{ 
		
		// deuxieme cas : variable qualitative pure
		if (varInfo['type'] == 'qualitatif'){
			chaine='';
			var varQual = varInfo['var_qual']; // recuperation du hash des varibles qualitatives

			var disc_var = new Array() ;			
			disc_var['valeur'] = 'null';
			disc_var['couleur'] = couleur_null;
			disc_var['signification'] = nodata ;
			discretize[0] = disc_var ;
			
			// chaine de code HTML a injecter : d'abord un lien pour la description de la variable
			var chaine = '<span style="margin-left:10px;"><b>' + varInfo['name'] + '</b></span> : <a href="/variable/' + dataset_courant + '/' + 
					variable_courante + '" id="lien_desc"><img src="/images/icones/description.png" title="description"/></a>';

			// lien vers le graphique de cette variable 
			chaine += ' <a href="/graph/dis/' + dataset_courant + '/' + 
					variable_courante + '" id="lien_graph"><img src="/images/icones/graphic.png" title="graph"/></a>';

			// chaine : la legende en tant que tel est affichee dans un div independant
			chaine = chaine + '<div id="legende">';
			
			// chaine : premier interval pour les valeurs 'null'
			chaine = chaine + '<p><input type="text" id="colorfield0" class="colorfields" value="C3C3C3"/><span id="intitule0"> '+nodata+' </span></p>';

			var o = 1;
			
			var tr1 = afficherLegendeQual(varQual, tab_couleur, o);
			ch1 = tr1[1] ;
			chaine += ch1 ;			
	
			chaine += '</div>' ;
			
			$('cadre_legende').innerHTML = chaine;
			new Control.ColorPicker(0);
			for (var i=1;nbClasses>=i;i++) {
				new Control.ColorPicker(i);
			}
		}
		else{ 
			
			// troisieme cas : variable qualitative ordonnee
			if (varInfo['type'] == 'qualitatif_ordonne'){
				chaine='';
				var varQualOrdo = varInfo['var_qual_ordo']; // recuperation du hash des varibles qualitatives ord
				var varQual = varInfo['var_qual']; // les autres variables qualitatives
				var valMini = varInfo['mini'];
				var valMaxi = varInfo['maxi'];					

				var disc_var = new Array() ;
				
				disc_var['valeur'] = 'null';
				disc_var['couleur'] = couleur_null;
				disc_var['signification'] = nodata ;
				discretize[0] = disc_var ;	
				
				var nbClas = 0 ;
				for (var i in varQualOrdo){
					nbClas += 1;
				}		
			
				// chaine de code HTML a injecter : d'abord un lien pour la description de la variable
				var chaine = '<span style="margin-left:10px;"><b>' + varInfo['name'] + 
					'</b></span> : <a href="/variable/' + dataset_courant + '/' + 
					variable_courante + '" id="lien_desc"><img src="/images/icones/description.png" title="description"/></a>';
					
				// lien vers le graphique de cette variable 
				chaine += ' <a href="/graph/dis/' + dataset_courant + '/' + 
					variable_courante + '" id="lien_graph"><img src="/images/icones/graphic.png" title="graph"/></a>';
				
				// chaine : la legende en tant que tel est affichee dans un div independant
				chaine = chaine + '<div id="legende">';
				
				chaine = chaine + '<p><input type="text" class="colorfields" id="colorfield0" value="C3C3C3"/><span id="intitule0"> '+nodata+' </span></p>';

				var tab_couleur_discr = chercherCouleursDisc(couleurs_pour_disc[0], couleurs_pour_disc[1], nbClas);
				
				var o = 1;
				
				// remplissage du tableau a envoyer avec les valeurs ordonnees...				
				var tr1 = afficherLegendeQual(varQualOrdo, tab_couleur_discr, o);
				ch1 = tr1[1] ;
				chaine += ch1 ;
				o = tr1[0] ;
				
				//...puis avec les valeurs qualitatives
				var tr2 = afficherLegendeQual(varQual, tab_couleur, o);
				ch2 = tr2[1];
				chaine += ch2 ;
				
				chaine += '</div>' ;
				
				// integration dans le code HTML et association de colorpickers par classe
				$('cadre_legende').innerHTML = chaine;
				new Control.ColorPicker(0);
				for (var i=1;nbClasses>=i;i++) {
					new Control.ColorPicker(i);
				}			
			}
			else{				
				////////////////////////// quatrieme cas : variable quantitative ///////////////////////
				var varQual = varInfo['var_qual'];
				var valMini = varInfo['mini'];
				var valMaxi = varInfo['maxi'];				
				
				// ici il faut ajouter une fonction qui calcule le nombre de classe et leur interval
				// recherche du nb de classes
				var nbCla = chercherNbClasses(valMini, valMaxi, 100) ;
				
				// generer le tableau d'intervals
				var typeDisc = 'equivalence';
				var tabIntervals = chercherIntervals(nbCla, valMini, valMaxi, typeDisc);
				var chaineIntervals = '' ;
				
				for (var elt=1; elt<nbCla - 1; elt+=1) {
					chaineIntervals += tabIntervals[elt] + ';' ;
				}
				chaineIntervals += tabIntervals[elt] ;
								
				for (var i in varQual){
					nbCla += 1;
				}
				var disc_var = new Array() ;
				nbClasses = nbCla ;
				
				// chaine de code HTML a injecter : d'abord un lien pour la description de la variable
				var chaine = '<span style="margin-left:10px;"><b>' + varInfo['name'] + 
					'</b></span> : <a href="/variable/' + dataset_courant + '/' + 
					variable_courante + '" id="lien_desc"><img src="/images/icones/description.png" title="description"/></a> ';
				
				// lien vers le graphique de cette variable 
				chaine += '<a href="/graph/dis/' + dataset_courant + '/' + 
					variable_courante + '" id="lien_graph"><img src="/images/icones/graphic.png" title="graph"/></a><br/>';
				
				// une zone de saisie pour choisir manuellement les intervals
				chaine += ' <span id="vMini">' + valMini + '</span>' +
					'; <input type="text" id="choixIntervals" value="' + chaineIntervals + '"/> ;' + 
					'<span id="vMaxi">' + valMaxi + '</span>' +
					'<button type="button" onclick="afficherLegendeQuant($(\'vMini\').innerHTML + \';\' + ' +
					'$(\'choixIntervals\').value + \';\' + $(\'vMaxi\').innerHTML)">Change</button>' ;
				
				// chaine : la legende en tant que tel est affichee dans un div independant
				chaine = chaine + '<div id="legende">';

				// chaine : une case de legende pour les valeurs 'null'
				chaine += '</div>' ;
				
				$('cadre_legende').innerHTML = chaine;				
				
				afficherLegendeQuant($('vMini').innerHTML + ';' + $('choixIntervals').value + ';' + $('vMaxi').innerHTML);
				
				new Control.ColorPicker(0);
				for (var i=1;i<=nbCla;i++) {
					new Control.ColorPicker(i);
				}								
			}			
		}
	}
	reInit2(parseInt($('choix_annee').innerHTML));
	afficherFrise(old_pays_survole);
}

function afficherLegendeQual (varQual, tab_couleur, o){
	var nbCla = 0 ;

	// ici il faudra integrer la fonction qui genere le tableau de nbCla couleurs				
	for (var i in varQual){
		nbCla += 1;
	}

	nbClasses = nbClasses + nbCla ;	

	//...puis avec les valeurs qualitatives
	var chaine2 = '' ;
	var c=2 ;
	for (var i in varQual) {
		chaine2 += '<p><span id="val' + o + '"> </span> <input type="text" title="click to change color" class="colorfields" id="colorfield' + o +
		  '" value="' + tab_couleur[c-1] + '"/> <a href="/var_label/'+ dataset_courant + "/" + 
		  variable_courante + "/" + i +'" id="intitule' + o + '">' + varQual[i] + ' (' + i + ')</a></p>';
		  
		disc_var = [];
		disc_var['valeur'] = i;
		disc_var['mini'] = i;
		disc_var['isFirstValue'] = 1;
		disc_var['maxi'] = i;
		disc_var['couleur'] = tab_couleur[c-1];
		disc_var['signification'] = varQual[i] ;
		discretize[o] = disc_var;
		o += 1;
		c += 1;
	}
	var truc = new Array() ;
	truc[0] = o ;
	truc[1] = chaine2 ;
	return truc ;
}

function afficherLegendeQuant(choixIntervals){
	var ch = choixIntervals ;
	var reg = new RegExp("[;]+", "g") ;
	var tabCh = ch.split(reg) ;
	
	if (verifierCoherenceIntervals(tabCh) == 0){
		
		nbClasses = tabCh.length - 1 ;
		var tabIntervals = tabCh ;
		
		var tab_couleur_disc = chercherCouleursDisc(couleurs_pour_disc[0], couleurs_pour_disc[1], nbClasses);
		
		// chaine : une case de legende pour les valeurs 'null'
		var chaine3 = '' ;
		discretize = [] ;
		var disc_var = new Array() ;
		
		disc_var['valeur'] = 'null';
		disc_var['couleur'] = couleur_null;
		disc_var['signification'] = nodata;
		discretize[0] = disc_var ;			

		chaine3 = chaine3 + '<p><input type="text" class="colorfields" id="colorfield0" value="C3C3C3"/><span id="intitule0"> '+nodata+' </span></p>';
		var o = 1;
		
		// chaine : premier interval
		chaine3 += '<p><span id="val' + o + '"></span> <input type="text" class="colorfields" id="colorfield' + o + '" value="' + tab_couleur_disc[o] + '"/><span id="intitule' + o + '"> [ ' + tabIntervals[0] + ' - ' + tabIntervals[1] + ' ]</span></p>';
		disc_var =[];
		disc_var['valeur'] = o;
		disc_var['isFirstValue'] = 1 ;
		disc_var['mini'] = tabIntervals[0] ;				
		disc_var['maxi'] = tabIntervals[1] ;				
		disc_var['couleur'] = tab_couleur_disc[o];
		disc_var['signification'] = '';				
		discretize[o] = disc_var ;
			
		o += 1 ;			
		// remplissage du tableau a envoyer et de la chaine avec les intervals de valeurs...
		for (var i=1; i<nbClasses; i++) {
			disc_var =[];
			disc_var['valeur'] = i+1;
			disc_var['isFirstValue'] = 0 ;
			disc_var['mini'] = tabIntervals[i] ;					
			disc_var['maxi'] = tabIntervals[i+1] ;					
			disc_var['couleur'] = tab_couleur_disc[o];
			disc_var['signification'] = '';					
			discretize[o] = disc_var ;
			chaine3 += '<p><span id="val' + o + '"></span> <input type="text" class="colorfields" id="colorfield' + o + '" value="' + tab_couleur_disc[o] + '"/><span id="intitule' + o + '"> ] ' + tabIntervals[i] + ' - ' + tabIntervals[i+1] + ' ]</span></p>';
			
			o += 1 ;
		}
		
		$('legende').innerHTML = chaine3 ;
		new Control.ColorPicker(0);
		for (var i=1;i<=nbClasses;i++) {
			new Control.ColorPicker(i);
		}
		reInit2(annee_en_cours);
		afficherFrise(old_pays_survole);
	} 
	else{
		alert('wrong order of values !') ;
	}
}

function chercherNbClasses(mini, maxi, nbVal){
	return 5 ;
}

function chercherIntervals(nb, mini, maxi, disc){
	// meme amplitude
	if (disc = 'equivalence'){		
		var intervalTotal = maxi - mini ;
		var longInterval = intervalTotal/nb ;
		
		var intervals = new Array() ;
		intervals[0] = mini ;
		for (var i=1; i<nb; i++){
			intervals[i] = mini + i * longInterval ;
		}
		intervals[i] = maxi ;				
	}
	// TODO effectifs egaux (non implemente pour l'instant)
	else if(disc = 'quantiles'){
		varPays = tab['pays'];
		varData = tab['data'];
		varInf = tab['info'];
		
		nbEltParClasse = parseInt(nbPays/nb) ;
		
		var cumul = 0 ;
		var compt = 0 ;
		for (annee in varData){
			for (data in annee){
				if (parseInt(varInf['mini']) <= parseInt(data) <= parseInt(varInf['maxi'])){
					cumul = cumul + parseInt(data);
					compt = compt + 1 ;					
				}
			}
		}
	}
	
	return intervals ;
}

// fonction qui renvoi un tableau de couleurs discretisees
function chercherCouleursDisc(coul1, coul2, nbCla){
	var rgb1 = YAHOO.util.Color.hex2rgb( coul1 );
	var rgb2 = YAHOO.util.Color.hex2rgb( coul2 );
	
	var hsv1 = YAHOO.util.Color.rgb2hsv( rgb1[0], rgb1[1], rgb1[2] );
	var hsv2 = YAHOO.util.Color.rgb2hsv( rgb2[0], rgb2[1], rgb2[2] );
	
	if (hsv1[0] <= hsv2[0]) {
		var diffHue = hsv2[0] * 100 - hsv1[0] * 100;
	}
	else{
		var diffHue = hsv1[0] * 100 - hsv2[0] * 100;
	}
	if (hsv1[1] <= hsv2[1]) {
		var diffSat = hsv2[1] * 100 - hsv1[1] * 100;
	}
	else{
		var diffSat = hsv1[1]*100 - hsv2[1]*100 ;
	}
	if (hsv1[2] <= hsv2[2]) {
		var diffVal = hsv2[2] * 100 - hsv1[2] * 100;
	}
	else{
		var diffVal = hsv1[2]*100 - hsv2[2]*100 ;
	}
	
	var tabHue = new Array();
	var tabSat = new Array();
	var tabVal = new Array();
	var tabCoul = new Array();
	var tabCoul2 = new Array();
	
	for(var i=1; i<=nbCla; i++){
		
		if (hsv1[0]<=hsv2[0]){
			tabHue[i] = parseInt(hsv1[0]*100 + (i-1)*(diffHue/(nbCla-1)));
		}
		else{
			tabHue[i] = parseInt(hsv1[0]*100 - (i-1)*(diffHue/(nbCla-1)));
		}
		if (hsv1[1]<=hsv2[1]){
			tabSat[i] = parseInt(hsv1[1]*100 + (i-1)*(diffSat/(nbCla-1)));
		}
		else{
			tabSat[i] = parseInt(hsv1[1]*100 - (i-1)*(diffSat/(nbCla-1)));
		}
		if (hsv1[2]<=hsv2[2]){
			tabVal[i] = parseInt(hsv1[2]*100 + (i-1)*(diffVal/(nbCla-1)));
		}
		else{
			tabVal[i] = parseInt(hsv1[2]*100 - (i-1)*(diffVal/(nbCla-1)));
		}
		
		tabCoul2 = YAHOO.util.Color.hsv2rgb(tabHue[i]/100, tabSat[i]/100, tabVal[i]/100);
		tabCoul[i] = YAHOO.util.Color.rgb2hex(tabCoul2[0], tabCoul2[1], tabCoul2[2]);
	}

	return tabCoul ;
}

function verifierCoherenceIntervals(tabInter){
	var err = 0 ;
	nbCl = tabInter.length;
	
	for (var i=0; i<(nbCl-1); i++){
		if (parseInt(tabInter[i]) > parseInt(tabInter[i+1])){
			err += 1 ;
		}
		if (tabInter[i].length < 1){
			err += 1 ;
		}	
	}
	return err ;
}
