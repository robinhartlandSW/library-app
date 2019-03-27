<html>
    <head>
        <title>Book search</title>
        % include('stylesheet_link_subtemplate.tpl')
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <script src="scripts/show_serial_numbers.js"></script>
    </head>

    <body>
        <div id="other-view-link">
            <a href="/home">Librarian homepage</a>
        </div>
        <h1>SEARCH THE LIBRARY</h1>
        <div id="search-box">
            <div class="search-element-container">
                <form action="/search">
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
                        % if edition['num_available_copies'] > 0:
                            <button class="see-available-copies-button"  onclick="show_serial_numbers({{edition['ID']}})"> Available Copy Serial Numbers > </button>
                        % end
                    </div>               
                </div>
            </div>
        % end

    </body>

</html>