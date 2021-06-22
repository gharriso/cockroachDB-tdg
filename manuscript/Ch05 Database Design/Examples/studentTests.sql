DROP DATABASE studenttests;
CREATE DATABASE studenttests;

CREATE TABLE public.studentstestdemormalized (
	studentname VARCHAR NULL,
	studentaddress VARCHAR NULL,
	studentdob DATE NULL,
	testname VARCHAR NULL,
	testdate DATE NULL,
	question1 VARCHAR NULL,
	answer1 VARCHAR NULL,
	question2 VARCHAR NULL,
	answer2 VARCHAR NULL,
	question3 VARCHAR NULL,
	answer3 VARCHAR NULL,
	question4 VARCHAR NULL,
	answer4 VARCHAR NULL,
	question5 VARCHAR NULL,
	answer5 VARCHAR NULL,
	question6 VARCHAR NULL,
	answer6 VARCHAR NULL,
	question7 VARCHAR NULL,
	answer7 VARCHAR NULL,
	question8 VARCHAR NULL,
	answer8 VARCHAR NULL,
	question9 VARCHAR NULL,
	answer9 VARCHAR NULL,
	question10 VARCHAR NULL,
	answer10 VARCHAR NULL);
	
DROP SCHEMA NORMALIZED cascade;

CREATE SCHEMA NORMALIZED;
 SET SCHEMA NORMALIZED ;

CREATE TABLE "normalized".students (
	student_id uuid NOT NULL PRIMARY KEY,
	"name" varchar NOT NULL,
	address varchar NOT NULL,
	dob date NOT NULL 
);

CREATE TABLE "normalized".tests (
	test_id uuid NOT NULL PRIMARY KEY,
	"name" varchar NOT NULL);

CREATE TABLE "normalized".testQuestions (
	test_id uuid NOT NULL ,
    Question_no integer NOT NULL,
    Question_Text varchar NOT NULL,
    CONSTRAINT testQuestions_pk PRIMARY KEY (test_id,Question_No),
    CONSTRAINT testQuestions_fk1 FOREIGN KEY (test_id) REFERENCES "normalized".tests(test_id));
 

CREATE TABLE "normalized".studentTest (
	student_id uuid NOT NULL ,
	test_id uuid NOT NULL,
	testDate date NOT NULL, 
    CONSTRAINT studentTest_pk PRIMARY KEY (student_id,test_id),
    CONSTRAINT studentTest_fk1 FOREIGN KEY (test_id) REFERENCES "normalized".tests(test_id),
    CONSTRAINT studentTest_fk2 FOREIGN KEY (student_id) REFERENCES "normalized".students(student_id)
   );

  
  CREATE TABLE "normalized".testAnswers (
	student_id uuid NOT NULL ,
	test_id uuid NOT NULL,
	Question_No integer NOT NULL,
	Questionanswer varchar,
    CONSTRAINT testAnswers_pk PRIMARY KEY (student_id,test_id,Question_No),
    CONSTRAINT testAnswers_fk1 FOREIGN KEY (test_id,Question_No) REFERENCES "normalized".testQuestions(test_id,Question_No),
    CONSTRAINT testAnswers_fk2 FOREIGN KEY (student_id,test_id) REFERENCES "normalized".studentTest(student_id,test_id)
   );
  
INSERT INTO students (student_id,name,address,dob)
with recursive series as (
	select 1 as id union all
	select id + 1 as id
   from series
   where id < 10000),
    randoms AS (
  SELECT id int_id,(random()*10000000)::int randomInt, 
            random() randomFloat,
             md5(random()::STRING) randomString ,
            (now()-INTERVAL '30 years')+ (random()*20||' years')::INTERVAL randomDate FROM series)
 SELECT gen_random_uuid(),randomString,randomString, randomDate::date FROM randoms;

CREATE TABLE NORMALIZED.classes (
	class_id uuid NOT NULL PRIMARY KEY,
	class_name STRING,
	lecturer_name string
 );

INSERT INTO classes (class_id,class_name,lecturer_name)
with recursive series as (
	select 1 as id union all
	select id + 1 as id
   from series
   where id < 10000),
    randoms AS (
  SELECT id int_id,(random()*10000000)::int randomInt, 
            random() randomFloat,
             md5(random()::STRING) randomString ,
            (now()-INTERVAL '30 years')+ (random()*20||' years')::INTERVAL randomDate FROM series)
 SELECT gen_random_uuid(),randomString,randomString FROM randoms;

DROP TABLE studentClasses;

CREATE TABLE studentClasses (
	student_id uuid NOT NULL,
	class_id uuid NOT NULL,
	PRIMARY KEY (student_id,class_id),
	CONSTRAINT studentClassesfk1 FOREIGN KEY (student_id) REFERENCES students(student_id),
	CONSTRAINT studentClassesfk2 FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

INSERT INTO studentClasses(student_id,class_Id)
SELECT student_id, class_id FROM 
(SELECT student_id FROM students LIMIT 100) s CROSS JOIN
(SELECT class_id FROM classes LIMIT 100) c;

SELECT * FROM studentClasses LIMIT 1;

SELECT class_name FROM students 
  JOIN studentClasses USING(student_id) 
  JOIN classes USING(class_id)
 WHERE student_id='000390a6-4e1d-4bc1-aad7-66b645131d54';

ALTER TABLE students ADD COLUMN classes UUID[];

UPDATE students s SET classes= (
       SELECT array_agg(class_id) 
        FROM studentClasses sc 
       WHERE s.student_id=sc.student_id);
      
SELECT * FROM students WHERE student_id='000390a6-4e1d-4bc1-aad7-66b645131d54';

WITH students_classes AS (
	SELECT student_id , UNNEST(classes) class_id  
	  FROM students
) 
SELECT class_name FROM classes 
  JOIN students_classes USING(class_id)
 WHERE student_id='000390a6-4e1d-4bc1-aad7-66b645131d54';


 
 SELECT s.student_id,s.test_id,question_no,questionanswer 
  FROM studenttest s 
  JOIN testanswers t on(t.student_id=s.student_id AND t.test_id=s.test_id)
 WHERE s.student_id=:student_id 
   AND s.test_id=:test_id;
  

 
 


DROP SCHEMA OVERNORMALIZED CASCADE;

CREATE SCHEMA OVERNORMALIZED;

CREATE TABLE OVERNORMALIZED.countries (country_id int PRIMARY KEY , country_name varchar NOT null);

CREATE TABLE OVERNORMALIZED.states (state_id int PRIMARY KEY , country_id INt NOT NULL REFERENCES OVERNORMALIZED.countries (country_id),state_name varchar NOT null);

CREATE TABLE OVERNORMALIZED.cities (city_id int PRIMARY KEY , state_id INt NOT NULL REFERENCES OVERNORMALIZED.states (state_id),city_name varchar NOT null);

CREATE TABLE OVERNORMALIZED.addresses (address_id int PRIMARY KEY , city_id INt NOT NULL REFERENCES OVERNORMALIZED.cities (city_id),street_address varchar NOT null);

CREATE TABLE OVERNORMALIZED.students (
	student_id int NOT NULL PRIMARY KEY,
	"name" varchar NOT NULL,
	address_id int NOT NULL  REFERENCES OVERNORMALIZED.addresses (address_id),
	dob date NOT NULL 
);

DROP TABLE studentTest;

CREATE TABLE  studentTest (
	student_id uuid NOT NULL ,
	test_id uuid NOT NULL,
	testDate date NOT NULL, 
	testAnswers varchar[] NOT NULL
   );
  
  INSERT INTO studentTest values(gen_random_uuid(),gen_random_uuid(),now(),array['a','b','c','d']);
  
  SELECT * FROM studenttest s WHERE student_id='2fdaadf5-ff3e-45c4-bc92-cc0d566e1ad9' AND test_id='dca69ac4-6c53-4efb-8c7e-bca9f412e2ee'
  
UPDATE studenttest s 
   SET testAnswers=array['a','b','c','d']
 WHERE student_id='2fdaadf5-ff3e-45c4-bc92-cc0d566e1ad9' 
   AND test_id='dca69ac4-6c53-4efb-8c7e-bca9f412e2ee'  

   
CREATE SCHEMA jsonTests;
SET SCHEMA jsonTests;

CREATE TABLE  studentTest (
	student_id uuid NOT NULL ,
	test_id uuid NOT NULL,
	testDate date NOT NULL, 
	answers JSONB
);

INSERT INTO studentTest (student_id,test_id,testDate,answers)
 VALUES ('2fdaadf5-ff3e-45c4-bc92-cc0d566e1ad9','dca69ac4-6c53-4efb-8c7e-bca9f412e2ee',now(),
         '{"answers":[
			 {"questionNumber":1,"Answer":5},
			 {"questionNumber":2,"Answer":25},
			 {"questionNumber":3,"Answer":58},
			 {"questionNumber":4,"Answer":3425},
			 {"questionNumber":5,"Answer":432},
			 {"questionNumber":6,"Answer":0},
			 {"questionNumber":7,"Answer":673}
		   ]}');
   
  



