/**
 * @author guy
 */

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
