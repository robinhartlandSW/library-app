CREATE TABLE IF NOT EXISTS reservations (
    ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    readerID INTEGER NOT NULL,
    editionID INTEGER NOT NULL,
    datePlaced DATE NOT NULL,

    FOREIGN KEY (readerID) REFERENCES readers(ID),
    FOREIGN KEY (editionID) REFERENCES editions(ID)
)