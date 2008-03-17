-- NB: SOUS PGADMIN", POUR EXPORTER LE RESULTAT DE CE FICHIER, CHOISIR LE MENU FICHIER/PREFERENCES/REQUETES
-- PUIS: Nombre max. de caractères par colonne: 100000

-- en tete du fichier .svg
drop table tmp;
create table tmp as
(
select '<svg id="monde" xmlns:svg="http://www.w3.org/2000/svg" xmlns="http://www.w3.org/2000/svg" version="1.0" width="600" height="400" viewBox="-130 -85 300 200" stroke-linejoin="round" stroke-linecap="round">
<rect x="-200" y="-200" height="400" width="400" fill="#B4DAF6" />"' -- la mer en bleu pale
union all
-- carte du monde en l'an 2000
select  '<path id="' || replace(cntry_name, '&', 'and') -- le caractere "&" plante en svg
||'" fill="lightgray" stroke="#000000" stroke-width="0.25" d=" '
 || assvg(Scale(Simplify(the_geom, 10000),0.00001,0.00001,1),0,1)||'"/>' as svg
-- assvg(Scale(Simplify(the_geom,echelle_de_simplif.),chgmt_echelle_x,chgmt_echelle_y,?),0,1)
-- apparemment, simplifier les frontieres joue aussi sur la vitesse de demasquage des zones de conflit
from world where (world.begin<=2000 and world.end>=2000)
union all
-- zones de conflit
select '<g id="conflits" visibility="hidden">'
union all

select  '<path id="lt'::text||lat||'lg'|| lon||'rd'||radius||'" visibility="hidden" fill="lightcoral" opacity=".65"  stroke="firebrick" stroke-width="0.25" d=" '
 || assvg(Scale(the_geom,0.00001,0.00001,1),0,1)||'"/>' as svg
--,lat ,  lon ,  radius, confid, assvg(the_geom,0,0)
from conflits_ext
group by lat,lon,radius, the_geom
--order by confid; 
union all
-- queue du fichier .svg
select '"</g></svg>'
);
copy tmp to '/home/commun/ecole/REC/PRISM/tmp/_guy_carte_moz.rhtml';
-- copy tmp to '/home/gtokarski/guy_carte_moz.rhtml';