/**
 * @author guy
 */

function afficherFrise(actuPays){
	//alert('ici');
	var info = tab['info'];
	var ann = tab['annees'];
	var pays = tab['pays'];
	var data = tab['data'];
	
	var long_annee = 10;
	
	//var actuPays = $('pays2').value ;
	var p = 0 
	while (pays[p] != actuPays){
		p += 1 ;
	}
	
	var tabDataPays = new Array() ;
	var ch = '' ;
	var coul = '';
	var sign = '';
	var c = 0 ;
	
	for (var a=0; a<ann.length; a++){
		tabDataPays[c] = (data[parseInt(ann[a])])[p] ;
		//alert(tabDataPays[c]);
		
		if (tabDataPays[c] == '#') {
			coul = 'FFFFFF';
			sign = 'Country dont exist';
		}
		else {
			if ((tabDataPays[c] == 'null') || (tabDataPays[c] == null)){
				coul = 'C3C3C3' ;
				sign = 'No Data' ;
			}
			else{
		
				for (y = 1; y < discretize.length; y++) {
			
					info = discretize[y] ;
					if (info['isFirstValue'] == 1){
						if ((tabDataPays[c] <= info['maxi'])&&(tabDataPays[c] >= info['mini'])){
							coul = info['couleur'];
							sign = info['signification'];
						}
					}
					else{
						if ((tabDataPays[c] <= info['maxi'])&&(tabDataPays[c] > info['mini'])){
							coul = info['couleur'];
							sign = info['signification'];
						}
					}			
				}
			}
		}
		ch += '<div title="' + ann[a] + ' : ' + sign + '(' + tabDataPays[c] + ')" style="height:20px; width:' + long_annee + 'px;background-color:#' + coul + ';float:left"> </div>' ;
		c +=1 ;
	}
	//alert(tabDataPays);
	$('frise').innerHTML = ch ;
	
	
}
