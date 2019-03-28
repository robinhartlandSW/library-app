<html>

    <head>
        <title>Register User</title>
        % include('stylesheet_link_subtemplate.tpl')
    </head>

    <body>

        <div id="other-view-link">
            <a style="text-decoration: none" href="/switch_to_borrower_view">SWITCH TO BORROWER VIEW</a>
        </div>
        <div id="home-link"><a href="/home">HOME</a></div>

        <h1>REGISTER A NEW LIBRARY USER</h1>
        <div class="block">
            <form class="add-user-form" method="POST" id="new_reader_form" action="/register_new_reader_in_database">
                FIRST NAME: <input type="text" name="first_name" id="first_name"><br>
                LAST NAME: <input type="text" name="last_name" id="last_name"><br>
                <input type="submit" value="REGISTER USER">
            </form>
            
        </div>
    </body>

</html>