-- ------------------------------------------------------------------
-- Base de dades per seguir el curs «Hello SQL» de MoureDev
-- Reconstrucció pròpia: les dades no són les mateixes que surten al
-- vídeo, però tenen la mateixa estructura i permeten executar tots
-- els exemples del repositori github.com/mouredev/hello-sql
-- ------------------------------------------------------------------

SET NAMES utf8mb4;

DROP DATABASE IF EXISTS hello_mysql;
CREATE DATABASE hello_mysql CHARACTER SET utf8mb4;
USE hello_mysql;

CREATE TABLE users (
    user_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100),
    age INT,
    init_date DATE,
    email VARCHAR(100),
    PRIMARY KEY (user_id),
    UNIQUE (email)
);

INSERT INTO users (name, surname, age, init_date, email) VALUES
('Brais', 'Moure', 35, '2010-01-15', 'braismoure@mouredev.com'),
('Sara', 'Gómez', 15, '2023-09-12', 'sara@gmail.com'),
('Pau', 'Ferrer', 22, '2019-03-01', 'pau@gmail.com'),
('Marta', 'Vidal', 30, '2015-06-20', 'marta@yahoo.es'),
('Joan', 'Pons', 15, NULL, NULL),
('Aina', 'Riera', NULL, '2021-11-05', 'aina@hotmail.com'),
('Biel', 'Serra', 18, '2024-02-10', 'biel@gmail.com');
