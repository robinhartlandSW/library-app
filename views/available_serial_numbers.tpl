<html>
    <head>
        <title>Serial numbers for {{title}}</title>
        % include('stylesheet_link_subtemplate.tpl')
    </head>
    <body>
        <div id="other-view-link">
            <a href="/home">Librarian homepage</a>
        </div>
        <div id="home-link">
            <a href="/view_library">Back to search</a>
        </div>
        <h1>
            Available serial numbers for {{title}}
        </h1>
        <div class="block">
            <h2>Available serial numbers are:</h2>
            <ul>
                % for num in serial_numbers:
                    <li>
                        {{num}}
                    </li>
                % end
            </ul>
        </div>
    </body>
</html>