<html>
    <head>
        <title>Librarian homepage</title>
        % include('stylesheet_link_subtemplate.tpl')
        <script src="/scripts/suggest_readers.js"></script>
    </head>
    <body>
        <div id="other-view-link">
            <a href="/view_library">Go to book search view</a>
        </div>
        <h1>
            Librarian Homepage
        </h1>
        <div class="container quarter-width">
            % include('reader_info_form.tpl', action = '/reader_overview', button_text='Enter account', extra_text="for loans and fines.", serial_number=0)
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