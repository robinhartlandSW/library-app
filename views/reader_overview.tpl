<html>
    <head>
        <title>Reader overview</title>
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
            Registered reader overview <br/>
            {{page_head_message}}
        </h1>
        <div id="reader-info">
            <h2>{{reader_name}}</h2>
            ID: {{ID}} <br />
            Books borrowed: {{num_books_borrowed}} of 8
            <br />
            Fines due: {{fine}}
        </div>
        <div class="block">
            <form action="/check_out_book" method="post">
                
                <!-- hidden field to store user's ID -->
                <input type="hidden" id="readerID" name="readerID" value = {{ID}} />

                <h2> Check out a book </h2>
                <div class = "book-details-block">
                    <div class="container book-details-area">
                        <div class="user-input-area">
                            <div class="label-input-wrapper">
                                <label for="author_input">Author name:</label>
                                <input type="text" id="author_input" name="author" class="input-box"/>
                                <input type="hidden" id="current_fine" name="current_fine" value={{fine}}>
                            </div>
                            <div class="label-input-wrapper">
                                <label for="title_input">Title:</label>
                                <input type="text" id="title_input" name="title" class="input-box"/>
                            </div>
                        </div>
                        <div class="user-input-area">
                            <div class="serial-number-input-wrapper">
                                <label for="serial_number" id="serial_number_label"> Serial number: </label>
                                <input name="serial_number" id="serial_number" type = "number" class="input-box" required/>
                            </div>
                            <div class="serial-number-input-wrapper">
                                <label for="days_rented">Days Rented:</label><br/>
                                <input name="days_rented" id="ISBN_input" type = "number" class="input-box" required/>
                            </div>
                        </div>
                    </div>
                
                    <div id="or-area" class = "container"> 
                        or
                    </div>

                    <div class="container book-details-area">
                        <div class="user-input-area label-input-wrapper">
                            <label for="ISBN_input">ISBN:</label>
                            <input type="text" id="ISBN_input" name="ISBN" class="input-box"/>
                        </div>
                    </div>
                </div>


                <input type="submit" value="Check out" />


            </form>
        </div>
        <div class="container half-width">
            <div class="block user-input-area">
                <h2> Add charges/fines </h2>
                <form action ="/reader_overview/fine" method="post">
                    <input type="hidden" name="user_id" value={{ID}}>
                    Amount (£): <input type="text" name="added_fine"><br>
                    <input type="submit" value="Submit">
                </form>
            </div>
        </div>
        <div class="container half-width">
            <div class="block">
                <div class = "user-input-area">
                    <h2> Record payment </h2>
                    <form action ="/reader_overview/pay_fine" method="post">
                        <input type="hidden" name="user_id" value={{ID}}>
                        Amount (£): <input type="text" name="paid_fine"><br>
                    <input type="submit" value="Submit">
                </form>
                </div>
            </div>
        </div>
    </body>
</html>