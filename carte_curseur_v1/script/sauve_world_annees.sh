#!/bin/bash
dossier='/home/gtokarski/workspace/carte_curseur_v1/tmp/'
s_annees=$dossier'annees.tar'
pg_dump --format=tar --username=postgres --port=5433 --table=annees testgis > $s_annees

echo 'Sauvegarde de annees effectuee'

s_world=$dossier'world.tar'
pg_dump --format=tar --username=postgres --port=5433 --table=world testgis > $s_world

echo 'Sauvegarde de world effectuee'

pg_restore --dbname=prism_db --table=annees $s_annee
#pg_restore --dbname=prism_db --table=world $s_world

echo 'restaure terminee'