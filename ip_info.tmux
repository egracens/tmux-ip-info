#!/usr/bin/env bash
# tmux-ip-info - Display public IP and country in tmux status bar

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Export tmux options - use #{E:@ip_address} and #{E:@ip_country} to reference
tmux set -gq "@ip_address" "#($PLUGIN_DIR/scripts/get_ip.sh)"
tmux set -gq "@ip_country" "#($PLUGIN_DIR/scripts/get_country.sh)"

# Support #{ip_address} and #{ip_country} placeholders in status-right/left
for placeholder in "#{ip_address}" "#{ip_country}"; do
    if [ "$placeholder" = "#{ip_address}" ]; then
        script="#($PLUGIN_DIR/scripts/get_ip.sh)"
    else
        script="#($PLUGIN_DIR/scripts/get_country.sh)"
    fi

    status_right=$(tmux show-option -gqv status-right)
    status_right="${status_right//$placeholder/$script}"
    tmux set-option -gq status-right "$status_right"

    status_left=$(tmux show-option -gqv status-left)
    status_left="${status_left//$placeholder/$script}"
    tmux set-option -gq status-left "$status_left"
done
