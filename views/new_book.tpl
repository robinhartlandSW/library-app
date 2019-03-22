<html>
    <head>
        <title>Add a new book</title>
        
        <link rel="stylesheet" type="text/css" href="/static/global.css" />
    </head>
    <body>
        <div id="other-view-link">
            <a href="/view_library">Go to book search view</a>
        </div>
        <div id="home-link">
            <a href="/home">Home</a>
        </div>
        <h1>
            Add a new book
        </h1>

        <div class="block">
            <form action="/add_new_edition_to_database" method="POST">
                <h2> Book details: </h2>
                <div class="container book-details-area">
                    <div class="user-input-area">
                        <label for="author_input">Author name:</label>
                        <input type="text" id="author_input" name="author" class="input-box"/>

                            <br /> <br />

                        <label for="title_input">Title:</label>
                        <input type="text" id="title_input" name="title" class="input-box"/>
                    </div>
                </div>
                <div id="or-area" class = "container"> 
                    or
                </div>
                <div class="container book-details-area">
                    <div class="user-input-area">
                        <label for="ISBN_input">ISBN:</label>
                        <input type="text" id="ISBN_input" name="ISBN" class="input-box"/>
                    </div>
                </div>
                
                <br /> <br />
                <br />
                <button type="submit">Search/register</button>
            </form>
        </div>
    </body>
</html>