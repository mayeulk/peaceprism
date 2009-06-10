#!/bin/bash

maintenant=`date +%Y%m%d-%T`

fichier='/home/mk/svg_ecole/postgresql/'$maintenant'postgresql.sql.gz'

echo 'Sauvegarde en cours dans '$fichier

pg_dump --compress=2 --username=postgres --port=5433 testgis > $fichier

echo 'Sauvegarde terminée'