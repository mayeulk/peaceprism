select cowcode, world.fips_cntry, world.cntry_name,  world.begin, world.end, 
world_old.fips_cntry, world_old.cntry_name,  world_old.begin, world_old.end
from world_old LEFT JOIN world USING (fips_cntry) order by world.end DESC