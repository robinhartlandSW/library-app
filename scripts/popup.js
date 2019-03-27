function popup(message) {
    swal({
        title: message,
        content: '', 
        className: "alert-box"
    })
}

function check_conditions(num_books_borrowed, fine, overdue_books){
    var books_borrowed_str = num_books_borrowed
    var books_borrowed_int = parseInt(books_borrowed_str, 10)
    var fine_str = fine
    var fine_int = parseFloat(fine_str, 10)
    var overdue_int = parseInt(overdue_books)
    if (books_borrowed_int > 7) {
        popup('Failed - user has borrowed too many books')
        return false
    }
    else if (fine_int > 0) {
        popup('Failed - user must pay fine')
        return false
    }
    else if (overdue_books > 0) {
        popup('Failed - user has overdue books')
        return false
    }
    else {
        return true
    }
}

function no() {
    return false
}
