! Copyright (C) 2008 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences namespaces words assocs logging sorting
prettyprint io io.styles strings logging.parser ;
IN: logging.analysis

SYMBOL: word-names
SYMBOL: errors
SYMBOL: word-histogram
SYMBOL: message-histogram

: analyze-entry ( entry -- )
    dup second ERROR eq? [ dup errors get push ] when
    dup second CRITICAL eq? [ dup errors get push ] when
    1 over third word-histogram get at+
    dup third word-names get member? [
        1 over 1 tail message-histogram get at+
    ] when
    drop ;

: analyze-entries ( entries word-names -- errors word-histogram message-histogram )
    [
        word-names set
        V{ } clone errors set
        H{ } clone word-histogram set
        H{ } clone message-histogram set

        [
            analyze-entry
        ] each

        errors get
        word-histogram get
        message-histogram get
    ] with-scope ;

: histogram. ( assoc quot -- )
    standard-table-style [
        >r >alist sort-values <reversed> r> [
            [ >r swap r> with-cell pprint-cell ] with-row
        ] curry assoc-each
    ] tabular-output ;

: log-entry.
    [
        dup first [ write ] with-cell
        dup second [ pprint ] with-cell
        dup third [ write ] with-cell
        fourth "\n" join [ write ] with-cell
    ] with-row ;

: errors. ( errors -- )
    standard-table-style
    [ [ log-entry. ] each ] tabular-output ;

: analysis. ( errors word-histogram message-histogram -- )
    "==== INTERESTING MESSAGES:" print nl
    "Total: " write dup values sum . nl
    [
        dup second write ": " write third "\n" join write
    ] histogram.
    nl
    "==== WORDS:" print nl
    [ write ] histogram.
    nl
    "==== ERRORS:" print nl
    errors. ;

: analyze-log ( lines word-names -- )
    >r parse-log r> analyze-entries analysis. ;