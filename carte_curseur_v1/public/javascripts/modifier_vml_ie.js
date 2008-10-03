/*****************************************************************************
 * fonctions d'affichage des formes sur la carte, pour le VML
 * fonctions de zoom et pan pour Internet Explorer
 * @author guy
 * 
 ****************************************************************************/

function colorierPays(pays, couleur){
	pays.setAttribute("fillcolor", couleur);
}

function afficherPays(pays){
	pays.style.visibility = "visible";
}
	
function masquerPays(pays){
	pays.style.visibility = "hidden";
}

rsz=0;
carte_w=600;
carte_h=300;
function resz() { 
	if (rsz==0)     {
		rsz=1; 
		//w = document.getElementById("cadre_carte").style.width;
		//h = document.getElementById("cadre_carte").style.height;
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
		document.getElementById("cadre_carte").style.width = 600;
		document.getElementById("cadre_carte").style.height = 300;
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

x_org = -1800 ;//
y_org = -900 ;//
w_org = 600 ;//largeur d'origine (???) (sino zoombox incorrecte???!!)
h_org = 300 ;//hauteur d'origine
n_x=0;
n_y=0;

function initzoom()
{
	x_org = -1800 ;//milieu d'origine (x) (bof)
	y_org = -900; //milieu d'origine (y) (bof)
	w_org = 600; //largeur d'origine (???) (sino zoombox incorrecte???!!)
	h_org = 300; //hauteur d'origine
	n_x=0;
	n_y=0;
	document.getElementById("monde").style.left=n_x+"px";
	document.getElementById("monde").style.top=n_y+"px";
	document.getElementById("monde").style.width=w_org+"px";
	document.getElementById("monde").style.height=h_org+"px";
}

function pan(dx,dy)
{
	if (rsz==1) {		
		carte_w=carte_w+dx*400 ;
		carte_h=carte_h+dy*400 ;
		//view_w=view_w
		if (30>carte_w) {carte_w=30}; //ne pas changer la taille si elle est deja� petite
		if (30>carte_h) {carte_h=30};
		
		document.getElementById("cadre_carte").style.width=carte_w+"px";
		document.getElementById("cadre_carte").style.height=carte_h+"px";

		document.getElementById("monde").style.width=carte_w+"px";
		document.getElementById("monde").style.height=carte_h+"px";
		
	}
	else
	{
	n_x=n_x+dx*(x_org);
	n_y=n_y+dy*(y_org);
	document.getElementById("monde").style.left=n_x+"px";
	document.getElementById("monde").style.top=n_y+"px";
	//document.getElementById("nompays").value="nx:"+n_x+" ny:"+n_y+" w"+w_org+" h"+h_org
	}
}

// fonction de Zoom :
function zoom(facteur)
{
	// en VML, il faut modifier les attributs width et height du groupe "monde"
	w_org=Math.round(w_org*facteur);
	h_org=Math.round(h_org*facteur);
	
	n_x=Math.round(facteur*n_x+(1-facteur)*carte_w/2);
	n_y=Math.round(facteur*n_y+(1-facteur)*carte_h/2);
	//n_x = Math.round(n_x + carte_w/2 + 1/facteur*carte_w)
	//n_y = Math.round(n_y + carte_h/2 + 1/facteur*carte_h)
	
	document.getElementById("monde").style.left=n_x+"px";
	document.getElementById("monde").style.top=n_y+"px";
	document.getElementById("monde").style.width=w_org+"px";
	document.getElementById("monde").style.height=h_org+"px";
	//document.getElementById("monde").coordorigin=n_x+","+n_y;
	//document.getElementById("monde").coordsize=w_org+","+h_org;
}

