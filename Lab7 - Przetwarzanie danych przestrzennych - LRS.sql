-- ZAD 1
-- A
create table A6_LRS (
  geom SDO_GEOMETRY
);

-- B
insert into A6_LRS
(select a.id, sdo_geom.sdo_length(a.geom, 1, 'unit=km') distance
from STREETS_AND_RAILROADS a, MAJOR_CITIES b
where sdo_relate(
  a.geom,
  sdo_geom.sdo_buffer(
    b.geom,
    10,
    1,
    'unit=km'
  ),
  'MASK=ANYINTERACT'
  ) = 'TRUE'
and b.city_name = 'Koszalin';);
-- Error report -
-- SQL Error: ORA-00913: za du?a liczba warto?c
-- 00913. 00000 -  "too many values"

-- Jest błąd dlatego rozbijam polecenie na 2 (w pierwszym sam select, w którym sprawdze wynik i w drugim poleceniu ręcznie go dodam.
select a.id, sdo_geom.sdo_length(a.geom, 1, 'unit=km') distance
from STREETS_AND_RAILROADS a, MAJOR_CITIES b
where sdo_relate(
  a.geom,
  sdo_geom.sdo_buffer(
    b.geom,
    10,
    1,
    'unit=km'
  ),
  'MASK=ANYINTERACT'
  ) = 'TRUE'
and b.city_name = 'Koszalin';

-- Wynik: id = 56
insert into A6_LRS
select a.geom
from STREETS_AND_RAILROADS a
where a.id = 5

-- C
select sdo_geom.sdo_length(geom, 1, 'unit=km') distance, st_linestring(geom).st_numpoints() st_numpoionts
from A6_LRS;

-- D
update A6_LRS
set geom = sdo_lrs.convert_to_lrs_geom(geom, 0, 276.6813154);

-- E
insert into user_sdo_geom_metadata values (
    'A6_LRS',
    'geom',
    mdsys.sdo_dim_array(mdsys.sdo_dim_element('X', 12.603676, 26.369824, 1),
                        mdsys.sdo_dim_element('Y', 45.8464, 58.0213, 1),
                        mdsys.sdo_dim_element('M', 0, 300, 1)),
    8307
);

-- F
create index a6_lrs_idx on
    a6_lrs (
        geom
    )
        indextype is mdsys.spatial_index;

-- ZAD 2
-- A
select SDO_LRS.VALID_MEASURE(GEOM, 500) VALID_500
from A6_LRS;

-- B
select SDO_LRS.GEOM_SEGMENT_END_PT(GEOM).Get_WKT() end_pt
from A6_LRS;

-- C
select SDO_LRS.LOCATE_PT(GEOM, 150, 0).Get_WKT() km150 
from A6_LRS;

-- D
select SDO_LRS.CLIP_GEOM_SEGMENT(GEOM, 120, 160).Get_WKT() clipped 
from A6_LRS;

-- E
select SDO_LRS.GET_NEXT_SHAPE_PT(a.geom, b.geom).Get_WKT() wjazd_na_a6
from A6_LRS a, MAJOR_CITIES b where b.CITY_NAME = 'Slupsk';

-- F
select sdo_geom.sdo_length(sdo_lrs.offset_geom_segment(a.geom, b.diminfo, 50, 200, 50, 'unit=m arc_tolerance=1'), 1, 'unit=km') koszt
from a6_lrs a, user_sdo_geom_metadata b
where b.table_name = 'A6_LRS' and b.column_name = 'GEOM';
