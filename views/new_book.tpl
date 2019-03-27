<html>

    <head>
        <title>Add a new book</title>
        
        % include('stylesheet_link_subtemplate.tpl')
    </head>

    <body>

        <div id="other-view-link"><a href="/view_library">Go to book search view</a></div>
        <div id="home-link"><a href="/home">Home</a></div>
        <h1>ADD TO THE LIBRARY</h1>
        
        <div class="side-by-side">
        <div class="add-form">
            <h2>ADD A NEW BOOK</h2>
            <form action="/add_new_edition" method="POST"><br>
                TITLE: <input type="text" name="title"><br>
                AUTHOR: <input type="text" name="author"><br>
                GENRE: <input type="text" name="genre"><br>
                ISBN: <input type="text" name="ISBN"><br>
                <input type="submit" value ="ADD BOOK">
            </form>
        </div>

        <div class="add-form">
            <h2>ADD ADDITIONAL COPIES</h2>
            <form action="/add_new_copy_by_title_author" method="POST"><br>
                TITLE: <input type="text" name="title"><br>
                AUTHOR: <input type="text" name="author"><br>
                <input type="submit" value ="ADD COPY"><br><br><br>
            </form>
            <form action="/add_new_copy_by_ISBN" method="POST">
                ISBN: <input type="text" name="ISBN"><br>
                <input type="submit" value ="ADD COPY">
            </form>
        </div>
     
    </body>
</html>