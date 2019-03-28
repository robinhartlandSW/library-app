<html>

    <head>
        <title>Account | {{reader_name}}</title>
        % include('stylesheet_link_subtemplate.tpl')
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <script src="scripts/popup.js"></script>
    </head>

    <body>

        <div id="other-view-link"><a href="/switch_to_borrower_view">SWITCH TO BORROWER VIEW</a></div>
        <div id="home-link"><a href="/home">HOME</a></div>

        <h1>{{reader_name}}</h1>
        <h2>{{page_head_message}}</h2>

        <div id="reader-info">
            ID: {{ID}} <br />
            Books borrowed: {{num_books_borrowed}} of 8
            <br />
            Fines due: {{fine}}
        </div>

        % num_fine = fine[1:-1]

        <div class="checkout-block">
            <div class="action-heading">CHECK OUT A BOOK</div><br>
            <form id="check_out" action="/check_out_book" method="POST">
                <input type="hidden" id="readerID" name="readerID" value={{ID}}/>
                <input type="hidden" id="current_fine" name="current_fine" value={{fine}}>
                <input type="number" id="checkout-box" name="serial_number" placeholder="Serial No." required/>
                <input type="days_rented" id="checkout-box" name="days_rented" placeholder="Loan Length (Days)"/>
                <input type="submit" value="CHECK OUT" onclick='return check_conditions({{num_books_borrowed}}, {{num_fine}}, {{num_overdue_books}})'/>
            </form>
        </div>

        <div class="row">
            <div class="column">
                <div class="home-block">
                    <div class="action-heading">ADD FINES AND CHARGES</div><br>
                    <div id="input-box">
                        <div class="input-container">
                            <form action="/reader_overview/fine" method="POST">
                                <input type="hidden" name="user_id" value={{ID}}>
                                <input type="text" name="added_fine" placeholder="Amount (£)">
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
                            <form action="/reader_overview/pay_fine" method="POST">
                                <input type="hidden" name="user_id" value={{ID}}>
                                <input type="text" name="paid_fine" placeholder="Amount (£)">
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