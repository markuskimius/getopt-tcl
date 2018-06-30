#
# getopt library for Tcl v0.1
# https://github.com/markuskimius/getopt-tcl
#
# Copyright Mark K. Kim
# Released under the Apache license 2.0
# https://github.com/markuskimius/getopt-tcl/blob/master/LICENSE
#

package provide getopt 0.1


proc getopt { argv optstring } {
    array set optarray $optstring
    upvar optopt optopt
    upvar optarg optarg
    upvar optind optind
    upvar optext optext
    set optarg ""
    set optopt 0
    set islong 0
    set gotarg 0
    set NONOPTION "-"
    set ERROR "?"
    set EOF -1

    # Initialize
    if { ! [info exists optind] || $optext(argv) ne $argv } {
        set optind 0
        set optext(done) 0
        set optext(argv) $argv
        set optext(subind) 1
    }

    # Get the next argument
    if { $optind < [llength $argv] } {
        set optarg [lindex $argv $optind]
        incr optind
    } else {
        return $EOF
    }

    # If we previously encountered "--", we're done
    if { $optext(done) } {
        return $NONOPTION
    }

    # Is this "--"? If so, get the next argument
    if { $optarg eq "--" } {
        set optext(done) 1
        return [getopt $argv $optstring]
    }

    # Is this a long option, short option, or an optionless argument?
    if { [string range $optarg 0 1] eq "--" } {
        set optopt [string range $optarg 2 end]
        set optarg ""
        set islong 1

        # --optopt=optarg
        if { [string first "=" $optopt] >= 0 } {
            set optarg [join [lrange [split $optopt "="] 1 end] "="]
            set optopt [lindex [split $optopt "="] 0]
            set gotarg 1
        }
    } elseif { [string index $optarg 0] eq "-" && [string length $optarg] > 1 } {
        set optopt [string index $optarg $optext(subind)]
        incr optext(subind)

        # Go to the next subindex
        if { $optext(subind) < [string length $optarg] } {
            # We need to take back one index because we previously increased
            # prematurely previously.
            incr optind -1
        } else {
            set optext(subind) 1
        }

        set optarg ""
    } else {
        return $NONOPTION
    }

    # Is this a valid option?
    if { [info exists optarray($optopt)] } {
        set v_fn $optarray($optopt)
    } else {
        puts stderr "$::argv0: invalid option -- '$optopt'"
        return $ERROR
    }

    # Does this option take an argument?
    if { [string is integer $v_fn] && ! $v_fn } {
        # No
        return $optopt
    }

    # Is there an argument for us to read?
    if { $islong && $gotarg } {
        # Nothing to do
    } elseif { $islong } {
        # Get arg
        set optarg [lindex $argv $optind]
        incr optind
    } elseif { $optind < [llength $argv] } {
        set optarg [lindex $argv $optind]
        incr optind

        if { $optext(subind) > 1 } {
            set optarg [string range $optarg $optext(subind) end]
            set optext(subind) 1
        }
    } else {
        puts stderr "$::argv0: option requires an argument -- '$optopt'"
        return $ERROR
    }

    # Do we need to validate the argument?
    if { [string is integer $v_fn] } {
        # No validation needed
    } elseif { [info procs $v_fn] ne $v_fn } {
        # We should never get here. Show error message then crash so the
        # developer can see the stacktrace and debug their code.
        puts stderr "$::argv0: invalid validation function -- '$v_fn'"
        eval [list $v_fn $optarg]
    } elseif { [eval [list $v_fn $optarg]] } {
        # Validation passed - nothing to do
    } else {
        # Validation fail
        puts stderr "$::argv0: invalid value as an argument to option '$optopt' -- '$optarg'"
        return $ERROR
    }

    # Option has a valid argument
    return $optopt
}
