-- creation de la table 'diese_null', qui attribut a chaque annee-pays un booleen ('diese') representant
-- l'existance ou non du pays a la date donnee, et un booleen ('manquante') pour l'inverse

DROP VIEW tab, data, paysannees
;

CREATE OR REPLACE VIEW tab AS (
	SELECT distinct annee, world.fips_cntry, world.fips_cntry || world.begin || world.end  as ccode,
		world.begin, world.end
        FROM annees, world
        WHERE annee >= (select min(dataset_1.var5) as min from dataset_1)
		and annee <= (select max(dataset_1.var5) as max from dataset_1)
        ORDER BY  annee, world.fips_cntry || world.begin || world.end
);

CREATE OR REPLACE VIEW data AS (
	SELECT dataset_1.var2 as ccode1,world.fips_cntry,
		world.fips_cntry || world.begin || world.end as ccode,
		dataset_1.var5 as annee,
		dataset_1.var8 as data
	FROM dataset_1, fips_cow_codes, world
	WHERE dataset_1.var5 < 2004
		and (dataset_1.var2 = fips_cow_codes.cowcode)
		and (fips_cow_codes.fips_cntry = world.fips_cntry)
		and (dataset_1.var5 >= world.begin
		and dataset_1.var5 <= world.end)
	ORDER BY dataset_1.var5,
		world.fips_cntry || world.begin || world.end
);

CREATE OR REPLACE VIEW paysannees AS (
	SELECT world.fips_cntry, world.fips_cntry || world.begin || world.end as code_pays, annee 
	FROM world, annees
	WHERE annee >= world.begin
	and annee <= world.end
);

CREATE TABLE diese_null AS (
SELECT tab.annee, tab.begin, tab.end, tab.ccode, paysannees.fips_cntry,
	CASE
		WHEN tab.annee < tab.begin or tab.annee > tab.end then 1
		ELSE 0
	END as diese,
	CASE
		WHEN paysannees.fips_cntry IS NOT NULL then 1
		ELSE 0
	END as manquante
	
	FROM tab
	     left join paysannees ON (tab.fips_cntry=paysannees.fips_cntry
		and tab.annee = paysannees.annee)
	
-- where tab.fips_cntry IN ('SB','GE', 'GM', 'GW', 'VN', 'VM','RS','UR' )
ORDER BY tab.annee, tab.ccode
);
