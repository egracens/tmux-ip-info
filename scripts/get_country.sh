#!/bin/bash
# Shows country code (reads from cache populated by get_ip.sh)

CACHE_FILE="/tmp/tmux_ip_cache"

if [ -f "$CACHE_FILE" ]; then
    tail -1 "$CACHE_FILE"
else
    echo "N/A"
fi
