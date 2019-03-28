<html>

    <head>
        <title>Account | {{reader_name}}</title>
        % include('stylesheet_link_subtemplate.tpl')
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <script src="scripts/popup.js"></script>
    </head>

    <body>
        % try:
            % fine_added
        %except NameError:
            % fine_added=0
        % end
        <script>
        success_message_fine({{fine_added}})
        </script>
        
        <div id="other-view-link">
            <a style="text-decoration: none" href="/switch_to_borrower_view">SWITCH TO BORROWER VIEW</a>
        </div>
        <div id="home-link">
            <a href="/home">HOME</a>
        </div>
        <h1>
            Registered reader overview <br/>
        </h1>
        <h1>{{reader_name}}</h1>

        <div id="reader-info">
            ID: {{ID}} <br />
            Books borrowed: {{num_books_borrowed}} of 8
            <br />
            Fines due: {{fine}}
        </div>

        % num_fine = fine[1:-1]

        <!-- TODO: move this check-out section to librarian book search -->

        <div class="block">
            <form  id = "check_out" action="/check_out_book" method="post">
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
                <input type="submit" value="Check out" onclick = 'return check_conditions({{num_books_borrowed}}, {{num_fine}}, {{num_overdue_books}})' />
            </form>
        </div>

    
    

        <div class="row">
            <div class="column">
                <div class="home-block">
                    <div class="action-heading">ADD FINES AND CHARGES</div><br>
                    <div id="input-box">
                        <div class="input-container">
                            <form action="/reader_overview_fine" method="POST" onsubmit='return verify_fine_add()'>
                                <input type="hidden" name="user_id" value={{ID}}>
                                <input type="text" name="added_fine" placeholder="Amount (£)" id="added_fine">
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <div class="column">
                <div class="home-block">
                    <div class="action-heading">RECORD A PAYMENT</div><br>
                    <div id="input-box">
                        <div class="input-container">
                            <form action="/reader_overview_pay_fine" method="POST" onsubmit ='return verify_fine_payment()'>
                                <input type="hidden" name="user_id" value={{ID}}>
                                <input type="text" name="paid_fine" placeholder="Amount (£)" id="paid_fine">
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="block">
            <div class="action-heading">BOOKS CURRENTLY ON LOAN</div><br>
            <table style="width:100%" id="search-table">
                <tr>
                    <td> Serial Number </td>
                    <td> Title </td>
                    <td> Author </td>
                    <td> Date Due </td>
                </tr>

                % for i in range(number_results):
                    %book = book_list[i]
                    <tr>
                        <td> {{book[0]}} </td>
                        <td> {{book[1]}} </td>
                        <td> {{book[2]}} </td>
                        <td> {{book[3]}} </td>
                    </tr>
                % end
            </table>
        </div>
    </body>
</html>