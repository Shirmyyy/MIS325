/*
<Shimin Zhang>
<sz6939>
<8am>
Assignment 4
*/

--Question 1
CREATE TABlE users 
(
    user_id    NUMBER(9,0)  PRIMARY KEY,
    email      VARCHAR2(50) NOT NULL  UNIQUE,
    password   VARCHAR2(50) NOT NULL,
    first_name VARCHAR2(50) NOT NULL,
    last_name  VARCHAR2(50) NOT NULL,
    nick_name  VARCHAR2(50),
    date_of_birth DATE  NOT NULL,
    university_id NUMBER(9,0) NOT NULL
)
;

CREATE TABLE posts
(
    post_id     NUMBER(9,0) PRIMARY KEY,
    post_timestamp TIMESTAMP   NOT NULL,
    user_id     NUMBER(9,0)  NOT NULL
                            CONSTRAINT posts_fk_users REFERENCES users(user_id),
    message     VARCHAR2(250)   NOT NULL
)
;

CREATE TABLE comments
(
   comment_id  NUMBER(9,0) PRIMARY KEY,
   comment_timestamp   TIMESTAMP   NOT NULL,
   comment_message     VARCHAR2(250)   NOT NULL, 
   user_id     NUMBER(9,0) NOT NULL
                            CONSTRAINT comments_fk_users REFERENCES users(user_id),
   post_id     NUMBER(9,0) NOT NULL
                            CONSTRAINT comments_fk_posts REFERENCES posts(post_id)  
)
;

--Question 2
ALTER TABLE users
ADD phone_number VARCHAR2(10)
;

--Question 3
CREATE TABLE universities
(
    university_id   NUMBER(9,0) PRIMARY KEY,
    university_name VARCHAR2(50)    NOT NULL    UNIQUE
)
;

ALTER TABLE users
ADD CONSTRAINT fk_university FOREIGN KEY(university_id) REFERENCES universities(university_id)
;

--Question 4
ALTER TABLE users
DROP CONSTRAINT fk_university
;
DROP TABLE universities 
;

--Question 5
/*CREATE TABLE universities
(
university_id   NUMBER(9,0) PRIMARY KEY,
university_name VARCHAR2(50)    NOT NULL    UNIQUE
)
;*/

INSERT INTO users 
VALUES (1234,'josh@example.com', 'JoshLovesSQL123', 'Josh', 'Choe', NULL, '01-JAN-97', 4444,'5121234567')
;

INSERT INTO users 
VALUES (5678,'madalyn@example.com', 'MadiLovesSQL123', 'Madalyn', 'Marabella', NULL, '01-JAN-98',4444,'5121122334')
;

--Question 6
INSERT INTO posts 
VALUES(0001, CURRENT_TIMESTAMP, 5678, 'Has anyone finished the homework?')
;

--Question 7
INSERT INTO comments
VALUES (0001, CURRENT_TIMESTAMP, 'I have', 1234, 0001)
;

--Question 8
INSERT INTO comments
VALUES (0002, CURRENT_TIMESTAMP, 'I have a question', 5678, 0001)
;

--Question 9
DELETE FROM comments
WHERE comment_id = 0002
;

--Question 10
ALTER TABLE comments
DROP CONSTRAINT comments_fk_users 
DROP CONSTRAINT comments_fk_posts
;

ALTER TABLE comments
ADD CONSTRAINT comments_fk_users FOREIGN KEY(user_id) REFERENCES users(user_id)
ON DELETE CASCADE
;

ALTER TABLE comments
ADD CONSTRAINT comments_fk_posts FOREIGN KEY(post_id) REFERENCES posts(post_id)
ON DELETE CASCADE
;

ALTER TABLE posts
DROP CONSTRAINT posts_fk_users
;

ALTER TABLE posts
ADD CONSTRAINT posts_fk_users FOREIGN KEY(user_id) REFERENCES users(user_id)
ON DELETE CASCADE
;

DELETE FROM users
WHERE user_id = 5678
;

    