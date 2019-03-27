<html>
    <head>
        <title>Book search</title>
        % include('stylesheet_link_subtemplate.tpl')
    </head>

    <body>
        <div id="other-view-link">
            <a style="text-decoration: none" href="/switch_to_librarian_view">SWITCH TO LIBRARIAN VIEW</a>
        </div>
        <h1>SEARCH THE LIBRARY</h1>
        <div id="search-box">
            <div class="search-element-container">
                <form action="/borrower_search">
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
                        ISBN: {{edition['ISBN']}}<br/><br><br><br><br><br><br> <!--TODO: no <br>s -->
                        {{edition['num_available_copies']}}<br>
                    </div>
                </div>
            </div>
        % end

    </body>

</html>