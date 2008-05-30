DROP VIEW tab, data, paysannees
;

CREATE OR REPLACE VIEW tab AS (
SELECT distinct annees.annee, world.fips_cntry || world.begin || world.end  as ccode,
world.begin, world.end
        FROM annees, world
        WHERE annee >= 1946 --(select min(dataset_6.var5) as min from dataset_6)
          and annee <= 2003 --(select max(dataset_6.var5) as max from dataset_6)
        ORDER BY  annee, world.fips_cntry || world.begin || world.end
);

CREATE OR REPLACE VIEW data AS (
SELECT dataset_6.var2 as ccode1,world.fips_cntry,
 world.fips_cntry || world.begin || world.end as ccode,
 dataset_6.var5 as annee,
 dataset_6.var8 as data
 FROM dataset_6, fips_cow_codes, world
 WHERE  (dataset_6.var2 = fips_cow_codes.cowcode)
 and (fips_cow_codes.fips_cntry = world.fips_cntry)
 and (dataset_6.var5 >= world.begin
 and dataset_6.var5 <= world.end)
 ORDER BY dataset_6.var5,
 world.fips_cntry || world.begin || world.end
);

CREATE OR REPLACE VIEW paysannees AS
(
 SELECT world.fips_cntry || world.begin || world.end as ccode, annee 
 FROM world, annees
 WHERE annee >= world.begin
 and annee <= world.end
);



SELECT tab.*, data.data, -- paysannees.fips_cntry,
	CASE
		WHEN data.data IS NOT NULL and paysannees.annee >= tab.begin and
			paysannees.annee <= tab.end then CAST (data as text)
		WHEN paysannees.ccode IS NOT NULL  and paysannees.annee >= tab.begin and
			paysannees.annee <= tab.end
			then 'TRUE'
		ELSE '#'
	END
	--as datajson
	FROM tab
	     left join data
		ON (tab.annee = data.annee and tab.ccode=data.ccode)
	     left join paysannees ON (tab.ccode=paysannees.ccode
		and tab.annee = paysannees.annee)
	
--where tab.fips_cntry IN ('SB','GE', 'GM', 'GW', 'VN', 'VM','RS','UR' ) --('VM')
ORDER BY tab.ccode, tab.annee, ccode
;
