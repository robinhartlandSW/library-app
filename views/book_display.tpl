<html>
    <head>
        <title>Book search</title>
        % include('stylesheet_link_subtemplate.tpl')
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
                        ISBN: {{edition['ISBN']}}
                    </div>
                    <form style="float:right" method="get" action="/available_serial_numbers">
                        <input type="hidden" name="editionID" value="{{edition['ID']}}"><br><br><br><br><br>
                        Copies in stock: {{edition['num_available_copies']}}<br>
                        <input type="submit" class="see-available-copies-button" value="Available Copy Serial Numbers >">
                    </form>
                </div>
            </div>
        % end

    </body>

</html>