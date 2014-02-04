USING: alien alien.syntax combinators kernel parser sequences
system words namespaces hashtables init math arrays assocs
continuations ;
IN: opengl.gl.extensions

ERROR: unknown-gl-platform ;
<< {
    { [ os windows? ] [ "opengl.gl.windows" ] }
    { [ os macosx? ]  [ "opengl.gl.macosx" ] }
    { [ os unix? ] [ "opengl.gl.unix" ] }
    [ unknown-gl-platform ]
} cond use+ >>

SYMBOL: +gl-function-number-counter+
SYMBOL: +gl-function-pointers+

: reset-gl-function-number-counter ( -- )
    0 +gl-function-number-counter+ set-global ;
: reset-gl-function-pointers ( -- )
    100 <hashtable> +gl-function-pointers+ set-global ;

[ reset-gl-function-pointers ] "opengl.gl" add-init-hook
reset-gl-function-pointers
reset-gl-function-number-counter

: gl-function-number ( -- n )
    +gl-function-number-counter+ get-global
    dup 1+ +gl-function-number-counter+ set-global ;

: gl-function-pointer ( names n -- funptr )
    gl-function-context 2array dup +gl-function-pointers+ get-global at
    [ 2nip ] [
        >r [ gl-function-address ] map [ ] find nip
        dup [ "OpenGL function not available" throw ] unless
        dup r>
        +gl-function-pointers+ get-global set-at
    ] if* ;

: GL-FUNCTION:
    gl-function-calling-convention
    scan
    scan dup
    scan drop "}" parse-tokens swap prefix
    gl-function-number
    [ gl-function-pointer ] 2curry swap
    ";" parse-tokens [ "()" subseq? not ] subset
    define-indirect
    ; parsing
