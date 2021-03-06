IN: http.server.auth.providers.assoc.tests
USING: http.server.auth.providers 
http.server.auth.providers.assoc tools.test
namespaces accessors kernel ;

<users-in-memory> "provider" set

[ t ] [
    <user>
        "slava" >>username
        "foobar" >>password
        "slava@factorcode.org" >>email
    "provider" get new-user
    username>> "slava" =
] unit-test

[ f ] [
    <user>
        "slava" >>username
    "provider" get new-user
] unit-test

[ f ] [ "fdasf" "slava" "provider" get check-login >boolean ] unit-test

[ ] [ "foobar" "slava" "provider" get check-login "user" set ] unit-test

[ t ] [ "user" get >boolean ] unit-test

[ ] [ "user" get "fdasf" set-password drop ] unit-test

[ t ] [ "fdasf" "slava" "provider" get check-login >boolean ] unit-test

[ f ] [ "foobar" "slava" "provider" get check-login >boolean ] unit-test
