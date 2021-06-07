-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : lun. 07 juin 2021 à 00:35
-- Version du serveur :  10.4.18-MariaDB
-- Version de PHP : 8.0.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `badminton`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addAdh` (IN `p_nom` VARCHAR(25), IN `p_prenom` VARCHAR(25), IN `p_ville` VARCHAR(50), IN `p_cp` INT(15), IN `p_niveau` INT(11), IN `p_type` INT(11))  begin
   insert into adherent
    (nomAdh, prenomAdh, villeAdh, cpAdh, niveauAdh, typeAdh)
    values
    (
     p_nom,
     p_prenom,
     p_ville,
     p_cp,
     p_niveau,
     p_type
    );
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_deleteAdh` (IN `p_matricule` INT(11))  begin
   delete from adherent where matriculeAdh=p_matricule;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_updateAdh` (IN `p_nomAdh` VARCHAR(25), IN `p_prenomAdh` VARCHAR(25), IN `p_ville` VARCHAR(50), IN `p_cp` INT(5), IN `p_niveau` INT(11), IN `p_type` INT(11), IN `p_matricule` INT(11))  begin
    update adherent set nomAdh=p_nomAdh, prenomAdh=p_prenomAdh, villeAdh=p_ville, cpAdh=p_cp, typeAdh=p_type, niveauAdh=p_niveau where matriculeAdh=p_matricule;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_verifAdh` (IN `p_nom` VARCHAR(25), IN `p_prenom` VARCHAR(25))  begin
    select nom, prenom from v_listadh where nom = p_nom and prenom = p_prenom;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `adherent`
--

CREATE TABLE `adherent` (
  `matriculeAdh` int(11) NOT NULL,
  `nomAdh` varchar(25) NOT NULL,
  `prenomAdh` varchar(25) NOT NULL,
  `villeAdh` varchar(50) NOT NULL,
  `cpAdh` int(5) NOT NULL,
  `niveauAdh` int(11) NOT NULL,
  `typeAdh` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `adherent`
--

INSERT INTO `adherent` (`matriculeAdh`, `nomAdh`, `prenomAdh`, `villeAdh`, `cpAdh`, `niveauAdh`, `typeAdh`) VALUES
(5, 'aaa', 'aaa', 'aaa', 222, 1, 1),
(6, 'roule', 'pierre', 'bretoche', 915425, 1, 1),
(7, 'roule', 'pierre', 'bretoche', 915425, 1, 1),
(8, 'roule', 'pierre', 'bretoche', 915425, 1, 1),
(9, 'TEST', 'testdoc', 'documentation', 91520, 2, 1);

-- --------------------------------------------------------

--
-- Structure de la table `compte`
--

CREATE TABLE `compte` (
  `id` int(11) NOT NULL,
  `login` varchar(30) NOT NULL,
  `mdp` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `compte`
--

INSERT INTO `compte` (`id`, `login`, `mdp`) VALUES
(1, 'admin', 'admin');

-- --------------------------------------------------------

--
-- Structure de la table `niveau`
--

CREATE TABLE `niveau` (
  `id` int(1) NOT NULL COMMENT 'Identifiant pour le niveau de jeu',
  `libelle` varchar(8) NOT NULL COMMENT 'Libellé niveau de jeu'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `niveau`
--

INSERT INTO `niveau` (`id`, `libelle`) VALUES
(1, 'Débutant'),
(2, 'Confirmé'),
(3, 'Expert');

-- --------------------------------------------------------

--
-- Structure de la table `type`
--

CREATE TABLE `type` (
  `id` int(1) NOT NULL COMMENT 'Identifiant Type de l''adhérent',
  `libelle` varchar(10) NOT NULL COMMENT 'Libellé Type de l''adhérent',
  `montantLicence` int(11) NOT NULL COMMENT 'Montant de la Licence en fonction du Type d''adhérent'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `type`
--

INSERT INTO `type` (`id`, `libelle`, `montantLicence`) VALUES
(1, 'Salarié', 27),
(2, 'Etudiant', 20),
(3, 'Retraité', 23);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_listadh`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_listadh` (
`matricule` int(11)
,`nom` varchar(25)
,`prenom` varchar(25)
,`ville` varchar(50)
,`cp` int(5)
,`idType` int(11)
,`type` varchar(10)
,`idNiveau` int(11)
,`niveau` varchar(8)
,`prixLicence` varchar(12)
);

-- --------------------------------------------------------

--
-- Structure de la vue `v_listadh`
--
DROP TABLE IF EXISTS `v_listadh`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_listadh`  AS SELECT `a`.`matriculeAdh` AS `matricule`, `a`.`nomAdh` AS `nom`, `a`.`prenomAdh` AS `prenom`, `a`.`villeAdh` AS `ville`, `a`.`cpAdh` AS `cp`, `a`.`typeAdh` AS `idType`, `t`.`libelle` AS `type`, `a`.`niveauAdh` AS `idNiveau`, `n`.`libelle` AS `niveau`, concat(`t`.`montantLicence`,'€') AS `prixLicence` FROM ((`adherent` `a` left join `niveau` `n` on(`n`.`id` = `a`.`niveauAdh`)) left join `type` `t` on(`t`.`id` = `a`.`typeAdh`)) ;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `adherent`
--
ALTER TABLE `adherent`
  ADD PRIMARY KEY (`matriculeAdh`),
  ADD KEY `fk_type` (`typeAdh`),
  ADD KEY `fk_niveau` (`niveauAdh`);

--
-- Index pour la table `compte`
--
ALTER TABLE `compte`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `niveau`
--
ALTER TABLE `niveau`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `type`
--
ALTER TABLE `type`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `adherent`
--
ALTER TABLE `adherent`
  MODIFY `matriculeAdh` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT pour la table `compte`
--
ALTER TABLE `compte`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `adherent`
--
ALTER TABLE `adherent`
  ADD CONSTRAINT `adherent_ibfk_1` FOREIGN KEY (`niveauAdh`) REFERENCES `niveau` (`id`),
  ADD CONSTRAINT `adherent_ibfk_2` FOREIGN KEY (`typeAdh`) REFERENCES `type` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
