! Copyright (c) 2008 Aaron Schaefer.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel math.ranges project-euler.common sequences sequences.lib ;
IN: project-euler.034

! http://projecteuler.net/index.php?section=problems&id=34

! DESCRIPTION
! -----------

! 145 is a curious number, as 1! + 4! + 5! = 1 + 24 + 120 = 145.

! Find the sum of all numbers which are equal to the sum of the factorial of
! their digits.

! Note: as 1! = 1 and 2! = 2 are not sums they are not included.


! SOLUTION
! --------

! We can reduce the upper bound a little by calculating 7 * 9! = 2540160, and
! then reducing one of the 9! to 2! (since the 7th digit cannot exceed 2), so we
! get 2! + 6 * 9! = 2177282 as an upper bound.

! We can then take that one more step, and notice that the largest factorial
! sum a 7 digit number starting with 21 or 20 is 2! + 1! + 5 * 9! or 1814403.
! So there can't be any 7 digit solutions starting with 21 or 20, and therefore
! our numbers must be less that 2000000.

<PRIVATE

: digit-factorial ( n -- n! )
    { 1 1 2 6 24 120 720 5040 40320 362880 } nth ;

: factorion? ( n -- ? )
    dup number>digits [ digit-factorial ] sigma = ;

PRIVATE>

: euler034 ( -- answer )
    3 2000000 [a,b] [ factorion? ] subset sum ;

! [ euler034 ] 10 ave-time
! 15089 ms run / 725 ms GC ave time - 10 trials

MAIN: euler034
