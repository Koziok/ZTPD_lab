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



