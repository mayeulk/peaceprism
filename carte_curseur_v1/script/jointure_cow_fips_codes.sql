-- DROP TABLE world3
CREATE TABLE world3 as
(select fips_cow_codes.cowcode, world.fips_cntry, world.cntry_name,
world.begin, world.end, world.ccode
FROM fips_cow_codes, world WHERE fips_cow_codes.fips_cntry = world.fips_cntry);

--ALTER TABLE world RENAME TO world_old;
--ALTER TABLE world3 RENAME TO world;