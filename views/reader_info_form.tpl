
<<<<<<< HEAD
<form class="librarian-form" method="post" action={{action}}>
    <div>
        <input type="text" placeholder="Name" id="reader_name_input" onkeydown="suggest_readers()" autocomplete="off"/>
    </div>
=======
    <form class="librarian-form" method="post" action={{action}}>
        <label>FIND A READER:</label>
        <div>
            <label for="reader_name_input">Reader name:</label>
            <input type="text" id="reader_name_input" onkeyup="suggest_readers()" autocomplete="off"/>
        </div>
>>>>>>> reader-autofill-finished

        <select id="reader_name_dropdown" name="reader_name_input">
            <option> Type a name above...</option>
        </select>

        <input type="submit" value="{{button_text}}" />
        % if edition_ID != 0:
            <input type="hidden" name="edition_ID" value="{{edition['ID']}}" />
        % end
    </form>
