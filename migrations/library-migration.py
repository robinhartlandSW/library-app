def upgrade(connection):
    setup = """CREATE TABLE IF NOT EXISTS editions (
        ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        author VARCHAR(255) NULL,
        title VARCHAR(255) NULL,
        ISBN VARCHAR(255) NULL
    );"""

    setup += """CREATE TABLE IF NOT EXISTS copies (
        copyID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        editionID INTEGER NOT NULL,
        readerID INTEGER NULL,

        FOREIGN KEY (editionID) REFERENCES editions(ID),
        FOREIGN KEY (readerID) REFERENCES readers(ID)
    );

    """

    setup += """CREATE TABLE IF NOT EXISTS readers (
        ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        firstName VARCHAR(255) NOT NULL,
        lastName VARCHAR(255) NULL
    );
    """

    setup += " INSERT INTO editions(author, title, ISBN) VALUES (Nomad, Works, 1234)"

    connection.execute(setup)

    connection.commit()

def downgrade(connection):
    connection.execute("""
        DROP TABLE editions;
        DROP TABLE copies;
        DROP TABLE readers;
    """
    connection.commit()