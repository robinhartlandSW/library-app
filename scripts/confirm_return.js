function confirm_return() {
    let serial_number_input = document.getElementById("serial_number");
    serial_number = serial_number_input.value;

    book_details = fetch_book_details(serial_number)
    .then(
    swal (`Are you sure you want to return ${book_details['title']} by ${book_details['author']}?`)
    ) .then (
        fetch('/return_book_to_database')
        .then (
            function(response) {
                if (!response.ok) {
                    throw new Error(`HTTP error, status = ${response.status}`)
                }
                response.json().then (
                    function(book_returned) {
                        if (book_returned) {
                            swal("Book successfully returned")
                        } else {
                            swal("Book not returned. Check you typed the serial number correctly and try again.")
                        }
                    }
                )
            }
        )
    )
}

function fetch_book_details(serial_number) {
    return (fetch('/get_edition_details', {
        method: "POST",
        body: JSON.stringify(editionID),
        headers: {
            'Content-Type': 'application/json'
        }
    }   
    )
    .then (
        function(response) {
            if (!response.ok) {
                throw new Error(`HTTP error, status = ${response.status}`)
            }
            (response => response.json());
        }
    ))
}