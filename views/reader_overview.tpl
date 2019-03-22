<html>
    <head>
        <title>Reader overview</title>
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
            Registered reader overview
        </h1>
        <div id="reader-info">
            <h2>{{reader_name}}</h2>
            ID: {{ID}} <br />
            Books borrowed: 5 of 8
            <br />
            Fines due: £0.58
        </div>
        <div class="block">
            <form action="/check_out_book" method="post">
                
                <!-- hidden field to store user's ID -->
                <input type="hidden" id="readerID" name="readerID" value = {{ID}} />

                <h2> Check out a book </h2>
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
                <input type="submit" value="Check out" />


            </form>
        </div>
        <div class="container half-width">
            <div class="block user-input-area">
                <h2> Add charges/fines </h2>
                Amount: £3.00
                <br /> <br />
                <button>add charge</button>
            </div>
        </div>
        <div class="container half-width">
            <div class="block">
                <div class = "user-input-area">
                    <h2> Record payment </h2>
                    Amount: £0.50
                    <br /> <br />
                    <button>Record payment</button>
                </div>
            </div>
        </div>
    </body>
</html>