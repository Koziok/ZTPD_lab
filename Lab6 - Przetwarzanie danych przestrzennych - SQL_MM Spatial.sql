-- ZAD 1
-- A
select lpad('-',2*(level-1),'|-') || t.owner||'.'||t.type_name||' (FINAL:'||t.final||
', INSTANTIABLE:'||t.instantiable||', ATTRIBUTES:'||t.attributes||', METHODS:'||t.methods||')'
from all_types t
start with t.type_name = 'ST_GEOMETRY'
connect by prior t.type_name = t.supertype_name
 and prior t.owner = t.owner;

-- B
select distinct m.method_name
from all_type_methods m
where m.type_name like 'ST_POLYGON'
and m.owner = 'MDSYS'
order by 1;

-- C
create table myst_major_cities(
    fips_cntry varchar2(2),
    city_name varchar2(40),
    stgeom st_point
);

-- D
insert into myst_major_cities(fips_cntry, city_name, stgeom)
select mc.FIPS_CNTRY, mc.CITY_NAME, st_point(mc.GEOM)
from major_cities mc;

-- ZAD 2
-- A
insert into myst_major_cities
values (
    'PL',
    'Szczyrk',
    st_point(19.036107, 49.718655, 8307)
);

-- ZAD 3
-- A
create table myst_country_boundaries(
    fips_cntry varchar2(2),
    cntry_name varchar2(40),
    stgeom st_multipolygon
);

-- B
insert into MYST_COUNTRY_BOUNDARIES(FIPS_CNTRY, CNTRY_NAME, STGEOM)
select cb.FIPS_CNTRY, cb.CNTRY_NAME, ST_MULTIPOLYGON(cb.GEOM)
from COUNTRY_BOUNDARIES cb;

-- C
select b.stgeom.st_geometrytype() as typ_obiektu, count(*) as ile
from myst_country_boundaries b
group by b.stgeom.st_geometrytype();

-- D
select b.stgeom.st_issimple()
from myst_country_boundaries b;

-- ZAD 4
-- A
select a.cntry_name, count(*) as count
from myst_major_cities b,
     myst_country_boundaries a
where a.stgeom.st_contains(b.stgeom) = 1
group by a.cntry_name;

-- B
select cb1.cntry_name, cb2.cntry_name
from myst_country_boundaries cb1,
  myst_country_boundaries cb2
where cb1.stgeom.st_touches(cb2.stgeom) = 1
and cb1.cntry_name = 'Czech Republic';

-- C
select distinct a.cntry_name, r.name
from myst_country_boundaries a,
  rivers r
where a.stgeom.st_intersects(st_linestring(r.geom)) = 1
and a.cntry_name = 'Czech Republic';

-- D
select round(treat(a.stgeom.st_union(b.stgeom) as st_polygon).st_area()) as powierzchnia
from myst_country_boundaries a,
  myst_country_boundaries b
where a.cntry_name = 'Czech Republic'
and b.cntry_name = 'Slovakia';

-- E
select a.stgeom.st_difference(st_geometry(b.geom)).st_geometrytype() as wegry_bez
from myst_country_boundaries a,
  water_bodies b
where a.cntry_name = 'Hungary'
and b.name = 'Balaton';

-- ZAD 5
-- A
explain plan for
select a.cntry_name, count(*)
from myst_country_boundaries a,
  myst_major_cities b
where a.cntry_name = 'Poland'
  and sdo_within_distance(
    a.stgeom, 
    b.stgeom,
    'distance=100 unit=km'
  ) = 'TRUE'
group by a.cntry_name;

-- B
insert into user_sdo_geom_metadata
select 'myst_major_cities', 'stgeom', T.diminfo, T.srid
from all_sdo_geom_metadata T
where table_name = 'MAJOR_CITIES';

select * from user_sdo_geom_metadata;

-- C
create index myst_major_cities_idx on myst_major_cities(stgeom) indextype is mdsys.spatial_index;

-- D
explain plan for
select a.cntry_name, count(*)
from myst_country_boundaries a,
  myst_major_cities b
where a.cntry_name = 'Poland'
  and sdo_within_distance(
    a.stgeom, 
    b.stgeom,
    'distance=100 unit=km'
  ) = 'TRUE'
group by a.cntry_name;


