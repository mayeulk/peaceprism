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

CREATE OR REPLACE VIEW paysannees AS
(
 SELECT fips_cntry, annee 
 FROM world, annees
 WHERE annee >= world.begin
 and annee <= world.end
);



SELECT tab.*, data.data, -- paysannees.fips_cntry,
	CASE
		WHEN data.data IS NOT NULL and paysannees.annee >= tab.begin and
			paysannees.annee <= tab.end then CAST (data as text)
		WHEN paysannees.fips_cntry IS NOT NULL  and paysannees.annee >= tab.begin and
			paysannees.annee <= tab.end
			then 'TRUE'
		ELSE '#'
	END
	--as datajson
	FROM tab
	     left join data
		ON (tab.annee = data.annee and tab.fips_cntry=data.fips_cntry)
	     left join paysannees ON (tab.fips_cntry=paysannees.fips_cntry
		and tab.annee = paysannees.annee)
	
--where tab.fips_cntry IN ('SB','GE', 'GM', 'GW', 'VN', 'VM','RS','UR' ) --('VM')
ORDER BY tab.fips_cntry, tab.annee, ccode
;
