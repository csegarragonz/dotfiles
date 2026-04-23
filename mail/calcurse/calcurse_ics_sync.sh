#!/usr/bin/env bash
set -euo pipefail

ICS_URL="https://outlook.office365.com/owa/calendar/28c9699b664a471c97d280b04595fa93@imperial.ac.uk/e35baedbfacb41dc84d1da625e1dc9df5431371069347241266/calendar.ics"

# Separate calcurse "database" just for the subscribed Outlook calendar
DATADIR="${XDG_DATA_HOME:-$HOME/.local/share}/calcurse-outlook-ics"
TMP="$(mktemp)"

mkdir -p "$DATADIR"

# Fetch the ICS (follow redirects)
curl -fsSL "$ICS_URL" -o "$TMP"

# Replace the local dataset each time (avoid duplicates)
rm -f "$DATADIR"/*

# Import into that dataset
echo "Importing calcurse data to dir: ${DATADIR}"
calcurse --datadir "$DATADIR" --import "$TMP"

rm -f "$TMP"
