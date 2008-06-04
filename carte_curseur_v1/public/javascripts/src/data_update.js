/**
 * @author guy
 */
//
function changerDonnees (request){
	tab = request.responseText.evalJSON();
	//tab = eval('(' + request + ')')
	//$('essai').innerHTML = tab

	//$('essai').innerHTML = tab ;
	
	// pour afficher le tableau 2D
	
/*
	tab.each(function(tab, index){
		new Insertion.Bottom("essai", "<br/>" + tab);
	});

*/	
	// pour afficher la requete data

/*

	tab.each(function(tab, index){
		new Insertion.Bottom("essai", "<br/>" + tab.year + " - " +
		tab.ccode + " - " +
		tab.data);
	});

*/


	
	//definir les variables
	//executer reinitialisation deplacement de curseur
	
}
