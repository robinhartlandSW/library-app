<html>

    <head>
        <title>Add To The Library</title>
        % include('stylesheet_link_subtemplate.tpl')
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <script src="scripts/new_book.js"></script>
    </head>

    <body>
    % try:
        % success
    %except NameError:
        % success=0
    % end
    <script>
    success_message({{success}})
    </script>

    <body>

        <div id="other-view-link"><a href="/switch_to_borrower_view">SWITCH TO BORROWER VIEW</a></div>
        <div id="home-link"><a href="/home">HOME</a></div>

        <h1>ADD TO THE LIBRARY</h1>

        <div class="row" >

            <div class="column">
                <h2>NEW BOOK</h2>
                <div class="add-form">
                    <form action="/add_new_edition" method="POST" id="POST" enctype="multipart/form-data"><br>
                        TITLE: <input type="text" name="title" id="title"><br>
                        AUTHOR: <input type="text" name="author" id="author"><br>
                        GENRE: <input type="text" name="genre" id="genre"><br>
                        LOCATION: <input type="text" name="location" id="location"><br>
                        ISBN: <input type="text" name="ISBN" id="ISBN"><br>
                        COVER: <input type="file" id="cover" name="cover" accept="image/png, image/jpeg">
                        <input type="submit" value ="ADD BOOK" onclick='return check_conditions()'>
                    </form>
                </div>
            </div>

            <div class="column">
                <h2>NEW COPY</h2>
                <div class="add-form" id="add-copy-title-author">
                    <form action="/add_new_copy_by_title_author" method="POST"><br>
                        TITLE: <input type="text" name="title" id="title_1"><br>
                        AUTHOR: <input type="text" name="author" id="author"><br>
                        <input type="submit" value ="ADD COPY" onclick='return check_conditions_title()'>
                    </form>
                </div>

                <h2>NEW COPY</h2>
                <div class="add-form" id="add-copy-isbn">
                    <form action="/add_new_copy_by_ISBN" method="POST">
                        ISBN: <input type="text" name="ISBN" id="ISBN_1"><br>
                        <input type="submit" value ="ADD COPY" onclick ='return check_conditions_isbn()'>
                    </form>
                </div>
            </div>

        </div>
     
    </body>
</html>