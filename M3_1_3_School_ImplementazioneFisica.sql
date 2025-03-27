
-- CREAZIONE DATABASE SCHOOL

CREATE DATABASE School;

USE School;

-- 1. TABELLA STUDENTI

CREATE TABLE Studenti (
    id_studente INT PRIMARY KEY,
    nome VARCHAR(45),
    cognome VARCHAR(45),
    sesso VARCHAR(45),
    eta INT,
    indirizzo VARCHAR(45),
    titolo_studio VARCHAR(45)
);

-- 2. TABELLA INSEGNANTI

CREATE TABLE Insegnanti (
    id_insegnante INT PRIMARY KEY,
    id_lezione INT,
    id_modulo INT,
    nome VARCHAR(45),
    cognome VARCHAR(45),
    data_nascita DATE,
    indirizzo VARCHAR(45),
    area_competenza VARCHAR(45)
);


-- 3. TABELLA MODULI DIDATTICI

CREATE TABLE Moduli_Didattici (
    id_modulo INT PRIMARY KEY,
    nome_modulo VARCHAR(45),
    presenze_modulo INT,
    data_inizio DATE,
    data_fine DATE
);


-- 4. TABELLA LEZIONI

CREATE TABLE Lezioni (
    id_lezione INT PRIMARY KEY,
    id_modulo INT,
    data_orario DATETIME,
    aula VARCHAR(45),
    argomento VARCHAR(45),
    FOREIGN KEY (id_modulo) REFERENCES Moduli_Didattici(id_modulo)
);


-- 5. TABELLA PRESENZE

CREATE TABLE Presenze (
    id_presenza INT PRIMARY KEY,
    id_studente INT,
    id_lezione INT,
    presenza TINYINT,
    id_modulo INT,
    FOREIGN KEY (id_studente) REFERENCES Studenti(id_studente),
    FOREIGN KEY (id_lezione) REFERENCES Lezioni(id_lezione),
    FOREIGN KEY (id_modulo) REFERENCES Moduli_Didattici(id_modulo)
);


-- 6. TABELLA VALUTAZIONI

CREATE TABLE Valutazioni (
    id_valutazione INT PRIMARY KEY,
    id_studente INT,
    id_insegnante INT,
    id_modulo INT,
    voto INT,
    data DATE,
    FOREIGN KEY (id_studente) REFERENCES Studenti(id_studente),
    FOREIGN KEY (id_insegnante) REFERENCES Insegnanti(id_insegnante),
    FOREIGN KEY (id_modulo) REFERENCES Moduli_Didattici(id_modulo)
);
