<html>
    <head>
        <title>Librarian homepage</title>
        <link rel="stylesheet" type="text/css" href="/static/global.css" />
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
                    <label for="reader_name_input">Find a reader:</label>
                    <input type="text" name="reader_name_input" id="reader_name_input" />
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