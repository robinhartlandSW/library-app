-- SQL ALTER statements for database migration

CREATE TABLE IF NOT EXISTS editions (
        ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        author VARCHAR(255) NULL,
        title VARCHAR(255) NULL,
        ISBN VARCHAR(255) NULL
    );

CREATE TABLE IF NOT EXISTS copies (
        copyID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        editionID INTEGER NOT NULL,
        readerID INTEGER NULL,

        FOREIGN KEY (editionID) REFERENCES editions(ID),
        FOREIGN KEY (readerID) REFERENCES readers(ID)
    );

CREATE TABLE IF NOT EXISTS readers (
        ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        firstName VARCHAR(255) NOT NULL,
        lastName VARCHAR(255) NULL
    );

INSERT INTO editions(author, title, ISBN) VALUES (Nomad, Works, 1234);
