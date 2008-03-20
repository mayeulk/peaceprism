------------------------------- POSTGIS VERS VML ----------------------------------------------------------
-- requete similaire a postgis_vers_svg.sql, avec quelques changements pour des specificites propres a VML

-- pour l'entete du fichier vml :
-- il faut un deuxieme antislash pour echapper le slash "v\:*"  (declaration dans head) et un E devant la chaine de caracteres
drop table tmp ;
create table tmp as
(
-- select E'<html xmlns:v\\="urn:schemas-microsoft-com:vml"><head><style> v:* { behavior: url(#default#VML); } </style> </head><body>
select '<v:group id="monde" style="position:relative;left:-43px;top:-11px; width:120px;height:60px;"  coordsize="600,300" coordorigin="-600,-300">'
-- <v:rect style="height:400; width:400;" fillcolor="#B4DAF6" />' -- la mer en bleu pale
union all

-- carte du monde en l'an 2000 :
-- d'abord les grands pays (>2000 km2), tres simplifies
select  '<v:shape id="' || replace(cntry_name, '&', 'and') 
|| '" style="position: relative; width:600;height:300" fillcolor="#D3D3D3" strokecolor="#000000" strokeweight="0.25pt" onmousedown="survol_zone(this.id);" path=" '
|| regexp_replace(regexp_replace(assvg(Scale(Simplify(the_geom,10000),0.0001,0.0001,1),0,0), 'M', 'm', 'g'), 'm +(-?[0-9]+) +(-?[0-9]+) +(-?[0-9]+)', E'm \\1 \\2 l \\3', 'g') ||'"/>' as svg
-- par rapport a  la ligne ci-dessous, on a multiplie par 10 et enleve la decimale car IE6 VML confond le point decimal avec un separateur de coordonnees...
-- || assvg(Scale(Simplify(the_geom,50000),0.00001,0.00001,1),0,1)||'"/>' as svg
-- assvg(Scale(Simplify(the_geom,echelle_de_simplif.),chgmt_echelle_x,chgmt_echelle_y,?), 0:absolute 1:relative,precision)
-- utilisation d'expresions regulieres pour modifier le 'path' cree pour SVG en langage VML
from world where world.begin<=2000 and world.end>=2000 and (area2d(the_geom)/1000000)>2000
union all
-- puis les petits pays (<2000 km2), sans simplification
select  '<v:shape id="' || replace(cntry_name, '&', 'and') 
|| '" style="position: relative; width:600;height:300" fillcolor="#D3D3D3" strokecolor="#000000" strokeweight="0.1pt" onmousedown="survol_zone(this.id);" path=" '
|| regexp_replace(regexp_replace(assvg(Scale (the_geom,0.0001,0.0001,1),0,0), 'M', 'm', 'g'), 'm +(-?[0-9]+) +(-?[0-9]+) +(-?[0-9]+)', E'm \\1 \\2 l \\3', 'g') ||'"/>' as svg
from world where (world.begin<=2000 and world.end>=2000) and (area2d(the_geom)/1000000)<=2000
union all

-- zones de conflits :
select  '<v:shape id="lt'::text||lat||'lg'|| lon||'rd'||radius
||'" style="position:relative; width:600; height:300; visibility:hidden" fillcolor="red" strokecolor="black" strokeweight="0.25pt" onmousedown="survol_zone(this.id);" path=" '
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
