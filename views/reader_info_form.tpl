
<form class="librarian-form" method="post" action={{action}}>
    <div>
        <input type="text" placeholder="Name" id="reader_name_input" onkeydown="suggest_readers()" autocomplete="off"/>
    </div>

        <select id="reader_name_dropdown" name="reader_name_input">
            <option> Type a name above...</option>
        </select>

        <input type="submit" value="{{button_text}}" />
        % if edition_ID != 0:
            <input type="hidden" name="edition_ID" value="{{edition['ID']}}" />
        % end
    </form>
