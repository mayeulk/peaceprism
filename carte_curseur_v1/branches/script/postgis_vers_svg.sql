-- NB: SOUS PGADMIN", POUR EXPORTER LE RESULTAT DE CE FICHIER, CHOISIR LE MENU FICHIER/PREFERENCES/REQUETES
-- PUIS: Nombre max. de caractères par colonne: 100000

-- en tête du fichier .svg
select '<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN"    "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd" [
	  <!ENTITY ns_flows "http://ns.adobe.com/Flows/1.0/">
	  <!ENTITY ns_extend "http://ns.adobe.com/Extensibility/1.0/">
	  <!ENTITY ns_ai "http://ns.adobe.com/AdobeIllustrator/10.0/">
	  <!ENTITY ns_graphs "http://ns.adobe.com/Graphs/1.0/">
	  <!ENTITY ns_vars "http://ns.adobe.com/Variables/1.0/">
	  <!ENTITY ns_imrep "http://ns.adobe.com/ImageReplacement/1.0/">
	  <!ENTITY ns_sfw "http://ns.adobe.com/SaveForWeb/1.0/">
	  <!ENTITY ns_custom "http://ns.adobe.com/GenericCustomNamespace/1.0/">
	  <!ENTITY ns_adobe_xpath "http://ns.adobe.com/XPath/1.0/">
	  <!ENTITY ns_svg "http://www.w3.org/2000/svg">
	  <!ENTITY ns_xlink "http://www.w3.org/1999/xlink">
]>
<svg xmlns:x="&ns_extend;" xmlns:i="&ns_ai;" xmlns:graph="&ns_graphs;" 
     xmlns="&ns_svg;" xmlns:xlink="&ns_xlink;" xmlns:a="http://ns.adobe.com/AdobeSVGViewerExtensions/3.0/"
	 xml:space="preserve" width="950px" height="400px" viewBox="-20 -90 160 160">
	<g>
		<rect x="-200" y="-200" height="400" width="400" fill="#B4DAF6" />' -- la mer en bleu pâle
union all
-- carte du monde en l'an 2000
select  '<path id="' || replace(cntry_name, '&', 'and') -- le caractère "&" plante en svg
|| '" i:knockout="Off" fill="lightgray" stroke="#000000" stroke-width="0.25" d=" '
 || assvg(Scale(Simplify(the_geom,50000),0.00001,0.00001,1),0,1)||'"/>' as svg
-- assvg(Scale(Simplify(the_geom,échelle_de_simplif.),chgmt_echelle_x,chgmt_echelle_y,?),0,1)
-- apparemment, simplifier les frontières joue aussi sur la vitesse de démasquage des zones de conflit
from world where begin<=2000 and term>=2000
union all
-- zones de conflit
select '<g id="conflits" visibility="hidden">'
union all
select  '<path id="lt'::text||lat||'lg'|| lon||'rd'||radius||'" i:knockout="Off" visibility="hidden" fill="lightcoral" opacity=".65"  stroke="firebrick" stroke-width="0.25" d=" '
 || assvg(Scale(Simplify(the_geom,50000),0.00001,0.00001,1),0,1)||'"/>' as svg
--,lat ,  lon ,  radius, confid, assvg(the_geom,0,0)
from conflits_ext
group by lat,lon,radius, the_geom
--order by confid; 
union all
-- queue du fichier .svg
select '</g></g></svg>'
