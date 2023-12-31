#!/bin/awk

# This is to easily number the dialogs in YAML files
# It looks for d[[:digit:]]+: and replaces it with di:
# Where i starts at 1 and increments with each replacement

BEGIN {
    i = 1;
}

# Match any tag of the form dn: where n is a number
/d[[:digit:]]+:/ {
    print "d" i ":";
    ++i
    next;
}

# Default: do nothing
{ print $0; }