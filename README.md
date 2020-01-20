# getopt-tcl
A getopt library for Tcl.


## Features

The feature set is based on GNU `getopt_long`:

- Short options. Options may be combined (`-a -b -c` is equivalent to `-abc`).
  Option arguments, if any, may appear with or without a space (`-o value` is
  equivalent to `-ovalue`).
- Long options. Option arguments, if any, may appear with or without an equal sign
  (`--option value` is equivalent to `--option=value`).
- Optional arguments are supported. The optional argument for a short option
  must be specified without a space (`-ovalue`) and for a long option must be
  specified with an equal sign (`--option=value`).
- Options (with or without arguments) and optionless arguments may appear in
  any order.
- `--` can be used to denote the end of options.


## Usage
```tcl
set c [getopt $argv $optstring]
```

All parameters are mandatory:
- `argv` - The argument list.
- `optstring` - A list containing the valid list of options and a specification
  of whether they take an argument. The list must contain an even number of
  items, even index containing the name of the option, and odd index containing
  `0` if the option takes no argument, or `1` if it takes an argument. Instead of
  `0` or `1`, it may specify a validation function that returns `1` if the
  argument is valid, or `0` otherwise.

The proc returns a single value which may be one of:
- `-1`: End of `argv` processing.
- `-`: An optionless argument. The value of the argument is stored in `optarg`.
- `?`: An invalid option. An error message has been printed to `stderr` and the
  option that caused the error is stored in `optopt`.
- All other values: A valid option. This value is also stored in `optopt`. If
  the option takes an argument, the value is stored in `optarg`.

The following variable names are reserved:
- `optind`: The index of the next `argv`.
- `optopt`: The last option processed.
- `optarg`: The argument to the last option.
- `optext`: Extra settings for internal use.

These variables are created by `getopt` in the caller's scope using `upvar`.
This allows calls to `getopt` be nested or called from multiple scopes.


## Example
```tcl
while { 1 } {
    set c [getopt $argv "h 0 help 0 o 1 output 1 p is_port port is_port v (is_int,1) verbose (is_int,1)"]
    if { $c == -1 } break

    switch -exact -- $c {
        -           { lappend opts(files) $optarg }
        h - help    { usage ; exit                }
        o - output  { set opts(output) $optarg    }
        p - port    { set opts(port) $optarg      }
        v - verbose { set opts(verbose) $optarg   }
        default     { exit 1                      }
    }
}
```

In the above example, single character options `h`, `o`, `p` may be
specified with a single hyphen (`-h`, `-o`, `-p`). Two hyphens are also
accepted. The others must be specified with two hyphens (`--help`,
`--output`, `--port`).

- `-h` and `--help` take no arguments since the value that follows each is 0.
- `-o` and `--output` take any argument since the value that follows each is 1.
- `-p` and `--port` take an argument whose value must pass a test by `is_port`. For example,

```tcl
proc is_port { value } {
    set isport 0

    # A port must be a positive integer less than 2^16. Also, UNIX doesn't
    # allow a port number < 1024 except as root.
    if { [string is integer -strict $value] && $value >= 1024 && $value < 65536 } {
        set isport 1
    }

    return $isport
}
```

Finally, `-v` and `--verbose` take an optional argument whose value, if any,
must pass the test by `is_int`. If no value is specified, the value defaults to
`1`.

See [example.sh] for a more complete example.


## License

[Apache 2.0]


[example.sh]: <https://github.com/markuskimius/getopt-tcl/blob/master/test/example.sh>
[Apache 2.0]: <https://github.com/markuskimius/getopt-tcl/blob/master/LICENSE>

