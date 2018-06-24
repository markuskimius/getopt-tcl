#
# getopt library for Tcl v0.0.1
# https://github.com/markuskimius/getopt-tcl
#
# Copyright Mark K. Kim
# Released under the Apache license 2.0
# https://github.com/markuskimius/getopt-tcl/blob/master/LICENSE
#
proc getopt { argv optstring } {
    array set optarray $optstring
    upvar optopt optopt
    upvar optarg optarg
    upvar optind optind
    upvar optdon optdon
    set optarg ""
    set optopt 0

    # Initialize
    if { ! [info exists optind] } { set optind 0 }
    if { $optind == 0 } { set optdon 0 }

    # Get the next argument
    if { $optind < [llength $argv] } {
        set optarg [lindex $argv $optind]
        incr optind
    } else {
        return -1
    }

    # If we previously encountered "--", we're done
    if { $optdon } {
        return 1
    }

    # Is this "--"? If so, get the next argument
    if { $optarg eq "--" } {
        set optdon 1
        return [getopt $argv $optstring]
    }

    # Is this an option or an argument?
    if { [string index $optarg 0] eq "-" } {
        set optopt [string range $optarg 1 end]
        set optarg ""
    } else {
        return 1
    }

    # Is this a valid option?
    if { [info exists optarray($optopt)] } {
        set v_fn $optarray($optopt)
    } else {
        puts stderr "$::argv0: invalid option -- '$optopt'"
        return "?"
    }

    # Does this option take an argument?
    if { [string is integer $v_fn] && ! $v_fn } {
        # No
        return $optopt
    }

    # Is there an argument for us to read?
    if { $optind < [llength $argv] } {
        set optarg [lindex $argv $optind]
        incr optind
    } else {
        puts stderr "$::argv0: option requires an argument -- '$optopt'"
        return "?"
    }

    # Do we need to validate the argument?
    if { [string is integer $v_fn] } {
        # No validation needed
    } elseif { [info procs $v_fn] ne $v_fn } {
        # Sanity check
        puts stderr "$::argv0: invalid validation function -- '$v_fn'"
        eval $v_fn $optarg
    } elseif { [eval $v_fn $optarg] } {
        # Validation passed - nothing to do
    } else {
        # Validation fail
        puts stderr "$::argv0: invalid argument to option '$optopt' -- '$optarg'"
        return "?"
    }

    # Option has a valid argument
    return $optopt
}
