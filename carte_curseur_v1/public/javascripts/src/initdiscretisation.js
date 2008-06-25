/**
 * @author guy
 */
	//var chaine='';
  function initdiscretisation(){
	// le tableau de couleurs discretisees sera genere par une fonction js automatique
	var tab_couleur_disc = new Array('FFFFFF', 'FFD2D2', 'FF9999', 'FF0000');
	var tab_couleur = new Array('FFFFFF', 'FF0000', '00FF00', '0000FF', 'FFFF00', '00FFFF', '000000');
	var varInfo = tab['info'];
	$('typeVar').innerHTML = varInfo['type'];
	$('formatVar').innerHTML = varInfo['format'];
	
	// premier cas : variable booleenne : 2 classes (oui/non)
	if (varInfo['format'] == 'boolean'){
		chaine='';
		$('nbClasses').innerHTML = 2;
		var disc_var = new Array() ;
		for (var i = 0; 2>i ; i++){
			chaine += '<p><span id="val' + i+1 + '">'+ i +'</span> <input type="text" id="colorfield' + (i+1) + '" value="0000FF"/></p>';
			disc_var['valeur'] = i;
			disc_var['mini'] = i ;
			disc_var['min_inclu'] = 1 ;
			disc_var['maxi'] = i ;
			disc_var['max_inclu'] = 1 ;
			disc_var['couleur'] = tab_couleur[i];
			discretize[i] = disc_var ;
		}
		$('colorClasses').innerHTML = chaine;
		
		for (var i=0;2>i;i++){
			new Control.ColorPicker("colorfield" + (i+1));
		}
	}

	else{ 
		// deuxieme cas : variable qualitative pure
		if (varInfo['type'] == 'qualitatif'){
			chaine='';
			var varQual = varInfo['var_qual']; // recuperation du hash des varibles qualit
			var nbCla = 0 ;
			for (var i in varQual){
				nbCla += 1;
			}
			var disc_var = new Array() ;
			$('nbClasses').innerHTML = nbCla;
			var o = 1;
			for (var i in varQual) {
				chaine += '<p><span id="val' + o + '">'+ i +'</span> <input type="text" class="colorfields" id="colorfield' + o + '" value="' + tab_couleur[o] + '"/><span id="intitule' + o + '">' + varQual[i] + '</span></p>';
				disc_var =[];
				disc_var['valeur'] = i;
				disc_var['mini'] = i ;
				disc_var['min_inclu'] = 1 ;
				disc_var['maxi'] = i ;
				disc_var['max_inclu'] = 1 ;
				disc_var['couleur'] = tab_couleur[o];				
				discretize[o-1] = disc_var ;
				o += 1 ;
			}
			//$('colorClasses').innerHTML = "zut encore";
			$('colorClasses').innerHTML = chaine;
			for (var i=1;nbCla>=i;i++) {
				new Control.ColorPicker("colorfield" + i);
			}
		}
		else{ 
			// troisieme cas : variable qualitative ordonnee
			if (varInfo['type'] == 'qualitatif_ordonne'){
				chaine='';
				var varQualOrdo = varInfo['var_qual_ordo']; // recuperation du hash des varibles qualitatives ord
				var varQualSpe = varInfo['var_qual_spe']; // les autres variables qualitatives
				var valMini = varInfo['mini'];
				var valMaxi = varInfo['maxi'];				
				
				var nbCla = 0 ;
				for (var i in varQualOrdo){
					nbCla += 1;
				}
				
				// ici il faudra integrer la fonction qui genere le tableau de nbCla couleurs
				
				for (var i in varQualSpe){
					nbCla += 1;
				}

				var disc_var = new Array() ;
				$('nbClasses').innerHTML = nbCla;
				var o = 1;
				
				// remplissage du tableau a envoyer avec les valeurs ordonnees...
				for (var i in varQualOrdo) {
					chaine += '<p><span id="val' + o + '">'+ i +'</span> <input type="text" id="colorfield' + o + '" value="' + tab_couleur_disc[o] + '"/><span id="intitule' + o + '">' + varQualOrdo[i] + '</span></p>';
					disc_var =[];
					disc_var['valeur'] = i;
					disc_var['mini'] = i ;
					disc_var['min_inclu'] = 1 ;
					disc_var['maxi'] = i ;
					disc_var['max_inclu'] = 1 ;
					disc_var['couleur'] = tab_couleur_disc[o];				
					discretize[o-1] = disc_var ;
					o += 1 ;
				}
				
				//...puis avec les valeurs qualitatives
				var c=2 ;
				for (var i in varQualSpe) {
					chaine += '<p><span id="val' + o + '">'+ i +'</span> <input type="text" id="colorfield' + o + '" value="' + tab_couleur[c] + '"/><span id="intitule' + o + '">' + varQualSpe[i] + '</span></p>';
					disc_var =[];
					disc_var['valeur'] = i;
					disc_var['mini'] = i ;
					disc_var['min_inclu'] = 1 ;
					disc_var['maxi'] = i ;
					disc_var['max_inclu'] = 1 ;
					disc_var['couleur'] = tab_couleur[c];				
					discretize[o-1] = disc_var ;
					o += 1 ;
					c += 1 ;
				}

			
				$('colorClasses').innerHTML = chaine;
				for (var i=1;nbCla>=i;i++) {
					new Control.ColorPicker("colorfield" + i);
				}
				
			
			}
			else{
				// quatrieme cas : variable quantitative
				chaine='';
			}
			
		}
	}


	reInit2(parseInt($('choix_annee').innerHTML),1);
  }
