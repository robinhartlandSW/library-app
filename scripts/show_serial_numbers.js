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
                        list_element.innerText = serial_number

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
