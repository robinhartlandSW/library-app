function copy_reserved(serial_number, readerID) {

    return (fetch("/check_if_copy_reserved", {
        method: "POST",
        body: JSON.stringify([serial_number, readerID]),
        headers: {
            'Content-Type': 'application/json'
        }
    }
    ) . then(response => response.json()))
    
}