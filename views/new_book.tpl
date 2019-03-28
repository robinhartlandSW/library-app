<html>

    <head>
        <title>Add a new book</title>
        
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
        <div id="other-view-link">
            <a style="text-decoration: none" href="/switch_to_borrower_view">SWITCH TO BORROWER VIEW</a>
        </div>
        <div id="home-link"><a href="/home">Home</a></div>
        <h1>ADD TO THE LIBRARY</h1>
        
        <div class="side-by-side">
        <div class="add-form">
            <h2>ADD A NEW BOOK</h2>
            <form action="/add_new_edition" method="POST" id="POST"><br>
                TITLE: <input type="text" name="title" id="title"><br>
                AUTHOR: <input type="text" name="author" id="author"><br>
                GENRE: <input type="text" name="genre" id="genre"><br>
                ISBN: <input type="text" name="ISBN" id="ISBN"><br>
                <input type="submit" value ="ADD BOOK" onclick='return check_conditions()'>
            </form>
        </div>

        <div class="add-form">
            <h2>ADD ADDITIONAL COPIES</h2>
            <form action="/add_new_copy_by_title_author" method="POST"><br>
                TITLE: <input type="text" name="title" id="title_1"><br>
                AUTHOR: <input type="text" name="author" id="author"><br>
                <input type="submit" value ="ADD COPY" onclick='return check_conditions_title()'><br><br><br>
            </form>
            <form action="/add_new_copy_by_ISBN" method="POST">
                ISBN: <input type="text" name="ISBN" id="ISBN_1"><br>
                <input type="submit" value ="ADD COPY" onclick ='return check_conditions_isbn()'>
            </form>
        </div>
     
    </body>
</html>