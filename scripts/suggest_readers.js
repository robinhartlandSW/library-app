function suggest_readers() {
    let name_input_box = document.getElementById("reader_name_input");
    let reader_name = name_input_box.value;

    if (reader_name.length > 0 ) {
        suggested_names = find_matching_names(reader_name);
    }
    else {
        apply_dropdown_placeholder_text();
    }
}

function find_matching_names(reader_name) {
    fetch('/find_matching_names', {
        method: "POST",
        body: JSON.stringify(reader_name),
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(
        function(response) {
            if (!response.ok) {
                throw new Error(`HTTP error, status = ${response.status}`)
            }

            response.json().then(
                function(suggested_names) {
                    let reader_name_dropdown = document.getElementById("reader_name_dropdown")
                    remove_all_dropdown_elements(reader_name_dropdown)

                    if (suggested_names.length > 0) {   

                        for (let names of suggested_names) {
                            suggested_first_name = names['first_name']
                            suggested_last_name = names['last_name']
                            ID = names['ID']
                    
                            new_option = document.createElement("option")
                            new_option.text = `${suggested_first_name} ${suggested_last_name} (ID ${ID})`
                            reader_name_dropdown.add(new_option)
                        }
                    } 
                    else {
                        apply_dropdown_placeholder_text()
                    }
                }
            )
        }
    )

}

function remove_all_dropdown_elements(dropdown) {
    while (reader_name_dropdown.length > 0) {
        reader_name_dropdown.remove(0);
    }
}

function apply_dropdown_placeholder_text() {
    let reader_name_dropdown = document.getElementById("reader_name_dropdown")
    remove_all_dropdown_elements(reader_name_dropdown);
    placeholder = document.createElement("option")
    placeholder.text = "type a name..."
    reader_name_dropdown.add(placeholder)
}