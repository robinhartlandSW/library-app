function popup(message) {
    swal({
        title: message,
        content: '', 
        className: "alert-box"
    })
}

async function check_conditions(num_books_borrowed, fine, overdue_books){
    var books_borrowed_str = num_books_borrowed;
    var books_borrowed_int = parseInt(books_borrowed_str, 10);
    var fine_str = fine;
    var fine_int = parseFloat(fine_str, 10);
    var overdue_int = parseInt(overdue_books);

    let serial_number_box = document.getElementById("serial_number");
    let serial_number = serial_number_box.value;

    let readerID = document.getElementById("readerID").value;

    if (books_borrowed_int > 7) {
        popup('Failed - user has borrowed too many books');
        return false;
    }
    else if (fine_int > 0) {
        popup('Failed - user must pay fine');
        return false;
    }
    else if (overdue_int > 0) {
        popup('Failed - user has overdue books');
        return false;
    } 
    else if (await copy_reserved(serial_number, readerID)) {
        popup('Sorry, there are no unreserved copies of that edition available for borrowing.');
        return false;
    }
    else {
        return true;
    }
}


function no() {
    return false
}

function success_message_fine(x) {
    let y = parseInt(x)
    if (y === 1) {
        popup("Fine added")
    }
    else if (y === -1) {
        popup("Fine paid")
    }
    else if (y === 2) {
        popup("Success! Book rented.")
    }
    else if (y === 3) {
        popup("Failed. Book not available to be rented.")
    }
}

function verify_fine_add() {
    let fine = document.getElementById("added_fine").value;
    if (fine.length === 0) {
        popup("Failed - enter fine value")
        return false
    }
    let Q = parseFloat(fine)
    if (isNaN(Q)) {
        popup("Please enter a valid fine.")
        return false
    }
    else {
        return true
    }
}

function verify_fine_payment() {
    let fine = document.getElementById("paid_fine").value;
    if (fine.length === 0) {
        popup("Failed - enter amount paid")
        return false
    }
    let Q = parseFloat(fine)
    if (isNaN(Q)) {
        popup("Please enter a valid fine.")
        return false
    }
    else {
        return true
    }
}