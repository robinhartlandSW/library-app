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
    if (title.length === 0 || isbn.length === 0) {
        popup("The form is incomplete! Please add a title and ISBN.")
        return false
    }
    else if (!(isbn.length == 13)) {
        popup("Please enter a valid 13 digit ISBN")
        return false
    }
    else if ((isNaN(int_isbn))) {
        popup("Please enter a valid 13 digit ISBN")
        return  false
    }
    else {
        return true
    }
}

function check_conditions_isbn() {
    let isbn = document.getElementById("ISBN_1").value;
    if (isbn.length === 0) {
        popup("The form is incomplete! Please add an ISBN.")
        return false
    }
    else {
        return true
    }
}

function check_conditions_title() {
    let isbn = document.getElementById("title_1").value;
    if (isbn.length === 0) {
        popup("The form is incomplete! Please add a title.")
        return false
    }
    else {
        return true
    }
}

function success_message(x) {
    let y = parseInt(x)
    if (y === 1) {
        popup("Book has been added.")
    }
    else if (y === -1) {
        popup("Failed - No edition with this ISBN exists!")
    }
    else if (y === -2) {
        popup("Failed - this book does not exist!")
    }
    else if (y === -3) {
        popup("Failed - this edition already exists!")
    }
}

function check_conditions_name() {
    let first_name = document.getElementById("first_name").value;
    let last_name = document.getElementById("last_name").value;
    if (first_name.length === 0 || last_name.length === 0) {
        popup("Failed - the form is incomplete!")
        return false
    }
    else {
        return true
    }
}

function success_message_user(x) {
    let y = parseInt(x)
    if (y === 1) {
        popup("Success! User has been added.")
    }
}