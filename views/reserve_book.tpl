<html>
    <head>
        <title> Place reservation? </title>
        % include('stylesheet_link_subtemplate.tpl')
        <script src="/scripts/suggest_readers.js"></script>
    </head>
    <body>
        <h1> Place reservation? </h1>
        <div class="block">
            {{edition['title']}} by {{edition['author']}}, ISBN {{edition['ISBN']}}
        </div>
        <div>
            % include('reader_info_form.tpl', action = '/reserve_book', button_text='Reserve book', extra_text="")
        </div>
    </body>

</html>