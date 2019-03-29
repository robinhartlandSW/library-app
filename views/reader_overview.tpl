<html>

    <head>
        <title>Account | {{reader_name}}</title>
        % include('stylesheet_link_subtemplate.tpl')
        % include('sweetalert_link_subtemplate.tpl')
        <script src="scripts/popup.js"></script>
        <script src="scripts/copy_reserved.js"></script>
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
        
        <div id="other-view-link"><a style="text-decoration: none" href="/switch_to_borrower_view">SWITCH TO BORROWER VIEW</a></div>
        <div id="home-link"><a href="/home">HOME</a></div>
        <h1 style="margin-bottom:10px">{{reader_name}}</h1>
        <div class="action-heading" style="margin-bottom: 30px;">ON LOAN: {{num_books_borrowed}}/8 &nbsp&nbsp&nbsp ID: {{ID}} &nbsp&nbsp&nbsp BALANCE: {{fine}}</div>
    
        <!--
            ID: {{ID}} <br />
            Books borrowed: {{num_books_borrowed}} of 8
            <br />
            Fines due: {{fine}}
        -->
        

        % num_fine = fine[1:]

        <div class="checkout-block">
            <div class="action-heading">CHECK OUT A BOOK</div><br>
            <form id="check_out" onsubmit = 'return check_conditions({{num_books_borrowed}}, {{num_fine}}, {{num_overdue_books}})'  action="/check_out_book" method="POST">
                <input type="hidden" id="readerID" name="readerID" value={{ID}}>
                <input type="hidden" id="current_fine" name="current_fine" value={{fine}}>
                <input type="number" class="checkout-box" id="serial_number" name="serial_number" placeholder="Serial No." required/>
                <input type="days_rented" class="checkout-box" name="days_rented" placeholder="Loan Length (Days)" required/>
                <input type="submit" value="CHECK OUT">
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

        <div class="block">
            <div class="action-heading">RESERVED BOOKS</div><br>
            <table style="width:100%" id="search-table">
                <tr>
                    <td>  </td>
                    <td> Title </td>
                    <td> Author </td>
                    <td>  </td>
                </tr>

                % for i in range(number_reservations):
                    %book = reservation_list[i]
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