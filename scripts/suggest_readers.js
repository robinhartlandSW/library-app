function suggest_readers() {
    let reader_name_dropdown = document.getElementById("reader_name_dropdown")

    let first_name_input_box = document.getElementById("reader_first_name_input");
    let first_name = first_name_input_box.value;

    let last_name_input_box = document.getElementById("reader_last_name_input");
    let last_name = last_name_input_box.value;

    suggested_names = find_matching_names(first_name, last_name);

    for (let names of suggested_names) {
        suggested_first_name = names['first_name']
        suggested_last_name = names['last_name']

        new_option = document.createElement("option")
        new_option.text = suggested_first_name + suggested_last_name
        reader_name_dropdown.add(new_option)
    }
   

}

function find_matching_names(first_name, last_name) {
    fetch('/find_matching_names', {
        method: "POST",
        body: JSON.stringify([first_name, last_name]),
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(
        function(response) {
            if (!response.ok) {
                throw new Error(`HTTP error, status = ${response.status}`)
            }
            return response.json();
        }
    )

}