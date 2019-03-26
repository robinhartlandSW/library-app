

# Setup
database_file = 'library-nomad.db'
from bottle import get, post, install, run, request, route, template, static_file
from bottle_sqlite import SQLitePlugin
import datetime
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
    #TODO: make reader selection be based on an ID rather than assuming only 2 names!
    IDs = db.execute("SELECT ID FROM readers WHERE firstName == ? AND lastName == ?", (names[0],names[1])).fetchone()
    if IDs != None:
        ID = IDs["ID"]
        fine = db.execute('SELECT fine FROM readers WHERE ID = ?', (ID,)).fetchone()[0]
        string_fine = str(fine)
        num_books_borrowed = db.execute("SELECT COUNT(copyID) FROM copies WHERE readerID == ?", (ID,)).fetchone()[0]
        return template('reader_overview.tpl', ID=ID, reader_name=reader_name, num_books_borrowed=num_books_borrowed, fine='£' + string_fine)
    else:
        
        # No readers of that name are registered in the library so redirect straight back to the librarian
        return librarian_home()

@post('/check_out_book')
def check_out_book(db): 
    title = request.forms.get('title')
    author = request.forms.get('author')
    serial_number = request.forms.get('serial_number')
    days_rented = request.forms.get('days_rented')
    days_rented = int(days_rented)
    readerID = request.forms.get('readerID')
    db.execute("UPDATE copies SET readerID=? WHERE copyID=?", (readerID, serial_number))
    due_date = datetime.datetime.now() + datetime.timedelta(days = days_rented)
    db.execute('UPDATE copies SET due_date = ?', (due_date,))

    #TODO: return a suitable error message when trying to check out a disallowed book (maybe use javascript to prevent this?)
    return template("book_checked_out.tpl")


@post('/return_book_to_database')
def return_book_to_database(db):
    title = request.forms.get('title')
    author = request.forms.get('author')
    ISBN = request.forms.get('ISBN')
    serial_number = request.forms.get('serial_number')

    due_date = db.execute('SELECT due_date FROM copies WHERE copyID = ?', (serial_number,))

    db.execute("UPDATE copies SET readerID=NULL WHERE copyID == ?", (serial_number,))
    db.execute("UPDATE copies SET due_date=NULL WHERE copyID == ?", (serial_number,))
    return template("book_returned.tpl")

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
    fine = 0
    db.execute("INSERT INTO readers(firstName, lastName, fine) VALUES (?, ?, ?)", (first_name, last_name, fine))
    return template('new_reader')


@get('/add_new_edition')
def add_new_edition():
    return template('new_book.tpl')

@get('/add_new_copy/<editionID>')
def add_new_copy(db, editionID):
    db.execute("INSERT INTO copies(editionID) VALUES (?)", (editionID,))

@get('/view_library')
def view_library(db):
    library = db.execute('SELECT * FROM editions').fetchall()
    editions = [{'title': e['title'], 'author' : e['author'], 'ISBN' : e['ISBN'], 'ID' : e['ID']} for e in library]

    for ed in editions:
        ID = ed['ID']
        num_available_copies = db.execute("SELECT COUNT (copyID) FROM copies WHERE readerID IS NULL AND editionID == ? ", (ID,)).fetchone()[0]
        ed['num_available_copies'] = num_available_copies

    return template('book_display.tpl', editions=editions)

@get('/available_serial_numbers')
def available_serial_numbers(db):
    editionID = request.query.get("editionID")
    edition = db.execute('SELECT * FROM editions WHERE ID == ?', (editionID,)).fetchone()
    copies_of_this_edition = db.execute('SELECT copyID FROM copies WHERE editionID == ? AND readerID IS NULL', (editionID,)).fetchall()
    serial_numbers = [c['copyID'] for c in copies_of_this_edition]
    return template("available_serial_numbers.tpl", title=edition['title'], serial_numbers=serial_numbers)


@get('/add_new_reader_to_database')
def add_new_reader_to_database(db):
    firstName = request.query["firstName"]
    lastName = request.query.get("lastName")
    db.execute("INSERT INTO readers(firstName, lastName) VALUES (?,?)", (firstName, lastName))

@post('/reader_overview/fine')
def fine_reader(db):
    fine = request.forms.get('added_fine')
    fine = float(fine)
    user_id = request.forms.get('user_id')
    current_fine = db.execute('SELECT fine FROM readers WHERE ID = ?', (user_id,)).fetchone()[0]
    current_fine = float(current_fine)
    new_fine = current_fine + fine
    db.execute('UPDATE readers SET fine = ? WHERE ID = ?', (new_fine, user_id))
    reader = db.execute('SELECT * FROM readers WHERE ID = ?', (user_id,)).fetchone()
    num_books_borrowed = db.execute("SELECT COUNT(copyID) FROM copies WHERE readerID == ?", (user_id,)).fetchone()[0]
    fine = db.execute('SELECT fine FROM readers WHERE ID = ?', (user_id,)).fetchone()[0]
    string_fine = str(fine)
    return template('reader_overview.tpl', ID=user_id, reader_name=reader['firstName'] + ' ' + reader['lastName'], num_books_borrowed=num_books_borrowed, fine='£' + string_fine)

@post('/reader_overview/pay_fine')
def fine_reader(db):
    fine = request.forms.get('paid_fine')
    fine = float(fine)
    user_id = request.forms.get('user_id')
    current_fine = db.execute('SELECT fine FROM readers WHERE ID = ?', (user_id,)).fetchone()[0]
    current_fine = float(current_fine)
    new_fine = current_fine - fine
    db.execute('UPDATE readers SET fine = ? WHERE ID = ?', (new_fine, user_id))
    reader = db.execute('SELECT * FROM readers WHERE ID = ?', (user_id,)).fetchone()
    num_books_borrowed = db.execute("SELECT COUNT(copyID) FROM copies WHERE readerID == ?", (user_id,)).fetchone()[0]
    fine = db.execute('SELECT fine FROM readers WHERE ID = ?', (user_id,)).fetchone()[0]
    string_fine = str(fine)
    return template('reader_overview.tpl', ID=user_id, reader_name=reader['firstName'] + ' ' + reader['lastName'], num_books_borrowed=num_books_borrowed, fine='£' + string_fine)

run(host='localhost', port=8080, debug=True)