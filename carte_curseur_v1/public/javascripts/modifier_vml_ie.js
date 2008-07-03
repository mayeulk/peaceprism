/*****************************************************************************
 * fonctions d'affichage des formes sur la carte, pour le VML
 * @author guy
 * 
 ****************************************************************************/

function colorierPays(pays, couleur){
	pays.setAttribute("fillcolor", couleur);
}

function afficherPays(pays){
	pays.style.visibility = 'visible';
}
	
function masquerPays(pays){
	pays.style.visibility = 'hidden';
}

//paysSVG.setAttribute("opacity", "0.5");
