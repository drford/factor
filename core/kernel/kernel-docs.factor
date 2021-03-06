USING: generic help.markup help.syntax math memory
namespaces sequences kernel.private layouts sorting classes
kernel.private vectors combinators quotations strings words
assocs arrays ;
IN: kernel

ARTICLE: "shuffle-words" "Shuffle words"
"Shuffle words rearrange items at the top of the data stack. They control the flow of data between words that perform actions."
$nl
"The " { $link "cleave-combinators" } " and " { $link "spread-combinators" } " are closely related to shuffle words and should be used instead where possible because they can result in clearer code; also, see the advice in " { $link "cookbook-philosophy" } "."
$nl
"Removing stack elements:"
{ $subsection drop }
{ $subsection 2drop }
{ $subsection 3drop }
{ $subsection nip }
{ $subsection 2nip }
"Duplicating stack elements:"
{ $subsection dup }
{ $subsection 2dup }
{ $subsection 3dup }
{ $subsection dupd }
{ $subsection over }
{ $subsection 2over }
{ $subsection pick }
{ $subsection tuck }
"Permuting stack elements:"
{ $subsection swap }
{ $subsection swapd }
{ $subsection rot }
{ $subsection -rot }
{ $subsection spin }
{ $subsection roll }
{ $subsection -roll }
"Sometimes an additional storage area is needed to hold objects. The " { $emphasis "retain stack" } " is an auxilliary stack for this purpose. Objects can be moved between the data and retain stacks using the following two words:"
{ $subsection >r }
{ $subsection r> }
"The top of the data stack is ``hidden'' between " { $link >r } " and " { $link r> } ":"
{ $example "1 2 3 >r .s r>" "1\n2" }
"Words must not leave objects on the retain stack, nor expect values to be there on entry. The retain stack is for local storage within a word only, and occurrences of " { $link >r } " and " { $link r> } " must be balanced inside a single quotation. One exception is the following trick involving " { $link if } "; values may be pushed on the retain stack before the condition value is computed, as long as both branches of the " { $link if } " pop the values off the retain stack before returning:"
{ $code
    ": foo ( m ? n -- m+n/n )"
    "    >r [ r> + ] [ drop r> ] if ; ! This is OK"
} ;

ARTICLE: "cleave-shuffle-equivalence" "Expressing shuffle words with cleave combinators"
"Cleave combinators are defined in terms of shuffle words, and mappings from certain shuffle idioms to cleave combinators are discussed in the documentation for " { $link bi } ", " { $link 2bi } ", " { $link 3bi } ", " { $link tri } ", " { $link 2tri } " and " { $link 3tri } "."
$nl
"Certain shuffle words can also be expressed in terms of the cleave combinators. Internalizing such identities can help with understanding and writing code using cleave combinators:"
{ $code
    ": keep  [ ] bi ;"
    ": 2keep [ ] 2bi ;"
    ": 3keep [ ] 3bi ;"
    ""
    ": dup   [ ] [ ] bi ;"
    ": 2dup  [ ] [ ] 2bi ;"
    ": 3dup  [ ] [ ] 3bi ;"
    ""
    ": tuck  [ nip ] [ ] 2bi ;"
    ": swap  [ nip ] [ drop ] 2bi ;"
    ""
    ": over  [ ] [ drop ] 2bi ;"
    ": pick  [ ] [ 2drop ] 3bi ;"
    ": 2over [ ] [ drop ] 3bi ;"
} ;

ARTICLE: "cleave-combinators" "Cleave combinators"
"The cleave combinators apply multiple quotations to a single value."
$nl
"Two quotations:"
{ $subsection bi }
{ $subsection 2bi }
{ $subsection 3bi }
"Three quotations:"
{ $subsection tri }
{ $subsection 2tri }
{ $subsection 3tri }
"Technically, the cleave combinators are redundant because they can be simulated using shuffle words and other combinators, and in addition, they do not reduce token counts by much, if at all. However, they can make code more readable by expressing intention and exploiting any inherent symmetry. For example, a piece of code which performs three operations on the top of the stack can be written in one of two ways:"
{ $code
    "! First alternative; uses keep"
    "[ 1 + ] keep"
    "[ 1 - ] keep"
    "2 *"
    "! Second alternative: uses tri"
    "[ 1 + ]"
    "[ 1 - ]"
    "[ 2 * ] tri"
}
"The latter is more aesthetically pleasing than the former."
$nl
"A generalization of the above combinators to any number of quotations can be found in " { $link "combinators" } "."
{ $subsection "cleave-shuffle-equivalence" } ;

ARTICLE: "spread-shuffle-equivalence" "Expressing shuffle words with spread combinators"
"Spread combinators are defined in terms of shuffle words, and mappings from certain shuffle idioms to spread combinators are discussed in the documentation for " { $link bi* } ", " { $link 2bi* } ", and " { $link tri* } "."
$nl
"Certain shuffle words can also be expressed in terms of the spread combinators. Internalizing such identities can help with understanding and writing code using spread combinators:"
{ $code
    ": dip   [ ] bi* ;"
    ""
    ": slip  [ call ] [ ] bi* ;"
    ": 2slip [ call ] [ ] [ ] tri* ;"
    ""
    ": nip   [ drop ] [ ] bi* ;"
    ": 2nip  [ drop ] [ drop ] [ ] tri* ;"
    ""
    ": rot"
    "    [ [ drop ] [      ] [ drop ] tri* ]"
    "    [ [ drop ] [ drop ] [      ] tri* ]"
    "    [ [      ] [ drop ] [ drop ] tri* ]"
    "    3tri ;"
    ""
    ": -rot"
    "    [ [ drop ] [ drop ] [      ] tri* ]"
    "    [ [      ] [ drop ] [ drop ] tri* ]"
    "    [ [ drop ] [      ] [ drop ] tri* ]"
    "    3tri ;"
    ""
    ": spin"
    "    [ [ drop ] [ drop ] [      ] tri* ]"
    "    [ [ drop ] [      ] [ drop ] tri* ]"
    "    [ [      ] [ drop ] [ drop ] tri* ]"
    "    3tri ;"
} ;

ARTICLE: "spread-combinators" "Spread combinators"
"The spread combinators apply multiple quotations to multiple values. The " { $snippet "*" } " suffix signifies spreading."
$nl
"Two quotations:"
{ $subsection bi* }
{ $subsection 2bi* }
"Three quotations:"
{ $subsection tri* }
"Technically, the spread combinators are redundant because they can be simulated using shuffle words and other combinators, and in addition, they do not reduce token counts by much, if at all. However, they can make code more readable by expressing intention and exploiting any inherent symmetry. For example, a piece of code which performs three operations on three related values can be written in one of two ways:"
{ $code
    "! First alternative; uses retain stack explicitly"
    ">r >r 1 +"
    "r> 1 -"
    "r> 2 *"
    "! Second alternative: uses tri*"
    "[ 1 + ]"
    "[ 1 - ]"
    "[ 2 * ] tri*"
}

$nl
"A generalization of the above combinators to any number of quotations can be found in " { $link "combinators" } "."
{ $subsection "spread-shuffle-equivalence" } ;

ARTICLE: "apply-combinators" "Apply combinators"
"The apply combinators apply multiple quotations to multiple values. The " { $snippet "@" } " suffix signifies application."
$nl
"Two quotations:"
{ $subsection bi@ }
{ $subsection 2bi@ }
"Three quotations:"
{ $subsection tri@ }
"A pair of utility words built from " { $link bi@ } ":"
{ $subsection both? }
{ $subsection either? } ;

ARTICLE: "slip-keep-combinators" "The slip and keep combinators"
"The slip combinators invoke a quotation further down on the stack. They are most useful for implementing other combinators:"
{ $subsection slip }
{ $subsection 2slip }
{ $subsection 3slip }
"The dip combinator invokes the quotation at the top of the stack, hiding the value underneath:"
{ $subsection dip }
"The keep combinators invoke a quotation which takes a number of values off the stack, and then they restore those values:"
{ $subsection keep }
{ $subsection 2keep }
{ $subsection 3keep } ;

ARTICLE: "compositional-combinators" "Compositional combinators"
"Quotations can be composed using efficient quotation-specific operations:"
{ $subsection curry }
{ $subsection 2curry }
{ $subsection 3curry }
{ $subsection with }
{ $subsection compose }
{ $subsection 3compose }
"Quotations also implement the sequence protocol, and can be manipulated with sequence words; see " { $link "quotations" } "." ;

ARTICLE: "implementing-combinators" "Implementing combinators"
"The following pair of words invoke words and quotations reflectively:"
{ $subsection call }
{ $subsection execute }
"These words are used to implement combinators. Note that combinator definitions must be followed by the " { $link POSTPONE: inline } " declaration in order to compile in the optimizing compiler; for example:"
{ $code
    ": keep ( x quot -- x )"
    "    over >r call r> ; inline"
}
"Word inlining is documented in " { $link "declarations" } "."
$nl
"A looping combinator:"
{ $subsection while } ;

ARTICLE: "booleans" "Booleans"
"In Factor, any object that is not " { $link f } " has a true value, and " { $link f } " has a false value. The " { $link t } " object is the canonical true value."
{ $subsection f }
{ $subsection t }
"The " { $link f } " object is the unique instance of the " { $link f } " class; the two are distinct objects. The latter is also a parsing word which adds the " { $link f } " object to the parse tree at parse time. To refer to the class itself you must use " { $link POSTPONE: POSTPONE: } " or " { $link POSTPONE: \ } " to prevent the parsing word from executing."
$nl
"Here is the " { $link f } " object:"
{ $example "f ." "f" }
"Here is the " { $link f } " class:"
{ $example "\\ f ." "POSTPONE: f" }
"They are not equal:"
{ $example "f \\ f = ." "f" }
"Here is an array containing the " { $link f } " object:"
{ $example "{ f } ." "{ f }" }
"Here is an array containing the " { $link f } " class:"
{ $example "{ POSTPONE: f } ." "{ POSTPONE: f }" }
"The " { $link f } " object is an instance of the " { $link f } " class:"
{ $example "f class ." "POSTPONE: f" }
"The " { $link f } " class is an instance of " { $link word } ":"
{ $example "\\ f class ." "word" }
"On the other hand, " { $link t } " is just a word, and there is no class which it is a unique instance of."
{ $example "t \\ t eq? ." "t" }
"Many words which search collections confuse the case of no element being present with an element being found equal to " { $link f } ". If this distinction is imporant, there is usually an alternative word which can be used; for example, compare " { $link at } " with " { $link at* } "." ;

ARTICLE: "conditionals" "Conditionals and logic"
"The basic conditionals:"
{ $subsection if }
{ $subsection when }
{ $subsection unless }
"Forms abstracting a common stack shuffle pattern:"
{ $subsection if* }
{ $subsection when* }
{ $subsection unless* }
"Another form abstracting a common stack shuffle pattern:"
{ $subsection ?if }
"Sometimes instead of branching, you just need to pick one of two values:"
{ $subsection ? }
"There are some logical operations on booleans:"
{ $subsection >boolean }
{ $subsection not }
{ $subsection and }
{ $subsection or }
{ $subsection xor }
"See " { $link "combinators" } " for forms which abstract away common patterns involving multiple nested branches."
{ $see-also "booleans" "bitwise-arithmetic" both? either? } ;

ARTICLE: "equality" "Equality and comparison testing"
"There are two distinct notions of ``sameness'' when it comes to objects. You can test if two references point to the same object (" { $emphasis "identity comparison" } "), or you can test if two objects are equal in a domain-specific sense, usually by being instances of the same class, and having equal slot values (" { $emphasis "value comparison" } "). Both notions of equality are equality relations in the mathematical sense."
$nl
"Identity comparison:"
{ $subsection eq? }
"Value comparison:"
{ $subsection = }
"Custom value comparison methods:"
{ $subsection equal? }
{ $subsection identity-tuple }
"Some types of objects also have an intrinsic order allowing sorting using " { $link natural-sort } ":"
{ $subsection <=> }
{ $subsection compare }
"Utilities for comparing objects:"
{ $subsection after? }
{ $subsection before? }
{ $subsection after=? }
{ $subsection before=? }
"An object can be cloned; the clone has distinct identity but equal value:"
{ $subsection clone } ;

ARTICLE: "dataflow" "Data and control flow"
{ $subsection "evaluator" }
{ $subsection "words" }
{ $subsection "effects" }
{ $subsection "booleans" }
{ $subsection "shuffle-words" }
"A central concept in Factor is that of a " { $emphasis "combinator" } ", which is a word taking code as input."
{ $subsection "cleave-combinators" }
{ $subsection "spread-combinators" }
{ $subsection "apply-combinators" }
{ $subsection "slip-keep-combinators" }
{ $subsection "conditionals" }
{ $subsection "compositional-combinators" }
{ $subsection "combinators" }
"Advanced topics:"
{ $subsection "implementing-combinators" }
{ $subsection "errors" }
{ $subsection "continuations" } ;

ABOUT: "dataflow"

HELP: eq? ( obj1 obj2 -- ? )
{ $values { "obj1" object } { "obj2" object } { "?" "a boolean" } }
{ $description "Tests if two references point at the same object." } ;

HELP: drop  ( x -- )                 $shuffle ;
HELP: 2drop ( x y -- )               $shuffle ;
HELP: 3drop ( x y z -- )             $shuffle ;
HELP: dup   ( x -- x x )             $shuffle ;
HELP: 2dup  ( x y -- x y x y )       $shuffle ;
HELP: 3dup  ( x y z -- x y z x y z ) $shuffle ;
HELP: rot   ( x y z -- y z x )       $shuffle ;
HELP: -rot  ( x y z -- z x y )       $shuffle ;
HELP: dupd  ( x y -- x x y )         $shuffle ;
HELP: swapd ( x y z -- y x z )       $shuffle ;
HELP: nip   ( x y -- y )             $shuffle ;
HELP: 2nip  ( x y z -- z )           $shuffle ;
HELP: tuck  ( x y -- y x y )         $shuffle ;
HELP: over  ( x y -- x y x )         $shuffle ;
HELP: 2over                          $shuffle ;
HELP: pick  ( x y z -- x y z x )     $shuffle ;
HELP: swap  ( x y -- y x )           $shuffle ;
HELP: spin                           $shuffle ;
HELP: roll                           $shuffle ;
HELP: -roll                          $shuffle ;

HELP: >r ( x -- )
{ $values { "x" object } } { $description "Moves the top of the data stack to the retain stack." } ;

HELP: r> ( -- x )
{ $values { "x" object } } { $description "Moves the top of the retain stack to the data stack." } ;

HELP: datastack ( -- ds )
{ $values { "ds" array } }
{ $description "Outputs an array containing a copy of the data stack contents right before the call to this word, with the top of the stack at the end of the array." } ;

HELP: set-datastack ( ds -- )
{ $values { "ds" array } }
{ $description "Replaces the data stack contents with a copy of an array. The end of the array becomes the top of the stack." } ;

HELP: retainstack ( -- rs )
{ $values { "rs" array } }
{ $description "Outputs an array containing a copy of the retain stack contents right before the call to this word, with the top of the stack at the end of the array." } ;

HELP: set-retainstack ( rs -- )
{ $values { "rs" array } }
{ $description "Replaces the retain stack contents with a copy of an array. The end of the array becomes the top of the stack." } ;

HELP: callstack ( -- cs )
{ $values { "cs" callstack } }
{ $description "Outputs a copy of the call stack contents, with the top of the stack at the end of the vector. The stack frame of the caller word is " { $emphasis "not" } " included." } ;

HELP: set-callstack ( cs -- )
{ $values { "cs" callstack } }
{ $description "Replaces the call stack contents. The end of the vector becomes the top of the stack. Control flow is transferred immediately to the new call stack." } ;

HELP: clear
{ $description "Clears the data stack." } ;

HELP: build
{ $description "The current build number. Factor increments this number whenever a new boot image is created." } ;

HELP: hashcode*
{ $values { "depth" integer } { "obj" object } { "code" fixnum } }
{ $contract "Outputs the hashcode of an object. The hashcode operation must satisfy the following properties:"
{ $list
    { "If two objects are equal under " { $link = } ", they must have equal hashcodes." }
    { "If the hashcode of an object depends on the values of its slots, the hashcode of the slots must be computed recursively by calling " { $link hashcode* } " with a " { $snippet "level" } " parameter decremented by one. This avoids excessive work while still computing well-distributed hashcodes. The " { $link recursive-hashcode } " combinator can help with implementing this logic," }
    { "The hashcode should be a " { $link fixnum } ", however returning a " { $link bignum } " will not cause any problems other than potential performance degradation." }
    { "The hashcode is only permitted to change between two invocations if the object or one of its slot values was mutated." }
}
"If mutable objects are used as hashtable keys, they must not be mutated in such a way that their hashcode changes. Doing so will violate bucket sorting invariants and result in undefined behavior. See " { $link "hashtables.keys" } " for details." } ;

HELP: hashcode
{ $values { "obj" object } { "code" fixnum } }
{ $description "Computes the hashcode of an object with a default hashing depth. See " { $link hashcode* } " for the hashcode contract." } ;

{ hashcode hashcode* } related-words

HELP: =
{ $values { "obj1" object } { "obj2" object } { "?" "a boolean" } }
{ $description
    "Tests if two objects are equal. If " { $snippet "obj1" } " and " { $snippet "obj2" } " point to the same object, outputs " { $link t } ". Otherwise, calls the " { $link equal? } " generic word."
} ;

HELP: equal?
{ $values { "obj1" object } { "obj2" object } { "?" "a boolean" } }
{ $contract
    "Tests if two objects are equal."
    $nl
    "User code should call " { $link = } " instead; that word first tests the case where the objects are " { $link eq? } ", and so by extension, methods defined on " { $link equal? } " assume they are never called on " { $link eq? } " objects."
    $nl
    "Method definitions should ensure that this is an equality relation, modulo the assumption that the two objects are not " { $link eq? } ". That is, for any three non-" { $link eq? } " objects " { $snippet "a" } ", " { $snippet "b" } " and " { $snippet "c" } ", we must have:"
    { $list
        { { $snippet "a = b" } " implies " { $snippet "b = a" } }
        { { $snippet "a = b" } " and " { $snippet "b = c" } " implies " { $snippet "a = c" } }
    }
    $nl
    "If a class defines a custom equality comparison test, it should also define a compatible method for the " { $link hashcode* } " generic word."
} ;

HELP: identity-tuple
{ $class-description "A class defining an " { $link equal? } " method which always returns f." }
{ $examples
    "To define a tuple class such that two instances are only equal if they are both the same instance, inherit from the " { $link identity-tuple } " class. This class defines a method on " { $link equal? } " which always returns " { $link f } ". Since " { $link = } " handles the case where the two objects are " { $link eq? } ", this method will never be called with two " { $link eq? } " objects, so such a definition is valid:"
    { $code "TUPLE: foo < identity-tuple ;" }
    "By calling " { $link = } " on instances of " { $snippet "foo" } " we get the results we expect:"
    { $unchecked-example "T{ foo } dup = ." "t" }
    { $unchecked-example "T{ foo } dup clone = ." "f" }
} ;

HELP: <=>
{ $values { "obj1" object } { "obj2" object } { "n" real } }
{ $contract
    "Compares two objects using an intrinsic total order, for example, the natural order for real numbers and lexicographic order for strings."
    $nl
    "The output value is one of the following:"
    { $list
        { "positive - indicating that " { $snippet "obj1" } " follows " { $snippet "obj2" } }
        { "zero - indicating that " { $snippet "obj1" } " is equal to " { $snippet "obj2" } }
        { "negative - indicating that " { $snippet "obj1" } " precedes " { $snippet "obj2" } }
    }
    "The default implementation treats the two objects as sequences, and recursively compares their elements. So no extra work is required to compare sequences lexicographically."
} ;

{ <=> compare natural-sort sort-keys sort-values } related-words

HELP: compare
{ $values { "obj1" object } { "obj2" object } { "quot" "a quotation with stack effect " { $snippet "( obj -- newobj )" } } { "n" integer } }
{ $description "Compares the results of applying the quotation to both objects via " { $link <=> } "." }
{ $examples
    { $example "USING: kernel prettyprint sequences ;" "\"hello\" \"hi\" [ length ] compare ." "3" }
} ;

HELP: clone
{ $values { "obj" object } { "cloned" "a new object" } }
{ $contract "Outputs a new object equal to the given object. This is not guaranteed to actually copy the object; it does nothing with immutable objects, and does not copy words either. However, sequences and tuples can be cloned to obtain a shallow copy of the original." } ;

HELP: ? ( ? true false -- true/false )
{ $values { "?" "a generalized boolean" } { "true" object } { "false" object } { "true/false" "one two input objects" } }
{ $description "Chooses between two values depending on the boolean value of " { $snippet "cond" } "." } ;

HELP: >boolean
{ $values { "obj" "a generalized boolean" } { "?" "a boolean" } }
{ $description "Convert a generalized boolean into a boolean. That is, " { $link f } " retains its value, whereas anything else becomes " { $link t } "." } ;

HELP: not ( obj -- ? )
{ $values { "obj" "a generalized boolean" } { "?" "a boolean" } }
{ $description "For " { $link f } " outputs " { $link t } " and for anything else outputs " { $link f } "." }
{ $notes "This word implements boolean not, so applying it to integers will not yield useful results (all integers have a true value). Bitwise not is the " { $link bitnot } " word." } ;

HELP: and
{ $values { "obj1" "a generalized boolean" } { "obj2" "a generalized boolean" } { "?" "a generalized boolean" } }
{ $description "If both inputs are true, outputs " { $snippet "obj2" } ". otherwise outputs " { $link f } "." }
{ $notes "This word implements boolean and, so applying it to integers will not yield useful results (all integers have a true value). Bitwise and is the " { $link bitand } " word." }
{ $examples
    "Usually only the boolean value of the result is used, however you can also explicitly rely on the behavior that if both inputs are true, the second is output:"
    { $example "USING: kernel prettyprint ;" "t f and ." "f" }
    { $example "USING: kernel prettyprint ;" "t 7 and ." "7" }
    { $example "USING: kernel prettyprint ;" "\"hi\" 12.0 and ." "12.0" }
} ;

HELP: or
{ $values { "obj1" "a generalized boolean" } { "obj2" "a generalized boolean" } { "?" "a generalized boolean" } }
{ $description "If both inputs are false, outputs " { $link f } ". otherwise outputs the first of " { $snippet "obj1" } " and " { $snippet "obj2" } " which is true." }
{ $notes "This word implements boolean inclusive or, so applying it to integers will not yield useful results (all integers have a true value). Bitwise inclusive or is the " { $link bitor } " word." }
{ $examples
    "Usually only the boolean value of the result is used, however you can also explicitly rely on the behavior that the result will be the first true input:"
    { $example "USING: kernel prettyprint ;" "t f or ." "t" }
    { $example "USING: kernel prettyprint ;" "\"hi\" 12.0 or ." "\"hi\"" }
} ;

HELP: xor
{ $values { "obj1" "a generalized boolean" } { "obj2" "a generalized boolean" } { "?" "a generalized boolean" } }
{ $description "Tests if at exactly one object is not " { $link f } "." }
{ $notes "This word implements boolean exclusive or, so applying it to integers will not yield useful results (all integers have a true value). Bitwise exclusive or is the " { $link bitxor } " word." } ;

HELP: both?
{ $values { "quot" "a quotation with stack effect " { $snippet "( obj -- ? )" } } { "x" object } { "y" object } { "?" "a boolean" } }
{ $description "Tests if the quotation yields a true value when applied to both " { $snippet "x" } " and " { $snippet "y" } "." }
{ $examples
    { $example "USING: kernel math prettyprint ;" "3 5 [ odd? ] both? ." "t" }
    { $example "USING: kernel math prettyprint ;" "12 7 [ even? ] both? ." "f" }
} ;

HELP: either?
{ $values { "quot" "a quotation with stack effect " { $snippet "( obj -- ? )" } } { "x" object } { "y" object } { "?" "a boolean" } }
{ $description "Tests if the quotation yields a true value when applied to either " { $snippet "x" } " or " { $snippet "y" } "." }
{ $examples
    { $example "USING: kernel math prettyprint ;" "3 6 [ odd? ] either? ." "t" }
    { $example "USING: kernel math prettyprint ;" "5 7 [ even? ] either? ." "f" }
} ;

HELP: call
{ $values { "callable" callable } }
{ $description "Calls a quotation." }
{ $examples
    "The following two lines are equivalent:"
    { $code "2 [ 2 + 3 * ] call" "2 2 + 3 *" }
} ;

HELP: call-clear ( quot -- )
{ $values { "quot" callable } }
{ $description "Calls a quotation with an empty call stack. If the quotation returns, Factor will exit.." }
{ $notes "Used to implement " { $link "threads" } "." } ;

HELP: slip
{ $values { "quot" quotation } { "x" object } }
{ $description "Calls a quotation while hiding the top of the stack." } ;

HELP: 2slip
{ $values { "quot" quotation } { "x" object } { "y" object } }
{ $description "Calls a quotation while hiding the top two stack elements." } ;

HELP: 3slip
{ $values { "quot" quotation } { "x" object } { "y" object } { "z" object } }
{ $description "Calls a quotation while hiding the top three stack elements." } ;

HELP: keep
{ $values { "quot" "a quotation with stack effect " { $snippet "( x -- )" } } { "x" object } }
{ $description "Call a quotation with a value on the stack, restoring the value when the quotation returns." } ;

HELP: 2keep
{ $values { "quot" "a quotation with stack effect " { $snippet "( x y -- )" } } { "x" object } { "y" object } }
{ $description "Call a quotation with two values on the stack, restoring the values when the quotation returns." } ;

HELP: 3keep
{ $values { "quot" "a quotation with stack effect " { $snippet "( x y z -- )" } } { "x" object } { "y" object } { "z" object } }
{ $description "Call a quotation with three values on the stack, restoring the values when the quotation returns." } ;

HELP: bi
{ $values { "x" object } { "p" "a quotation with stack effect " { $snippet "( x -- ... )" } } { "q" "a quotation with stack effect " { $snippet "( x -- ... )" } } }
{ $description "Applies " { $snippet "p" } " to " { $snippet "x" } ", then applies " { $snippet "q" } " to " { $snippet "x" } "." }
{ $examples
    "If " { $snippet "[ p ]" } " and " { $snippet "[ q ]" } " have stack effect " { $snippet "( x -- )" } ", then the following two lines are equivalent:"
    { $code
        "[ p ] [ q ] bi"
        "dup p q"
    }
    "If " { $snippet "[ p ]" } " and " { $snippet "[ q ]" } " have stack effect " { $snippet "( x -- y )" } ", then the following two lines are equivalent:"
    { $code
        "[ p ] [ q ] bi"
        "dup p swap q"
    }
    "In general, the following two lines are equivalent:"
    { $code
        "[ p ] [ q ] bi"
        "[ p ] keep q"
    }
    
} ;

HELP: 2bi
{ $values { "x" object } { "y" object } { "p" "a quotation with stack effect " { $snippet "( x y -- ... )" } } { "q" "a quotation with stack effect " { $snippet "( x y -- ... )" } } }
{ $description "Applies " { $snippet "p" } " to the two input values, then applies " { $snippet "q" } " to the two input values." }
{ $examples
    "If " { $snippet "[ p ]" } " and " { $snippet "[ q ]" } " have stack effect " { $snippet "( x y -- )" } ", then the following two lines are equivalent:"
    { $code
        "[ p ] [ q ] 2bi"
        "2dup p q"
    }
    "If " { $snippet "[ p ]" } " and " { $snippet "[ q ]" } " have stack effect " { $snippet "( x y -- z )" } ", then the following two lines are equivalent:"
    { $code
        "[ p ] [ q ] 2bi"
        "2dup p -rot q"
    }
    "In general, the following two lines are equivalent:"
    { $code
        "[ p ] [ q ] 2bi"
        "[ p ] 2keep q"
    }
} ;

HELP: 3bi
{ $values { "x" object } { "y" object } { "z" object } { "p" "a quotation with stack effect " { $snippet "( x y z -- ... )" } } { "q" "a quotation with stack effect " { $snippet "( x y z -- ... )" } } }
{ $description "Applies " { $snippet "p" } " to the two input values, then applies " { $snippet "q" } " to the two input values." }
{ $examples
    "If " { $snippet "[ p ]" } " and " { $snippet "[ q ]" } " have stack effect " { $snippet "( x y z -- )" } ", then the following two lines are equivalent:"
    { $code
        "[ p ] [ q ] 3bi"
        "3dup p q"
    }
    "If " { $snippet "[ p ]" } " and " { $snippet "[ q ]" } " have stack effect " { $snippet "( x y z -- w )" } ", then the following two lines are equivalent:"
    { $code
        "[ p ] [ q ] 3bi"
        "3dup p -roll q"
    }
    "In general, the following two lines are equivalent:"
    { $code
        "[ p ] [ q ] 3bi"
        "[ p ] 3keep q"
    }
} ;

HELP: tri
{ $values { "x" object } { "p" "a quotation with stack effect " { $snippet "( x -- ... )" } } { "q" "a quotation with stack effect " { $snippet "( x -- ... )" } } { "r" "a quotation with stack effect " { $snippet "( x -- ... )" } } }
{ $description "Applies " { $snippet "p" } " to " { $snippet "x" } ", then applies " { $snippet "q" } " to " { $snippet "x" } ", and finally applies " { $snippet "r" } " to " { $snippet "x" } "." }
{ $examples
    "If " { $snippet "[ p ]" } ", " { $snippet "[ q ]" } " and " { $snippet "[ r ]" } " have stack effect " { $snippet "( x -- )" } ", then the following two lines are equivalent:"
    { $code
        "[ p ] [ q ] [ r ] tri"
        "dup p dup q r"
    }
    "If " { $snippet "[ p ]" } ", " { $snippet "[ q ]" } " and " { $snippet "[ r ]" } " have stack effect " { $snippet "( x -- y )" } ", then the following two lines are equivalent:"
    { $code
        "[ p ] [ q ] [ r ] tri"
        "dup p over q rot r"
    }
    "In general, the following two lines are equivalent:"
    { $code
        "[ p ] [ q ] [ r ] tri"
        "[ p ] keep [ q ] keep r"
    }
} ;

HELP: 2tri
{ $values { "x" object } { "y" object } { "p" "a quotation with stack effect " { $snippet "( x y -- ... )" } } { "q" "a quotation with stack effect " { $snippet "( x y -- ... )" } } { "r" "a quotation with stack effect " { $snippet "( x y -- ... )" } } }
{ $description "Applies " { $snippet "p" } " to the two input values, then applies " { $snippet "q" } " to the two input values, and finally applies " { $snippet "r" } " to the two input values." }
{ $examples
    "If " { $snippet "[ p ]" } ", " { $snippet "[ q ]" } " and " { $snippet "[ r ]" } " have stack effect " { $snippet "( x y -- )" } ", then the following two lines are equivalent:"
    { $code
        "[ p ] [ q ] [ r ] 2tri"
        "2dup p 2dup q r"
    }
    "In general, the following two lines are equivalent:"
    { $code
        "[ p ] [ q ] [ r ] 2tri"
        "[ p ] 2keep [ q ] 2keep r"
    }
} ;

HELP: 3tri
{ $values { "x" object } { "y" object } { "z" object } { "p" "a quotation with stack effect " { $snippet "( x y z -- ... )" } } { "q" "a quotation with stack effect " { $snippet "( x y z -- ... )" } } { "r" "a quotation with stack effect " { $snippet "( x y z -- ... )" } } }
{ $description "Applies " { $snippet "p" } " to the three input values, then applies " { $snippet "q" } " to the three input values, and finally applies " { $snippet "r" } " to the three input values." }
{ $examples
    "If " { $snippet "[ p ]" } ", " { $snippet "[ q ]" } " and " { $snippet "[ r ]" } " have stack effect " { $snippet "( x y z -- )" } ", then the following two lines are equivalent:"
    { $code
        "[ p ] [ q ] [ r ] 3tri"
        "3dup p 3dup q r"
    }
    "In general, the following two lines are equivalent:"
    { $code
        "[ p ] [ q ] [ r ] 3tri"
        "[ p ] 3keep [ q ] 3keep r"
    }
} ;


HELP: bi*
{ $values { "x" object } { "y" object } { "p" "a quotation with stack effect " { $snippet "( x -- ... )" } } { "q" "a quotation with stack effect " { $snippet "( y -- ... )" } } }
{ $description "Applies " { $snippet "p" } " to " { $snippet "x" } ", then applies " { $snippet "q" } " to " { $snippet "y" } "." }
{ $examples
    "The following two lines are equivalent:"
    { $code
        "[ p ] [ q ] bi*"
        ">r p r> q"
    }
} ;

HELP: 2bi*
{ $values { "w" object } { "x" object } { "y" object } { "z" object } { "p" "a quotation with stack effect " { $snippet "( w x -- ... )" } } { "q" "a quotation with stack effect " { $snippet "( y z -- ... )" } } }
{ $description "Applies " { $snippet "p" } " to " { $snippet "w" } " and " { $snippet "x" } ", then applies " { $snippet "q" } " to " { $snippet "y" } " and " { $snippet "z" } "." }
{ $examples
    "The following two lines are equivalent:"
    { $code
        "[ p ] [ q ] 2bi*"
        ">r >r q r> r> q"
    }
} ;

HELP: tri*
{ $values { "x" object } { "y" object } { "z" object } { "p" "a quotation with stack effect " { $snippet "( x -- ... )" } } { "q" "a quotation with stack effect " { $snippet "( y -- ... )" } } { "r" "a quotation with stack effect " { $snippet "( z -- ... )" } } }
{ $description "Applies " { $snippet "p" } " to " { $snippet "x" } ", then applies " { $snippet "q" } " to " { $snippet "y" } ", and finally applies " { $snippet "r" } " to " { $snippet "z" } "." }
{ $examples
    "The following two lines are equivalent:"
    { $code
        "[ p ] [ q ] [ r ] tri*"
        ">r >r q r> q r> r"
    }
} ;

HELP: bi@
{ $values { "x" object } { "y" object } { "quot" "a quotation with stack effect " { $snippet "( obj -- )" } } }
{ $description "Applies the quotation to " { $snippet "x" } ", then to " { $snippet "y" } "." }
{ $examples
    "The following two lines are equivalent:"
    { $code
        "[ p ] bi@"
        ">r p r> p"
    }
    "The following two lines are also equivalent:"
    { $code
        "[ p ] bi@"
        "[ p ] [ p ] bi*"
    }
} ;

HELP: 2bi@
{ $values { "w" object } { "x" object } { "y" object } { "z" object } { "quot" "a quotation with stack effect " { $snippet "( obj1 obj2 -- )" } } }
{ $description "Applies the quotation to " { $snippet "w" } " and " { $snippet "x" } ", then to " { $snippet "y" } " and " { $snippet "z" } "." }
{ $examples
    "The following two lines are equivalent:"
    { $code
        "[ p ] 2bi@"
        ">r >r p r> r> p"
    }
    "The following two lines are also equivalent:"
    { $code
        "[ p ] 2bi@"
        "[ p ] [ p ] 2bi*"
    }
} ;

HELP: tri@
{ $values { "x" object } { "y" object } { "z" object } { "quot" "a quotation with stack effect " { $snippet "( obj -- )" } } }
{ $description "Applies the quotation to " { $snippet "x" } ", then to " { $snippet "y" } ", and finally to " { $snippet "z" } "." }
{ $examples
    "The following two lines are equivalent:"
    { $code
        "[ p ] tri@"
        ">r >r p r> p r> p"
    }
    "The following two lines are also equivalent:"
    { $code
        "[ p ] tri@"
        "[ p ] [ p ] [ p ] tri*"
    }
} ;

HELP: if ( cond true false -- )
{ $values { "cond" "a generalized boolean" } { "true" quotation } { "false" quotation } }
{ $description "If " { $snippet "cond" } " is " { $link f } ", calls the " { $snippet "false" } " quotation. Otherwise calls the " { $snippet "true" } " quotation."
$nl
"The " { $snippet "cond" } " value is removed from the stack before either quotation is called." } ;

HELP: when
{ $values { "cond" "a generalized boolean" } { "true" quotation } }
{ $description "If " { $snippet "cond" } " is not " { $link f } ", calls the " { $snippet "true" } " quotation."
$nl
"The " { $snippet "cond" } " value is removed from the stack before the quotation is called." } ;

HELP: unless
{ $values { "cond" "a generalized boolean" } { "false" quotation } }
{ $description "If " { $snippet "cond" } " is " { $link f } ", calls the " { $snippet "false" } " quotation."
$nl
"The " { $snippet "cond" } " value is removed from the stack before the quotation is called." } ;

HELP: if*
{ $values { "cond" "a generalized boolean" } { "true" "a quotation with stack effect " { $snippet "( cond -- )" } } { "false" quotation } }
{ $description "Alternative conditional form that preserves the " { $snippet "cond" } " value if it is true."
$nl
"If the condition is true, it is retained on the stack before the " { $snippet "true" } " quotation is called. Otherwise, the condition is removed from the stack and the " { $snippet "false" } " quotation is called."
$nl
"The following two lines are equivalent:"
{ $code "X [ Y ] [ Z ] if*" "X dup [ Y ] [ drop Z ] if" } } ;

HELP: when*
{ $values { "cond" "a generalized boolean" } { "true" "a quotation with stack effect " { $snippet "( cond -- )" } } }
{ $description "Variant of " { $link if* } " with no false quotation."
$nl
"The following two lines are equivalent:"
{ $code "X [ Y ] when*" "X dup [ Y ] [ drop ] if" } } ;

HELP: unless*
{ $values { "cond" "a generalized boolean" } { "false" "a quotation " } }
{ $description "Variant of " { $link if* } " with no true quotation."
$nl
"The following two lines are equivalent:"
{ $code "X [ Y ] unless*" "X dup [ ] [ drop Y ] if" } } ;

HELP: ?if
{ $values { "default" object } { "cond" "a generalized boolean" } { "true" "a quotation with stack effect " { $snippet "( cond -- )" } } { "false" "a quotation with stack effect " { $snippet "( default -- )" } } }
{ $description "If the condition is " { $link f } ", the " { $snippet "false" } " quotation is called with the " { $snippet "default" } " value on the stack. Otherwise, the " { $snippet "true" } " quotation is called with the condition on the stack."
$nl
"The following two lines are equivalent:"
{ $code "[ X ] [ Y ] ?if" "dup [ nip X ] [ drop Y ] if" } } ;

HELP: die
{ $description "Starts the front-end processor (FEP), which is a low-level debugger which can inspect memory addresses and the like. The FEP is also entered when a critical error occurs." }
{ $notes
    "The term FEP originates from the Lisp machines of old. According to the Jargon File,"
    $nl
    { $strong "fepped out" } " /fept owt/ " { $emphasis "adj." }  " The Symbolics 3600 LISP Machine has a Front-End Processor called a `FEP' (compare sense 2 of box). When the main processor gets wedged, the FEP takes control of the keyboard and screen. Such a machine is said to have `fepped out' or `dropped into the fep'." 
    $nl
    { $url "http://www.jargon.net/jargonfile/f/feppedout.html" }
} ;

HELP: (clone) ( obj -- newobj )
{ $values { "obj" object } { "newobj" "a shallow copy" } }
{ $description "Outputs a byte-by-byte copy of the given object. User code should call " { $link clone } " instead." } ;

HELP: declare
{ $values { "spec" "an array of class words" } }
{ $description "Declares that the elements at the top of the stack are instances of the classes in " { $snippet "spec" } "." }
{ $warning "The compiler blindly trusts declarations, and false declarations can lead to crashes, memory corruption and other undesirable behavior." }
{ $examples
    "The optimizer cannot do anything with the below code:"
    { $code "2 + 10 *" }
    "However, if we declare that the top of the stack is a " { $link float } ", then type checks and generic dispatch are eliminated, and the compiler can use unsafe intrinsics:"
    { $code "{ float } declare 2 + 10 *" }
} ;

HELP: tag ( object -- n )
{ $values { "object" object } { "n" "a tag number" } }
{ $description "Outputs an object's tag number, between zero and one less than " { $link num-tags } ". This is implementation detail and user code should call " { $link class } " instead." } ;

HELP: getenv ( n -- obj )
{ $values { "n" "a non-negative integer" } { "obj" object } }
{ $description "Reads an object from the Factor VM's environment table. User code never has to read the environment table directly; instead, use one of the callers of this word." } ;

HELP: setenv ( obj n -- )
{ $values { "n" "a non-negative integer" } { "obj" object } }
{ $description "Writes an object to the Factor VM's environment table. User code never has to write to the environment table directly; instead, use one of the callers of this word." } ;

HELP: object
{ $class-description
    "The class of all objects. If a generic word defines a method specializing on this class, the method is used as a fallback, if no other applicable method is found. For instance:"
    { $code "GENERIC: enclose" "M: number enclose 1array ;" "M: object enclose ;" }
} ;

HELP: null
{ $class-description
    "The canonical empty class with no instances."
} ;

HELP: most
{ $values { "x" object } { "y" object } { "quot" "a quotation with stack effect " { $snippet "( x y -- ? )" } } { "z" "either " { $snippet "x" } " or " { $snippet "y" } } }
{ $description "If the quotation yields a true value when applied to " { $snippet "x" } " and " { $snippet "y" } ", outputs " { $snippet "x" } ", otherwise outputs " { $snippet "y" } "." } ;

HELP: curry ( obj quot -- curry )
{ $values { "obj" object } { "quot" callable } { "curry" curry } }
{ $description "Partial application. Outputs a " { $link callable } " which first pushes " { $snippet "obj" } " and then calls " { $snippet "quot" } "." }
{ $class-description "The class of objects created by " { $link curry } ". These objects print identically to quotations and implement the sequence protocol, however they only use two cells of storage; a reference to the object and a reference to the underlying quotation." }
{ $notes "Even if " { $snippet "obj" } " is a word, it will be pushed as a literal."
$nl
"This operation is efficient and does not copy the quotation." }
{ $examples
    { $example "USING: kernel prettyprint ;" "5 [ . ] curry ." "[ 5 . ]" }
    { $example "USING: kernel prettyprint ;" "\\ = [ see ] curry ." "[ \\ = see ]" }
    { $example "USING: kernel math prettyprint sequences ;" "{ 1 2 3 } 2 [ - ] curry map ." "{ -1 0 1 }" }
} ;

HELP: 2curry
{ $values { "obj1" object } { "obj2" object } { "quot" callable } { "curry" curry } }
{ $description "Outputs a " { $link callable } " which pushes " { $snippet "obj1" } " and " { $snippet "obj2" } " and then calls " { $snippet "quot" } "." }
{ $notes "This operation is efficient and does not copy the quotation." }
{ $examples
    { $example "USING: kernel math prettyprint ;" "5 4 [ + ] 2curry ." "[ 5 4 + ]" }
} ;

HELP: 3curry
{ $values { "obj1" object } { "obj2" object } { "obj3" object } { "quot" callable } { "curry" curry } }
{ $description "Outputs a " { $link callable } " which pushes " { $snippet "obj1" } ", " { $snippet "obj2" } " and " { $snippet "obj3" } ", and then calls " { $snippet "quot" } "." }
{ $notes "This operation is efficient and does not copy the quotation." } ;

HELP: with
{ $values { "param" object } { "obj" object } { "quot" "a quotation with stack effect " { $snippet "( param elt -- ... )" } } { "obj" object } { "curry" curry } }
{ $description "Partial application on the left. The following two lines are equivalent:"
    { $code "swap [ swap A ] curry B" }
    { $code "[ A ] with B" }
    
}
{ $notes "This operation is efficient and does not copy the quotation." }
{ $examples
    { $example "USING: kernel math prettyprint sequences ;" "2 { 1 2 3 } [ - ] with map ." "{ 1 0 -1 }" }
} ;

HELP: compose ( quot1 quot2 -- compose )
{ $values { "quot1" callable } { "quot2" callable } { "compose" compose } }
{ $description "Quotation composition. Outputs a " { $link callable } " which calls " { $snippet "quot1" } " followed by " { $snippet "quot2" } "." }
{ $notes
    "The two quotations must leave the retain stack in the same state on exit as it was on entry, so the following code is not allowed:"
    { $code
        "[ 3 >r ] [ r> . ] compose"
    }
    "Except for this restriction, the following two lines are equivalent:"
    { $code
        "compose call"
        "append call"
    }
    "However, " { $link compose } " runs in constant time, and the optimizing compiler is able to compile code which calls composed quotations."
} ;

HELP: 3compose
{ $values { "quot1" callable } { "quot2" callable } { "quot3" callable } { "curry" curry } }
{ $description "Quotation composition. Outputs a " { $link callable } " which calls " { $snippet "quot1" } ", " { $snippet "quot2" } " and then " { $snippet "quot3" } "." }
{ $notes
    "The three quotations must leave the retain stack in the same state on exit as it was on entry, so for example, the following code is not allowed:"
    { $code
        "[ >r ] swap [ r> ] 3compose"
    }
    "The correct way to achieve the effect of the above is the following:"
    { $code
        "[ dip ] curry"
    }
    "Excepting the retain stack restriction, the following two lines are equivalent:"
    { $code
        "3compose call"
        "3append call"
    }
    "However, " { $link 3compose } " runs in constant time, and the compiler is able to compile code which calls composed quotations."
} ;

HELP: dip
{ $values { "obj" object } { "quot" quotation } }
{ $description "Calls " { $snippet "quot" } " with " { $snippet "obj" } " hidden on the retain stack." }
{ $notes "The following are equivalent:"
    { $code ">r foo bar r>" }
    { $code "[ foo bar ] dip" }
} ;

HELP: while
{ $values { "pred" "a quotation with stack effect " { $snippet "( -- ? )" } } { "body" "a quotation" } { "tail" "a quotation" } }
{ $description "Repeatedly calls " { $snippet "pred" } ". If it yields " { $link f } ", iteration stops, otherwise " { $snippet "body" } " is called. After iteration stops, " { $snippet "tail" } " is called." }
{ $notes "In most cases, tail recursion should be used, because it is simpler both in terms of implementation and conceptually. However in some cases this combinator expresses intent better and should be used."
$nl
"Strictly speaking, the " { $snippet "tail" } " is not necessary, since the following are equivalent:"
{ $code
    "[ P ] [ Q ] [ T ] while"
    "[ P ] [ Q ] [ ] while T"
}
"However, depending on the stack effects of " { $snippet "pred" } " and " { $snippet "quot" } ", the " { $snippet "tail" } " quotation might need to be non-empty in order to balance out the stack effect of branches for stack effect inference." } ;
