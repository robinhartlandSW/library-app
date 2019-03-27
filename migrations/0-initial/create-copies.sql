CREATE TABLE IF NOT EXISTS copies (
        copyID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        editionID INTEGER NOT NULL,
        readerID INTEGER NULL,
        reserverID INTEGER NULL,
        due_date DATE NULL,

        FOREIGN KEY (editionID) REFERENCES editions(ID),
        FOREIGN KEY (readerID) REFERENCES readers(ID),
        FOREIGN KEY (reserverID) REFERENCES readers(ID)
    );