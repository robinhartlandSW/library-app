<html>
    <head>
        <title>Return a book</title>
        
        % include('stylesheet_link_subtemplate.tpl')
    </head>
    <body>
        <div id="other-view-link">
            <a href="/view_library">Go to book search view</a>
        </div>
        <div id="home-link">
            <a href="/home">Home</a>
        </div>
        <h1>
            Return a book
        </h1>
        <div class="block">
                <form action="/return_book_to_database" method="post">
                    
                    <h2> Return a book </h2>
                    <div class = "book-details-block">
                        <div class="container book-details-area">
                            <div class="user-input-area">
                                <label for="author_input">Author name:</label>
                                <input type="text" id="author_input" name="author" class="input-box"/>
    
                                    <br /> <br />
    
                                <label for="title_input">Title:</label>
                                <input type="text" id="title_input" name="title" class="input-box"/>
                            </div>
                            <br /><br /><br />
                            <div>
                                <label for="serial_number" id="serial_number_label"> Serial number: </label>
                                <input name="serial_number" id="serial_number" type = "number" class="input-box" required/>
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
                    </div>
                    <br /> <br />
                    
                    <br />
                    <input type="submit" value="Return book" />
    
    
                </form>
            </div>
    </body>
</html>