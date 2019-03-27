function take_out_book(userID) {
    fetch('/overdue_books', {
        method: "POST",
        body: JSON.stringify(userID),
        headers: {
            'Content-Type': 'application/json'
        }

    }
    )
    .then(
        function(response) {
            if (!response.ok) {
                throw new Error(`HTTP error, status = ${response.status}`)
            }

            response.json().then(
                function(overdue_books) {  
                    let overdue_book_list = document.createElement("UL");
                    
                    for (let overdue_book of overdue_books) {
                        let list_element = document.createElement("LI");
                        list_element.innerText = overdue_book;
                        overdue_book_list.appendChild(list_element);
                    }
                
                    // use a sweetAlert to display serial numbers nicely 
                    swal({
                        title: "Overdue books:",
                        content: overdue_book_list,
                        className: "alert-box"
                    });
    )
}