                                                                                                                                                                                                                                                                                                                                                                                                                            -- /* Задание №1 */
--DROP TABLESPACE TS_SNE INCLUDING CONTENTS AND DATAFILES
CREATE TABLESPACE TS_SNE
DATAFILE 'TS_SNE.dbf'
SIZE 7M
AUTOEXTEND ON
NEXT 5M
MAXSIZE 20M;

-- /* Задание №2 */
--DROP TABLESPACE TS_SNE_TEMP INCLUDING CONTENTS AND DATAFILES
CREATE TEMPORARY TABLESPACE TS_SNE_TEMP
TEMPFILE 'TS_SNE_TEMP.dbf'
SIZE 5M
AUTOEXTEND ON
NEXT 3M
MAXSIZE 30M;

-- /* Задание №3 */
SELECT * FROM SYS.dba_tablespaces;
SELECT * FROM SYS.dba_data_files;

-- /* Задание №4 */
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
--DROP ROLE RL_SNECORE;
CREATE ROLE RL_SNECORE;

GRANT CONNECT, CREATE SESSION, CREATE ANY TABLE, DROP ANY TABLE, CREATE ANY VIEW,
DROP ANY VIEW, CREATE ANY PROCEDURE, DROP ANY PROCEDURE TO RL_SNECORE;

-- /* Задание №5 */
SELECT * FROM dba_roles WHERE role LIKE '%RL%';
SELECT * FROM dba_sys_privs;
SELECT * FROM dba_roles;

-- /* Задание №6 */
--DROP PROFILE PF_SNECORE;
CREATE PROFILE PF_SNECORE LIMIT
PASSWORD_LIFE_TIME 365
SESSIONS_PER_USER 5
FAILED_LOGIN_ATTEMPTS 5
PASSWORD_LOCK_TIME 1
PASSWORD_REUSE_TIME 10
PASSWORD_GRACE_TIME DEFAULT
CONNECT_TIME 180
IDLE_TIME 45;

-- /* Задание №7 */
SELECT profile, resource_name, limit FROM dba_profiles ORDER BY profile;
SELECT profile, resource_name, limit FROM dba_profiles WHERE profile = 'PF_SNECORE';
SELECT profile, resource_name, limit FROM dba_profiles WHERE profile = 'DEFAULT';

-- /* Задание №8 */
--DROP USER SNECORE;
CREATE USER SNECORE IDENTIFIED BY SNE123
DEFAULT TABLESPACE TS_SNE QUOTA UNLIMITED ON TS_SNE
TEMPORARY TABLESPACE TS_SNE_TEMP
PROFILE PF_SNECORE
ACCOUNT UNLOCK
PASSWORD EXPIRE;

GRANT RL_SNECORE TO SNECORE;

-- /* Задание №10 */
--CREATE TABLE sample_table (
--    id NUMBER PRIMARY KEY,
--    name VARCHAR2(100)
--);

--CREATE VIEW sample_view AS
--SELECT * FROM sample_table;

-- /* Задание №11 */
--DROP TABLESPACE SNE_QDATA INCLUDING CONTENTS AND DATAFILES
CREATE TABLESPACE SNE_QDATA
DATAFILE 'SNE_QDATA.dbf'
SIZE 10M
OFFLINE;

SELECT tablespace_name, status, contents FROM SYS.dba_tablespaces;

ALTER TABLESPACE SNE_QDATA ONLINE;

ALTER USER SNECORE QUOTA 2M ON SNE_QDATA;

--SNECORE
--DROP TABLE SNE_T1
CREATE TABLE SNE_T1
(
    x number(2),
    s varchar(50)
)TABLESPACE SNE_QDATA;

INSERT ALL 
    INTO SNE_T1 VALUES (1, 'HELLO')
    INTO SNE_T1 VALUES (2, 'TEST')
    INTO SNE_T1 VALUES (3, 'WORLD')
    SELECT * FROM dual;
    
SELECT * FROM SNE_T1;

SELECT owner FROM dba_tables where table_name = 'SNE_T1';

















































