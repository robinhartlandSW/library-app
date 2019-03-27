-- SQL ALTER statements for database migration
CREATE TABLE IF NOT EXISTS editions (
        ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        author VARCHAR(255) NULL,
        title VARCHAR(255) NOT NULL,
	genre VARCHAR(255) NULL,
        location VARCHAR(255) NOT NULL,
        ISBN VARCHAR(255) NULL UNIQUE
    );

