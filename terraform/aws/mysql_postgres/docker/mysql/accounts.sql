#GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'replicator' IDENTIFIED BY 'replpass';
#GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT  ON *.* TO 'debezium' IDENTIFIED BY 'dbz';

# Create the database that we'll use to populate data and watch the effect in the binlog
CREATE DATABASE demo;
GRANT ALL PRIVILEGES ON demo.* TO 'mysqluser'@'%';

use demo;

create table accounts (
	account_id VARCHAR(50) NOT NULL,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(50),
	phone VARCHAR(50),
	address VARCHAR(50),
	country VARCHAR(50),
    create_ts timestamp DEFAULT CURRENT_TIMESTAMP ,
    update_ts timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (account_id)
);

-- https://www.mockaroo.com/8be2bd10
insert into accounts (account_id, first_name, last_name, email, phone, address, country) values ('a001', 'Robin', 'Moffatt', 'robin@confluent.io', '+44 123 456 789', '22 Acacia Avenue', 'United Kingdom');
insert into accounts (account_id, first_name, last_name, email, phone, address, country) values ('a002', 'Sidoney', 'Lafranconi', 'slafranconi0@cbc.ca', '+44 908 687 6649', '40 Kensington Pass', 'United Kingdom');
insert into accounts (account_id, first_name, last_name, email, phone, address, country) values ('a003', 'Mick', 'Edinburgh', 'medinburgh1@eepurl.com', '+44 301 837 6535', '27 Blackbird Lane', 'United Kingdom');
insert into accounts (account_id, first_name, last_name, email, phone, address, country) values ('a004', 'Merrill', 'Stroobant', 'mstroobant2@china.com.cn', '+44 694 224 4989', '4053 Corry Circle', 'United Kingdom');
insert into accounts (account_id, first_name, last_name, email, phone, address, country) values ('a005', 'Cheryl', 'Vern', 'cvern3@istockphoto.com', '+44 978 613 7286', '993 Loomis Junction', 'United Kingdom');
insert into accounts (account_id, first_name, last_name, email, phone, address, country) values ('a006', 'Aura', 'Cota', 'acota4@dion.ne.jp', '+44 516 539 4337', '5106 Waxwing Pass', 'United Kingdom');
insert into accounts (account_id, first_name, last_name, email, phone, address, country) values ('a007', 'Carsten', 'Muetzlitz', 'cmutzlitz@confluent.io', '+49 30 200202', '13595 Berlin', 'Germany');
