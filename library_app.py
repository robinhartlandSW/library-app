import json
import datetime
from decimal import Decimal, getcontext
from bottle import get, post, install, run, request, route, template, static_file, redirect
from bottle_sqlite import SQLitePlugin
database_file = 'library-nomad.db'
install(SQLitePlugin(dbfile=database_file))

TWO_DECIMAL_PLACES = Decimal(10) ** -2

##### STATIC #####

@get('/static/<file:path>')
def serve_static(file):
    return static_file(file, root='./static')

@get('/scripts/<file:path>')
def serve_script(file):
    return static_file(file, root = './scripts')

@route('/img/<filename>')
def fetch_book_cover(filename):
    return static_file(filename, root='./img')


##### BORROWER #####

@route('/switch_to_borrower_view')
def switch_to_borrower_view(db):
    redirect ('/borrower_search?phrase=')

@get('/borrower_search')
def search(db):
    phrase = request.query.phrase
    if phrase == '': return template ('borrower_home', editions=[])
    search_results = get_search_results(db, phrase)
    search_results = list({e['ID']:e for e in check_availability(db, search_results)}.values())
    return template('borrower_home', editions=search_results)


##### LIBRARIAN #####

@route('/home')
@route('/')
@route('/switch_to_librarian_view')
def switch_to_librarian_view(db):
    redirect ('/librarian_search?phrase=')

@get('/librarian_search')
def librarian_search(db):
    phrase = request.query.phrase
    if phrase == '': return template('librarian_home', editions=[])
    search_results = get_search_results(db, phrase)
    search_results = list({e['ID']:e for e in get_num_copies(db, search_results)}.values())
    return template('librarian_home', editions=search_results)

@get('/add_new_reader')
def add_new_reader():
    return template('new_reader')

@get('/return_book')
def return_book():
    return template('return_book')

@post('/get_edition_details')
def get_edition_details(db):
    serial_number = request.json
    editionID = db.execute("SELECT editionID FROM copies WHERE copyID = ?", (serial_number, )).fetchone()['editionID']
    edition = db.execute("SELECT * FROM editions WHERE ID = ?", (editionID,)).fetchone()
    return json.dumps(refine_book_info(edition[0]))

@post('/find_matching_names')
def find_matching_names(db):
    # Parse the JSON of the HTTP request
    reader_name = request.json
    names = reader_name.split(' ')

    # Extract all names that have more than zero non-whitespace characters
    name_list = [n for n in names if len(n.strip()) > 0 ]
    num_names = len(name_list)
    parsed_matches = []

    if num_names > 0:
        first_name = name_list[0]
        
        if num_names == 1:
            # find all the readers whose first name starts with what has been typed
            matches = db.execute("SELECT * FROM readers WHERE firstName LIKE ? ", (first_name + '%',)).fetchall()
        else:
            last_name = name_list[-1]
            matches = db.execute("SELECT * FROM readers WHERE firstName = ? AND lastName LIKE ?", (first_name, last_name + '%')).fetchall()

        parsed_matches = [{'first_name': m['firstName'], 'last_name': m['lastName'], 'ID': m['ID']} for m in matches]

    # convert response to JSON
    return json.dumps(parsed_matches)

@post('/reader_overview')
def reader_overview(db):
    reader_name_dropdown = request.forms.get('reader_name_input')
    reader_ID = dropdown_field_to_id(reader_name_dropdown)
    reader = db.execute('SELECT * FROM readers WHERE ID = ?', (reader_ID,)).fetchone()
    fine = reader['fine']
    first_name = reader['firstName']
    last_name = reader['lastName']
    reader_name = first_name + ' ' + last_name
    string_fine = str(fine)
    num_books_borrowed = db.execute("SELECT COUNT(copyID) FROM copies WHERE readerID = ?", (reader_ID,)).fetchone()[0]
    rented_book_list = get_rented_books(db, reader_ID)
    number_results = len(rented_book_list)

    overdue_books = number_overdue_books(number_results, rented_book_list)

    return template('reader_overview', ID=reader_ID, reader_name=reader_name, num_books_borrowed=num_books_borrowed, fine='£' + string_fine, page_head_message=' ', book_list = rented_book_list, number_results = number_results, num_overdue_books = overdue_books)
    

        
@post('/check_out_book')
def check_out_book(db): 
    title = request.forms.get('title')
    author = request.forms.get('author')
    serial_number = request.forms.get('serial_number')
    days_rented = request.forms.get('days_rented')
    current_fine = request.forms.get('current_fine')
    days_rented = int(days_rented)
    current_fine = fine_string_to_decimal(current_fine)

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

    copy_in_library = db.execute("SELECT readerID FROM copies WHERE copyID = ? AND readerID IS NULL", (serial_number,)).fetchone()
    if copy_in_library and copy_in_library['readerID']:
        db.execute("UPDATE copies SET readerID=? WHERE copyID=?", (readerID, serial_number))
        db.execute('UPDATE copies SET due_date = ? WHERE copyID = ?', (due_date, serial_number))
        check_for_satisfied_reservations(serial_number, readerID, db)
        return template("book_checked_out.tpl")
    else:
        return template('message_page.tpl', message="Error", submessage = "That book is not available to be borrowed")


    

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
    location = request.forms.get('location')
    ISBN = request.forms.get('ISBN')
    check_existence = db.execute("SELECT * FROM editions WHERE ISBN = (?)", [ISBN]).fetchone()
    if check_existence == None:
        edition_id = db.execute("INSERT INTO editions(author, title, genre, location, ISBN) VALUES (?,?,?,?,?)", (author, title, genre, location, ISBN)).lastrowid
        return template('new_book', success = 1)
    else:
        return template('new_book', success = -3)

@post('/add_new_copy_by_ISBN')
def add_new_copy(db):
    ISBN = request.forms.get('ISBN')
    book_edition = db.execute("SELECT * FROM editions WHERE ISBN = (?)", [ISBN]).fetchone()
    if book_edition != None:
        book_id = book_edition['ID']
        copy_id = db.execute("INSERT INTO copies(editionID) VALUES (?)", (book_id,)).lastrowid
        return template('new_book', success = 1)
    else:
        return template('new_book', success = -1)

@post('/add_new_copy_by_title_author')
def add_new_copy(db):
    title = request.forms.get('title')
    author = request.forms.get('author')
    book_edition = db.execute("SELECT * FROM editions WHERE title = (?) AND author = (?)", [title, author]).fetchone()
    if book_edition != None:
        book_id = book_edition['ID']
        copy_id = db.execute("INSERT INTO copies(editionID) VALUES (?)", (book_id,)).lastrowid
        return template('new_book', success=1)
    else:
        return template('new_book', success=-2)

@post('/register_new_reader_in_database')
def register_new_reader_in_database(db):
    first_name = request.forms.get('first_name')
    last_name = request.forms.get('last_name')
    fine = 0
    db.execute("INSERT INTO readers(firstName, lastName, fine) VALUES (?, ?, ?)", (first_name, last_name, fine))
    return template('new_reader', success=1)

@get('/add_new_edition')
def add_new_edition():
    return template('new_book.tpl')

@get('/add_new_copy/<editionID>')
def add_new_copy(db, editionID):
    db.execute("INSERT INTO copies(editionID) VALUES (?)", (editionID,))

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

@post('/reserve_book')
def reserve_book(db):
    serial_number = request.forms.get('serial_number')
    reader_name_dropdown = request.forms.get('reader_name_input')
    reserver_ID = dropdown_field_to_id(reader_name_dropdown)
    edition_ID = request.forms.get('edition_ID')
    date = datetime.datetime.now()
    db.execute("INSERT INTO reservations(reserver_ID, editionID, datePlaced) VALUES (?, ?, ?)", (reserver_ID, edition_ID ,date))

@get('/show_reservation_form/<serial_number>')
def show_reservation_form(serial_number, db):
    edition = db.execute("SELECT * FROM editions WHERE ID = ?", (serial_number,)).fetchone()

    return template("reserve_book.tpl", edition=edition)

@post('/reader_overview_fine')
def fine_reader(db):
    fine = request.forms.get('added_fine')
    fine = Decimal(fine)
    user_id = request.forms.get('user_id')
    current_fine = db.execute('SELECT fine FROM readers WHERE ID = ?', (user_id,)).fetchone()[0]
    current_fine = Decimal(current_fine)
    new_fine = Decimal(current_fine + fine).quantize(TWO_DECIMAL_PLACES)
    db.execute('UPDATE readers SET fine = ? WHERE ID = ?', (str(new_fine), user_id))
    reader = db.execute('SELECT * FROM readers WHERE ID = ?', (user_id,)).fetchone()
    num_books_borrowed = db.execute("SELECT COUNT(copyID) FROM copies WHERE readerID == ?", (user_id,)).fetchone()[0]
    fine = db.execute('SELECT fine FROM readers WHERE ID = ?', (user_id,)).fetchone()[0]
    string_fine = str(fine)

    rented_book_list = get_rented_books(db, user_id)
    number_results = len(rented_book_list)
    overdue_books = number_overdue_books(number_results, rented_book_list)

    return template('reader_overview.tpl', ID=user_id, reader_name=reader['firstName'] + ' ' + reader['lastName'], num_books_borrowed=num_books_borrowed, fine='£' + string_fine, page_head_message='FINE ADDED', book_list=rented_book_list, number_results=number_results, num_overdue_books = overdue_books, fine_added=1)

@post('/reader_overview_pay_fine')
def pay_fine(db):
    fine = request.forms.get('paid_fine')
    fine = Decimal(fine)
    user_id = request.forms.get('user_id')
    current_fine = db.execute('SELECT fine FROM readers WHERE ID = ?', (user_id,)).fetchone()[0]
    current_fine = Decimal(current_fine)

    new_fine = Decimal(current_fine - fine).quantize(TWO_DECIMAL_PLACES)
    db.execute('UPDATE readers SET fine = ? WHERE ID = ?', (str(new_fine), user_id))
    reader = db.execute('SELECT * FROM readers WHERE ID = ?', (user_id,)).fetchone()
    num_books_borrowed = db.execute("SELECT COUNT(copyID) FROM copies WHERE readerID == ?", (user_id,)).fetchone()[0]
    fine = db.execute('SELECT fine FROM readers WHERE ID = ?', (user_id,)).fetchone()[0]
    string_fine = str(fine)
    rented_book_list = get_rented_books(db, user_id)
    number_results = len(rented_book_list)
    overdue_books = number_overdue_books(number_results, rented_book_list)
    return template('reader_overview.tpl', ID=user_id, reader_name=reader['firstName'] + ' ' + reader['lastName'], num_books_borrowed=num_books_borrowed, fine='£' + string_fine, page_head_message='FINE PAID', book_list=rented_book_list, number_results=number_results, num_overdue_books = overdue_books, fine_added=-1)


##### HELPER FUNCTIONS #####

def refine_book_info (editions):
    editions = [{'title': e['title'], 'author' : e['author'], 'location' : e['location'], 'genre' : e['genre'], 'ISBN' : e['ISBN'], 'ID' : e['ID']} for e in editions]
    return editions

def get_search_results (db, phrase):
    matching_titles = db.execute('SELECT * FROM editions WHERE title LIKE (?)', (f'%{phrase}%',)).fetchall()
    matching_authors = db.execute('SELECT * FROM editions WHERE author LIKE (?)', (f'%{phrase}%',)).fetchall()
    matching_genres = db.execute('SELECT * FROM editions WHERE genre LIKE (?)', (f'%{phrase}%',)).fetchall()
    editions = refine_book_info(matching_titles) + refine_book_info(matching_authors) + refine_book_info(matching_genres)
    return editions

def check_availability (db, editions):
    editions = get_num_copies (db, editions)
    for edition in editions:
        if edition['num_available_copies'] != 0: edition['num_available_copies'] = ('AVAILABLE FROM ' + edition['location'])
        else: edition['num_available_copies'] = 'UNAVAILABLE: PLEASE SEE THE LIBRARIAN TO RESERVE'
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

# Convert the format from the dropdown user lists into an ID
# The reader names are in the format Fred Smith (ID 12345) in the dropdown list.
def dropdown_field_to_id(reader_name_input):
    reader_ID = reader_name_input.split('(')[-1].rstrip(')').lstrip('ID ')
    return reader_ID
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

def number_overdue_books(number_results, rented_book_list):
    import datetime
    overdue_books = 0
    now = datetime.datetime.now()
    for i in range(number_results):
        due_date = rented_book_list[i][3]
        due_date_time = datetime.datetime.strptime(due_date, '%Y-%m-%d %H:%M:%S')
        if due_date_time < now:
            overdue_books += 1
    return overdue_books

def fine_string_to_decimal(fine_string):
    return Decimal(fine_string.split('£')[-1])

def check_for_satisfied_reservations(copy_ID, reader_ID, db):
    edition_ID = db.execute("SELECT editionID FROM copies WHERE copyID = ?", (copy_ID, )).fetchone()['editionID']
    db.execute("DELETE FROM reservations WHERE reserver_ID = ? AND editionID = ?", (reader_ID, edition_ID))
    


run(host='localhost', port=8080, debug=True)
