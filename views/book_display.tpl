<html>
    <head>
        <title>Book search</title>
        <link rel="stylesheet" type="text/css" href="/static/global.css" />
    </head>
    <body>
            <div id="other-view-link">
                <a href="/home">Librarian homepage</a>
            </div>
            <h1>
                Book search
            </h1>
            <div id="search-box">
                <div class="search-element-container">
                    {keyword search box}
                </div> 

                <div class="search-element-container">
                    {dropdown menu to choose what to search}
                </div>
                <div  class="search-element-container button-container">
                    <button>
                        Search
                    </button>
                </div>
            </div>
            % for edition in editions:
            <div class="block">
                {{edition['title']}} <br />
                {{edition['author']}}    <br />
                ISBN: {{edition['ISBN']}} <br />
                <div>
                    Copies in stock: {{edition['num_available_copies']}}
                    <button class="see-available-copies-button"> see serial numbers of available copies...</button>
                </div>
            </div>
            % end


    </body>
</html>