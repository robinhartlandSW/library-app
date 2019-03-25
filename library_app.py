database_file = 'library.db'

# Database Seeding:
import sqlite3
conn = sqlite3.connect(database_file)

conn.execute("""CREATE TABLE IF NOT EXISTS editions (
	ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	author VARCHAR(255) NULL,
	title VARCHAR(255) NULL,
	ISBN VARCHAR(255) NULL
);"""
)

conn.execute("""CREATE TABLE IF NOT EXISTS copies (
	copyID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	editionID INTEGER NOT NULL,
	readerID INTEGER NULL,

	FOREIGN KEY (editionID) REFERENCES editions(ID),
	FOREIGN KEY (readerID) REFERENCES readers(ID)
);

"""
)

conn.execute("""CREATE TABLE IF NOT EXISTS readers (
	ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	firstName VARCHAR(255) NOT NULL,
	lastName VARCHAR(255) NULL
);
"""
)

conn.commit()

# Setup

from bottle import get, post, install, run, request, route, template, static_file
from bottle_sqlite import SQLitePlugin
install(SQLitePlugin(dbfile=database_file))


# Static content:
@get('/static/<file:path>')
def serve_static(file):
    return static_file(file, root='./static')

# Routes


@get('/')
@get('/home')
def librarian_home():
    return template('librarian_homepage.tpl')



@get('/add_new_reader')
def add_new_reader():
    return template('new_reader.tpl')

@get('/return_book')
def return_book():
    return template('return_book.tpl')

@post('/reader_overview')
def reader_overview(db):
    reader_name = request.forms.get('reader_name_input')

    # Split into first and last names 
    names = reader_name.split(' ')

    # Assume there's only one person with each name for now, and get the corresponding ID
    IDs = db.execute("SELECT ID FROM readers WHERE firstName == ? AND lastName == ?", (names[0],names[1])).fetchone()
    if IDs != None:
        ID = IDs["ID"]
        return template('reader_overview.tpl', ID=ID, reader_name=reader_name)
    else:
        # No readers of that name are registered in the library so redirect straight back to the librarian
        return librarian_home()

@post('/check_out_book')
def check_out_book(db): 
    title = request.forms.get('title')
    author = request.forms.get('author')
    serial_number = request.forms.get('serial_number')
    readerID = request.forms.get('readerID')
    db.execute("UPDATE copies SET readerID=? WHERE copyID=?", (readerID, serial_number))
    # TODO: return a page showing that the book has been successfully checked out


@post('/return_book_to_database')
def return_book_to_database(db):
    title = request.forms.get('title')
    author = request.forms.get('author')
    ISBN = request.forms.get('ISBN')
    serial_number = request.forms.get('serial_number')
    db.execute("UPDATE copies SET readerID=NULL WHERE copyID == ?", (serial_number,))


    


@post('/add_new_edition_to_database')
def add_new_edition_to_database(db): 
    title = request.forms.get('title')
    author = request.forms.get('author')
    ISBN = request.forms.get('ISBN')
    # TODO: check if either title+author, or ISBN, have been entered


    edition_in_library = db.execute("SELECT * from editions WHERE ISBN == ?", (ISBN,)).fetchone()

    if edition_in_library == None:
        # edition is not already registered in the library, so log it in the database and save its ID in editionID
        editionID = db.execute("INSERT INTO editions(author, title, ISBN) VALUES (?,?,?)", (author, title, ISBN)).lastrowid
    else:
        editionID = edition_in_library["ID"]

    # Add a copy of this edition into the library
    copyID = db.execute("INSERT INTO copies(editionID) VALUES (?)", (editionID,)).lastrowid

    return template('new_copy_added.tpl', serial_number=copyID)
    


@post('/register_new_reader_in_database')
def register_new_reader_in_database(db):
    first_name = request.forms.get('first_name')
    last_name = request.forms.get('last_name')
    db.execute("INSERT INTO readers(firstName, lastName) VALUES (?, ?)", (first_name, last_name))


@get('/add_new_edition')
def add_new_edition():
    return template('new_book.tpl')

@get('/add_new_copy/<editionID>')
def add_new_copy(db, editionID):
    db.execute("INSERT INTO copies(editionID) VALUES (?)", (editionID,))




@get('/view_library')
def view_library(db):
    library = db.execute('SELECT * FROM editions').fetchall()
    editions = [{'title': e['title'], 'author' : e['author'], 'ISBN' : e['ISBN']} for e in library]
    return template('book_display.tpl', editions=editions)


@get('/add_new_reader_to_database')
def add_new_reader_to_database(db):
    firstName = request.query["firstName"]
    lastName = request.query.get("lastName")
    db.execute("INSERT INTO readers(firstName, lastName) VALUES (?,?)", (firstName, lastName))



run(host='localhost', port=8080)