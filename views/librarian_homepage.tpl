<html>
    <head>
        <title>Librarian Home</title>
        % include('stylesheet_link_subtemplate.tpl')
        <script src="scripts/suggest_readers.js"></script>
    </head>
    <body>
        <div id="other-view-link">
            <a href="/view_library">Go to book search view</a>
        </div>
        <h1>LIBRARIAN HOME</h1>
        <div class="container quarter-width">

            <div class="centred-block">
                <form class="librarian-form" method="post" action="/reader_overview">
                    <label>FIND A READER:</label>
                    <div>
                        <label for="reader_first_name_input">First name:</label>
                        <input type="text" id="reader_first_name_input" onchange="suggest_readers()" />
                    </div>
                    <div>
                        <label for="reader_last_name_input">Last name (optional):</label>
                        <input type="text" id="reader_last_name_input" />
                    </div>

                    <select id="reader_name_dropdown" name="reader_name_input">
                        <option> select one... </option>
                    </select>

                    <input type="submit" value="Enter account" />
                    for loans and fines.
                </form>
            </div>
        </div>
        <div class="big-button quarter-width">
                <div class="centred-block">
                    <h2>RETURN A BOOK</h2><br/><br/><br/><br>
                    <div class="serial-no-container">
                        <form style="width:100%" action="/return_book_to_database">
                            <input type="text" placeholder="Serial No." name="serial_number">
                        </form>
                    </div>
                </div>
        </div>
        <div class="big-button quarter-width">
            <a href="/add_new_edition">
                <div class="centred-block">
                    ADD BOOKS AND COPIES
                </div>
            </a>
        </div>
        <div class="big-button quarter-width">
            <a href="/add_new_reader">
                <div class="centred-block">
                    ADD A READER
                </div>
            </a>
        </div>
    </body>
</html>