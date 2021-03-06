! Copyright (C) 2007 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: io.files io.launcher io.styles io hashtables kernel
sequences sequences.lib assocs system sorting math.parser ;
IN: contributors

: changelog ( -- authors )
    image parent-directory [
        "git-log --pretty=format:%an" <process-stream> lines
    ] with-directory ;

: patch-counts ( authors -- assoc )
    dup prune
    [ dup rot [ = ] with count ] with
    { } map>assoc ;

: contributors ( -- )
    changelog patch-counts sort-values <reversed>
    standard-table-style [
        [
            [
                first2 swap
                [ write ] with-cell
                [ number>string write ] with-cell
            ] with-row
        ] each
    ] tabular-output ;

MAIN: contributors
