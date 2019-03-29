function popup(message) {
    swal({
        title: message,
        content: '', 
        className: "alert-box"
    })
}



function reservation_added(x) {
    let y = parseInt(x)
    if (y === 1) {
        popup("Reservation added!")
    }
}