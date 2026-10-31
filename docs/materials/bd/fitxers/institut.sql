-- ------------------------------------------------------------------
-- Base de dades «institut» per als exercicis de bases de dades
-- Dades inventades
-- ------------------------------------------------------------------

SET NAMES utf8mb4;

DROP DATABASE IF EXISTS institut;
CREATE DATABASE institut CHARACTER SET utf8mb4;
USE institut;

CREATE TABLE grups (
    grup_id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(20) NOT NULL UNIQUE,
    curs VARCHAR(30) NOT NULL
);

CREATE TABLE alumnes (
    alumne_id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    llinatges VARCHAR(100) NOT NULL,
    data_naixement DATE,
    municipi VARCHAR(50),
    correu VARCHAR(100) UNIQUE,
    grup_id INT,
    FOREIGN KEY (grup_id) REFERENCES grups(grup_id)
);

CREATE TABLE professors (
    professor_id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    llinatges VARCHAR(100) NOT NULL,
    departament VARCHAR(50)
);

CREATE TABLE assignatures (
    assignatura_id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(80) NOT NULL,
    hores_setmana INT CHECK (hores_setmana > 0),
    professor_id INT,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
);

CREATE TABLE notes (
    alumne_id INT,
    assignatura_id INT,
    nota DECIMAL(4,2) CHECK (nota BETWEEN 0 AND 10),
    PRIMARY KEY (alumne_id, assignatura_id),
    FOREIGN KEY (alumne_id) REFERENCES alumnes(alumne_id),
    FOREIGN KEY (assignatura_id) REFERENCES assignatures(assignatura_id)
);

INSERT INTO grups (nom, curs) VALUES
('1BA', '1r de Batxillerat'),
('1BB', '1r de Batxillerat'),
('2BA', '2n de Batxillerat'),
('4EA', '4t d''ESO');

INSERT INTO alumnes (nom, llinatges, data_naixement, municipi, correu, grup_id) VALUES
('Aina', 'Ferrer Pons', '2009-03-14', 'Palma', 'aina.ferrer@exemple.cat', 1),
('Biel', 'Mas Riera', '2009-07-02', 'Marratxí', 'biel.mas@exemple.cat', 1),
('Carla', 'Vidal Bauzà', '2009-11-23', 'Palma', 'carla.vidal@exemple.cat', 1),
('Dani', 'Oliver Serra', '2008-12-30', 'Inca', NULL, 2),
('Elena', 'Garcia Ramis', '2009-05-08', 'Palma', 'elena.garcia@exemple.cat', 2),
('Fèlix', 'Roig Coll', '2008-02-17', 'Llucmajor', 'felix.roig@exemple.cat', 3),
('Gemma', 'Sastre Pujol', '2008-09-04', 'Palma', 'gemma.sastre@exemple.cat', 3),
('Hug', 'Bennàssar Vich', '2010-01-21', 'Marratxí', NULL, 4),
('Irene', 'Fiol Torres', '2010-06-11', 'Palma', 'irene.fiol@exemple.cat', 4),
('Joan', 'Amengual Mir', '2009-04-29', 'Calvià', 'joan.amengual@exemple.cat', NULL);

INSERT INTO professors (nom, llinatges, departament) VALUES
('Marta', 'Coll Ripoll', 'Tecnologia'),
('Pere', 'Llull Sureda', 'Matemàtiques'),
('Laura', 'Bonnín Font', 'Llengua catalana'),
('Xavier', 'Ramon Alzina', 'Tecnologia');

INSERT INTO assignatures (nom, hores_setmana, professor_id) VALUES
('Programació i Tractament de Dades I', 4, 1),
('Matemàtiques I', 4, 2),
('Llengua Catalana i Literatura I', 3, 3),
('Programació i Tractament de Dades II', 4, 4),
('Tecnologia', 3, NULL);

INSERT INTO notes (alumne_id, assignatura_id, nota) VALUES
(1, 1, 8.50), (1, 2, 7.00), (1, 3, 9.25),
(2, 1, 4.75), (2, 2, 5.50), (2, 3, 6.00),
(3, 1, 9.75), (3, 2, 8.00),
(4, 1, 6.25), (4, 2, 3.50), (4, 3, 5.00),
(5, 1, 7.50), (5, 3, 8.75),
(6, 4, 9.00), (7, 4, 4.25),
(8, 5, 6.50), (9, 5, 8.25);
