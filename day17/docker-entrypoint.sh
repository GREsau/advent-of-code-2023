#!/bin/sh
. gtmprofile
export gtmroutines="$gtmroutines "`pwd`
exec "$@"
