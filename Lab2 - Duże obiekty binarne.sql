--ZAD 1
CREATE TABLE movies as select * from ztpd.movies;

--ZAD 2
desc movies;
select * from movies;

--ZAD 3
select id, title from movies where cover is null;

--ZAD 4
select id, title, dbms_lob.getlength(cover) as filesize from movies where cover is not null;

--ZAD 5
select id, title, dbms_lob.getlength(cover) as filesize from movies where cover is null;

--ZAD 6
select * from all_directories;
--/u01/app/oracle/oradata/DBLAB03/directories/tpd_dir

--ZAD 7
update movies set mime_type = 'image/jpeg', cover = empty_blob() where id = 66;
commit;

--ZAD 8
select id, title, dbms_lob.getlength(cover) as filesize from movies where id in(65,66);

--ZAD 9
DECLARE
    lobd blob;
    fils BFILE := BFILENAME('TPD_DIR','escape.jpg');
BEGIN
    select cover into lobd
    from movies
    where id=66
    for update;
    DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADFROMFILE(lobd,fils,DBMS_LOB.GETLENGTH(fils));
    DBMS_LOB.FILECLOSE(fils);
COMMIT;
END;

--ZAD 10
CREATE TABLE TEMP_COVERS (
    movie_id NUMBER(12),
    image BFILE,
    mime_type VARCHAR2(50)
);

--ZAD 11
INSERT INTO TEMP_COVERS VALUES (65, BFILENAME('TPD_DIR', 'eagles.jpg'), 'image/jpeg');
COMMIT;

--ZAD 12
select movie_id, dbms_lob.getlength(image) as filesize from temp_covers;

--ZAD 13
DECLARE
    lobd BLOB;
    fils BFILE;
    mime VARCHAR2(200);
BEGIN
    select image into fils
    from temp_covers
    where movie_id=65;
    
    select mime_type into mime
    from temp_covers
    where movie_id=65;
    
    SELECT cover into lobd
    from movies
    where id=65
    for update;
    
    DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
    dbms_lob.createtemporary(lobd, TRUE);
    DBMS_LOB.LOADFROMFILE(lobd,fils,DBMS_LOB.GETLENGTH(fils));
    
    update movies set cover = lobd, mime_type = mime where id = 65;
    
    dbms_lob.freetemporary(lobd);
    DBMS_LOB.FILECLOSE(fils);
COMMIT;
END;

--ZAD 14
select id, dbms_lob.getlength(cover) as FILESIZE from movies where id in ('65','66');

--ZAD 15
drop table movies;
drop table temp_covers;

