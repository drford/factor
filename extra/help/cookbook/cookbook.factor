USING: help.markup help.syntax io kernel math namespaces parser
prettyprint sequences vocabs.loader namespaces inference ;
IN: help.cookbook

ARTICLE: "cookbook-syntax" "Basic syntax cookbook"
"The following is a simple snippet of Factor code:"
{ $example "10 sq 5 - ." "95" }
"You can click on it to evaluate it in the listener, and it will print the same output value as indicated above."
$nl
"Factor has a very simple syntax. Your program consists of " { $emphasis "words" } " and " { $emphasis "literals" } ". In the above snippet, the words are " { $link sq } ", " { $link - } " and " { $link . } ". The two integers 10 and 5 are literals."
$nl
"Factor evaluates code left to right, and stores intermediate values on a " { $emphasis "stack" } ". If you think of the stack as a pile of papers, then " { $emphasis "pushing" } " a value on the stack corresponds to placing a piece of paper at the top of the pile, while " { $emphasis "popping" } " a value corresponds to removing the topmost piece."
$nl
"Most words have a " { $emphasis "stack effect declaration" } ", for example " { $snippet "( x y -- z )" } " denotes that a word takes two inputs, with " { $snippet "y" } " at the top of the stack, and returns one output. Stack effect declarations can be viewed by browsing source code, or using tools such as " { $link see } ". See " { $link "effect-declaration" } "."
$nl
"Coming back to the example in the beginning of this article, the following series of steps occurs as the code is evaluated:"
{ $table
    { "Action" "Stack contents" }
    { "10 is pushed on the stack." { $snippet "10" } }
    { { "The " { $link sq } " word is executed. It pops one input from the stack - the integer 10 - and squares it, pushing the result." } { $snippet "100" } }
    { { "5 is pushed on the stack." } { $snippet "100 5" } }
    { { "The " { $link - } " word is executed. It pops two inputs from the stack - the integers 100 and 5 - and subtracts 5 from 100, pushing the result." } { $snippet "95" } }
    { { "The " { $link . } " word is executed. It pops one input from the stack - the integer 95 - and prints it in the listener's output area." } { } }
}
"Factor supports many other data types:"
{ $code
    "10.5"
    "\"character strings\""
    "{ 1 2 3 }"
    "! by the way, this is a comment"
    "#! and so is this"
}
{ $references
    { "Factor's syntax can be extended, the parser can be called reflectively, and the " { $link . } " word is in fact a general facility for turning almost any object into a form which can be parsed back in again. If this interests you, consult the following sections:" }
    "syntax"
    "parser"
    "prettyprint"
} ;

ARTICLE: "cookbook-colon-defs" "Shuffle word and definition cookbook"
"The " { $link dup } " word makes a copy of the value at the top of the stack:"
{ $example "5 dup * ." "25" }
"The " { $link sq } " word is actually defined as follows:"
{ $code ": sq dup * ;" }
"(You could have looked this up yourself by clicking on the " { $link sq } " word itself.)"
$nl
"Note the key elements in a word definition: The colon " { $link POSTPONE: : } " denotes the start of a word definition. The name of the new word must immediately follow. The word definition then continues on until the " { $link POSTPONE: ; } " token signifies the end of the definition. This type of word definition is called a " { $emphasis "compound definition." }
$nl
"Factor is all about code reuse through short and logical colon definitions. Breaking up a problem into small pieces which are easy to test is called " { $emphasis "factoring." }
$nl
"Another example of a colon definition:"
{ $code ": neg ( x -- -x ) 0 swap - ;" }
"Here the " { $link swap } " shuffle word is used to interchange the top two stack elements. Note the difference that " { $link swap } " makes in the following two snippets:"
{ $code
    "5 0 -       ! Computes 5-0"
    "5 0 swap -  ! Computes 0-5"
}
"Also, in the above example a stack effect declaration is written between " { $snippet "(" } " and " { $snippet ")" } " with a mnemonic description of what the word does to the stack. See " { $link "effect-declaration" } " for details."
{ $curious
    "This syntax will be familiar to anybody who has used Forth before. However the behavior is slightly different. In most Forth systems, the below code prints 2, because the definition of " { $snippet "b" } " still refers to the previous definition of " { $snippet "a" } ":"
    { $code
        ": a 1 ;"
        ": b a 1 + ;"
        ": a 2 ;"
        "b ."
    }
    "In Factor, this example will print 3 since word redefinition is explicitly supported."
}
{ $references
    { "A whole slew of shuffle words can be used to rearrange the stack. There are forms of word definition other than colon definition, words can be defined entirely at runtime, and word definitions can be " { $emphasis "annotated" } " with tracing calls and breakpoints without modifying the source code." }
    "shuffle-words"
    "words"
    "generic"
    "tools"
} ;

ARTICLE: "cookbook-combinators" "Control flow cookbook"
"A " { $emphasis "quotation" } " is an object containing code which can be evaluated."
{ $code
    "2 2 + .     ! Prints 4"
    "[ 2 2 + . ] ! Pushes a quotation"
}
"The quotation pushed by the second example will print 4 when called by " { $link call } "."
$nl
"Quotations are used to implement control flow. For example, conditional execution is done with " { $link if } ":"
{ $code
    ": sign-test ( n -- )"
    "    dup 0 < ["
    "        drop \"negative\""
    "    ] ["
    "        zero? [ \"zero\" ] [ \"positive\" ] if"
    "    ] if print ;"
}
"The " { $link if } " word takes a boolean, a true quotation, and a false quotation, and executes one of the two quotations depending on the value of the boolean. In Factor, any object not equal to the special value " { $link f } " is considered true, while " { $link f } " is false."
$nl
"Another useful form of control flow is iteration. You can do something several times:"
{ $code "10 [ \"Factor rocks!\" print ] times" }
"Now we can look at a new data type, the array:"
{ $code "{ 1 2 3 }" }
"An array looks like a quotation except it cannot be evaluated; it simply stores data."
$nl
"You can perform an operation on each element of an array:"
{ $example
    "{ 1 2 3 } [ \"The number is \" write . ] each"
    "The number is 1"
    "The number is 2"
    "The number is 3"
}
"You can transform each element, collecting the results in a new array:"
{ $example "{ 5 12 0 -12 -5 } [ sq ] map ." "{ 25 144 0 144 25 }" }
"You can create a new array, only containing elements which satisfy some condition:"
{ $example
    ": negative? ( n -- ? ) 0 < ;"
    "{ -12 10 16 0 -1 -3 -9 } [ negative? ] subset ."
    "{ -12 -1 -3 -9 }"
}
{ $references
    { "Since quotations are objects, they can be constructed and taken apart at will. You can write code that writes code. Arrays are just one of the various types of sequences, and the sequence operations such as " { $link each } " and " { $link map } " operate on all types of sequences. There are many more sequence iteration operations than the ones above, too." }
    "dataflow"
    "sequences"
} ;

ARTICLE: "cookbook-variables" "Variables cookbook"
"Before using a variable, you must define a symbol for it:"
{ $code "SYMBOL: name" }
"A symbol is a word which pushes itself on the stack when executed. Try it:"
{ $example "SYMBOL: foo" "foo ." "foo" }
"Symbols can be passed to the " { $link get } " and " { $link set } " words to read and write variable values:"
{ $example "\"Slava\" name set" "name get print" "Slava" }
"If you set variables inside a " { $link with-scope } ", their values will be lost after leaving the scope:"
{ $example
    ": print-name name get print ;"
    "\"Slava\" name set"
    "["
    "    \"Diana\" name set"
    "    \"There, the name is \" write  print-name"
    "] with-scope"
    "\"Here, the name is \" write  print-name"
    "There, the name is Diana\nHere, the name is Slava"
}
{ $curious
    "Variables are dynamically-scoped in Factor."
}
{ $references
    "There is a lot more to be said about variables and namespaces."
    "namespaces"
} ;

ARTICLE: "cookbook-vocabs" "Vocabularies cookbook"
"Rather than being in one flat list, words belong to vocabularies; every word is contained in exactly one. When parsing a word name, the parser searches the " { $emphasis "vocabulary search path" } ". When working at the listener, a useful set of vocabularies is already available. In a source file, all used vocabularies must be imported."
$nl
"For example, a source file containing the following code will print a parse error if you try loading it:"
{ $code "\"Hello world\" print" }
"The " { $link print } " word is contained inside the " { $vocab-link "io" } " vocabulary, which is available in the listener but must be explicitly added to the search path in source files:"
{ $code
    "USE: io"
    "\"Hello world\" print"
}
"Typically a source file will refer to words in multiple vocabularies, and they can all be added to the search path in one go:"
{ $code "USING: arrays kernel math ;" }
"New words go into the " { $vocab-link "scratchpad" } " vocabulary by default. You can change this with " { $link POSTPONE: IN: } ":"
{ $code
    "IN: time-machine"
    ": time-travel ( when what -- ) frob fizz flap ;"
}
"Note that words must be defined before being referenced. The following is generally invalid:"
{ $code
    ": frob accelerate particles ;"
    ": accelerate accelerator on ;"
    ": particles [ (particles) ] each ;"
}
"You would have to place the first definition after the two others for the parser to accept the file."
{ $references
    { }
    "vocabulary-search"
    "words"
    "parser"
} ;

ARTICLE: "cookbook-io" "Input and output cookbook"
"Ask the user for their age, and print it back:"
{ $code
    ": ask-age ( -- ) \"How old are you?\" print ;"
    ": read-age ( -- n ) readln string>number ;"
    ": print-age ( n -- )"
    "    \"You are \" write"
    "    number>string write"
    "    \" years old.\" print ;"
    ": example ( -- ) ask-age read-age print-age ;"
    "example"
}
"Print the lines of a file in sorted order:"
{ $code
    "utf8 \"lines.txt\" file-lines natural-sort [ print ] each"
}
"Read 1024 bytes from a file:"
{ $code
    "\"data.bin\" binary [ 1024 read ] with-file-reader"
}
"Convert a file of 4-byte cells from little to big endian or vice versa, by directly mapping it into memory and operating on it with sequence words:"
{ $code
    "\"mydata.dat\" dup file-info size>> ["
    "    4 <sliced-groups> [ reverse-here ] change-each"
    "] with-mapped-file"
}
"Send some bytes to a remote host:"
{ $code
    "\"myhost\" 1033 <inet> <client>"
    "[ { 12 17 102 } >string write ] with-stream"
}
{ $references
    { }
    "number-strings"
    "io"
} ;

ARTICLE: "cookbook-compiler" "Compiler cookbook"
"Factor includes two compilers which work behind the scenes. Words are always compiled, and the compilers do not have to be invoked explicitly. For the most part, compilation is a fully transparent process. However, there are a few things worth knowing about the compilation process."
$nl
"The optimizing compiler trades off compile time for performance of generated code, so loading certain vocabularies might take a while. Saving the image after loading vocabularies can save you a lot of time that you would spend waiting for the same code to load in every coding session; see " { $link "images" } " for information."
$nl
"After loading a vocabulary, you might see messages like:"
{ $code
    ":errors - print 2 compiler errors."
    ":warnings - print 50 compiler warnings."
}
"These warnings arise from the compiler's stack effect checker. Warnings are non-fatal conditions -- not all code has a static stack effect, so you try to minimize warnings but understand that in many cases they cannot be eliminated. Errors indicate programming mistakes, such as erroneous stack effect declarations."
{ $references
    "To learn more about the compiler and static stack effect inference, read these articles:"
    "compiler"
    "compiler-errors"
    "inference"
} ;

ARTICLE: "cookbook-application" "Application cookbook"
"Vocabularies can define a main entry point:"
{ $code "IN: game-of-life"
"..."
": play-life ... ;"
""
"MAIN: play-life"
}
"See " { $link POSTPONE: MAIN: } " for details. The " { $link run } " word loads a vocabulary if necessary, and calls its main entry point; try the following, it's fun:"
{ $code "\"tetris\" run" }
"On Mac OS X and Windows, stand-alone applications can also be deployed; these are genuine, 100% native code double-clickable executables:"
{ $code "\"tetris\" deploy-tool" }
{ $references
    { }
    "vocabs.loader"
    "tools.deploy"
    "ui.tools.deploy"
    "cookbook-scripts"
} ;

ARTICLE: "cookbook-scripts" "Scripting cookbook"
"Factor can be used for command-line scripting on Unix-like systems."
$nl
"A text file can begin with a comment like the following, and made executable:"
{ $code "#! /usr/bin/env factor -script" }
"Running the text file will run it through Factor, assuming the " { $snippet "factor" } " binary is in your " { $snippet "$PATH" } "."
$nl
"The space between " { $snippet "#!" } " and " { $snippet "/usr/bin/env" } " is necessary, since " { $link POSTPONE: #! } " is a parsing word, and a syntax error would otherwise result. The " { $snippet "-script" } " switch suppresses compiler messages, and exits Factor when the script finishes."
{ $references
    { }
    "cli"
    "cookbook-application"
} ;

ARTICLE: "cookbook-philosophy" "Factor philosophy"
"Learning a stack language is like learning to ride a bicycle: it takes a bit of practice and you might graze your knees a couple of times, but once you get the hang of it, it becomes second nature."
$nl
"The most common difficulty encountered by beginners is trouble reading and writing code as a result of trying to place too many values on the stack at a time."
$nl
"Keep the following guidelines in mind to avoid losing your sense of balance:"
{ $list
    "Simplify, simplify, simplify. Break your program up into small words which operate on a few values at a time. Most word definitions should fit on a single line; very rarely should they exceed two or three lines."
    "In addition to keeping your words short, keep them meaningful. Give them good names, and make sure each word only does one thing. Try documenting your words; if the documentation for a word is unclear or complex, chances are the word definition is too. Don't be afraid to refactor your code."
    "If your code looks repetitive, factor it some more."
    "If after factoring, your code still looks repetitive, introduce combinators."
    "If after introducing combinators, your code still looks repetitive, look into using meta-programming techniques."
    "Try to place items on the stack in the order in which they are needed. If everything is in the correct order, no shuffling needs to be performed."
    "If you find yourself writing a stack comment in the middle of a word, break the word up."
    { "Use " { $link "cleave-combinators" } " and " { $link "spread-combinators" } " instead of " { $link "shuffle-words" } " to give your code more structure." }
    { "Not everything has to go on the stack. The " { $vocab-link "namespaces" } " vocabulary provides dynamically-scoped variables, and the " { $vocab-link "locals" } " vocabulary provides lexically-scoped variables. Learn both and use them where they make sense, but keep in mind that overuse of variables makes code harder to factor." }
    "Every time you define a word which simply manipulates sequences, hashtables or objects in an abstract way which is not related to your program domain, check the library to see if you can reuse an existing definition."
    { "Learn to use the " { $link "inference" } " tool." }
    { "Write unit tests. Factor provides good support for unit testing; see " { $link "tools.test" } ". Once your program has a good test suite you can refactor with confidence and catch regressions early." }
    "Don't write Factor as if it were C. Imperative programming and indexed loops are almost always not the most idiomatic solution."
    { "Use sequences, assocs and objects to group related data. Object allocation is very cheap. Don't be afraid to create tuples, pairs and triples. Don't be afraid of operations which allocate new objects either, such as " { $link append } "." }
    { "If you find yourself writing a loop with a sequence and an index, there's almost always a better way. Learn the " { $link "sequences-combinators" } " by heart." }
    { "If you find yourself writing a heavily nested loop which performs several steps on each iteration, there is almost always a better way. Break the problem down into a series of passes over the data instead, gradually transforming it into the desired result with a series of simple loops. Factor the loops out and reuse them. If you're working on anything math-related, learn " { $link "math-vectors" } " by heart." }
    { "If you find yourself wishing you could iterate over the datastack, or capture the contents of the datastack into a sequence, or push each element of a sequence onto the datastack, there is almost always a better way. Use " { $link "sequences" } " instead." }
    "Don't use meta-programming if there's a simpler way."
    "Don't worry about efficiency unless your program is too slow. Don't prefer complex code to simple code just because you feel it will be more efficient. The Factor compiler is designed to make idiomatic code run fast."
    { "None of the above are hard-and-fast rules: there are exceptions to all of them. But one rule unconditionally holds: " { $emphasis "there is always a simpler way" } "." }
}
"Factor tries to implement as much of itself as possible, because this improves simplicity and performance. One consequence is that Factor exposes its internals for extension and study. You even have the option of using low-level features not usually found in high-level languages, such manual memory management, pointer arithmetic, and inline assembly code."
$nl
"Unsafe features are tucked away so that you will not invoke them by accident, or have to use them to solve conventional programming problems. However when the need arises, unsafe features are invaluable, for example you might have to do some pointer arithmetic when interfacing directly with C libraries." ;
ARTICLE: "cookbook-pitfalls" "Pitfalls to avoid"
"Factor is a very clean and consistent language. However, it has some limitations and leaky abstractions you should keep in mind, as well as behaviors which differ from other languages you may be used to."
{ $list
    "Factor only makes use of one native thread, and Factor threads are scheduled co-operatively. C library calls block the entire VM."
    "Factor does not hide anything from the programmer, all internals are exposed. It is your responsibility to avoid writing fragile code which depends too much on implementation detail."
    { "When a source file uses two vocabularies which define words with the same name, the order of the vocabularies in the " { $link POSTPONE: USE: } " or " { $link POSTPONE: USING: } " forms is important. The parser prints warnings when vocabularies shadow words from other vocabularies; see " { $link "vocabulary-search-shadow" } ". The " { $vocab-link "qualified" } " vocabulary implements qualified naming, which can be used to resolve ambiguities." }
    { "If a literal object appears in a word definition, the object itself is pushed on the stack when the word executes, not a copy. If you intend to mutate this object, you must " { $link clone } " it first. See " { $link "syntax-literals" } "." }
    { "For a discussion of potential issues surrounding the " { $link f } " object, see " { $link "booleans" } "." }
    { "Factor's object system is quite flexible. Careless usage of union, mixin and predicate classes can lead to similar problems to those caused by ``multiple inheritance'' in other languages. In particular, it is possible to have two classes such that they have a non-empty intersection and yet neither is a subclass of the other. If a generic word defines methods on two such classes, method precedence is undefined for objects that are instances of both classes. See " { $link "method-order" } " for details." }
    { "Performance-sensitive code should have a static stack effect so that it can be compiled by the optimizing word compiler, which generates more efficient code than the non-optimizing quotation compiler. See " { $link "inference" } " and " { $link "compiler" } "."
    $nl
    "This means that methods defined on performance sensitive, frequently-called core generic words such as " { $link nth } " should have static stack effects which are consistent with each other, since a generic word will only have a static stack effect if all methods do."
    $nl
    "Unit tests for the " { $vocab-link "inference" } " vocabulary can be used to ensure that any methods your vocabulary defines on core generic words have static stack effects:"
    { $code "\"inference\" test" }
    "In general, you should strive to write code with inferable stack effects, even for sections of a program which are not performance sensitive; the " { $link infer. } " tool together with the optimizing compiler's error reporting can catch many bugs ahead of time." }
    { "Be careful when calling words which access variables from a " { $link make-assoc } " which constructs an assoc with arbitrary keys, since those keys might shadow variables." }
    { "If " { $link run-file } " throws a stack depth assertion, it means that the top-level form in the file left behind values on the stack. The stack depth is compared before and after loading a source file, since this type of situation is almost always an error. If you have a legitimate need to load a source file which returns data in some manner, define a word in the source file which produces this data on the stack and call the word after loading the file." }
} ;

ARTICLE: "cookbook" "Factor cookbook"
"The Factor cookbook is a high-level overview of the most important concepts required to program in Factor."
{ $subsection "cookbook-syntax" }
{ $subsection "cookbook-colon-defs" }
{ $subsection "cookbook-combinators" }
{ $subsection "cookbook-variables" }
{ $subsection "cookbook-vocabs" }
{ $subsection "cookbook-io" }
{ $subsection "cookbook-application" }
{ $subsection "cookbook-scripts" }
{ $subsection "cookbook-compiler" }
{ $subsection "cookbook-philosophy" }
{ $subsection "cookbook-pitfalls" } ;

ABOUT: "cookbook"
