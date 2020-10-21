------- Меркулов Лев Владимирович
------- Создание базы данных и таблицы для импорта
CREATE TABLE moove;
\c moove 
set search_path TO public ;
CREATE TABLE test_table (
id serial,
department text,
email text,
first_name text,
last_name text,
phone text,
position text,
room integer );
\d test_table

ALTER SEQUENCE test_table_id_seq MINVALUE 0 RESTART WITH 0;
ALTER TABLE test_table ALTER COLUMN room SET DATA TYPE text;
ALTER TABLE test_table ADD PRIMARY KEY(id);
\d test_table;

-------------- 0. Импорт таблицы в Postgres
\copy test_table FROM 'src/db_normalized.csv' DELIMITER ',' CSV HEADER;

--------------Запросы
--------------1. получение всех имен и фамилий людей в определенном кабинете; 
SELECT first_name, last_name, room FROM test_table WHERE room = '5424.0';
-------------- 2. добавление нового телефона сотруднику;
UPDATE test_table SET phone = '+79159344480' WHERE first_name = 'William' and last_name = 'Anderson' and position = 'Specialist' RETURNING *;

-------------- 3. получение списка телефонов всех сотрудников определенной должности в одном из отделов; 

SELECT phone FROM test_table WHERE depatment = 'R&D' and position = 'Intern';

--------------4.добавление нового сотрудника;

INSERT INTO test_table  VALUES (
'167979', 'Clerical Office',
'test@mail.ru',
'Student',
'Test',
'+78005553555',
'Intern',
'5329.0') RETURNING *;

--------------5. перемещение сотрудника в другой отдел со сменой комнаты.
select MAX(id) FROM test_table;

UPDATE test_table SET position = 'Specialist', room = '400.0' WHERE id = 167979 RETURNING *;

-------------- Сохранение запросов в локальный файл
\s src/moove.sql
