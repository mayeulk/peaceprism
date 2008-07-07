/*****************************************************************************
 * Les fonctions qui gerent la discretisation et la constitution de la legende
 * 
 * @author guy
 ****************************************************************************/

discretize = new Array() ; // variable globale, il contiendra les parametres
							// des variables a afficher (valeur, couleur...)

// fonction qui rempli le tableau discretize en fonction de la variable choisie,
// c'est a dire en fonction des infos recuperees dans le json associe
function initdiscretisation(){
	// le tableau de couleurs discretisees sera genere par une fonction js automatique
	var tab_couleur_disc = new Array('FFFFFF', 'FFEEEE', 'FFD2D2', 'FFBBBB', 'FF9999', 'FF0000');
	var tab_couleur = new Array('FFFFFF', 'FF0000', '00FF00', '0000FF', 'FFFF00', '00FFFF', '000000');
	var varInfo = tab['info'];
	$('typeVar').innerHTML = varInfo['type'];
	$('formatVar').innerHTML = varInfo['format'];
	
	// premier cas : variable booleenne : 2 classes (oui/non)
	if (varInfo['format'] == 'boolean'){
		chaine='';
		var disc_var = new Array() ;
		
		// premiere case pour legende des valeurs 'null'
		disc_var['valeur'] = 'null';
		disc_var['couleur'] = 'C3C3C3';
		discretize[0] = disc_var ;			
		var chaine = '<p>0<input type="text" id="colorfield0" class="colorfields" value="C3C3C3"/><span id="intitule0"> No Data </span></p>';

		// autres classes
		$('nbClasses').innerHTML = nbCla;
		nbClasses = 2 ;		
		for (var i = 0; 2>i ; i++){
			chaine += '<p><span id="val' + i+1 + '">'+ i +'</span> <input type="text" class="colorfields" id="colorfield' + (i+1) + '" value="0000FF"/></p>';
			disc_var['valeur'] = i;
			disc_var['mini'] = i ;
			disc_var['isFirstValue'] = 1 ;			
			disc_var['maxi'] = i ;			
			disc_var['couleur'] = tab_couleur[i];
			discretize[i+1] = disc_var ;
		}
		$('colorClasses').innerHTML = chaine;
		

		//...puis avec les valeurs qualitatives
		var varQual = varInfo['var_qual']; // les autres variables qualitatives
		var c=2 ;
		
		for (var i in varQual) {
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
			var nbCla = 0 ;
			for (var i in varQual){
				nbCla += 1;
			}
			var disc_var = new Array() ;			
			disc_var['valeur'] = 'null';
			disc_var['couleur'] = 'C3C3C3';
			discretize[0] = disc_var ;			

			$('nbClasses').innerHTML = nbCla;
			nbClasses = nbCla ;
			var chaine = '<p>0<input type="text" id="colorfield0" class="colorfields" value="C3C3C3"/><span id="intitule0"> No Data </span></p>';

			var o = 1;
			for (var i in varQual) {
				chaine += '<p><span id="val' + o + '">'+ i +'</span> <input type="text" class="colorfields" id="colorfield' + o + '" value="' + tab_couleur[o] + '"></input><span id="intitule' + o + '">' + varQual[i] + '</span></p>';
				disc_var =[];
				disc_var['valeur'] = i;
				disc_var['mini'] = i ;
				disc_var['isFirstValue'] = 1 ;				
				disc_var['maxi'] = i ;				
				disc_var['couleur'] = tab_couleur[o];				
				discretize[o] = disc_var ;
				o += 1 ;
			}
			$('colorClasses').innerHTML = chaine;
			new Control.ColorPicker(0);
			for (var i=1;nbCla>=i;i++) {
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
				
				var nbCla = 0 ;
				for (var i in varQualOrdo){
					nbCla += 1;
				}
				
				// ici il faudra integrer la fonction qui genere le tableau de nbCla couleurs				
				for (var i in varQual){
					nbCla += 1;
				}

				var disc_var = new Array() ;
				
				disc_var['valeur'] = 'null';
				disc_var['couleur'] = 'C3C3C3';
				discretize[0] = disc_var ;			

				$('nbClasses').innerHTML = nbCla;
				nbClasses = nbCla ;
				var chaine = '<p>0<input type="text" class="colorfields" id="colorfield0" value="C3C3C3"/><span id="intitule0"> No Data </span></p>';

				var o = 1;
				
				// remplissage du tableau a envoyer avec les valeurs ordonnees...
				for (var i in varQualOrdo) {
					chaine += '<p><span id="val' + o + '">'+ i +'</span> <input type="text" class="colorfields" id="colorfield' + o + '" value="' + tab_couleur_disc[o] + '"/><span id="intitule' + o + '">' + varQualOrdo[i] + '</span></p>';
					disc_var =[];
					disc_var['valeur'] = i;
					disc_var['mini'] = i ;
					disc_var['isFirstValue'] = 1 ;					
					disc_var['maxi'] = i ;					
					disc_var['couleur'] = tab_couleur_disc[o];				
					discretize[o] = disc_var ;
					o += 1 ;
				}
				//...puis avec les valeurs qualitatives
				var c=2 ;
				for (var i in varQual) {
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
				}
				
				// integration dans le code HTML et association de colorpickers par classe
				$('colorClasses').innerHTML = chaine;
				new Control.ColorPicker(0);
				for (var i=1;nbCla>=i;i++) {
					new Control.ColorPicker(i);
				}			
			}
			else{
				////////////////////////// quatrieme cas : variable quantitative ///////////////////////
				var varQual = varInfo['var_qual'];
				var valMini = varInfo['mini'];
				var valMaxi = varInfo['maxi'];				
				
				// ici il faut ajouter une fonction qui calcule le nombre de classe et leur interval
				var intervalTotal = valMaxi - valMini ;
				
				var nbCla = 5 ;
				var longInterval = intervalTotal/nbCla ;
				
				var tabIntervals = new Array() ;
				tabIntervals[0] = valMini ;
				for (var i=1; i<nbCla; i++){
					tabIntervals[i] = valMini + i * longInterval ;
				}
				tabIntervals[i] = valMaxi ;
				// ici il faudra integrer la fonction qui genere le tableau de nbCla couleurs
				
				for (var i in varQual){
					nbCla += 1;
				}
				var disc_var = new Array() ;
							
				disc_var['valeur'] = 'null';
				disc_var['couleur'] = 'C3C3C3';
				discretize[0] = disc_var ;			

				$('nbClasses').innerHTML = nbCla;
				nbClasses = nbCla ;
				var chaine = '<p>0<input type="text" class="colorfields" id="colorfield0" value="C3C3C3"/><span id="intitule0"> No Data </span></p>';
				var o = 1;
				
				// premier interval
				chaine += '<p><span id="val' + o + '">'+ o +'</span> <input type="text" class="colorfields" id="colorfield' + o + '" value="' + tab_couleur_disc[o] + '"/><span id="intitule' + o + '"> [ ' + tabIntervals[0] + ' - ' + tabIntervals[1] + ' ]</span></p>';
				disc_var =[];
				disc_var['valeur'] = o;
				disc_var['isFirstValue'] = 1 ;
				disc_var['mini'] = tabIntervals[0] ;				
				disc_var['maxi'] = tabIntervals[1] ;				
				disc_var['couleur'] = tab_couleur_disc[o];				
				discretize[o] = disc_var ;
					
				o += 1 ;			
				// remplissage du tableau a envoyer avec les intervals de valeurs...
				for (var i=1; i<nbCla; i++) {
					disc_var =[];
					disc_var['valeur'] = i;
					disc_var['isFirstValue'] = 0 ;
					disc_var['mini'] = tabIntervals[i] ;					
					disc_var['maxi'] = tabIntervals[i+1] ;					
					disc_var['couleur'] = tab_couleur_disc[o];				
					discretize[o] = disc_var ;
					chaine += '<p><span id="val' + o + '">'+ o +'</span> <input type="text" class="colorfields" id="colorfield' + o + '" value="' + tab_couleur_disc[o] + '"/><span id="intitule' + o + '"> ] ' + tabIntervals[i] + ' - ' + tabIntervals[i+1] + ' ]</span></p>';
					
					o += 1 ;
				}
				
				//...puis avec les valeurs qualitatives				
				var c = 2;
				for (var i in varQual) {
					disc_var = [];
					disc_var['valeur'] = i;
					disc_var['isFirstValue'] = 1;
					disc_var['mini'] = i;
					disc_var['maxi'] = i;
					disc_var['couleur'] = tab_couleur[c];
					discretize[o - 1] = disc_var;
					chaine += '<p><span id="val' + o + '">' + i + '</span> <input type="text" id="colorfield' + o + '" value="' + tab_couleur[c] + '"/><span id="intitule' + o + '">' + varQual[i] + '</span></p>';
					
					o += 1;
					c += 1;
				}
		
				$('colorClasses').innerHTML = chaine;
				new Control.ColorPicker(0);
				for (var i=1;i<=nbCla;i++) {
					new Control.ColorPicker(i);
				}								
			}			
		}
	}

	reInit2(parseInt($('choix_annee').innerHTML));
  }
