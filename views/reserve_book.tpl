<html>
    <head>
        <title> Place reservation? </title>
        % include('stylesheet_link_subtemplate.tpl')
        <script src="/scripts/suggest_readers.js"></script>
        <script src="/scripts/reserve_book_checker.js"></script>
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <script src="/scripts/empty_search.js"></script>
    </head>
    <body>
        <h1> Place reservation? </h1>
        <div class="block">
            {{edition['title']}} by {{edition['author']}}, ISBN {{edition['ISBN']}}
        </div>
        <div>
            % include('reader_info_form.tpl', action = '/reserve_book', button_text='Reserve book', extra_text="", edition_ID = edition['ID'])
        </div>
    </body>

</html>