#!/usr/bin/env bash
# Usage: ssh-match-date.sh <YYYY-MM-DD>
# Returns 0 (true) if today >= given date, 1 otherwise.
# Designed for SSH config: Match host * exec "~/.ssh/ssh-match-date.sh 2026-04-28"
[ $(date +%s) -ge $(date -jf '%Y-%m-%d' "$1" +%s 2>/dev/null) ]
