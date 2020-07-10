-- Suppression de la base de données si elle existe
DROP DATABASE IF EXISTS courses;

-- Création de la base de données
CREATE DATABASE courses DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

-- Ouverture de la base
USE courses;

/****************************************
* Création des tables
*****************************************/

CREATE TABLE categories (
    id tinyint UNSIGNED AUTO_INCREMENT,
    nom VARCHAR(30) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE listes (
    id tinyint UNSIGNED AUTO_INCREMENT,
    nom VARCHAR(30) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE articles (
    id smallint UNSIGNED AUTO_INCREMENT,
    nom VARCHAR(30) NOT NULL,
    id_categorie tinyint UNSIGNED NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT articles_to_categories
        FOREIGN KEY (id_categorie)
        REFERENCES categories(id)
);

CREATE TABLE articles_listes (
    id_liste tinyint UNSIGNED,
    id_article smallint UNSIGNED,
    PRIMARY KEY (id_liste, id_article),
    CONSTRAINT articles_listes_to_articles
        FOREIGN KEY (id_article)
        REFERENCES articles(id),
    CONSTRAINT articles_listes_to_listes
        FOREIGN KEY (id_liste)
        REFERENCES listes(id)
);


/****************************************
* Insertion des données
*****************************************/

INSERT INTO categories (nom)
VALUES ('Céréales'), ('Légumes'), ('Fruits');

INSERT INTO listes (nom)
VALUES ('Courses d\'hiver'), ('Courses d\'été');

INSERT INTO articles (nom, id_categorie)
VALUES ('Tomates', 2), ('Aubergines', 2), ('Courgettes', 2),
('Pastèque', 3), ('Abricots', 3), ('Riz', 1), ('Semoule', 1);

INSERT INTO articles_listes (id_article, id_liste)
VALUES (1, 1), (2, 1), (6, 1), (6, 2);

/****************************************
* Création des vues
*****************************************/

-- Vue pour les articles
CREATE OR REPLACE VIEW vue_articles AS
    SELECT a.*, c.nom as categorie, al.id_liste as id_liste 
    FROM articles as a 
    INNER JOIN categories as c ON a.id_categorie = c.id
    LEFT JOIN articles_listes as al ON al.id_article = a.id;

CREATE OR REPLACE VIEW vue_listes AS
    SELECT l.*, COUNT(al.id_article) as nb_articles
    FROM listes as l 
    LEFT JOIN articles_listes as al ON al.id_liste = l.id
    GROUP BY l.id;


