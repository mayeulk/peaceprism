/*****************************************************************************
 * fonctions d'affichage de formes sur la carte, pour SVG
 * fonctions de zoom et pan pour Firefox
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

rsz=0;
carte_w=600;
carte_h=300;
function resz() { 
	if (rsz==0)     {
		rsz=1; 
		//document.getElementById("navig").style.backgroundColor="red";
		document.getElementById("cadre_carte").className="cadre_carte_rouge";
		document.getElementById("b").src="images/icones/b-r.png";
		document.getElementById("bd").src="images/icones/bd-r.png";
		document.getElementById("bg").src="images/icones/bg-r.png";
		document.getElementById("d").src="images/icones/d-r.png";
		document.getElementById("g").src="images/icones/g-r.png";
		document.getElementById("h").src="images/icones/h-r.png";
		document.getElementById("hd").src="images/icones/hd-r.png";
		document.getElementById("hg").src="images/icones/hg-r.png";
		//document.getElementById("resize").src="images/icones/resize_enfonce.png";
		
	}
	else {
		rsz=0;
		//    document.getElementById("navig").style.backgroundColor="white";
		document.getElementById("cadre_carte").className="cadre_carte";    
		document.getElementById("b").src="images/icones/b.png";
		document.getElementById("bd").src="images/icones/bd.png";
		document.getElementById("bg").src="images/icones/bg.png";
		document.getElementById("d").src="images/icones/d.png";
		document.getElementById("g").src="images/icones/g.png";
		document.getElementById("h").src="images/icones/h.png";
		document.getElementById("hd").src="images/icones/hd.png";
		document.getElementById("hg").src="images/icones/hg.png";
		//document.getElementById("resize").src="images/icones/resize_enfonce.png";
	}
}
//x_org = 60; //milieu d'origine (x)
//y_org = -10 ;//milieu d'origine (y)
x_org = 0; //milieu d'origine (x)
y_org = 0; //milieu d'origine (y)
//w_org = 240 ;//largeur d'origine (???) (sino zoombox incorrecte???!!)
//h_org = 160 ;//hauteur d'origine
//n_x=-130;
//n_y=-80;
w_org=3600;
h_org=1800;


function initzoom()
{
	document.getElementById("monde").setAttributeNS(null,"viewBox","-1800 -900 3600 1800");
	x_org = 0 ;//milieu d'origine (x)
	y_org = 0 ;//milieu d'origine (y)
	w_org=3600;
	h_org=1800;
	
}

function pan(dx,dy)
{
	if (rsz==1) {
		carte_w=carte_w+dx*400;
		carte_h=carte_h+dy*400;
		if (30>carte_w) {carte_w=30}; //ne pas changer la taille si elle est deja� petite
		if (30>carte_h) {carte_h=30}; //NB: "30>" marche mais pas "carte_h inferieur_a� 30" car le parseur xml le prend pour une balise  
		document.getElementById("monde").setAttributeNS(null,"width",carte_w);
		document.getElementById("monde").setAttributeNS(null,"height",carte_h);
		document.getElementById("cadre_carte").style.width=carte_w+"px";
		document.getElementById("cadre_carte").style.height=carte_h+"px";		
	}
	else
	{
		x_org=x_org+dx*(w_org+h_org);
		y_org=y_org+dy*(w_org+h_org);
		n_x=x_org-w_org/2;
		n_y=y_org-h_org/2;
		new_vb = n_x + " " + n_y + " " + w_org + " " + h_org;
		document.getElementById("monde").setAttributeNS(null,"viewBox",new_vb);
		//document.getElementById("nompays").value="x_org:"+x_org+" y_org:"+y_org+" nx:"+n_x+" ny:"+n_y+" w"+w_org+" h"+h_org
		//document.getElementById("nompays").value=new_vb		
	}
}

// fonction de Zoom :
function zoom(facteur)
{
	// en SVG (pour firefox), il faut modifier les parametres de la viewbox associee au groupe "monde"
	w_org=w_org/facteur;
	h_org=h_org/facteur;
	//w_org = w_org*facteur;
	//h_org = h_org*facteur;
	n_x=x_org-w_org/2;
	n_y=y_org-h_org/2;	
	new_vb = n_x + " " + n_y + " " + w_org + " " + h_org;
	document.getElementById("monde").setAttributeNS(null,"viewBox",new_vb);
}