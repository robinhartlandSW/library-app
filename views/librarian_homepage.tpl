<html>
    <head>
        <title>Librarian homepage</title>
        % include('stylesheet_link_subtemplate.tpl')
        <script src="scripts/suggest_readers.js"></script>
    </head>
    <body>
        <div id="other-view-link">
            <a href="/view_library">Go to book search view</a>
        </div>
        <h1>
            Librarian Homepage
        </h1>
        <div class="container quarter-width">

            <div class="centred-block">
                <form class="librarian-form" method="post" action="/reader_overview">
                    <label>Find a reader:</label>
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
            <a href="/return_book">
                <div class="centred-block">
                    Return a book
                </div>
            </a>
        </div>
        <div class="big-button quarter-width">
            <a href="/add_new_edition">
                <div class="centred-block">
                    Add a new book
                </div>
            </a>
        </div>
        <div class="big-button quarter-width">
            <a href="/add_new_reader">
                <div class="centred-block">
                    Add a new reader
                </div>
            </a>
        </div>
    </body>
</html>