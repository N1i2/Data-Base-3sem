SET SERVEROUTPUT ON;

GRANT CREATE PROCEDURE TO U1_SNE_PDB; 

-- Task 1

DECLARE
    PROCEDURE GET_TEACHERS (PCODE TEACHER.PULPIT%TYPE)
    AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Pulpit: ' || PCODE || ';');

        FOR res IN (SELECT TEACHER_NAME, PULPIT FROM TEACHER WHERE PULPIT = PCODE)
        LOOP
            DBMS_OUTPUT.PUT_LINE('===================================================');
            DBMS_OUTPUT.PUT_LINE('Name: ' || res.TEACHER_NAME || ';');
            DBMS_OUTPUT.PUT_LINE('Pulpit: ' || res.PULPIT || ';');
        END LOOP;
    END GET_TEACHERS;
BEGIN
    GET_TEACHERS('ПОиСОИ');
END;

-- Task 2
CREATE OR REPLACE FUNCTION GET_NUM_TEACHERS (PCODE TEACHER.PULPIT%TYPE) RETURN NUMBER
AUTHID DEFINER
AS
    result_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO result_count
    FROM TEACHER tch
    WHERE tch.PULPIT = PCODE;

    RETURN result_count;
END GET_NUM_TEACHERS;
/

DECLARE
    PULPIT TEACHER.PULPIT%TYPE := 'ПОиСОИ';
    res_count NUMBER;
BEGIN
    res_count := GET_NUM_TEACHERS(PULPIT);

    DBMS_OUTPUT.PUT_LINE('Count in ' || RTRIM(PULPIT) || ' = ' || res_count || ';');
END;
/

-- Task 3
CREATE OR REPLACE PROCEDURE GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
AUTHID DEFINER
AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Fuculty ' || RTRIM(FCODE));

    FOR res IN (SELECT tch.TEACHER_NAME, fac.FACULTY_NAME FROM PULPIT pl
    INNER JOIN TEACHER tch ON tch.PULPIT = pl.PULPIT
    INNER JOIN FACULTY fac ON fac.FACULTY = pl.FACULTY
    WHERE fac.FACULTY = FCODE)
    LOOP
        DBMS_OUTPUT.PUT_LINE('===============================================');
        DBMS_OUTPUT.PUT_LINE('Name: ' || res.TEACHER_NAME || ';');
        DBMS_OUTPUT.PUT_LINE('Faculty: ' || res.FACULTY_NAME || ';');
    END LOOP;
END GET_TEACHERS;
/

DECLARE
    fanc FACULTY.FACULTY%TYPE := 'ЛХФ';
BEGIN
    GET_TEACHERS(fanc);
END;
/

-- Task 4
CREATE OR REPLACE PROCEDURE GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
AUTHID DEFINER
AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Pulpit ' || RTRIM(PCODE));

    FOR res IN (SELECT * FROM SUBJECT su WHERE su.PULPIT = PCODE)
    LOOP
        DBMS_OUTPUT.PUT_LINE('===============================================');
        DBMS_OUTPUT.PUT_LINE('SUBJECT: ' || res.SUBJECT_NAME || ';');
        DBMS_OUTPUT.PUT_LINE('Pulpit: ' || res.Pulpit || ';');
    END LOOP;
END GET_SUBJECTS;
/

DECLARE 
    pulpit SUBJECT.PULPIT%type := 'ПОиСОИ';
BEGIN
    GET_SUBJECTS(pulpit);
END;
/

-- Task 5
CREATE OR REPLACE FUNCTION GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER
AUTHID DEFINER
AS
    res NUMBER;
BEGIN
    SELECT COUNT(*) INTO res    
    FROM PULPIT pl
    INNER JOIN TEACHER tch ON tch.PULPIT = pl.PULPIT
    INNER JOIN FACULTY fac ON fac.FACULTY = pl.FACULTY
    WHERE fac.FACULTY = FCODE;

    RETURN res;
END GET_NUM_TEACHERS;
/

DECLARE
    fvalue FACULTY.FACULTY%TYPE := 'ЛХФ';
    res NUMBER;
BEGIN
    res := GET_NUM_TEACHERS(fvalue);

    DBMS_OUTPUT.PUT_LINE('Teacher count: ' || res || ';');
END;
/

-- Task 6
CREATE OR REPLACE FUNCTION GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER 
AUTHID DEFINER
AS
    num_subjects NUMBER; 
BEGIN
    SELECT COUNT(*) 
    INTO num_subjects
    FROM SUBJECT
    WHERE PULPIT = PCODE;

    RETURN num_subjects;
END GET_NUM_SUBJECTS;
/


declare
    num NUMBER;
BEGIN
    num := GET_NUM_SUBJECTS('ИСиТ');

    DBMS_OUTPUT.PUT_LINE('Count = ' || num);
END;


-- Task 7
CREATE OR REPLACE PACKAGE TEACHERS_PACK AS
    PROCEDURE GET_TEACHERS(FCODE FACULTY.FACULTY%TYPE);
    PROCEDURE GET_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE);
    FUNCTION GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER;
    FUNCTION GET_NUM_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER;
END TEACHERS_PACK;
/

CREATE OR REPLACE PACKAGE BODY TEACHERS_PACK AS
    PROCEDURE GET_TEACHERS(FCODE FACULTY.FACULTY%TYPE)
    AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Pulpit: ' || FCODE || ';');

        FOR res IN (SELECT TEACHER_NAME, PULPIT FROM TEACHER WHERE PULPIT = FCODE)
        LOOP
            DBMS_OUTPUT.PUT_LINE('===================================================');
            DBMS_OUTPUT.PUT_LINE('Name: ' || res.TEACHER_NAME || ';');
            DBMS_OUTPUT.PUT_LINE('Pulpit: ' || res.PULPIT || ';');
        END LOOP;
    END GET_TEACHERS;

    PROCEDURE GET_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE)
    AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Pulpit ' || RTRIM(PCODE));

        FOR res IN (SELECT * FROM SUBJECT su WHERE su.PULPIT = PCODE)
        LOOP
            DBMS_OUTPUT.PUT_LINE('===============================================');
            DBMS_OUTPUT.PUT_LINE('SUBJECT: ' || res.SUBJECT_NAME || ';');
            DBMS_OUTPUT.PUT_LINE('Pulpit: ' || res.Pulpit || ';');
        END LOOP;
    END GET_SUBJECTS;

    FUNCTION GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER
    AS
        result_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO result_count
        FROM TEACHER tch
        WHERE tch.PULPIT = FCODE;

        RETURN result_count;
    END GET_NUM_TEACHERS;

    FUNCTION GET_NUM_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER
    AS
        num_subjects NUMBER; 
    BEGIN
        SELECT COUNT(*) 
        INTO num_subjects
        FROM SUBJECT
        WHERE PULPIT = PCODE;

        RETURN num_subjects;
    END GET_NUM_SUBJECTS;
END TEACHERS_PACK;
/

show errors;

DECLARE
    first_numb number;
    second_numb number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('VVV GET_TEACHERS VVV');
    TEACHERS_PACK.GET_TEACHERS('ПОиСОИ');
    DBMS_OUTPUT.PUT_LINE('VVV GET_SUBJECTS VVV');
    TEACHERS_PACK.GET_SUBJECTS('ПОиСОИ');
    first_numb :=  TEACHERS_PACK.GET_NUM_TEACHERS('ПОиСОИ');
    second_numb := TEACHERS_PACK.GET_NUM_SUBJECTS('ИСиТ');

    DBMS_OUTPUT.PUT_LINE('GET_NUM_TEACHERS = ' || first_numb);
    DBMS_OUTPUT.PUT_LINE('GET_NUM_SUBJECTS = ' || second_numb);    
END;