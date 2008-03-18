-- NB: SOUS PGADMIN", POUR EXPORTER LE RESULTAT DE CE FICHIER, CHOISIR LE MENU FICHIER/PREFERENCES/REQUETES
-- PUIS: Nombre max. de caracteres par colonne: 100000

-- en tete du fichier .svg
drop table tmp;
create table tmp as
(
select '<svg id="monde" xmlns:svg="http://www.w3.org/2000/svg" xmlns="http://www.w3.org/2000/svg" version="1.0" width="600" height="400" viewBox="-130 -85 300 200" stroke-linejoin="round" stroke-linecap="round"><rect x="-200" y="-200" height="400" width="400" fill="#B4DAF6" />"<path id="lt23.5lg121rd200"  visibility="hidden" fill="lightcoral" opacity=".65"  stroke="firebrick" stroke-width="0.25" onmousedown="survol_zone(this.id);" d=" M 2 -0 2 0.4 1.8 0.8 1.7 1.1 1.4 1.4 1.1 1.7 0.8 1.8 0.4 2 0 2 -0.4 2 -0.8 1.8 -1.1 1.7 -1.4 1.4 -1.7 1.1 -1.8 0.8 -2 0.4 -2 -0 -2 -0.4 -1.8 -0.8 -1.7 -1.1 -1.4 -1.4 -1.1 -1.7 -0.8 -1.8 -0.4 -2 0 -2 0.4 -2 0.8 -1.8 1.1 -1.7 1.4 -1.4 1.7 -1.1 1.8 -0.8 2 -0.4 2 -0 "/><path id="lt25lg-14rd500"  visibility="hidden" fill="lightcoral" opacity=".65"  stroke="firebrick" stroke-width="0.25" onmousedown="survol_zone(this.id);" d=" M 5 0 4.9 1 4.6 1.9 4.2 2.8 3.5 3.5 2.8 4.2 1.9 4.6 1 4.9 0 5 -1 4.9 -1.9 4.6 -2.8 4.2 -3.5 3.5 -4.2 2.8 -4.6 1.9 -4.9 1 -5 0 -4.9 -1 -4.6 -1.9 -4.2 -2.8 -3.5 -3.5 -2.8 -4.2 -1.9 -4.6 -1 -4.9 0 -5 1 -4.9 1.9 -4.6 2.8 -4.2 3.5 -3.5 4.2 -2.8 4.6 -1.9 4.9 -1 5 0 "/><path id="lt1.5lg10rd100"  visibility="hidden" fill="lightcoral" opacity=".65"  stroke="firebrick" stroke-width="0.25" onmousedown="survol_zone(this.id);" d=" M 1 -0 1 0.2 0.9 0.4 0.8 0.6 0.7 0.7 0.6 0.8 0.4 0.9 0.2 1 0 1 -0.2 1 -0.4 0.9 -0.6 0.8 -0.7 0.7 -0.8 0.6 -0.9 0.4 -1 0.2 -1 -0 -1 -0.2 -0.9 -0.4 -0.8 -0.6 -0.7 -0.7 -0.6 -0.8 -0.4 -0.9 -0.2 -1 0 -1 0.2 -1 0.4 -0.9 0.6 -0.8 0.7 -0.7 0.8 -0.6 0.9 -0.4 1 -0.2 1 -0 "/><path id="lt39.75lg19.75rd50"  visibility="hidden" fill="lightcoral" opacity=".65"  stroke="firebrick" stroke-width="0.25" onmousedown="survol_zone(this.id);" d=" M 0.5 -0 0.5 0.1 0.5 0.2 0.4 0.3 0.4 0.4 0.3 0.4 0.2 0.5 0.1 0.5 0 0.5 -0.1 0.5 -0.2 0.5 -0.3 0.4 -0.4 0.4 -0.4 0.3 -0.5 0.2 -0.5 0.1 -0.5 -0 -0.5 -0.1 -0.5 -0.2 -0.4 -0.3 -0.4 -0.4 -0.3 -0.4 -0.2 -0.5 -0.1 -0.5 0 -0.5 0.1 -0.5 0.2 -0.5 0.3 -0.4 0.4 -0.4 0.4 -0.3 0.5 -0.2 0.5 -0.1 0.5 -0 "/><path id="lt-51.77lg-59.99rd300"  visibility="hidden" fill="lightcoral" opacity=".65"  stroke="firebrick" stroke-width="0.25" onmousedown="survol_zone(this.id);" d=" M 3 0 2.9 0.6 2.8 1.1 2.5 1.7 2.1 2.1 1.7 2.5 1.1 2.8 0.6 2.9 -0 3 -0.6 2.9 -1.1 2.8 -1.7 2.5 -2.1 2.1 -2.5 1.7 -2.8 1.1 -2.9 0.6 -3 0 -2.9 -0.6 -2.8 -1.1 -2.5 -1.7 -2.1 -2.1 -1.7 -2.5 -1.1 -2.8 -0.6 -2.9 -0 -3 0.6 -2.9 1.1 -2.8 1.7 -2.5 2.1 -2.1 2.5 -1.7 2.8 -1.1 2.9 -0.6 3 0 "/>'
 -- la mer en bleu pale
union all
-- carte du monde en l'an 2000, d'abord les grands pays, tres simplifies
select  '<path id="' || replace(cntry_name, '&', 'and') -- le caractere "&" plante en svg
||'" fill="lightgray" stroke="#000000" stroke-width="0.25" onmousedown="survol_zone(this.id);" d=" '
 || assvg(Scale(Simplify(the_geom, 10000),0.00001,0.00001,1),0,1)||'"/>' as svg
-- assvg(Scale(Simplify(the_geom,echelle_de_simplif.),chgmt_echelle_x,chgmt_echelle_y,?),0,1)
-- apparemment, simplifier les frontieres joue aussi sur la vitesse de demasquage des zones de conflit
from world where (world.begin<=2000 and world.end>=2000) and (area2d(the_geom)/1000000)>2000
union all
-- les petits pays, avec une assez bonne precision
select  '<path id="' || replace(cntry_name, '&', 'and')
||'" fill="lightgray" stroke="#000000" stroke-width="0.1" onmousedown="survol_zone(this.id);" d=" '
 || assvg(Scale (the_geom,0.00001,0.00001,1),0,1)||'"/>' as svg
from world where (world.begin<=2000 and world.end>=2000) and (area2d(the_geom)/1000000)<=2000
union all
-- zones de conflit
select '<g id="conflits" visibility="hidden">'
union all

select  '<path id="lt'::text||lat||'lg'|| lon||'rd'||radius||'" visibility="hidden" fill="lightcoral" opacity=".65"  stroke="firebrick" stroke-width="0.25" onmousedown="survol_zone(this.id);" d=" '
 || assvg(Scale(Simplify(the_geom, 10000),0.00001,0.00001,1),0,1)||'"/>' as svg
--,lat ,  lon ,  radius, confid, assvg(the_geom,0,0)
from conflits_ext
group by lat,lon,radius, the_geom
--order by confid; 
union all
-- queue du fichier .svg
select '"</g></svg>'
);
copy tmp to '/home/commun/ecole/REC/PRISM/tmp/guy_carte_moz.svg';
-- copy tmp to '/home/gtokarski/guy_carte_moz.rhtml';