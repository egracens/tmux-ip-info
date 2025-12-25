#!/bin/bash
# Shows public IP address (fetches and caches both IP and country)

CACHE_FILE="/tmp/tmux_ip_cache"
CACHE_TTL=60  # 1 minute

# Check if cache is fresh
if [ -f "$CACHE_FILE" ]; then
    cache_age=$(($(date +%s) - $(stat -c %Y "$CACHE_FILE")))
    if [ "$cache_age" -lt "$CACHE_TTL" ]; then
        head -1 "$CACHE_FILE"
        exit 0
    fi
fi

# Get IP from icanhazip.com (Cloudflare)
ip=$(curl -s --max-time 2 https://icanhazip.com 2>/dev/null | tr -d '\n')

if [ -n "$ip" ]; then
    # Get country from db-ip.com
    country=$(curl -s --max-time 2 "http://api.db-ip.com/v2/free/$ip/countryCode" 2>/dev/null | tr -d '\n"')
    [ -z "$country" ] && country="??"

    echo "$ip" > "$CACHE_FILE"
    echo "$country" >> "$CACHE_FILE"
    echo "$ip"
else
    [ -f "$CACHE_FILE" ] && head -1 "$CACHE_FILE" || echo "N/A"
fi
