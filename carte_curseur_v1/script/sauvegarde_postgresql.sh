#!/bin/bash

maintenant=`date +%Y%m%d-%T`

#fichier='/home/mk/svg_ecole/postgresql/'$maintenant'postgresql.sql.gz'
#fichier_sql='/home/mk/svg_ecole/postgresql/'$maintenant'postgresql.sql'
fichier_tar='/home/mk/svg_ecole/postgresql/'$maintenant'postgresql.tar'
#fichier_tar_gz='/home/mk/svg_ecole/postgresql/'$maintenant'postgresql.tar.gz'

echo 'Sauvegarde en cours dans '$fichier_tar

# pg_dump --compress=2 --username=postgres --port=5433 prism_db > $fichier
# pg_dump --create --format=plain --username=postgres --port=5433 prism_db > $fichier_sql
pg_dump --format=tar --username=postgres --port=5433 prism_db > $fichier_tar
# pg_dump --format=custom --username=postgres --port=5433 prism_db > $fichier_tar_gz

echo 'Sauvegarde terminée'

echo 'pour restorer, faire: pg_restore --create --dbname=postgres prism_db.tar'
