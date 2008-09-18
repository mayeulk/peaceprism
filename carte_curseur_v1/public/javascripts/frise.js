/**
 * @author guy
 */
old_pays_survole="CZ19461993"; //var. globale

// fonction reflexe sur clic d'un pays : appel de la fonction afficherFrise()
function survol_zone(pays_survole) {
	pays_survole=pays_survole;
	document.getElementById(pays_survole).setAttribute("stroke-width", "2");
	document.getElementById(old_pays_survole).setAttribute("stroke-width", "0.25");
	ti = document.getElementById(pays_survole).getAttribute("title") ;
	document.getElementById("pays2").value=ti;//pays_survole;
	afficherFrise(pays_survole);
	old_pays_survole=pays_survole;        }
	function curseurPays(val, box) {var b=document.getElementById('output'+box);val=Math.round(val);
	b.value=val;
	//toggle_layer_number(val);
}
	
	
function afficherFrise(actuPays){
	var countrydoesnotexist = 'Country does not exist'
	if (tab != "") {	
		var info = tab['info'];
		var ann = tab['annees'];
		var pays = tab['pays'];
		var data = tab['data'];		
		var long_annee = 10;		
		var p = 0
		
		while (pays[p] != actuPays) {
			p += 1;
		}
		
		var tabDataPays = new Array();
		var ch = '';
		var coul = '';
		var sign = '';
		var c = 0;
		
		for (var a = 0; a < ann.length; a++) {
			tabDataPays[c] = (data[parseInt(ann[a])])[p];
						
			if (tabDataPays[c] == '#') {
				coul = 'FFFFFF';
				sign = countrydoesnotexist;
			}
			else {
				if ((tabDataPays[c] == 'null') || (tabDataPays[c] == null)) {
					var info2 = discretize[0];
					coul = info2['couleur'];
					sign = info2['signification'];
				}
				else {
					for (var y = 1; y < discretize.length; y++) {
						var info2 = discretize[y];
						if (info2['isFirstValue'] == 1) {
							if ((parseInt(tabDataPays[c]) <= parseInt(info2['maxi'])) && (parseInt(tabDataPays[c]) >= parseInt(info2['mini']))) {
								coul = info2['couleur'];
								sign = info2['signification'];
							}
						}
						else {
							if ((parseInt(tabDataPays[c]) <= parseInt(info2['maxi'])) && (parseInt(tabDataPays[c]) > parseInt(info2['mini']))) {
								coul = info2['couleur'];
								sign = info2['signification'];
							}
						}
					}
				}
			}
			ch += '<div title="' + ann[a] + ' : ' + sign + ' (' + tabDataPays[c] + ')" style="height:20px; width:' + long_annee + 'px;background-color:#' + coul + ';float:left"> </div>';
			c += 1;
		}
		//alert(tabDataPays);
		$('frise').innerHTML = ch;
		
	}
}
