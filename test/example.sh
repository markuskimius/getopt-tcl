#!/bin/sh
#
# Example of how to use getopt-tcl, the getopt library for Tcl.
# https://github.com/markuskimius/getopt-tcl
#
# Copyright Mark K. Kim
# Released under the Apache license 2.0
# https://github.com/markuskimius/getopt-tcl/blob/master/LICENSE
#
#\
exec tclsh "$0" "$@"

source "../src/getopt.tcl"


# Defaults
set opts(files)  [list]
set opts(output) "-"
set opts(port)   8080


proc usage { } {
    global opts

    puts stderr "Usage: test \[option\] \[file\]"
    puts stderr ""
    puts stderr "Example script to show how to use getopt.tcl"
    puts stderr ""
    puts stderr "Options:"
    puts stderr "  \[file\]                       Input file(s)"
    puts stderr "  -o <file>, --output=<file>   Output file \[default=none\]"
    puts stderr "  -p <port>, --port=<port>     Port number, must be within (1024, 65535\] \[default=$opts(port)\]"
    puts stderr "  -h, --help                   Show help screen (this screen)"
    puts stderr ""

    exit 1
}


proc main { argv } {
    global opts
    set errcount 0

    while { 1 } {
        set c [getopt $argv "o 1 output 1 p is_port port is_port h 0 help 0"]
        if { $c == -1 } break

        switch -exact -- $c {
            -       { lappend opts(files) $optarg }
            o       -
            output  { set opts(output) $optarg    }
            p       -
            port    { set opts(port) $optarg      }
            h       -
            help    { usage                       }
            default { incr errcount               }
        }
    }

    if { $errcount > 0 } {
        usage
    }

    if { [llength $opts(files)] == 0 } {
        puts stderr "$::argv0: must specify at least one file"
        usage
    }

    foreach file $opts(files) {
        do_my_thing $file
    }
}


proc is_port { val } {
    set isPort 0

    if { [string is integer $val] && $val > 1024 && $val <= 65535 } {
        set isPort 1
    }

    return $isPort
}


proc do_my_thing { file } {
    global opts
    set output $opts(output)

    if { $output eq "-" } {
        set output "stdout"
    }

    puts "$output: read $file via port $opts(port)"
}


main $argv

# vim:ts=4:sts=4:et:ai
