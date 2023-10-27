--ZAD 1
CREATE TYPE samochod AS OBJECT (
    marka VARCHAR2(20),
    model VARCHAR2(20),
    kilometry NUMBER,
    data_produkcji DATE,
    cena NUMBER(10,2)
);

CREATE TABLE samochody
OF samochod;

insert into samochody values(new samochod('Fiat', 'Brava', 60000, date '1999-11-30', 25000));
insert into samochody values(new samochod('Ford', 'Mondeo', 80000, date '1997-05-10', 45000));
insert into samochody values(new samochod('Mazda', '323', 12000, date '2000-09-22', 52000));

--ZAD 2
create  table wlasciciele(
    imie varchar2(100), 
    nazwisko varchar2(100), 
    auto samochod
);

insert into wlasciciele values('Jan', 'Kowalski', new samochod('Ford', 'Seicento', 30000, date '2010-12-02', 19500));
insert into wlasciciele values('Adam', 'Nowak', new samochod('Opel', 'Astra', 34000, date '2009-06-01', 33700));

--ZAD 3
alter type samochod replace as object(
    marka varchar2(20), 
    model varchar2(20), 
    kilometry number,
    data_produkcji date, 
    cena number(10, 2),
    member function wartosc return number
    );
    
CREATE OR REPLACE TYPE BODY samochod AS
    MEMBER FUNCTION wartosc RETURN NUMBER IS
    BEGIN
        RETURN cena * power(0.9, EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji));
    END wartosc;
END;

--ZAD 4
ALTER TYPE samochod ADD MAP MEMBER FUNCTION odwzoruj
    RETURN NUMBER CASCADE INCLUDING TABLE DATA;

CREATE OR REPLACE TYPE BODY samochod AS 
    MEMBER FUNCTION wartosc RETURN NUMBER IS
    BEGIN
        RETURN cena * POWER(0.9, EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM data_produkcji));
    END wartosc;
    MAP MEMBER FUNCTION odwzoruj RETURN NUMBER IS 
    BEGIN
        RETURN (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM data_produkcji)) + ROUND(kilometry / 10000, 3);
    END odwzoruj;
END;

--ZAD 5
CREATE TYPE wlasciciel AS OBJECT(
    imie VARCHAR2(50),
    nazwisko VARCHAR2(50)
);

ALTER TYPE samochod ADD ATTRIBUTE posiadacz REF wlasciciel CASCADE;
DROP TABLE wlasciciele;
CREATE TABLE wlasciciele OF wlasciciel;

INSERT INTO wlasciciele VALUES ('Jan', 'Kowalski');
INSERT INTO wlasciciele VALUES ('Adam', 'Nowak');

UPDATE samochody
SET posiadacz = (SELECT REF(w)
                      FROM wlasciciele w
                      WHERE nazwisko = 'Kowalski')
WHERE marka = 'Ford';

UPDATE samochody
SET posiadacz = (SELECT REF(w)
                      FROM wlasciciele w
                      WHERE nazwisko = 'Nowak')
WHERE marka = 'Fiat';

--ZAD 6
SET SERVEROUTPUT ON;
DECLARE
    TYPE t_przedmioty IS
        VARRAY(10) OF VARCHAR2(20);
    moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
    moje_przedmioty(1) := 'MATEMATYKA';
    moje_przedmioty.extend(9);
    FOR i IN 2..10 LOOP
        moje_przedmioty(i) := 'PRZEDMIOT_' || i;
    END LOOP;

    FOR i IN moje_przedmioty.first()..moje_przedmioty.last() LOOP
        dbms_output.put_line(moje_przedmioty(i));
    END LOOP;

    moje_przedmioty.trim(2);
    FOR i IN moje_przedmioty.first()..moje_przedmioty.last() LOOP
        dbms_output.put_line(moje_przedmioty(i));
    END LOOP;

    dbms_output.put_line('Limit: ' || moje_przedmioty.limit());
    dbms_output.put_line('Liczba elementow: ' || moje_przedmioty.count());
    moje_przedmioty.extend();
    moje_przedmioty(9) := 9;
    dbms_output.put_line('Limit: ' || moje_przedmioty.limit());
    dbms_output.put_line('Liczba elementow: ' || moje_przedmioty.count());
    moje_przedmioty.DELETE();
    dbms_output.put_line('Limit: ' || moje_przedmioty.limit());
    dbms_output.put_line('Liczba elementow: ' || moje_przedmioty.count());
END;

--ZAD 7
SET SERVEROUTPUT ON;
DECLARE
    TYPE t_ksiazki IS 
        VARRAY(10) OF VARCHAR2(20);
    moje_ksiazki t_ksiazki := t_ksiazki('');
BEGIN
    moje_ksiazki(1) := 'FAJNA KSIAZKA';
    moje_ksiazki.EXTEND(9);
    
    FOR i IN 2..10 LOOP
        moje_ksiazki(i) := 'TYTUL_' || i;
    END LOOP;
    
    FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
    END LOOP;
    
    moje_ksiazki.TRIM(3);
    
    FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
    
    moje_ksiazki.EXTEND();
    moje_ksiazki(8) := 8;
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
    
    moje_ksiazki.DELETE();
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
END;

--ZAD 8
SET SERVEROUTPUT ON;
DECLARE
    TYPE t_wykladowcy IS
        TABLE OF VARCHAR2(20);
    moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
    moi_wykladowcy.extend(2);
    moi_wykladowcy(1) := 'MORZY';
    moi_wykladowcy(2) := 'WOJCIECHOWSKI';
    moi_wykladowcy.extend(8);
    FOR i IN 3..10 LOOP
        moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
    END LOOP;

    FOR i IN moi_wykladowcy.first()..moi_wykladowcy.last() LOOP
        dbms_output.put_line(moi_wykladowcy(i));
    END LOOP;

    moi_wykladowcy.trim(2);
    FOR i IN moi_wykladowcy.first()..moi_wykladowcy.last() LOOP
        dbms_output.put_line(moi_wykladowcy(i));
    END LOOP;

    moi_wykladowcy.DELETE(5, 7);
    dbms_output.put_line('Limit: ' || moi_wykladowcy.limit());
    dbms_output.put_line('Liczba elementow: ' || moi_wykladowcy.count());
    FOR i IN moi_wykladowcy.first()..moi_wykladowcy.last() LOOP
        IF moi_wykladowcy.EXISTS(i) THEN
            dbms_output.put_line(moi_wykladowcy(i));
        END IF;
    END LOOP;

    moi_wykladowcy(5) := 'ZAKRZEWICZ';
    moi_wykladowcy(6) := 'KROLIKOWSKI';
    moi_wykladowcy(7) := 'KOSZLAJDA';
    FOR i IN moi_wykladowcy.first()..moi_wykladowcy.last() LOOP
        IF moi_wykladowcy.EXISTS(i) THEN
            dbms_output.put_line(moi_wykladowcy(i));
        END IF;
    END LOOP;

    dbms_output.put_line('Limit: ' || moi_wykladowcy.limit());
    dbms_output.put_line('Liczba elementow: ' || moi_wykladowcy.count());
END;

--ZAD 9
SET SERVEROUTPUT ON;
DECLARE
    TYPE t_miesiace IS
        TABLE OF VARCHAR2(20);
    moje_miesiace t_miesiace := t_miesiace();
BEGIN
    moje_miesiace.extend(12);
    moje_miesiace(1) := 'Styczen';
    moje_miesiace(2) := 'Luty';
    moje_miesiace(3) := 'Marzec';
    moje_miesiace(4) := 'Kwiecien';
    moje_miesiace(5) := 'Maj';
    moje_miesiace(6) := 'Czerwiec';
    moje_miesiace(7) := 'Lipiec';
    moje_miesiace(8) := 'Sierpien';
    moje_miesiace(9) := 'Wrzesien';
    moje_miesiace(10) := 'Pazdziernik';
    moje_miesiace(11) := 'Listopad';
    moje_miesiace(11) := 'Grudzien';
    FOR i IN moje_miesiace.first()..moje_miesiace.last() LOOP
        dbms_output.put_line(moje_miesiace(i));
    END LOOP;

    moje_miesiace.trim(2);
    FOR i IN moje_miesiace.first()..moje_miesiace.last() LOOP
        dbms_output.put_line(moje_miesiace(i));
    END LOOP;

    moje_miesiace.DELETE(5, 7);
    dbms_output.put_line('Liczba elementow: ' || moje_miesiace.count());
    FOR i IN moje_miesiace.first()..moje_miesiace.last() LOOP
        IF moje_miesiace.EXISTS(i) THEN
            dbms_output.put_line(moje_miesiace(i));
        END IF;
    END LOOP;
END;

--ZAD 10
CREATE TYPE jezyki_obce AS
    VARRAY(10) OF VARCHAR2(20);
/

CREATE TYPE stypendium AS OBJECT (
        nazwa  VARCHAR2(50),
        kraj   VARCHAR2(30),
        jezyki jezyki_obce
);
/

CREATE TABLE stypendia OF stypendium;

INSERT INTO stypendia VALUES (
    'SOKRATES',
    'FRANCJA',
    jezyki_obce('ANGIELSKI', 'FRANCUSKI', 'NIEMIECKI')
);

INSERT INTO stypendia VALUES (
    'ERASMUS',
    'NIEMCY',
    jezyki_obce('ANGIELSKI', 'NIEMIECKI', 'HISZPANSKI')
);

SELECT * FROM stypendia;

SELECT s.jezyki FROM stypendia s;

UPDATE stypendia
SET
    jezyki = jezyki_obce('ANGIELSKI', 'NIEMIECKI', 'HISZPANSKI', 'FRANCUSKI')
WHERE
    nazwa = 'ERASMUS';

CREATE TYPE lista_egzaminow AS
    TABLE OF VARCHAR2(20);
/

CREATE TYPE semestr AS OBJECT (
        numer    NUMBER,
        egzaminy lista_egzaminow
);
/

CREATE TABLE semestry OF semestr
NESTED TABLE egzaminy STORE AS tab_egzaminy;

INSERT INTO semestry VALUES ( semestr(1,
                                      lista_egzaminow('MATEMATYKA', 'LOGIKA', 'ALGEBRA')) );

INSERT INTO semestry VALUES ( semestr(2,
                                      lista_egzaminow('BAZY DANYCH', 'SYSTEMY OPERACYJNE')) );

SELECT s.numer, e.*
FROM semestry s, TABLE(s.egzaminy) e;

SELECT e.*
FROM semestry s, TABLE ( s.egzaminy ) e;

SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );

INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
VALUES ('METODY NUMERYCZNE');

UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';

DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
WHERE e.column_value = 'BAZY DANYCH';

--ZAD 11
CREATE TYPE koszyk AS TABLE OF VARCHAR2(20);

CREATE TYPE zakup AS OBJECT (
    id NUMBER,
    koszyk_produktow koszyk
);

CREATE TABLE zakupy OF zakup NESTED TABLE koszyk_produktow STORE AS t_koszyk;

INSERT INTO zakupy VALUES (1, koszyk('mleko', 'jajka'));
INSERT INTO zakupy VALUES (2, koszyk('woda', 'sok'));
INSERT INTO zakupy VALUES (3, koszyk('chleb', 'maslo', 'ser', 'szynka'));

SELECT * FROM zakupy;

DELETE FROM zakupy z WHERE (
    SELECT COUNT(*) FROM TABLE (z.koszyk_produktow) k
       WHERE k.COLUMN_VALUE = 'woda') > 0;

SELECT * FROM zakupy;

--ZAD 12
CREATE TYPE instrument AS OBJECT (
        nazwa  VARCHAR2(20),
        dzwiek VARCHAR2(20),
        MEMBER FUNCTION graj RETURN VARCHAR2
) NOT FINAL;

CREATE TYPE BODY instrument AS
    MEMBER FUNCTION graj RETURN VARCHAR2 IS
    BEGIN
        RETURN dzwiek;
    END;
END;
/

CREATE TYPE instrument_dety UNDER instrument (
        material VARCHAR2(20),
        OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
        MEMBER FUNCTION graj (
               glosnosc VARCHAR2
           ) RETURN VARCHAR2
);

CREATE OR REPLACE TYPE BODY instrument_dety AS OVERRIDING
    MEMBER FUNCTION graj RETURN VARCHAR2 IS
    BEGIN
        RETURN 'dmucham: ' || dzwiek;
    END;

    MEMBER FUNCTION graj (
        glosnosc VARCHAR2
    ) RETURN VARCHAR2 IS
    BEGIN
        RETURN glosnosc
               || ':'
               || dzwiek;
    END;
END;
/

CREATE TYPE instrument_klawiszowy UNDER instrument (
        producent VARCHAR2(20),
        OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2
);

CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS OVERRIDING
    MEMBER FUNCTION graj RETURN VARCHAR2 IS
    BEGIN
        RETURN 'stukam w klawisze: ' || dzwiek;
    END;
END;
/

DECLARE
    tamburyn  instrument := instrument('tamburyn', 'brzdek-brzdek');
    trabka    instrument_dety := instrument_dety('trabka', 'tra-ta-ta', 'metalowa');
    fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian', 'pingping', 'steinway');
BEGIN
    dbms_output.put_line(tamburyn.graj);
    dbms_output.put_line(trabka.graj);
    dbms_output.put_line(trabka.graj('glosno'));
    dbms_output.put_line(fortepian.graj);
END;

--ZAD 13
CREATE TYPE istota AS OBJECT (
        nazwa VARCHAR2(20),
        NOT INSTANTIABLE MEMBER FUNCTION poluj (
               ofiara CHAR
           ) RETURN CHAR
) NOT INSTANTIABLE NOT FINAL;

CREATE TYPE lew UNDER istota (
        liczba_nog NUMBER,
        OVERRIDING MEMBER FUNCTION poluj (
               ofiara CHAR
           ) RETURN CHAR
);

CREATE OR REPLACE TYPE BODY lew AS OVERRIDING
    MEMBER FUNCTION poluj (
        ofiara CHAR
    ) RETURN CHAR IS
    BEGIN
        RETURN 'upolowana ofiara: ' || ofiara;
    END;
END;

DECLARE
    krollew    lew := lew('LEW', 4);
BEGIN
    dbms_output.put_line(krollew.poluj('antylopa'));
END;

--ZAD 14
DECLARE
    tamburyn instrument;
    cymbalki instrument;
    trabka   instrument_dety;
    saksofon instrument_dety;
BEGIN
    tamburyn := instrument('tamburyn', 'brzdek-brzdek');
    cymbalki := instrument_dety('cymbalki', 'ding-ding', 'metalowe');
    trabka := instrument_dety('trabka', 'tra-ta-ta', 'metalowa');
 -- saksofon := instrument('saksofon','tra-taaaa');
 -- saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);
END;

--ZAD 15
CREATE TABLE instrumenty OF instrument;

INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES ( instrument_dety('trabka','tra-ta-ta','metalowa'));

INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','pingping','steinway') );
SELECT i.nazwa, i.graj() FROM instrumenty i;

--ZAD 16
DROP TABLE PRACOWNICY cascade constraints;
DROP TABLE ZESPOLY cascade constraints;
DROP TABLE ETATY cascade constraints;

CREATE TABLE ZESPOLY
	(ID_ZESP NUMBER(4) CONSTRAINT PK_ZESP PRIMARY KEY,
	NAZWA VARCHAR2(20),
	ADRES VARCHAR2(20) );

CREATE TABLE ETATY
      ( NAZWA VARCHAR2(10) CONSTRAINT PK_ETAT PRIMARY KEY,
	PLACA_MIN NUMBER(6,2),
	PLACA_MAX NUMBER(6,2));

CREATE TABLE PRACOWNICY
       (ID_PRAC NUMBER(6) CONSTRAINT PK_PRAC PRIMARY KEY,
	NAZWISKO VARCHAR2(15),
	ETAT VARCHAR2(10) CONSTRAINT FK_ETAT REFERENCES ETATY(NAZWA),
	ID_SZEFA NUMBER(6) CONSTRAINT FK_ID_SZEFA REFERENCES PRACOWNICY(ID_PRAC),
	ZATRUDNIONY DATE,
	PLACA_POD NUMBER(6,2) CONSTRAINT MIN_PLACA_POD CHECK(PLACA_POD>100),
	PLACA_DOD NUMBER(6,2),
	ID_ZESP NUMBER(4) CONSTRAINT FK_ID_ZESP REFERENCES ZESPOLY(ID_ZESP));

INSERT INTO ZESPOLY VALUES (10,'ADMINISTRACJA',      'PIOTROWO 3A');
INSERT INTO ZESPOLY VALUES (20,'SYSTEMY ROZPROSZONE','PIOTROWO 3A');
INSERT INTO ZESPOLY VALUES (30,'SYSTEMY EKSPERCKIE', 'STRZELECKA 14');
INSERT INTO ZESPOLY VALUES (40,'ALGORYTMY',          'WLODKOWICA 16');
INSERT INTO ZESPOLY VALUES (50,'BADANIA OPERACYJNE', 'MIELZYNSKIEGO 30');

INSERT INTO ETATY VALUES ('PROFESOR'  ,800.00,1500.00);
INSERT INTO ETATY VALUES ('ADIUNKT'   ,510.00, 750.00);
INSERT INTO ETATY VALUES ('ASYSTENT'  ,300.00, 500.00);
INSERT INTO ETATY VALUES ('STAZYSTA'  ,150.00, 250.00);
INSERT INTO ETATY VALUES ('SEKRETARKA',270.00, 450.00);
INSERT INTO ETATY VALUES ('DYREKTOR' ,1280.00,2100.00);
 
INSERT INTO PRACOWNICY VALUES (100,'WEGLARZ'    ,'DYREKTOR'  ,NULL,to_date('01-01-1968','DD-MM-YYYY'),1730.00,420.50,10);
INSERT INTO PRACOWNICY VALUES (110,'BLAZEWICZ'  ,'PROFESOR'  ,100 ,to_date('01-05-1973','DD-MM-YYYY'),1350.00,210.00,40);
INSERT INTO PRACOWNICY VALUES (120,'SLOWINSKI'  ,'PROFESOR'  ,100 ,to_date('01-09-1977','DD-MM-YYYY'),1070.00,  NULL,30);
INSERT INTO PRACOWNICY VALUES (130,'BRZEZINSKI' ,'PROFESOR'  ,100 ,to_date('01-07-1968','DD-MM-YYYY'), 960.00,  NULL,20);
INSERT INTO PRACOWNICY VALUES (140,'MORZY'      ,'PROFESOR'  ,130 ,to_date('15-09-1975','DD-MM-YYYY'), 830.00,105.00,20);
INSERT INTO PRACOWNICY VALUES (150,'KROLIKOWSKI','ADIUNKT'   ,130 ,to_date('01-09-1977','DD-MM-YYYY'), 645.50,  NULL,20);
INSERT INTO PRACOWNICY VALUES (160,'KOSZLAJDA'  ,'ADIUNKT'   ,130 ,to_date('01-03-1985','DD-MM-YYYY'), 590.00,  NULL,20);
INSERT INTO PRACOWNICY VALUES (170,'JEZIERSKI'  ,'ASYSTENT'  ,130 ,to_date('01-10-1992','DD-MM-YYYY'), 439.70, 80.50,20);
INSERT INTO PRACOWNICY VALUES (190,'MATYSIAK'   ,'ASYSTENT'  ,140 ,to_date('01-09-1993','DD-MM-YYYY'), 371.00,  NULL,20);
INSERT INTO PRACOWNICY VALUES (180,'MAREK'      ,'SEKRETARKA',100 ,to_date('20-02-1985','DD-MM-YYYY'), 410.20,  NULL,10);
INSERT INTO PRACOWNICY VALUES (200,'ZAKRZEWICZ' ,'STAZYSTA'  ,140 ,to_date('15-07-1994','DD-MM-YYYY'), 208.00,  NULL,30);
INSERT INTO PRACOWNICY VALUES (210,'BIALY'      ,'STAZYSTA'  ,130 ,to_date('15-10-1993','DD-MM-YYYY'), 250.00,170.60,30);
INSERT INTO PRACOWNICY VALUES (220,'KONOPKA'    ,'ASYSTENT'  ,110 ,to_date('01-10-1993','DD-MM-YYYY'), 480.00,  NULL,20);
INSERT INTO PRACOWNICY VALUES (230,'HAPKE'      ,'ASYSTENT'  ,120 ,to_date('01-09-1992','DD-MM-YYYY'), 480.00, 90.00,30);

COMMIT;

CREATE TABLE przedmioty (
    nazwa      VARCHAR2(50),
    nauczyciel NUMBER
        REFERENCES pracownicy ( id_prac )
);

INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',100);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',100);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',110);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',110);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',120);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',120);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',130);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',140);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',140);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',140);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',150);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',150);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',160);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',160);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',170);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',180);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',180);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',190);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',200);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',210);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',220);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',220);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',230);

--ZAD 17
CREATE TYPE ZESPOL AS OBJECT (
 ID_ZESP NUMBER,
 NAZWA VARCHAR2(50),
 ADRES VARCHAR2(100)
);
/

--ZAD 18
CREATE OR REPLACE VIEW ZESPOLY_V OF ZESPOL
WITH OBJECT IDENTIFIER(ID_ZESP)
AS SELECT ID_ZESP, NAZWA, ADRES FROM ZESPOLY;

--ZAD 19
CREATE TYPE przedmioty_tab AS
    TABLE OF VARCHAR2(100);
/

CREATE TYPE pracownik AS OBJECT (
        id_prac       NUMBER,
        nazwisko      VARCHAR2(30),
        etat          VARCHAR2(20),
        zatrudniony   DATE,
        placa_pod     NUMBER(10, 2),
        miejsce_pracy REF zespol,
        przedmioty    przedmioty_tab,
        MEMBER FUNCTION ile_przedmiotow RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY pracownik AS
    MEMBER FUNCTION ile_przedmiotow RETURN NUMBER IS
    BEGIN
        RETURN przedmioty.count();
    END ile_przedmiotow;
END;

--ZAD 20
CREATE OR REPLACE VIEW PRACOWNICY_V OF PRACOWNIK
WITH OBJECT IDENTIFIER (ID_PRAC)
AS SELECT ID_PRAC, NAZWISKO, ETAT, ZATRUDNIONY, PLACA_POD,
    MAKE_REF(ZESPOLY_V,ID_ZESP),
    CAST(MULTISET( SELECT NAZWA FROM PRZEDMIOTY WHERE NAUCZYCIEL=P.ID_PRAC ) AS
PRZEDMIOTY_TAB )
FROM PRACOWNICY P;

--ZAD 21
SELECT *
FROM PRACOWNICY_V;

SELECT P.NAZWISKO, P.ETAT, P.MIEJSCE_PRACY.NAZWA
FROM PRACOWNICY_V P;

SELECT P.NAZWISKO, P.ILE_PRZEDMIOTOW()
FROM PRACOWNICY_V P;

SELECT *
FROM TABLE( SELECT PRZEDMIOTY FROM PRACOWNICY_V WHERE NAZWISKO='WEGLARZ' );

SELECT NAZWISKO, CURSOR( SELECT PRZEDMIOTY
FROM PRACOWNICY_V
WHERE ID_PRAC=P.ID_PRAC)
FROM PRACOWNICY_V P;

--ZAD 22
CREATE TABLE PISARZE (
    ID_PISARZA NUMBER PRIMARY KEY,
    NAZWISKO VARCHAR2(20),
    DATA_UR DATE );
    
CREATE TABLE KSIAZKI (
    ID_KSIAZKI NUMBER PRIMARY KEY,
    ID_PISARZA NUMBER NOT NULL REFERENCES PISARZE,
    TYTUL VARCHAR2(50),
    DATA_WYDANIE DATE );
    
INSERT INTO PISARZE VALUES(10,'SIENKIEWICZ',DATE '1880-01-01');
INSERT INTO PISARZE VALUES(20,'PRUS',DATE '1890-04-12');
INSERT INTO PISARZE VALUES(30,'ZEROMSKI',DATE '1899-09-11');

INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(10,10,'OGNIEM I MIECZEM',DATE '1990-01-05');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(20,10,'POTOP',DATE '1975-12-09');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(30,10,'PAN WOLODYJOWSKI',DATE '1987-02-15');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(40,20,'FARAON',DATE '1948-01-21');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(50,20,'LALKA',DATE '1994-08-01');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(60,30,'PRZEDWIOSNIE',DATE '1938-02-02');

CREATE TYPE PISARZ AS OBJECT (
    ID_PISARZA NUMBER,
    NAZWISKO VARCHAR2(20),
    DATA_UR DATE,
    LKSIAZEK NUMBER,
    MEMBER FUNCTION LICZBA_KSIAZEK RETURN NUMBER );

CREATE OR REPLACE TYPE BODY PISARZ AS
    MEMBER FUNCTION LICZBA_KSIAZEK RETURN NUMBER IS
    BEGIN
        RETURN LKSIAZEK;
    END;
END;

CREATE OR REPLACE VIEW PISARZE_V OF PISARZ
WITH OBJECT IDENTIFIER (ID_PISARZA) AS
SELECT ID_PISARZA,
       NAZWISKO,
       DATA_UR,
       (SELECT COUNT(*) FROM KSIAZKI WHERE ID_PISARZA = P.ID_PISARZA) AS LKSIAZEK
FROM PISARZE P;

CREATE TYPE KSIAZKA AS OBJECT (
    ID_KSIAZKI NUMBER,
    AUTOR REF PISARZ,
    TYTUL VARCHAR2(50),
    DATA_WYDANIE DATE,
    MEMBER FUNCTION WIEK RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY KSIAZKA AS
    MEMBER FUNCTION WIEK RETURN NUMBER IS
    BEGIN
        RETURN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM DATA_WYDANIE);
    END;
END;

CREATE OR REPLACE VIEW KSIAZKI_V OF KSIAZKA
WITH OBJECT IDENTIFIER (ID_KSIAZKI) AS
SELECT ID_KSIAZKI,
       MAKE_REF(PISARZE_V, ID_PISARZA),
       TYTUL,
       DATA_WYDANIE
FROM KSIAZKI K;

SELECT p.NAZWISKO, p.LICZBA_KSIAZEK() FROM PISARZE_V p;
SELECT TYTUL, k.AUTOR.NAZWISKO FROM KSIAZKI_V k;

--ZAD 23
CREATE TYPE AUTO AS OBJECT (
    MARKA VARCHAR2(20),
    MODEL VARCHAR2(20),
    KILOMETRY NUMBER,
    DATA_PRODUKCJI DATE,
    CENA NUMBER(10,2),
    MEMBER FUNCTION WARTOSC RETURN NUMBER
) NOT FINAL;

CREATE OR REPLACE TYPE BODY AUTO AS
    MEMBER FUNCTION WARTOSC RETURN NUMBER IS
    WIEK NUMBER;
    WARTOSC NUMBER;
    BEGIN
    WIEK := ROUND(MONTHS_BETWEEN(SYSDATE,DATA_PRODUKCJI)/12);
    WARTOSC := CENA - (WIEK * 0.1 * CENA);
    IF (WARTOSC < 0) THEN
    WARTOSC := 0;
    END IF;
    RETURN WARTOSC;
    END WARTOSC;
END;

CREATE TABLE AUTA OF AUTO;

INSERT INTO AUTA VALUES (AUTO('FIAT','BRAVA',60000,DATE '1999-11-30',25000));
INSERT INTO AUTA VALUES (AUTO('FORD','MONDEO',80000,DATE '1997-05-10',45000));
INSERT INTO AUTA VALUES (AUTO('MAZDA','323',12000,DATE '2000-09-22',52000));

CREATE OR REPLACE TYPE auto_osobowe UNDER auto (
    liczba_miejsc NUMBER,
    klimatyzacja NUMBER,
    OVERRIDING MEMBER FUNCTION wartosc RETURN NUMBER 
);

CREATE OR REPLACE TYPE BODY auto_osobowe AS
    OVERRIDING MEMBER FUNCTION wartosc RETURN NUMBER IS
        bazowa_wartosc NUMBER;
    BEGIN
        bazowa_wartosc := (SELF AS AUTO).WARTOSC();
        if klimatyzacja = 1 THEN
            RETURN bazowa_wartosc * 1.5;
        end if;
        RETURN bazowa_wartosc;
    END;
END;

CREATE TYPE auto_ciezarowe UNDER auto (
    maks_ladownosc NUMBER,
    OVERRIDING MEMBER FUNCTION wartosc RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY auto_ciezarowe AS
    OVERRIDING MEMBER FUNCTION wartosc RETURN NUMBER IS
        bazowa_wartosc NUMBER;
    BEGIN
        bazowa_wartosc := (SELF AS AUTO).WARTOSC();
        if maks_ladownosc > 10 THEN
            RETURN bazowa_wartosc * 2;
        end if;
        RETURN bazowa_wartosc;
    END;
END;

INSERT INTO AUTA VALUES (auto_osobowe('Toyota', 'Corolla', 150000, DATE '2020-11-15', 12000, 5, 1));
INSERT INTO AUTA VALUES (auto_osobowe('Volkswagen', 'Golf', 130000, DATE '2021-05-02', 8000, 5, 0));
INSERT INTO AUTA VALUES (auto_ciezarowe('Volvo', 'FH16', 350000, DATE '2022-09-10', 80000, 10));
INSERT INTO AUTA VALUES (auto_ciezarowe('Mercedes-Benz', 'Actros', 420000, DATE '2020-12-18', 70000, 8));

SELECT marka, a.wartosc() FROM auta a;
