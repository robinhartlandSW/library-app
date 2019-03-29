<html>

    <head>
        <title>Reserve a Book</title>
        % include('stylesheet_link_subtemplate.tpl')
        <script src="/scripts/suggest_readers.js"></script>
        <script src="/scripts/reserve_book_checker.js"></script>
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <script src="/scripts/empty_search.js"></script>
    </head>

    <body>
        <div id="other-view-link"><a href="/switch_to_borrower_view">SWITCH TO BORROWER VIEW</a></div>
        <div id="home-link"><a href="/home">HOME</a></div>
        <h1>RESERVE THIS BOOK </h1>

        <div class="reserve-block">
            <div style="font-weight:bold">{{edition['title']}} by {{edition['author']}} <br> ISBN {{edition['ISBN']}} <br><br></div>
            % include('reader_info_form.tpl', action = '/reserve_book', button_text='Reserve book', extra_text="", edition_ID = edition['ID'])
        </div>
    </body>

</html>