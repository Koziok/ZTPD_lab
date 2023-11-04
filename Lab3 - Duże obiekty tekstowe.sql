--ZAD 1
create table DOKUMENTY (
    ID number(12) primary key,
    DOKUMENT clob
);

--ZAD 2
DECLARE
    lob clob;
    counter NUMBER := 1;
BEGIN
    lob := 'Oto tekst.';
    for counter in 2..10000
    LOOP
    lob := lob || 'Oto tekst.'; 
  END LOOP;
    INSERT INTO dokumenty
    values (1, lob);
    COMMIT;
END;

--ZAD 3
--A
select * from dokumenty;
--B
select upper(dokument) from dokumenty;
--C
select length(dokument) from dokumenty;
--D
select dbms_lob.getlength(dokument) from dokumenty;
--E
select substr(dokument, 5 ,1000) from dokumenty;
--F
select dbms_lob.substr(dokument, 1000, 5) from dokumenty;

--ZAD 4
insert into dokumenty values (2, EMPTY_CLOB());

--ZAD 5
insert into dokumenty values (3, NULL);
commit;

--ZAD 6
--A
select * from dokumenty;
--B
select upper(dokument) from dokumenty;
--C
select length(dokument) from dokumenty;
--D
select dbms_lob.getlength(dokument) from dokumenty;
--E
select substr(dokument, 5 ,1000) from dokumenty;
--F
select dbms_lob.substr(dokument, 1000, 5) from dokumenty;

--ZAD 7
DECLARE
    lobd clob;
    fils BFILE := BFILENAME('TPD_DIR','dokument.txt');
    doffset integer := 1;
    soffset integer := 1;
    langctx integer := 0;
    warn integer := null;
BEGIN
    SELECT dokument INTO lobd FROM dokumenty WHERE id=2 FOR UPDATE;
    DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADCLOBFROMFILE(lobd, fils, DBMS_LOB.LOBMAXSIZE, doffset, soffset, 873, langctx, warn);
    DBMS_LOB.FILECLOSE(fils);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Status operacji: '||warn);
END;

--ZAD 8
update dokumenty set dokument = to_clob(BFILENAME('TPD_DIR','dokument.txt')) where id = 3;

--ZAD 9
select * from dokumenty;

--ZAD 10
select dbms_lob.getlength(dokument) from dokumenty;

--ZAD 11
drop table dokumenty;

--ZAD 12


--ZAD 13


--ZAD 14
