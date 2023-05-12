CREATE DATABASE mytest;
CREATE USER noob@localhost IDENTIFIED BY 'password';
GRANT ALL ON mytest.* TO noob@localhost;
FLUSH PRIVILEGES;

USE mytest;

CREATE TABLE users (
  user_id int NOT NULL AUTO_INCREMENT,
  username varchar(15),
  email varchar(50),
  password varchar(32),
  phone varchar(15),
  PRIMARY KEY (user_id)
);

CREATE TABLE comments (
  id int NOT NULL AUTO_INCREMENT,
  user_id int NOT NULL,
  comment text NOT NULL,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);
