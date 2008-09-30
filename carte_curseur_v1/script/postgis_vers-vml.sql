------------------------------- POSTGIS VERS VML ----------------------------------------------------------
-- requete similaire a postgis_vers_svg.sql, avec quelques changements pour des specificites propres a VML

drop view test_geom;
create view test_geom as
(
-- d'abord les grands pays (>2000 km2), tres simplifies : couleur  grise (lightgrey et black)
select cntry_name, fips_cntry, world.begin, world.end, Scale(Simplify(the_geom,10000),0.0001,0.0001,1) as the_geom
-- assvg(Scale(Simplify(the_geom,echelle_de_simplif.),chgmt_echelle_x,chgmt_echelle_y,?), 0:absolute 1:relative,precision)
-- apparemment, simplifier les frontieres joue aussi sur la vitesse de demasquage des zones de conflit
from world where (area2d(the_geom)/1000000)>2000
union all
-- puis les petits pays (<2000 km2), sans simplification
select cntry_name, fips_cntry, world.begin, world.end, Scale (the_geom,0.0001,0.0001,1) as the_geom
from world where (area2d(the_geom)/1000000)<=2000
);

-- pour l'entete du fichier vml :
-- il faut un deuxieme antislash pour echapper le slash "v\:*"  (declaration dans head) et un E devant la chaine de caracteres
drop table tmp ;
create table tmp as
(
-- select E'<html xmlns:v\\="urn:schemas-microsoft-com:vml"><head><style> v:* { behavior: url(#default#VML); } </style> </head><body>
select '<v:group id="monde" style="position:relative;left:0px;top:0px; width:600px;height:300px;"  coordsize="3600,1800" coordorigin="0,0">'
|| '<v:rect style="top:-900; left:-1800; height:1800; width:3600;" fillcolor="#B4DAF6" />' -- la mer en bleu pale
union all

-- carte du monde en l'an 2000 :
-- d'abord les grands pays (>2000 km2), tres simplifies
select '<v:shape id="' || fips_cntry || test_geom.begin || test_geom.end
|| '" title="' || test_geom.cntry_name
|| '" style="position: relative; width:3600;height:1800" fillcolor="#D3D3D3" strokecolor="#000000" strokeweight="0.25pt" onmousedown="survol_zone(this.id);" path=" '
|| regexp_replace(regexp_replace(assvg(the_geom,0,0), 'M', 'm', 'g'), 'm +(-?[0-9]+) +(-?[0-9]+) +(-?[0-9]+)', E'm \\1 \\2 l \\3', 'g') ||'"/>' as svg
-- par rapport a la ligne ci-dessous, on a multiplie par 10 et enleve la decimale car IE6 VML confond le point decimal avec un separateur de coordonnees...
-- || assvg(Scale(Simplify(the_geom,50000),0.00001,0.00001,1),0,1)||'"/>' as svg
from test_geom

union all

-- zones de conflits :
select '<v:shape id="lt'::text||lat||'lg'|| lon||'rd'||radius
|| '" style="position:relative; width:3600; height:1800; visibility:hidden" fillcolor="#F08080" strokecolor="#B22222" strokeweight="0.25pt" onmousedown="survol_zone(this.id);" path=" '
|| regexp_replace(regexp_replace(assvg(Scale(Simplify(the_geom,10000),0.0001,0.0001,1),0,0), 'M', 'm', 'g'), 'm +(-?[0-9]+) +(-?[0-9]+) +(-?[0-9]+)', E'm \\1 \\2 l \\3', 'g') ||'"/>' as svg
from conflits_ext
group by lat,lon,radius, the_geom
--order by confid; 
union all
-- queue du fichier vml
select '</v:group>' 
-- </body> </html>'
);

-- creation d'un fichier de sortie pour l'implementation dans l'appli radrails
copy tmp to '/home/commun/ecole/REC/PRISM/tmp/guy_carte_ie.html';
