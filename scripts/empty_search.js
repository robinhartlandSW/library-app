function popup(message) {
    swal({
        title: message,
        content: '', 
        className: "alert-box"
    })
}

function empty_search() {
    let name = document.getElementById("reader_name_dropdown").value;
    name_second_last_digit = name[name.length-2]
    let ID = parseInt(name_second_last_digit)
    if (isNaN(ID)) {
        popup('Please choose a valid user.')
        return false
    }
    else {
        return true
    }
}