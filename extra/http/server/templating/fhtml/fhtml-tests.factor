USING: io io.files io.streams.string io.encodings.utf8
http.server.templating.fhtml kernel tools.test sequences
parser ;
IN: http.server.templating.fhtml.tests

: test-template ( path -- ? )
    "extra/http/server/templating/fhtml/test/" swap append
    [
        ".fhtml" append resource-path
        [ run-template-file ] with-string-writer
    ] keep
    ".html" append resource-path utf8 file-contents = ;

[ t ] [ "example" test-template ] unit-test
[ t ] [ "bug" test-template ] unit-test
[ t ] [ "stack" test-template ] unit-test

[
    [ ] [ "<%\n%>" parse-template drop ] unit-test
] with-file-vocabs