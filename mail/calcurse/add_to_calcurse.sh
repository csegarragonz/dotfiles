#!/bin/bash
#
# Import text/calendar files from mutt
# to calcurse.
#
# Copied from:
# http://hentenaar.com/keeping-track-of-meetings-with-mutt-calcurse

# Make sure calcurse is running
if [ ! -f "$HOME/.calcurse/.calcurse.pid" ]; then
	exit 1
fi

# Extract the attachments
TEMPDIR=$(mktemp -d add-to-calcurse.XXXXXXXX)
cat "$@" | uudeview -i -m -n -q -p $TEMPDIR - > /dev/null 2>&1

# Add the calendar file
FILE=$(file $TEMPDIR/* | grep vCalendar | cut -d: -f1 | head -1)
calcurse -i $FILE > /dev/null 2>&1

# Remove the temporary dir and trigger a reload in calcurse
rm -rf $TEMPDIR > /dev/null 2>&1
kill -USR1 `cat $HOME/.calcurse/.calcurse.pid` > /dev/null 2>&1
