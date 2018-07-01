#!/bin/sh
#
# Example showing how to use getopt-tcl, the getopt library for Tcl.
# https://github.com/markuskimius/getopt-tcl
#
# This script works like cat, with options.
#
# Copyright Mark K. Kim
# Released under the Apache license 2.0
# https://github.com/markuskimius/getopt-tcl/blob/master/LICENSE
#
#\
exec tclsh "$0" "$@"

lappend auto_path "../lib"
package require getopt


# Defaults
set opts(files)    [list]
set opts(output)   "-"
set opts(number)   0
set opts(head)     0
set opts(help)     0


proc usage { } {
    global opts

    puts {Usage: test [option] [file]}
    puts {}
    puts {Example script to show how to use getopt.tcl}
    puts {}
    puts {Options:}
    puts {  [file]                       Input file(s) [default=stdin]}
    puts {  -o <file>, --output=<file>   Output file [default=stdout]}
    puts {}
    puts {  -n, --number                 Show line numbers}
    puts {  -H <NUM>, --head=<NUM>       Head operation - show <NUM> lines}
    puts {}
    puts {  -h, --help                   Show help screen (this screen)}
    puts {}
}


proc main { argv } {
    global opts
    set ofs stdout
    set errcount 0

    # Process options
    while { 1 } {
        set c [getopt $argv "o 1 output 1 n 0 number 0 H is_int head is_int h 0 help 0"]
        if { $c == -1 } break

        switch -exact -- $c {
            -          { lappend opts(files) $optarg }
            o - output { set opts(output) $optarg    }
            n - number { set opts(number) 1          }
            H - head   { set opts(head) $optarg      }
            h - help   { set opts(help) 1            }
            default    { incr errcount               }
        }
    }

    # Sanity check
    if { $errcount > 0 } {
        puts stderr ""
        puts stderr "Type '$::argv0 --help' for help"
        exit 1
    }

    # Help screen
    if { $opts(help) } {
        usage
        exit
    }

    # Open output.  Consider "-" as stdout.
    if { $opts(output) ne "-" } {
        if { [catch {set ofs [open $opts(output) w]} err] } {
            puts stderr $err
            exit 1
        }
    }

    # Read stdin by default
    if { [llength $opts(files)] == 0 } {
        lappend opts(files) "-"
    }

    # cat input files
    foreach file $opts(files) {
        cat $ofs $file
    }

    close $ofs
}


proc is_int { val } {
    return [string is integer -strict $val]
}


###########################################################################
# Cat a file.  Any options specified in ::opts are honored.
#
# @param ofs   Channel to output to.
# @param file  File to cat. "-" is considered stdin.
#
proc cat { ofs file } {
    global opts
    set ifs stdin
    set num 0

    # Open input file, enable line buffering
    if { $file ne "-" } {
        if { [catch {set ifs [open $file r]} err] } {
            puts stderr $err
            exit 1
        }

        fconfigure $ifs -buffering line
    }

    # cat the file
    while { [gets $ifs line] >= 0 } {
        incr num

        # Head
        if { $opts(head) && ( $num > $opts(head) ) } break

        # Line numbers
        if { $opts(number) } {
            set line [format "%3d %s" $num $line]
        }

        puts $ofs $line
    }

    # Close input file
    if { $ifs ne "stdin" } {
        close $ifs
    }
}


main $argv

# vim:ts=4:sts=4:et:ai
