GRANT ALL ON *.* TO 'vaultuser'@'%' IDENTIFIED BY 'vaultpass';
GRANT GRANT OPTION ON *.* TO 'vaultuser'@'%';

CREATE DATABASE appdb;

USE appdb;

CREATE TABLE greetings ( 
    id smallint unsigned not null auto_increment
    , phrase nvarchar(255)
    , constraint pk_greetings primary key (id) );

INSERT INTO greetings ( phrase )
    VALUES ('Hello MySQL!');
