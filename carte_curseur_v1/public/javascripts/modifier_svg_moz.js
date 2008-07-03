/*****************************************************************************
 * fonctions d'affichage de formes sur la carte, pour SVG
 * @author guy
 * 
 ****************************************************************************/

function colorierPays(pays, couleur){
	pays.setAttribute("fill", couleur);
}

function afficherPays(pays){
	pays.setAttribute("visibility", "visible");
}
	
function masquerPays(pays){
	pays.setAttribute("visibility", "hidden");
}

//paysSVG.setAttribute("opacity", "0.5");
//truc.style.visibility = 'visible';
