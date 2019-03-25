<html>
    <head>
        <title>New reader</title>
        % include('stylesheet_link_subtemplate.tpl')
    </head>
    <body>
        <div id="other-view-link">
            <a href="/view_library">Go to book search view</a>
        </div>
        <div id="home-link">
            <a href="/home">Home</a>
        </div>
        <h1>
            Register a new reader
        </h1>
        <div class="block">
            <form class="librarian-form" method="post" action="/register_new_reader_in_database">
                <label for="first_name">First name: </label>
                <input type="text" name="first_name" id="first_name" />
                <br />
                <label for="last_name">Last name: </label>
                <input type="text" name="last_name" id="last_name" />

                
                <br />
                {access level dropdown list}
                <br /><br />
                <input type="submit" value="Add reader to library" />
            </form>
        </div>
    </body>
</html>