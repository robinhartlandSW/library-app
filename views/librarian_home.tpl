<html>

    <head>
        <title>Librarian Home</title>
        % include('stylesheet_link_subtemplate.tpl')
        % include('sweetalert_link_subtemplate.tpl')
        <script src="/scripts/suggest_readers.js"></script>
        <script src="/scripts/show_serial_numbers.js"></script>
        <script src="/scripts/confirm_return.js"></script>
        <script src="scripts/empty_search.js"></script>
        <script src="scripts/reserve_book_checker.js"></script>
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    </head>

    <body>

    % try:
        % reservation_added
    %except NameError:
        % reservation_added=0
    % end
    <script>
    reservation_added({{reservation_added}})
    </script>

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
                    <div id="input-box">
                        <div class="input-container">
                            <form action="/return_book_to_database" method="POST" onsubmit="confirm_return()">
                                <input type="number" placeholder="Serial No." name="serial_number" id="serial_number" required/>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <div class="column">
                <div class="home-block">
                    <div class="action-heading">USER ACCOUNTS</div><br>
                        % include('reader_info_form.tpl', action = '/reader_overview', button_text='VIEW', edition_ID=0)
                    </div>
                </div>
            </div><br>

            

        <h2 id="search_reserve">SEARCH AND RESERVE BOOKS </h2>  

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
                            {{edition['genre']}}<br/><br>
                            ISBN: {{edition['ISBN']}}<br/>
                            Copies in stock: {{edition['num_available_copies']}}<br>
                            Location: {{edition['location']}}
                        </div>               
                        <div id="num-available-copies-button">   
                            % if edition['num_available_copies'] > 0:
                                <button class="search-result-more-info-button"  onclick="show_serial_numbers({{edition['ID']}})">VIEW AVAILABLE SERIAL NOs</button>
                            % else:
                                <button class="search-result-more-info-button" onclick="window.location.href = '/show_reservation_form/{{edition['ID']}}'">RESERVE A COPY</button>
                            % end
                        </div>               
                    </div>
                </div>
            % end
            <p id="all_button_p"><a href = "/librarian_show_all"><button id = "all_button">SHOW ENTIRE LIBRARY</button></a></p>
        </body>
    
    </html>
