#!/bin/sh
#
# Regression test script for getopt-tcl, the getopt library for Tcl.
# https://github.com/markuskimius/getopt-tcl
#
# Copyright Mark K. Kim
# Released under the Apache license 2.0
# https://github.com/markuskimius/getopt-tcl/blob/master/LICENSE
#
#\
exec tclsh "$0" "$@"

lappend auto_path "../lib"
package require getopt


proc main { argv } {
    puts "*** BASIC ***"
    test myarg1
    test -n
    test --no-arg
    test -w warg1
    test --with-arg warg1
    test --with-arg=warg1
    test -i1024
    test -i 1024
    test --integer 1024
    test --integer=1024
    test --opt-arg 128
    test --opt-arg=128

    puts "*** REPETITIONS ***"
    test myarg1 myarg2
    test -nn
    test --no-arg --no-arg
    test -w warg1 -w warg2
    test -wwarg1 -wwarg2
    test --with-arg warg1 --with-arg warg2
    test --with-arg=warg1 --with-arg=warg2
    test -i1024 -i2048
    test -i 1024 -i 2048
    test --integer 1024 --integer 2048
    test --integer=1024 --integer=2048
    test --opt-arg 128 --opt-arg 256
    test --opt-arg=128 --opt-arg=256

    puts "*** COMBINATION (RELATED) ***"
    test -n --no-arg
    test -wwarg1 -w warg2 --with-arg warg3 --with-arg=warg4
    test -i1024 -i 2048 --integer 3072 --integer=4096

    puts "*** COMBINATION (COMPREHENSIVE) ***"
    test -n --no-arg -wwarg1 -w warg2 --with-arg warg3 --with-arg=warg4 -i1024 -i 2048 --integer 3072 --integer=4096 --opt-arg 128 --opt-arg=256 myarg1
    test --no-arg -nwwarg1 -w warg2 --with-arg warg3 --with-arg=warg4 -i1024 -i 2048 --integer 3072 --integer=4096 --opt-arg 128 --opt-arg=256 myarg1
    test --no-arg -wwarg1 -nw warg2 --with-arg warg3 --with-arg=warg4 -i1024 -i 2048 --integer 3072 --integer=4096 --opt-arg 128 --opt-arg=256 myarg1
    test --no-arg -wwarg1 -w warg2 --with-arg warg3 --with-arg=warg4 -ni1024 -i 2048 --integer 3072 --integer=4096 --opt-arg 128 --opt-arg=256 myarg1
    test --no-arg -wwarg1 -w warg2 --with-arg warg3 --with-arg=warg4 -i1024 -ni 2048 --integer 3072 --integer=4096 --opt-arg 128 --opt-arg=256 myarg1
    test --no-arg -wwarg1 -w warg2 --with-arg warg3 --with-arg=warg4 -i1024 -i 2048 --integer 3072 --integer=4096 --opt-arg 128 --opt-arg=256 myarg1 -n
    test --no-arg -wwarg1 -w warg2 --with-arg warg3 --with-arg=warg4 -i1024 -i 2048 --integer 3072 --integer=4096 --opt-arg 128 --opt-arg=256 -n myarg1
    test --no-arg -w warg1 --with-arg warg2 --with-arg=warg3 -i1024 -i 2048 --integer 3072 --integer=4096 --opt-arg 128 --opt-arg=256 myarg1 -nwwarg4
    test --no-arg -w warg1 --with-arg warg2 --with-arg=warg3 -i1024 -i 2048 --integer 3072 --integer=4096 --opt-arg 128 --opt-arg=256 -nwwarg4 myarg1
    test --no-arg -wwarg1 --with-arg warg2 --with-arg=warg3 -i1024 -i 2048 --integer 3072 --integer=4096 --opt-arg 128 --opt-arg=256 myarg1 -nw warg4
    test --no-arg -wwarg1 --with-arg warg2 --with-arg=warg3 -i1024 -i 2048 --integer 3072 --integer=4096 --opt-arg 128 --opt-arg=256 -nw warg4 myarg1
    test --no-arg -wwarg1 -w warg2 --with-arg warg3 --with-arg=warg4 -i 1024 --integer 2048 --integer=3072 --opt-arg 128 --opt-arg=256 myarg1 -ni4096
    test --no-arg -wwarg1 -w warg2 --with-arg warg3 --with-arg=warg4 -i 1024 --integer 2048 --integer=3072 --opt-arg 128 --opt-arg=256 -ni4096 myarg1
    test --no-arg -wwarg1 -w warg2 --with-arg warg3 --with-arg=warg4 -i1024 --integer 2048 --integer=3072 --opt-arg 128 --opt-arg=256 myarg1 -ni 4096
    test --no-arg -wwarg1 -w warg2 --with-arg warg3 --with-arg=warg4 -i1024 --integer 2048 --integer=3072 --opt-arg 128 --opt-arg=256 -ni 4096 myarg1

    puts "*** EMPTY ARGS ***"
    test -n --no-arg -wwarg1 -w "" --with-arg warg2 --with-arg=warg3 -i1024 -i 2048 --integer 3072 --integer=4096 myarg1
    test -n --no-arg -wwarg1 -w warg2 --with-arg "" --with-arg=warg3 -i1024 -i 2048 --integer 3072 --integer=4096 myarg1
    test -n --no-arg -wwarg1 -w warg2 --with-arg warg3 --with-arg= -i1024 -i 2048 --integer 3072 --integer=4096 myarg1
    test -n --no-arg -wwarg1 -w warg2 --with-arg warg3 -i1024 -i 1024 --integer 2048 --integer=3072 myarg1 --with-arg=
    test -n --no-arg -wwarg1 -w warg2 --with-arg warg3 -i1024 -i 1024 --integer 2048 --integer=3072 --with-arg= myarg1
    test -n --no-arg -wwarg1 -w "" --opt-arg warg2 --opt-arg=warg3 -i1024 -i 2048 --integer 3072 --integer=4096 myarg1
    test -n --no-arg -wwarg1 -w warg2 --opt-arg "" --opt-arg=warg3 -i1024 -i 2048 --integer 3072 --integer=4096 myarg1
    test -n --no-arg -wwarg1 -w warg2 --opt-arg warg3 --opt-arg= -i1024 -i 2048 --integer 3072 --integer=4096 myarg1
    test -n --no-arg -wwarg1 -w warg2 --opt-arg warg3 -i1024 -i 1024 --integer 2048 --integer=3072 myarg1 --opt-arg=
    test -n --no-arg -wwarg1 -w warg2 --opt-arg warg3 -i1024 -i 1024 --integer 2048 --integer=3072 --opt-arg= myarg1

    puts "*** EXCEPTIONS (EMPTY INTEGER ARGS) ***"
    test -n --no-arg -wwarg1 -w warg2 --with-arg warg3 --with-arg=warg4 -i1024 -i "" --integer 2048 --integer=3072 myarg1
    test -n --no-arg -wwarg1 -w warg2 --with-arg warg3 --with-arg=warg4 -i1024 -i 2048 --integer "" --integer=3072 myarg1
    test -n --no-arg -wwarg1 -w warg2 --with-arg warg3 --with-arg=warg4 -i1024 -i 2048 --integer 3072 --integer= myarg1

    puts "*** EXCEPTIONS (MISSING MANDATORY ARGS) ***"
    test -n --no-arg -w warg1 --with-arg warg2 --with-arg=warg3 -i1024 -i 1024 --integer 2048 --integer=3072 myarg1 -w
    test -n --no-arg -wwarg1 --with-arg warg2 --with-arg=warg3 -i1024 -i 1024 --integer 2048 --integer=3072 myarg1 -w
    test -n --no-arg -wwarg1 -w warg2 --with-arg=warg3 -i1024 -i 1024 --integer 2048 --integer=3072 myarg1 --with-arg
    test -n --no-arg -wwarg1 -w warg2 --with-arg warg3 --with-arg=warg4 -i 1024 --integer 2048 --integer=3072 myarg1 -i
    test -n --no-arg -wwarg1 -w warg2 --with-arg warg3 --with-arg=warg4 -i1024 --integer 2048 --integer=3072 myarg1 -i
    test -n --no-arg -wwarg1 -w warg2 --with-arg warg3 --with-arg=warg4 -i1024 -i 2048 --integer=3072 myarg1 --integer
    test -n --no-arg -wwarg1 -w warg2 --with-arg warg3 --with-arg=warg4 -i1024 -i 2048 --integer 3072 --integer= myarg1
    test -n --no-arg -wwarg1 -w warg2 --with-arg warg3 --with-arg=warg4 -i1024 -i 2048 --integer 3072 myarg1 --integer=
}


proc test { args } {
    puts "  target $args:"
    array set output [eval target $args]

    foreach name [lsort -dictionary [array names output]] {
        puts "  $name = $output($name)"
    }

    puts ""
}


proc target { args } {
    array set opts [list]

    while { 1 } {
        set c [getopt $args "n 0 no-arg 0 w 1 with-arg 1 i is_int integer is_int opt-arg (is_int,null)"]
        if { $c == -1 } break

        lappend opts(-|opts)  $optopt
        lappend opts(-|index) $optind

        switch -exact -- $c {
            -            { lappend opts(0) $optarg }
            n - no-arg   { lappend opts(n) $optarg }
            w - with-arg { lappend opts(w) $optarg }
            i - integer  { lappend opts(i) $optarg }
            o - opt-arg  { lappend opts(o) $optarg }
            default      { lappend opts(x) $optarg }
        }
    }

    return [array get opts]
}


proc is_int { val } {
    return [string is integer -strict $val]
}


main $argv

# vim:ts=4:sts=4:et:ai
