
    <form class="user-lookup" method="post" action={{action}} onsubmit='return empty_search()'>

        <div class="lookup-search">
            <input type="text" style="width: 220px" placeholder="Start Typing a name..." id="reader_name_input" onkeyup="suggest_readers()" autocomplete="off"/>
        </div>
    
        <div class="user-lookup-element" id="lookup-search">
            <select id="reader_name_dropdown" name="reader_name_input">
                <option>Select a User</option>
            </select>
        </div>
        
        <div class="user-lookup-element">
            <input type="submit" value="{{button_text}}"/>
            % if edition_ID != 0:
                <input type="hidden" name="edition_ID" value="{{edition['ID']}}" />
            % end
        </div>

    </form>
</div>


    




