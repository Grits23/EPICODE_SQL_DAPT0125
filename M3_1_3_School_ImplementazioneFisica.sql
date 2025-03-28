- CREAZIONE DATABASE SCHOOL

CREATE DATABASE School;

USE School;

-- 1. TABELLA STUDENTI

CREATE TABLE Studenti (
    ID_Studenti INT
    , nome VARCHAR(45)
    , cognome VARCHAR(45)
    , sesso VARCHAR(45)
    , eta INT
    , indirizzo VARCHAR(45)
    , titolo_studio VARCHAR(45)
    , CONSTRAINT PK_Studenti PRIMARY KEY (ID_Studenti)
);


-- 3. TABELLA MODULI DIDATTICI

CREATE TABLE ModuliDidattici (
    ID_ModuliDidattici INT 
    , nome_modulo VARCHAR(45)
    , presenze_modulo INT
    , data_inizio DATE
    , data_fine DATE
    , CONSTRAINT PK_ModuliDidattici PRIMARY KEY (ID_ModuliDidattici)
);


-- 2. TABELLA INSEGNANTI

CREATE TABLE Insegnanti (
    ID_Insegnanti INT
    , ID_Lezioni INT
    , ID_ModuliDidattici INT
    , nome VARCHAR(45)
    , cognome VARCHAR(45)
    , data_nascita DATE
    , indirizzo VARCHAR(45)
    , area_competenza VARCHAR(45)
    , CONSTRAINT PK_Insegnanti PRIMARY KEY (ID_Insegnanti)
    , CONSTRAINT FK_ModuliDidattici_Insegnanti FOREIGN KEY (ID_ModuliDidattici)
		REFERENCES ModuliDidattici (ID_ModuliDidattici)
);


-- 4. TABELLA LEZIONI

CREATE TABLE Lezioni (
    ID_Lezioni INT
    , ID_ModuliDidattici INT
    , data_orario DATETIME
    , aula VARCHAR(45)
    , argomento VARCHAR(45)
    , CONSTRAINT PK_Lezioni PRIMARY KEY (ID_Lezioni)
    , CONSTRAINT FK_Lezioni_ModuliDidattici FOREIGN KEY (ID_ModuliDidattici) 
		REFERENCES ModuliDidattici (ID_ModuliDidattici)
);


-- 5. TABELLA PRESENZE

CREATE TABLE Presenze (
    ID_Presenze INT
    , ID_Studenti INT
    , ID_Lezioni INT
    , ID_ModuliDidattici INT
    , presenza TINYINT
    , CONSTRAINT PK_Presenze PRIMARY KEY (ID_Presenze)
    , CONSTRAINT FK_Presenze_Studenti FOREIGN KEY (ID_Studenti) 
		REFERENCES Studenti(ID_Studenti)
    , CONSTRAINT FK_Presenze_Lezioni FOREIGN KEY (ID_Lezioni) 
		REFERENCES Lezioni(ID_Lezioni)
    , CONSTRAINT FK_Presenze_ModuliDidattici FOREIGN KEY (ID_ModuliDidattici) 
		REFERENCES ModuliDidattici(ID_ModuliDidattici)
);


-- 6. TABELLA VALUTAZIONI

CREATE TABLE Valutazioni (
    ID_Valutazioni INT
    , ID_Studenti INT
    , ID_Insegnanti INT
    , ID_ModuliDidattici INT
    , voto INT
    , data_votazione DATE
    , CONSTRAINT PK_Valutazioni PRIMARY KEY (ID_Valutazioni)
    , CONSTRAINT FK_Valutazioni_Studenti FOREIGN KEY (ID_Studenti) 
		REFERENCES Studenti(ID_Studenti)
    , CONSTRAINT FK_Valutazioni_Insegnanti FOREIGN KEY (ID_Insegnanti) 
		REFERENCES Insegnanti(ID_Insegnanti)
    , CONSTRAINT FK_Valutazioni_ModuliDidattici FOREIGN KEY (ID_ModuliDidattici) 
		REFERENCES ModuliDidattici(ID_ModuliDidattici)
);
