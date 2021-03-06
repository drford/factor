USING: assocs words sequences arrays compiler tools.time
io.styles io prettyprint vocabs kernel sorting generator
optimizer math ;
IN: report.optimizer

: count-optimization-passes ( nodes n -- n )
    >r optimize-1
    [ r> 1+ count-optimization-passes ] [ drop r> ] if ;

: results
    [ [ second ] swap compose compare ] curry sort 20 tail*
    print
    standard-table-style
    [
        [ [ [ pprint-cell ] each ] with-row ] each
    ] tabular-output ; inline

: optimizer-measurements ( -- alist )
    all-words [ compiled? ] subset
    [
        dup [
            word-dataflow nip 1 count-optimization-passes
        ] benchmark nip 2array
    ] { } map>assoc ;

: optimizer-measurements. ( alist -- )
    [ [ first ] "Worst number of optimizer passes:" results ]
    [ [ second ] "Worst compile times:" results ] bi ;

: optimizer-report ( -- )
    optimizer-measurements optimizer-measurements. ;

MAIN: optimizer-report
