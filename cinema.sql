-- realisation dune base de donnée avec le terminal shel de xampp
-- toutes les commandes utilisées : 

cd mysql/bin    -- pour se deplacer dans le dossier mysql/bin
mysql.exe -u root -p -- pour se connecter a la base de donnée

-- creer une base de donnée Cinema

CREATE DATABASE Cinema;

-- utiliser la base de donnée Cinema

USE Cinema;

-- creer une table Complexe :

CREATE TABLE Complexe (
    id INT PRIMARY KEY AUTO_INCREMENT,  
    Nom VARCHAR(255) NOT NULL,      
    Adresse VARCHAR(255) NOT NULL,  
    Ville VARCHAR(100) NOT NULL,    
    Code_Postal VARCHAR(10) NOT NULL,
    Telephone VARCHAR(20), 
    Email VARCHAR(255) UNIQUE NOT NULL, 
    password VARCHAR(255) NOT NULL

);
-- contrainte sur la table Complexe pour verifier que le code postal est bien un code postal français --

ALTER TABLE Complexe
ADD CONSTRAINT code_postal CHECK (Code_Postal REGEXP '^[0-9]{5}$');


-- ajouter des données dans la table Complexe

ALTER TABLE Complexe
ADD nbCinemas INT NOT NULL DEFAULT 0;

--creer une table Utilsateur (utilisateur peut gerer les seances) :


CREATE TABLE Utilisateur (
  id INT PRIMARY KEY AUTO_INCREMENT,
  Nom VARCHAR(255) NOT NULL,
  Prenom VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  mot_de_passe VARCHAR(255) NOT NULL,
  GererLesSeances BOOLEAN NOT NULL
);
-- ajout de id_complexe dans la table Utilisateur pour lier l'utilisateur avec le complexe qu'il gere --

ALTER TABLE Utilisateur ADD id_complexe INT,
ADD FOREIGN KEY (id_complexe) REFERENCES Complexe(id);

-- supprimer la colonne GererLesSeances de la table Utilisateur pour creer table role  à part --
ALTER TABLE Utilisateur
DROP COLUMN GererLesSeances;

-- ajouter id_role dans la table Utilisateur pour lier l'utilisateur avec son role --
ALTER TABLE Utilisateur
ADD id_role INT NOT NULL;



--creer la table Admin :

CREATE TABLE Admin (
  id INT PRIMARY KEY AUTO_INCREMENT,
  Nom VARCHAR(255) NOT NULL,
  Prenom VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  mot_de_passe VARCHAR(255) NOT NULL
);


-- ajouter id_complexe dans la table Admin pour lier l'admin avec le complexe qu'il gere --

ALTER TABLE Admin ADD id_complexe INT,
ADD FOREIGN KEY (id_complexe) REFERENCES Complexe(id);

--ajouter id_role dans la table Admin pour lier l'admin avec son role --

ALTER TABLE admin
ADD id_role INT,
ADD CONSTRAINT fk_admin_role FOREIGN KEY (id_role) REFERENCES role(id_role);





--creer la table Cinema :

CREATE TABLE Cinema (
  id INT PRIMARY KEY AUTO_INCREMENT,
  Nom VARCHAR(255) NOT NULL,
  Adresse VARCHAR(255) NOT NULL,
  Ville VARCHAR(100) NOT NULL,
  Code_Postal VARCHAR(10) NOT NULL,
  Telephone VARCHAR(20),
  nb_salles INT NOT NULL DEFAULT 0
);

-- ajout de id_complexe dans la table Cinema pour lier le cinema avec le complexe auquel il appartient --

ALTER TABLE Cinema ADD id_complexe INT,
ADD FOREIGN KEY (id_complexe) REFERENCES Complexe(id);

-- contrainte sur la table Cinema pour verifier que le code postal est bien un code postal français --

ALTER TABLE Cinema
ADD CONSTRAINT code_postal CHECK (Code_Postal REGEXP '^[0-9]{5}$')








--creer la table Salle :

CREATE TABLE Salle (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nb_places INT NOT NULL,
  id_cinema INT NOT NULL,
  FOREIGN KEY (id_cinema) REFERENCES Cinema(id)
);

--creer la table Film :

CREATE TABLE Film (
  id INT PRIMARY KEY AUTO_INCREMENT,
  Titre VARCHAR(255) NOT NULL,
  Duree INT NOT NULL,
  Realisateur VARCHAR(255) NOT NULL,
  Genre VARCHAR(255) NOT NULL,
  Date_de_sortie DATE NOT NULL,
  Synopsis TEXT NOT NULL
);

--creer la table Seance :

CREATE TABLE Seance (
  id INT PRIMARY KEY AUTO_INCREMENT,
  Date DATE NOT NULL,
  Heure TIME NOT NULL,
  id_film INT NOT NULL,
  id_salle INT NOT NULL,
  FOREIGN KEY (id_film) REFERENCES Film(id),
  FOREIGN KEY (id_salle) REFERENCES Salle(id)
);

-- ajout de id_utilisateur dans la table Seance pour lier la seance avec l'utilisateur qui l'a creee --

ALTER TABLE Seance ADD id_utilisateur INT,
ADD FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id);




-- on doit creer la table client d''abord pour pouvoir creer la table abonnée avec la clé etrangere id_client

-- creer la table Client :

CREATE TABLE Client (
  id INT PRIMARY KEY AUTO_INCREMENT,
  Nom VARCHAR(255) NOT NULL,
  Prenom VARCHAR(255) NOT NULL,
  date_naissance DATE NOT NULL -- pour verifier son age--
);

-- contrainte sur la table Client pour verifier que la date de naissance est bien une date --

ALTER TABLE Client
ADD CONSTRAINT date_naissance CHECK (date_naissance REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');




-- creer la table Abonne qui herite de la table Client aevc email et mot de passe en plus :

CREATE TABLE Abonne (
  id INT PRIMARY KEY AUTO_INCREMENT, 
  email VARCHAR(255) UNIQUE NOT NULL,
  mot_de_passe VARCHAR(255) NOT NULL,
  ADD date_debut DATE NOT NULL,
  ADD date_fin DATE NOT NULL;
  id_client INT NOT NULL,
  type_abonnement VARCHAR(255) NOT NULL,
  id_complexe INT,
  FOREIGN KEY (id_client) REFERENCES Client(id)

);

-- ajout de type d'abonnement dans la table Abonne 
 -- lier l'abonnée avec le complexe auquel il est abonné --

ALTER TABLE Abonne
Add type_abonnement VARCHAR(255) NOT NULL,
ADD id_complexe INT,
ADD FOREIGN KEY (id_complexe) REFERENCES Complexe(id);


-- contrainte sur la table Abonne pour verifier que la date de debut et fin sont bien des dates --

ALTER TABLE Abonne
ADD CONSTRAINT date_debut CHECK (date_debut REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');

ALTER TABLE Abonne
ADD CONSTRAINT date_fin CHECK (date_fin REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');




-- creer table resevation 

CREATE TABLE Reservation (
  id INT PRIMARY KEY AUTO_INCREMENT,
  Date_seance DATE NOT NULL,
  Heure_debut TIME NOT NULL,
  Heure_fin TIME NOT NULL,
  id_client INT NOT NULL,
  id_seance INT NOT NULL,
  prix FLOAT NOT NULL,
  id_paiement INT,
  FOREIGN KEY (id_paiement) REFERENCES Paiement(id),
  FOREIGN KEY (id_client) REFERENCES Client(id),
  FOREIGN KEY (id_seance) REFERENCES Seance(id)
);




-- ajout de id_utilisateur dans la table Reservation pour lier la reservation avec l'utilisateur qui l'a effectuee --

ALTER TABLE Reservation ADD id_utilisateur INT,
ADD FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id);

-- ajout de id_abonne dans la table Reservation pour lier la reservation avec l'abonne qui l'a effectuee --

ALTER TABLE Reservation ADD id_abonne INT,
ADD FOREIGN KEY (id_abonne) REFERENCES Abonne(id);

-- modifier la table Resevation pour ajouter le paiement et modifier float en decimal --
--utile pour suivi des paiment des clients--
--annulation et remboussement ...--

ALTER TABLE Reservation modify prix Decimal(10,2),
ADD id_paiement INT,
ADD FOREIGN KEY (id_paiement) REFERENCES Paiement(id);

-- contrainte sur la table Reservation pour verifier que la date de la seance est bien une date --

ALTER TABLE Reservation
ADD CONSTRAINT date_seance CHECK (Date_seance REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');



ALTER TABLE Reservation
ADD CONSTRAINT heure_debut CHECK (Heure_debut REGEXP '^[0-9]{2}:[0-9]{2}$');  -- exemple 14:00 -- pourquoi ça ne me prend pas 14:00 comme valeur ? --  parce 


-- contrainte sur la table Reservation pour verifier que l'heure de debut est bien une heure --
Alter table Reservation
Add CONSTRAINT heure_debut CHECK (Heure_debut REGEXP '^[0-9]{2}:[0-9]{2}:00$');

-- contrainte sur la table Reservation pour verifier que l'heure de fin est bien une heure --

Alter table Reservation
Add CONSTRAINT heure_fin CHECK (Heure_fin REGEXP '^[0-9]{2}:[0-9]{2}:00$');






-- creer table genre :

CREATE TABLE Genre (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(255) NOT NULL
);
-- nfilm peut avoir plusieurs genres et un genre peut avoir plusieurs films donc on doit creer une table de jointure entre table film et genre --

-- creer table Film_Genre :

CREATE TABLE Film_Genre (
  id_film INT NOT NULL,
  id_genre INT NOT NULL,
  PRIMARY KEY (id_film, id_genre),
  FOREIGN KEY (id_film) REFERENCES Film(id),
  FOREIGN KEY (id_genre) REFERENCES Genre(id)
);

-- creer table tarif sachant qu'il y a trois tarif different  
-- Plein tarif: 9€20 Étudiant: 7€60  Moins de 14 ans: 5€90 

CREATE TABLE Tarif (
  id INT PRIMARY KEY AUTO_INCREMENT,
  TYPE VARCHAR(255) NOT NULL,
  prix FLOAT NOT NULL
);
-- modifier la table tarif pour changer float en decimal --

ALTER TABLE Tarif modify prix Decimal(10,2);

-- ajouer id seance dans la table tarif pour lier le tarif avec la seance 
ALTER TABLE Tarif
ADD id_seance INT,
ADD FOREIGN KEY (id_seance) REFERENCES Seance(id);



--creation table paimeent pour enregistrer les paiements des clients--

CREATE TABLE Paiement (
  id INT PRIMARY KEY AUTO_INCREMENT,
  Date DATE NOT NULL,
  Montant Decimal(10,2) NOT NULL,
  id_client INT NOT NULL,
  FOREIGN KEY (id_client) REFERENCES Client(id)
);
-- ajour de mode de paiement dans la table paiement--
ALTER TABLE Paiement
ADD mode_paiement VARCHAR(255) NOT NULL;

-- ajout de id_reservation dans la table paiement pour lier le paiement avec la reservation

-- ajout de la clees etrangerees id_client, id_tarif et id_paiement
ALTER TABLE Paiement 
ADD FOREIGN KEY (id_client) REFERENCES Client(id),
ADD FOREIGN KEY (id_tarif) REFERENCES Tarif(id),
ADD FOREIGN KEY (id_reservation) REFERENCES Reservation(id);

ALTER TABLE Paiement
ADD id_reservation INT,
ADD FOREIGN KEY (id_reservation) REFERENCES Reservation(id);

-- contrainte sur la table Paiement pour verifier que la date est bien une date --

ALTER TABLE Paiement
ADD CONSTRAINT date CHECK (Date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');

-- contrainte sur la table Paiement pour verifier que le montant est bien un montant --
ALTER TABLE Paiement
ADD CONSTRAINT montant CHECK (Montant REGEXP '^[0-9]+(\.[0-9]{1,2})?$');



-- creer la table Role :

CREATE TABLE role (
  id_role INT PRIMARY KEY AUTO_INCREMENT,
  nom_role VARCHAR(50) NOT NULL UNIQUE,
  description VARCHAR(255)
);

--inserer des données dans la table role :

INSERT INTO role (nom_role, description) VALUES ('Admin', 'Peut gérer les utilisateurs et les rôles');

INSERT INTO role (nom_role, description) VALUES ('Utilisateur', 'Peut gérer les séances');



--insérer des données dans la table admin avec hashage des mots de passe--

INSERT INTO admin (nom, prenom, email, mot_de_passe,id_complexe, id_role)
VALUES
  ('admin1', 'admin1', 'admin1@example.com', SHA256(CONCAT('password1', 'votre_sel')),1, 2); -- on hash le mot de passe en utilisant SHA256 



--insérer des données dans la table utilisateur avec hashage des mots de passe--

INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, id_complexe, id_role)
VALUES
  ('utilisateur1', 'utilisateur1', 'utilisateurs1@example.com', SHA256(CONCAT('password1', 'votre_sel')),1, 1); -- on hash le mot de passe en utilisant SHA256



                             --sécurité des mots de passe--

--- definir la function SHA256 pour hasher le mot de passe

DELIMITER //
CREATE FUNCTION SHA256(input VARCHAR(255)) RETURNS VARCHAR(255) -- fonction pour hasher le mot de passe
BEGIN
  RETURN SHA2(input, 256); -- on hash le mot de passe en utilisant SHA256
END; //
DELIMITER ;



---------------- INSERTION DES DONNEES DANS LES TABLES ----------------

-- insertion des données dans la table Genre -- fait

INSERT INTO Genre (nom) VALUES ('Action');
INSERT INTO Genre (nom) VALUES ('Comédie');
INSERT INTO Genre (nom) VALUES ('Drame');
INSERT INTO Genre (nom) VALUES ('Horreur');
INSERT INTO Genre (nom) VALUES ('Science-fiction');
INSERT INTO Genre (nom) VALUES ('Thriller');
INSERT INTO Genre (nom) VALUES ('Animation');


-- insertion des données dans la table Tarif -- fait 

INSERT INTO Tarif (TYPE, prix) VALUES ('Plein tarif', 9.20);
INSERT INTO Tarif (TYPE, prix) VALUES ('Étudiant', 7.60);
INSERT INTO Tarif (TYPE, prix) VALUES ('Moins de 14 ans', 5.90);


-- insertion des données dans la table Film -- fait 

INSERT INTO Film (Titre, Duree, Realisateur, Genre, Date_de_sortie, Synopsis)
VALUES
  ('The Dark Knight', 152, 'Christopher Nolan', 'Action', '2008-08-13', 'Batman, Gordon and
Harvey Dent est obligé de faire face au chaos déclenché par un cerveau anarchiste connu uniquement sous le nom de Joker, car cela pousse chacun d''eux à leurs limites.');

INSERT INTO Film (Titre, Duree, Realisateur, Genre, Date_de_sortie, Synopsis)

VALUES
  ('Inception', 148, 'Christopher Nolan', 'Science-fiction', '2010-07-21', 'Dom Cobb est un voleur expérimenté, le meilleur dans l''art dangereux de l''extraction, voler des secrets précieux dans les profondeurs du subconscient pendant l''état de rêve lorsque l''esprit est le plus vulnérable.');  


-- insertion des données dans la table Film_Genre -- fait 

INSERT INTO Film_Genre (id_film, id_genre) VALUES (1, 1);
INSERT INTO Film_Genre (id_film, id_genre) VALUES (1, 6);
INSERT INTO Film_Genre (id_film, id_genre) VALUES (2, 5);


-- insertion des données dans la table Complexe et hashage du mot de passe en utilisant SHA256 --

INSERT INTO Complexe (Nom, Adresse, Ville, Code_Postal, Telephone, Email, password)
VALUES 
  ('Pathé Vaise', '43 Rue des Docks', 'Lyon', '69009', '04 72 85 10 00', 'pathe-vaise@cin.com' , SHA256(CONCAT('password1', 'votre_sel'))),
  ('UGC Confluence', '112 Cours Charlemagne', 'Lyon', '69002', '04 78 37 85 85', 'cin-confluence@cin.com' , SHA256(CONCAT('password2', 'votre_sel'))),
  ('Pathé Bellecour', '79 Rue de la République', 'Lyon', '69002', '04 78 37 85 85', 'cin-belcour@cin.com' , SHA256(CONCAT('password3', 'votre_sel')));


-- insertion des données dans la table Cinema -- fait

INSERT INTO Cinema (Nom, Adresse, Ville, Code_Postal, Telephone, nb_salles, id_complexe)

VALUES
  ('Pathé Vaise', '43 Rue des Docks', 'Lyon', '69009', '04 72 85 10 00', 10, 1),
  ('UGC Confluence', '112 Cours Charlemagne', 'Lyon', '69002', '04 78 37 85 85', 8, 2);


-- insertion des données dans la table Salle -- fait 

INSERT INTO Salle (nb_places, id_cinema) VALUES (200, 1);

INSERT INTO Salle (nb_places, id_cinema) VALUES (150, 2);


-- insertion des données dans la table Seance -- fait

INSERT INTO Seance (Date, Heure, id_film, id_salle, id_utilisateur) VALUES ('2024-06-01', '14:00', 1, 3, 1);

INSERT INTO Seance (Date, Heure, id_film, id_salle, id_utilisateur) VALUES ('2024-06-01', '16:00', 2, 4, 1);


-- insertion des données dans la table Client -- fait 

INSERT INTO Client (Nom, Prenom, date_naissance) VALUES ('Dupont', 'Jean', '1990-01-01');

INSERT INTO Client (Nom, Prenom, date_naissance) VALUES ('Durand', 'Marie', '1995-02-02');


-- insertion des données dans la table Abonne sachant que l'abonne Dupont Jean est abonné au Pathé Vaise et l'abonne Durand Marie est abonné au UGC Confluence avec hashage du mot de passe--

INSERT INTO Abonne (email, mot_de_passe, date_debut, date_fin, id_client, type_abonnement, id_complexe) VALUES ('dupont@hotmail.fr' , SHA256(CONCAT('password1', 'votre_sel')), '2024-06-01', '2025-06-01', 1, 'Annuel', 1);

INSERT INTO Abonne (email, mot_de_passe, date_debut, date_fin, id_client, type_abonnement, id_complexe) VALUES ('durant@hotmail.fr' , SHA256(CONCAT('password2', 'votre_sel')), '2024-06-01', '2025-06-01', 2, 'Annuel', 2);



-- insertion des données dans la table Reservation --

INSERT INTO Reservation (Date_seance, Heure_debut, Heure_fin, id_client, id_seance, prix, id_utilisateur, id_abonne) VALUES ('2024-06-01','14:00','16:00',1,9, 9.20, 1, 3);

INSERT INTO Reservation (Date_seance, Heure_debut, Heure_fin, id_client, id_seance, prix, id_utilisateur, id_abonne) VALUES ('2024-06-01', '16:00', '18:00', 2, 10, 7.60, 1, 4);



-- insertion des données dans la table Paiement --

INSERT INTO Paiement (Date, Montant, mode_paiement, id_client, id_reservation) VALUES ('2024-06-01', 9.20, 'Carte bancaire', 1, 2);

INSERT INTO Paiement (Date, Montant, mode_paiement, id_client, id_reservation) VALUES ('2024-06-01', 7.60, 'Carte bancaire', 2, 3);












