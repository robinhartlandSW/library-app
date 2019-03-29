function popup(message) {
    swal({
        title: message,
        content: '', 
        className: "alert-box"
    })
}

function check_conditions() {
    let title = document.getElementById("title").value;
    let isbn = document.getElementById("ISBN").value;
    int_isbn = parseInt(isbn)

    if (title.length == 0 && isbn.length == 0) {
        popup("FAILED: TITLE & ISBN MUST NOT BE EMPTY")
        return false
    }
    else if (title.length == 0) {
        popup("FAILED: TITLE MUST NOT BE EMPTY")
        return false
    }
    else if (isbn.length == 0) {
        popup("FAILED: ISBN MUST NOT BE EMPTY")
        return false
    }
    else if (!(isbn.length == 13)) {
        popup("FAILED: ENTER A VALID 13 DIGIT ISBN")
        return false
    }
    else if ((isNaN(int_isbn))) {
        popup("FAILED: ENTER A VALID 13 DIGIT ISBN")
        return  false
    }
    return true
}

function check_conditions_isbn() {
    let isbn = document.getElementById("ISBN_1").value;
    if (isbn.length === 0) {
        popup("FAILED: ISBN MUST NOT BE EMPTY")
        return false
    }
    else {
        return true
    }
}

function check_conditions_title() {
    let isbn = document.getElementById("title_1").value;
    if (isbn.length === 0) {
        popup("FAILED: TITLE MUST NOT BE EMPTY")
        return false
    }
    else {
        return true
    }
}

function success_message(x) {
    let y = parseInt(x)
    if (y === 1) {
        popup("BOOK ADDED")
    }
    else if (y === -1) {
        popup("FAILED: NO EXISTING EDITION WITH THIS ISBN")
    }
    else if (y === -2) {
        popup("FAILED: MATCHING BOOK NOT FOUND")
    }
    else if (y === -3) {
        popup("FAILED: EDITION ALREADY EXISTS")
    }
}

function check_conditions_name() {
    let first_name = document.getElementById("first_name").value;
    if (first_name.length == 0) {
        popup("FAILED: FIRST NAME MUST NOT BE EMPTY")
        return false
    }
    else {
        return true
    }
}

function success_message_user(x) {
    let y = parseInt(x)
    if (y === 1) {
        popup("USER ADDED")
    }
}