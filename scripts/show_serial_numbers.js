function show_serial_numbers(editionID) {
    fetch('/available_serial_numbers', {
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
       
            response.json().then(
                function(serial_numbers) {  
                    let serial_number_list = document.createElement("UL");
                    
                    for (let serial_number of serial_numbers) {
                        let list_element = document.createElement("LI");
                        form = book_info_form(serial_number)
                        list_element.appendChild(form);

                        serial_number_list.appendChild(list_element);
                    }
                
                    // use a sweetAlert to display serial numbers nicely 
                    swal({
                        title: "Available serial numbers:",
                        content: serial_number_list,
                        className: "alert-box"
                    });
                }
            )
        }
    )

}

function book_info_form(serial_number) {
    let form = document.createElement("FORM");
    form.method = "get";

    // TODO: location page
    form.action = `/`;

    let label = document.createElement("LABEL")
    label.htmlFor = serial_number;
    label.innerText = serial_number;

    form.appendChild(label);

    return form;
}