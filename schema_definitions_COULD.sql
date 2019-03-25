PRAGMA foreign_keys = ON;

CREATE TABLE genres (
	ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	genre VARCHAR(255) NOT NULL
);

CREATE TABLE categories (
	ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	category VARCHAR(255) NOT NULL,
	dailyFine DECIMAL NULL
);

CREATE TABLE editions (
	ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	author VARCHAR(255) NULL,
	title VARCHAR(255) NULL,
	editionNumber INTEGER NULL,
	ISBN VARCHAR(255) NULL,
	genreID INTEGER NULL,
	categoryID INTEGER NULL,
	
	FOREIGN KEY (genreID) REFERENCES genres(ID),
	FOREIGN KEY (categoryID) REFERENCES categories(ID)
);

CREATE TABLE privileges (
	ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	name VARCHAR(255) NULL,
	maxBooksAllowance INTEGER NOT NULL
);

CREATE TABLE readers (
	ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	firstName VARCHAR(255) NOT NULL,
	lastName VARCHAR(255) NULL,
	outstandingCharges DECIMAL NULL,
	privilegesID INTEGER NULL,
	
	FOREIGN KEY (privilegesID) REFERENCES privileges(ID)
);

CREATE TABLE copies (
	copyID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	editionID INTEGER NOT NULL,
	readerID INTEGER NULL,
	FOREIGN KEY (editionID) REFERENCES editions(ID),
	FOREIGN KEY (readerID) REFERENCES readers(ID)
);


CREATE TABLE allowedCategoryPrivileges (
	ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	categoryID INTEGER NOT NULL,
	privilegeID INTEGER NOT NULL,
	
	FOREIGN KEY (categoryID) REFERENCES categories(ID),
	FOREIGN KEY (privilegeID) REFERENCES privileges(ID)
);