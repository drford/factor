! Copyright (C) 2007, 2008 Doug Coleman, Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: alien alien.c-types arrays destructors io io.windows libc
windows.types math windows.kernel32 windows namespaces kernel
sequences windows.errors assocs math.parser system random
combinators accessors ;
IN: io.windows.nt.pipes

! This code is based on
! http://twistedmatrix.com/trac/browser/trunk/twisted/internet/iocpreactor/process.py

: create-named-pipe ( name mode -- handle )
    FILE_FLAG_OVERLAPPED bitor
    PIPE_TYPE_BYTE
    1
    4096
    4096
    0
    security-attributes-inherit
    CreateNamedPipe
    dup win32-error=0/f
    dup add-completion ;

: open-other-end ( name mode -- handle )
    FILE_SHARE_READ FILE_SHARE_WRITE bitor
    security-attributes-inherit
    OPEN_EXISTING
    FILE_FLAG_OVERLAPPED
    f
    CreateFile
    dup win32-error=0/f
    dup add-completion ;

TUPLE: pipe in out ;

: <pipe> ( name in-mode out-mode -- pipe )
    [
        >r over >r create-named-pipe dup close-later
        r> r> open-other-end dup close-later
        pipe construct-boa
    ] with-destructors ;

: close-pipe ( pipe -- )
    dup
    in>> CloseHandle drop
    out>> CloseHandle drop ;

: <incoming-pipe> ( name -- pipe )
    PIPE_ACCESS_INBOUND GENERIC_WRITE <pipe> ;

: <outgoing-pipe> ( name -- pipe )
    PIPE_ACCESS_DUPLEX GENERIC_READ <pipe> ;

: unique-pipe-name ( -- string )
    [
        "\\\\.\\pipe\\factor-" %
        pipe counter #
        "-" %
        32 random-bits #
        "-" %
        millis #
    ] "" make ;

: <unique-incoming-pipe> ( -- pipe )
    unique-pipe-name <incoming-pipe> ;

: <unique-outgoing-pipe> ( -- pipe )
    unique-pipe-name <outgoing-pipe> ;

! /dev/null simulation
: null-input ( -- pipe )
    <unique-outgoing-pipe>
    dup out>> CloseHandle drop
    in>> ;

: null-output ( -- pipe )
    <unique-incoming-pipe>
    dup in>> CloseHandle drop
    out>> ;

: null-pipe ( mode -- pipe )
    {
        { [ dup GENERIC_READ = ] [ drop null-input ] }
        { [ dup GENERIC_WRITE = ] [ drop null-output ] }
    } cond ;
