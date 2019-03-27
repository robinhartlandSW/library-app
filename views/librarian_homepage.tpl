<html>
    <head>
        <title>Librarian Home</title>
        % include('stylesheet_link_subtemplate.tpl')
        <script src="/scripts/suggest_readers.js"></script>
    </head>
    <body>
        <div id="other-view-link">
            <a href="/view_library">Go to book search view</a>
        </div>
        <h1>LIBRARIAN HOME</h1>
        <div class="container quarter-width">
            % include('reader_info_form.tpl', action = '/reader_overview', button_text='Enter account', extra_text="for loans and fines.", serial_number=0)
        </div>
        <div class="big-button quarter-width">
                <div class="centred-block">
                    <h2>RETURN A BOOK</h2><br/><br/><br/><br>
                    <div class="serial-no-container">
                        <form action="/return_book_to_database" method="POST">
                            <input type="number" placeholder="Serial No." name="serial_number" id="serial_number">
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