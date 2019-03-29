window.addEventListener('DOMContentLoaded', function() {
    check_out_form = document.getElementById("check_out");
    check_out_form.addEventListener("submit", function(event) {
        event.preventDefault();
    })

})

function borrow_if_not_reserved(serial_number, readerID, days_to_rent_for) {

    fetch("/is_copy_reserved_by_someone_else", {
        method: "POST",
        body: JSON.stringify([serial_number, readerID]),
        headers: {
            'Content-Type': 'application/json'
        }
    }
    ) . then(
        function(response) {
            if (!response.ok) {
                throw new Error(`HTTP error, status = ${response.status}`)
            }
            response.json().then(
                function(is_copy_reserved) {
                    if (is_copy_reserved) {
                        popup('Sorry, there are no unreserved copies of that edition available for borrowing.');
                    } else {
                        borrow_book(serial_number, readerID, days_to_rent_for);
                    }

                }
            )
        }
    )  
}

function borrow_book(serial_number, readerID, days_to_rent_for) {
    fetch("/check_out_book", {
        method: "POST",
        body: JSON.stringify([serial_number, readerID, days_to_rent_for]),
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
            response.json().then(
                function(borrowed_successfully) {
                    if (borrowed_successfully) {
                        swal({title: 'Book checked out!'})
                        .then (function() {
                            window.location.href= `/reader_overview_by_ID/${readerID}`;
                        })
                        
                    }  
                    else {
                        swal("That serial number doesn't seem to be in stock at the moment; please check you typed it correctly and try again")
                    }
                }
            )
        }
    )
}