! Copyright (C) 2003, 2008 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: arrays vectors kernel kernel.private sequences
namespaces math splitting sorting quotations assocs
combinators accessors ;
IN: continuations

SYMBOL: error
SYMBOL: error-continuation
SYMBOL: error-thread
SYMBOL: restarts

<PRIVATE

: catchstack* ( -- catchstack )
    1 getenv { vector } declare ; inline

: >c ( continuation -- ) catchstack* push ;

: c> ( -- continuation ) catchstack* pop ;

: dummy ( -- obj )
    #! Optimizing compiler assumes stack won't be messed with
    #! in-transit. To ensure that a value is actually reified
    #! on the stack, we put it in a non-inline word together
    #! with a declaration.
    f { object } declare ;

: init-catchstack V{ } clone 1 setenv ;

PRIVATE>

: catchstack ( -- catchstack ) catchstack* clone ; inline

: set-catchstack ( catchstack -- ) >vector 1 setenv ; inline

TUPLE: continuation data call retain name catch ;

C: <continuation> continuation

: continuation ( -- continuation )
    datastack callstack retainstack namestack catchstack
    <continuation> ;

: >continuation< ( continuation -- data call retain name catch )
    {
        [ data>>   ]
        [ call>>   ]
        [ retain>> ]
        [ name>>   ]
        [ catch>>  ]
    } cleave ;

: ifcc ( capture restore -- )
    #! After continuation is being captured, the stacks looks
    #! like:
    #! ( f continuation r:capture r:restore )
    #! so the 'capture' branch is taken.
    #!
    #! Note that the continuation itself is not captured as part
    #! of the datastack.
    #!
    #! BUT...
    #!
    #! After the continuation is resumed, (continue-with) pushes
    #! the given value together with f,
    #! so now, the stacks looks like:
    #! ( value f r:capture r:restore )
    #! Execution begins right after the call to 'continuation'.
    #! The 'restore' branch is taken.
    >r >r dummy continuation r> r> ?if ; inline

: callcc0 ( quot -- ) [ drop ] ifcc ; inline

: callcc1 ( quot -- obj ) [ ] ifcc ; inline

<PRIVATE

: (continue) ( continuation -- )
    >continuation<
    set-catchstack
    set-namestack
    set-retainstack
    >r set-datastack r>
    set-callstack ;

: (continue-with) ( obj continuation -- )
    swap 4 setenv
    >continuation<
    set-catchstack
    set-namestack
    set-retainstack
    >r set-datastack drop 4 getenv f 4 setenv f r>
    set-callstack ;

PRIVATE>

: continue-with ( obj continuation -- )
    [ (continue-with) ] 2 (throw) ;

: continue ( continuation -- )
    f swap continue-with ;

GENERIC: compute-restarts ( error -- seq )

<PRIVATE

: save-error ( error -- )
    dup error set-global
    compute-restarts restarts set-global ;

PRIVATE>

SYMBOL: thread-error-hook

: rethrow ( error -- * )
    dup save-error
    catchstack* empty? [
        thread-error-hook get-global
        [ 1 (throw) ] [ die ] if*
    ] when
    c> continue-with ;

: recover ( try recovery -- )
    >r [ swap >c call c> drop ] curry r> ifcc ; inline

: ignore-errors ( quot -- )
    [ drop ] recover ; inline

: cleanup ( try cleanup-always cleanup-error -- )
    over >r compose [ dip rethrow ] curry
    recover r> call ; inline

: attempt-all ( seq quot -- obj )
    [
        [ [ , f ] compose [ , drop t ] recover ] curry all?
    ] { } make peek swap [ rethrow ] when ; inline

GENERIC: dispose ( object -- )

: with-disposal ( object quot -- )
    over [ dispose ] curry [ ] cleanup ; inline

TUPLE: condition error restarts continuation ;

C: <condition> condition ( error restarts cc -- condition )

: throw-restarts ( error restarts -- restart )
    [ <condition> throw ] callcc1 2nip ;

: rethrow-restarts ( error restarts -- restart )
    [ <condition> rethrow ] callcc1 2nip ;

TUPLE: restart name obj continuation ;

C: <restart> restart

: restart ( restart -- )
    [ obj>> ] [ continuation>> ] bi continue-with ;

M: object compute-restarts drop { } ;

M: condition compute-restarts
    [ error>> compute-restarts ]
    [
        [ restarts>> ]
        [ condition-continuation [ <restart> ] curry ] bi
        { } assoc>map
    ] bi append ;
