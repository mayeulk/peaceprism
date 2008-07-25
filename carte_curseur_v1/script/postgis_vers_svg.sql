

ERROR:  could not access file "/usr/lib/postgresql/8.2/lib/liblwgeom.so.1.2": Aucun fichier ou dossier de ce type

********** Erreur **********

ERROR: could not access file "/usr/lib/postgresql/8.2/lib/liblwgeom.so.1.2": Aucun fichier ou dossier de ce type
État SQL :58P01




--------------------------------------- POSTGIS VERS SVG -------------------------------------------------
-- la requete genere un fichier SVG a partir des tables 'world' et 'conflits_ext'

-- NB: SOUS PGADMIN", POUR EXPORTER LE RESULTAT DE CE FICHIER, CHOISIR LE MENU FICHIER/PREFERENCES/REQUETES
-- PUIS: Nombre max. de caracteres par colonne: 100000
drop view test_geom;
create view test_geom as
(
-- d'abord les grands pays (>2000 km2), tres simplifies : couleur  grise (lightgrey et black)
select cntry_name, fips_cntry, world.begin, world.end, Scale(Simplify(the_geom, 10000),0.0001,0.0001,1) as the_geom
-- assvg(Scale(Simplify(the_geom,echelle_de_simplif.),chgmt_echelle_x,chgmt_echelle_y,?), 0:absolute 1:relative,precision)
-- apparemment, simplifier les frontieres joue aussi sur la vitesse de demasquage des zones de conflit
from world where (area2d(the_geom)/1000000)>2000
union all
-- puis les petits pays (<2000 km2), sans simplification
select cntry_name, fips_cntry, world.begin, world.end, Scale (the_geom,0.0001,0.0001,1) as the_geom
from world where (area2d(the_geom)/1000000)<=2000
);


drop table tmp;
create table tmp as
(
-- en tete du fichier .svg
select '<svg id="monde" xmlns:svg="http://www.w3.org/2000/svg" xmlns="http://www.w3.org/2000/svg" version="1.0" width="600" height="300" viewBox="-1800 -900 3600 1800" stroke-width="1" stroke-linejoin="round" stroke-linecap="round">'
|| '<rect x="-1800" y="-900" height="1800" width="3600" fill="#B4DAF6"/>' -- la mer en bleu pale
-- des zones ajoutees au debut car il semble qu'elle previennent contre certains bugs
|| '<path id="lt23.5lg121rd200"  visibility="hidden" fill="lightcoral" opacity=".65"  stroke="firebrick" stroke-width="0.25" onmousedown="survol_zone(this.id);" d=" M 2 -0 2 0.4 1.8 0.8 1.7 1.1 1.4 1.4 1.1 1.7 0.8 1.8 0.4 2 0 2 -0.4 2 -0.8 1.8 -1.1 1.7 -1.4 1.4 -1.7 1.1 -1.8 0.8 -2 0.4 -2 -0 -2 -0.4 -1.8 -0.8 -1.7 -1.1 -1.4 -1.4 -1.1 -1.7 -0.8 -1.8 -0.4 -2 0 -2 0.4 -2 0.8 -1.8 1.1 -1.7 1.4 -1.4 1.7 -1.1 1.8 -0.8 2 -0.4 2 -0 "/>'
|| '<path id="lt25lg-14rd500"  visibility="hidden" fill="lightcoral" opacity=".65"  stroke="firebrick" stroke-width="0.25" onmousedown="survol_zone(this.id);" d=" M 5 0 4.9 1 4.6 1.9 4.2 2.8 3.5 3.5 2.8 4.2 1.9 4.6 1 4.9 0 5 -1 4.9 -1.9 4.6 -2.8 4.2 -3.5 3.5 -4.2 2.8 -4.6 1.9 -4.9 1 -5 0 -4.9 -1 -4.6 -1.9 -4.2 -2.8 -3.5 -3.5 -2.8 -4.2 -1.9 -4.6 -1 -4.9 0 -5 1 -4.9 1.9 -4.6 2.8 -4.2 3.5 -3.5 4.2 -2.8 4.6 -1.9 4.9 -1 5 0 "/>'
|| '<path id="lt1.5lg10rd100"  visibility="hidden" fill="lightcoral" opacity=".65"  stroke="firebrick" stroke-width="0.25" onmousedown="survol_zone(this.id);" d=" M 1 -0 1 0.2 0.9 0.4 0.8 0.6 0.7 0.7 0.6 0.8 0.4 0.9 0.2 1 0 1 -0.2 1 -0.4 0.9 -0.6 0.8 -0.7 0.7 -0.8 0.6 -0.9 0.4 -1 0.2 -1 -0 -1 -0.2 -0.9 -0.4 -0.8 -0.6 -0.7 -0.7 -0.6 -0.8 -0.4 -0.9 -0.2 -1 0 -1 0.2 -1 0.4 -0.9 0.6 -0.8 0.7 -0.7 0.8 -0.6 0.9 -0.4 1 -0.2 1 -0 "/>'
|| '<path id="lt39.75lg19.75rd50"  visibility="hidden" fill="lightcoral" opacity=".65"  stroke="firebrick" stroke-width="0.25" onmousedown="survol_zone(this.id);" d=" M 0.5 -0 0.5 0.1 0.5 0.2 0.4 0.3 0.4 0.4 0.3 0.4 0.2 0.5 0.1 0.5 0 0.5 -0.1 0.5 -0.2 0.5 -0.3 0.4 -0.4 0.4 -0.4 0.3 -0.5 0.2 -0.5 0.1 -0.5 -0 -0.5 -0.1 -0.5 -0.2 -0.4 -0.3 -0.4 -0.4 -0.3 -0.4 -0.2 -0.5 -0.1 -0.5 0 -0.5 0.1 -0.5 0.2 -0.5 0.3 -0.4 0.4 -0.4 0.4 -0.3 0.5 -0.2 0.5 -0.1 0.5 -0 "/>'
|| '<path id="lt-51.77lg-59.99rd300"  visibility="hidden" fill="lightcoral" opacity=".65"  stroke="firebrick" stroke-width="0.25" onmousedown="survol_zone(this.id);" d=" M 3 0 2.9 0.6 2.8 1.1 2.5 1.7 2.1 2.1 1.7 2.5 1.1 2.8 0.6 2.9 -0 3 -0.6 2.9 -1.1 2.8 -1.7 2.5 -2.1 2.1 -2.5 1.7 -2.8 1.1 -2.9 0.6 -3 0 -2.9 -0.6 -2.8 -1.1 -2.5 -1.7 -2.1 -2.1 -1.7 -2.5 -1.1 -2.8 -0.6 -2.9 -0 -3 0.6 -2.9 1.1 -2.8 1.7 -2.5 2.1 -2.1 2.5 -1.7 2.8 -1.1 2.9 -0.6 3 0 "/>'

union all
-- carte du monde en l'an 2000 :
select '<path id="' || fips_cntry || test_geom.begin || test_geom.end -- le caractere "&" plante en svg
|| '" fill="#D3D3D3" stroke="#000000" onmousedown="survol_zone(this.id);" d=" '
|| assvg (the_geom, 0, 0) ||'"/>' as svg from test_geom

union all
-- zones de conflits : couleurs rouge (lightcoral et firebrick)
-- creation d'un code pour les zones de conflits : lat, lon, radius, (confid)
select '<path id="lt'::text||lat||'lg'|| lon||'rd'||radius||'" visibility="hidden" fill="#F08080" opacity=".65"  stroke="#B22222" onmousedown="survol_zone(this.id);" d=" '
|| assvg(Scale(Simplify(the_geom, 10000),0.0001,0.0001,1),0,0)||'"/>' as svg from conflits_ext
group by lat,lon,radius, the_geom
-- order by confid; 
-- queue du fichier .svg
union all
select '</svg>'
);
copy tmp to '/home/commun/ecole/REC/PRISM/tmp/guy_carte_moz.svg';
-- creation du fichier SVG
-- pour implementation dans le projet radrails, copier dans le repertoire local app/views/carte, en changeant le nom en _guy_carte_moz.rhtml';




