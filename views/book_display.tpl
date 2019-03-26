<html>
    <head>
        <title>Book search</title>
        % include('stylesheet_link_subtemplate.tpl')
    </head>
    <body>
            <div id="other-view-link">
                <a href="/home">Librarian homepage</a>
            </div>
            <h1>
                Search For Books
            </h1>
            <div id="search-box">

                <div class="search-element-container">
                    <form action="/search">
                        <input type="text" placeholder="Search..." name="phrase">
                    </form>
                </div> 

            </div>

            % for edition in editions:
            <div class="block">
                {{edition['title']}} <br />
                {{edition['author']}}    <br />
                ISBN: {{edition['ISBN']}} <br />
                <form method="get" action="/available_serial_numbers">
                    <input type="hidden" name="editionID" value="{{edition['ID']}}">
                    Copies in stock: {{edition['num_available_copies']}}
                    <input type="submit" class="see-available-copies-button" value="see serial numbers of available copies...">
                </form>
            </div>
            % end


    </body>
</html>