<html>

    <head>
        <title>Librarian Home</title>
        % include('stylesheet_link_subtemplate.tpl')
        % include('sweetalert_link_subtemplate.tpl')
        <script src="/scripts/suggest_readers.js"></script>
        <script src="/scripts/show_serial_numbers.js"></script>
    </head>

    <body>
        <div id="other-view-link">
            <a href="/switch_to_borrower_view">SWITCH TO BORROWER VIEW</a>
        </div>

        <h1>LIBRARIAN HOME</h1>

        <div class="row">
            <div class="column">
                <a href="/add_new_edition">
                    <div class="home-block" id="big-button">
                        <div class="action-heading">ADD TO THE LIBRARY</div>
                    </div>
                </a>
            </div>

            <div class="column">
                <a href="/add_new_reader">
                    <div class="home-block" id="big-button">
                        <div class="action-heading">ONBOARD A USER</div>
                    </div>
                </a>
            </div>
        </div>

        <div class="row">
            <div class="column">
                <div class="home-block">
                    <div class="action-heading">LOG A RETURN</div><br>
                    <div id="serial-box">
                        <div class="serial-no-container">
                            <form action="/return_book_to_database" method="POST">
                                <input type="number" placeholder="Serial No." name="serial_number" id="serial_number">
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <div class="column">
                <div class="home-block">
                    <div class="action-heading">USER ACCOUNTS</div>                       
                        % include('reader_info_form.tpl', action = '/reader_overview', button_text='Enter account', extra_text="for loans and fines.", edition_ID=0)
                    </div>
                </div>
            </div><br>

        <h2>CHECK OUT AND RESERVE BOOKS</h2>

            <div id="search-box">
                <div class="search-element-container">
                    <form action="/librarian_search">
                        <input type="text" placeholder="Search..." name="phrase">
                    </form>
                </div> 
            </div>
    
            % for edition in editions:
                <div class="block">
                    <div class="book-cover"><img src="/img/{{edition['ISBN']}}.jpg" onerror="this.src='img/placeholder.jpg';"></div>
                    <div class="book-info">
                        <div class="title-text">{{edition['title']}}</div>
                        <div class="info-text">
                            {{edition['author']}}<br/>
                            {{edition['genre']}}<br/>
                            ISBN: {{edition['ISBN']}}
                        </div>               
                        <div id="num-available-copies-button">   
                            Copies in stock: {{edition['num_available_copies']}}<br>
                            Location: {{edition['location']}}
                            % if edition['num_available_copies'] > 0:
                                <button class="search-result-more-info-button"  onclick="show_serial_numbers({{edition['ID']}})"> See serial numbers of available copies > </button>
                            % else:
                                <button class="search-result-more-info-button" onclick="window.location.href = '/show_reservation_form/{{edition['ID']}}'"> Reserve a copy > </button>
                            % end
                        </div>               
                    </div>
                </div>
            % end
    
        </body>
    
    </html>
