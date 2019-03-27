# Setup
database_file = 'library-nomad.db'
from bottle import get, post, install, run, request, route, template, static_file
from bottle_sqlite import SQLitePlugin
import json

import datetime
install(SQLitePlugin(dbfile=database_file))

# Static content:
@get('/static/<file:path>')
def serve_static(file):
    return static_file(file, root='./static')

@get('/scripts/<file:path>')
def serve_script(file):
    return static_file(file, root = './scripts')

# Routes
@route('/img/<filename>')
def fetch_book_cover(filename):
    return static_file(filename, root='./img')

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

@post('/find_matching_names')
def find_matching_names(db):
    # Parse the JSON of the HTTP request
    names = request.json

    # find all the readers whose first name starts with what has been typed
    matches = db.execute("SELECT * FROM readers WHERE firstName LIKE ? ", (names[0] + '%',)).fetchall()

    parsed_matches = [{'first_name': m['firstName'], 'last_name': m['lastName'], 'ID': m['ID']} for m in matches]

    # convert response to JSON
    return json.dumps(parsed_matches)

@post('/reader_overview')
def reader_overview(db):
    reader_name = request.forms.get('reader_name_input')

    # The reader names are in the format Fred Smith (ID 12345)
    # This section extracts the reader's ID
    reader_ID = reader_name.split('(')[-1].rstrip(')').lstrip('ID ')

    fine = db.execute('SELECT fine FROM readers WHERE ID = ?', (reader_ID,)).fetchone()[0]
    string_fine = str(fine)
    num_books_borrowed = db.execute("SELECT COUNT(copyID) FROM copies WHERE readerID = ?", (reader_ID,)).fetchone()[0]

    rented_book_list = get_rented_books(db, reader_ID)
    number_results = len(rented_book_list)

    return template('reader_overview.tpl', ID=reader_ID, reader_name=reader_name, num_books_borrowed=num_books_borrowed, fine='£' + string_fine, page_head_message=' ', book_list = rented_book_list, number_results = number_results)
    

        
@post('/check_out_book')
def check_out_book(db): 
    title = request.forms.get('title')
    author = request.forms.get('author')
    serial_number = request.forms.get('serial_number')
    days_rented = request.forms.get('days_rented')
    current_fine = request.forms.get('current_fine')[-3:-1]
    days_rented = int(days_rented)
    current_fine = float(current_fine)

    if current_fine > 0:
        return template('message_page.tpl', message = 'USER MUST PAY FINE BEFORE RENTING OUT BOOK.', submessage = 'Return to the readers page and ensure that all fines are paid and there are no overdue books.')

    now = datetime.datetime.now()
    due_date = now + datetime.timedelta(days = days_rented)

    readerID = request.forms.get('readerID')

    has_overdue_book = user_has_overdue_book(db, readerID)
    if has_overdue_book[0] == True:
        books_overdue = has_overdue_book[1]
        bookstring = ''
        for book in books_overdue:
            bookstring += (str(book['copyID']) + ', ')
        
        return template('message_page.tpl', message = 'FAILED - USER HAS OVERDUE BOOKS', submessage = 'Overdue book IDs: ' + bookstring)

    db.execute("UPDATE copies SET readerID=? WHERE copyID=?", (readerID, serial_number))
    db.execute('UPDATE copies SET due_date = ? WHERE copyID = ?', (due_date, serial_number))

    #TODO: return a suitable error message when trying to check out a disallowed book (maybe use javascript to prevent this?)
    return template("book_checked_out.tpl")

@post('/return_book_to_database')
def return_book_to_database(db):
    serial_number = request.forms.get('serial_number')
    reader_id = db.execute('SELECT readerID FROM copies WHERE copyID = ?', (serial_number,)).fetchone()[0]
    message = ''
    is_overdue = is_book_overdue(db, serial_number)
    if is_overdue[0] == True:
        user_old_fine = db.execute('SElECT fine FROM readers WHERE ID = ?',(reader_id,)).fetchone()
        if user_old_fine is None:
            user_old_fine = 0
        else:
            user_old_fine = user_old_fine[0]
        user_new_fine = user_old_fine + is_overdue[1]
        db.execute('UPDATE readers SET fine = ? WHERE ID = ?', (user_new_fine, reader_id))
        message = f'BOOK RETURNED LATE. Reader fine now £{user_new_fine}'
    db.execute("UPDATE copies SET readerID=NULL WHERE copyID == ?", (serial_number,))
    db.execute("UPDATE copies SET due_date=NULL WHERE copyID == ?", (serial_number,))
    return template("book_returned.tpl", message = message)

@post('/add_new_edition')
def add_new_edition(db):
    title = request.forms.get('title')
    author = request.forms.get('author')
    genre = request.forms.get('genre')
    ISBN = request.forms.get('ISBN')
    check_existence = db.execute("SELECT * FROM editions WHERE ISBN = (?)", [ISBN]).fetchone()
    if check_existence == None:
        edition_id = db.execute("INSERT INTO editions(author, title, genre, ISBN) VALUES (?,?,?,?)", (author, title, genre, ISBN)).lastrowid
        return template('book_display')
    #TODO: else error message book already exists

@post('/add_new_copy_by_ISBN')
def add_new_copy(db):
    ISBN = request.forms.get('ISBN')
    book_edition = db.execute("SELECT * FROM editions WHERE ISBN = (?)", [ISBN]).fetchone()
    book_id = book_edition['ID']
    if book_edition != None:
        copy_id = db.execute("INSERT INTO copies(editionID) VALUES (?)", (book_id,)).lastrowid
        return template('new_copy_added', serial_number=copy_id)
    #TODO: else error message book does not exist

@post('/add_new_copy_by_title_author')
def add_new_copy(db):
    title = request.forms.get('title')
    author = request.forms.get('author')
    book_edition = db.execute("SELECT * FROM editions WHERE title = (?) AND author = author", [title]).fetchone()
    book_id = book_edition['ID']
    if book_edition != None:
        copy_id = db.execute("INSERT INTO copies(editionID) VALUES (?)", (book_id,)).lastrowid
        return template('new_copy_added', serial_number=copy_id)
    #TODO: else error message book does not exist

@post('/register_new_reader_in_database')
def register_new_reader_in_database(db):
    first_name = request.forms.get('first_name')
    last_name = request.forms.get('last_name')
    fine = 0
    db.execute("INSERT INTO readers(firstName, lastName, fine) VALUES (?, ?, ?)", (first_name, last_name, fine))
    return template('new_reader')

@get('/add_new_edition')
def add_new_edition():
    return template('new_book')

@get('/add_new_copy/<editionID>')
def add_new_copy(db, editionID):
    db.execute("INSERT INTO copies(editionID) VALUES (?)", (editionID,))

@get('/view_library')
def view_library(db):
    library = db.execute('SELECT * FROM editions').fetchall()
    editions = [{'title': e['title'], 'author' : e['author'], 'genre' : e['genre'], 'ISBN' : e['ISBN'], 'ID' : e['ID']} for e in library]
    editions = get_num_copies(db, editions)
    return template('book_display', editions=editions)

@get('/search')
def search(db):
    phrase = request.query.phrase
    matching_titles = db.execute('SELECT * FROM editions WHERE title LIKE (?)', (f'%{phrase}%',)).fetchall()
    matching_authors = db.execute('SELECT * FROM editions WHERE author LIKE (?)', (f'%{phrase}%',)).fetchall()
    matching_genres = db.execute('SELECT * FROM editions WHERE genre LIKE (?)', (f'%{phrase}%',)).fetchall()
    editions = refine_book_info(matching_titles) + refine_book_info(matching_authors) + refine_book_info(matching_genres)
    editions = get_num_copies(db, editions)
    return template('book_display.tpl', editions=editions)

@post('/available_serial_numbers')
def available_serial_numbers(db):
    editionID = request.json
    edition = db.execute('SELECT * FROM editions WHERE ID == ?', (editionID,)).fetchone()
    copies_of_this_edition = db.execute('SELECT copyID FROM copies WHERE editionID == ? AND readerID IS NULL', (editionID,)).fetchall()
    serial_numbers = [c['copyID'] for c in copies_of_this_edition]
    return json.dumps(serial_numbers)


@get('/add_new_reader_to_database')
def add_new_reader_to_database(db):
    firstName = request.query["firstName"]
    lastName = request.query.get("lastName")
    db.execute("INSERT INTO readers(firstName, lastName) VALUES (?,?)", (firstName, lastName))

#add, pay fines
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

    rented_book_list = get_rented_books(db, user_id)
    number_results = len(rented_book_list)

    return template('reader_overview.tpl', ID=user_id, reader_name=reader['firstName'] + ' ' + reader['lastName'], num_books_borrowed=num_books_borrowed, fine='£' + string_fine, page_head_message='FINE ADDED', book_list=rented_book_list, number_results=number_results)

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

    rented_book_list = get_rented_books(db, user_id)
    number_results = len(rented_book_list)

    return template('reader_overview.tpl', ID=user_id, reader_name=reader['firstName'] + ' ' + reader['lastName'], num_books_borrowed=num_books_borrowed, fine='£' + string_fine, page_head_message='FINE PAID', book_list=rented_book_list, number_results=number_results)

# Helper Functions

def refine_book_info (editions):
    editions = [{'title': e['title'], 'author' : e['author'], 'ISBN' : e['ISBN'], 'ID' : e['ID']} for e in editions]
    return editions

def get_num_copies (db, editions):
    for ed in editions:
        ID = ed['ID']
        num_available_copies = db.execute("SELECT COUNT (copyID) FROM copies WHERE readerID IS NULL AND editionID == ? ", (ID,)).fetchone()[0]
        ed['num_available_copies'] = num_available_copies
    return editions

def is_book_overdue(db, book_id):
    now = datetime.datetime.now()
    due_date = db.execute('SELECT due_date FROM copies WHERE copyID = ?', (book_id,)).fetchone()
    if due_date is None:
        pass
    due_date = due_date[0]
    due_date = datetime.datetime.strptime(due_date, '%Y-%m-%d %H:%M:%S.%f')
    if now > due_date:
        time_late = now - due_date
        days_late = time_late.days
        return (True, days_late)
    else:
        return (False, 0)

def user_has_overdue_book(db, user_id):
    rented_books = db.execute('SELECT * FROM copies WHERE readerID = ?', (user_id,)).fetchall()
    overdue_books = []
    for book in rented_books:
        ID = book['copyID']
        overdue = is_book_overdue(db, ID)
        if overdue[0] == True:
            overdue_books.append(book)
    if overdue_books == []:
        return (False, [])
    else:
        return (True, overdue_books)

def get_rented_books(db, reader_ID):
    rented_books1 = db.execute('SELECT * FROM copies WHERE readerID = ?', (reader_ID,)).fetchall()
    rented_books = []
    for book in rented_books1:
        rented_books.append(book)
    number_results = len(rented_books)
    rented_book_editions = []
    for book in rented_books:
        edition = book['editionID']
        edition_book = db.execute('SELECT * FROM editions WHERE ID = ?', (edition,)).fetchone()
        rented_book_editions.append(edition_book)
    rented_book_list = []
    for i in range(number_results):
        rented_book_list.append([str(rented_books[i]['copyID']), str(rented_book_editions[i]['title']), str(rented_book_editions[i]['author']), str(rented_books[i]['due_date'])[0:19]])
    return rented_book_list
    


run(host='localhost', port=8080, debug=True)
