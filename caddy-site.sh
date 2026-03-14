#!/usr/bin/env bash
set -euo pipefail

SITES_AVAILABLE="/etc/caddy/sites-available"
SITES_ENABLED="/etc/caddy/sites-enabled"

progname="$(basename "$0")"

list_sites() {
    local dir="$1"
    local label="$2"
    echo "Sites in $dir:"
    if [ ! -d "$dir" ]; then
        echo "(Directory does not exist)"
        return
    fi
    ls -1 "$dir" 2>/dev/null || echo "(No sites)"
}

usage() {
    echo "Usage: $progname [<site>]" >&2
    echo "  No argument: List $1 sites" >&2
    exit 1
}

if [ $# -eq 0 ]; then
    case "$progname" in
        caddy-ensite) list_sites "$SITES_AVAILABLE" "available" ;;
        caddy-dissite) list_sites "$SITES_ENABLED" "enabled" ;;
    esac
    exit 0
fi

[ $# -eq 1 ] || usage "$(basename "$SITES_ENABLED")"

site="$1"
src="$SITES_AVAILABLE/$site"
dst="$SITES_ENABLED/$site"

case "$progname" in
    caddy-ensite)
        if [ ! -e "$src" ]; then
            echo "Site '$site' does not exist in $SITES_AVAILABLE" >&2
            exit 1
        fi
        if [ -e "$dst" ]; then
            echo "Site '$site' is already enabled (exists in $SITES_ENABLED)" >&2
            exit 1
        fi
        ln -s "$src" "$dst"
        echo "Enabled site '$site' (created link $dst -> $src)"
        ;;
    caddy-dissite)
        if [ ! -L "$dst" ] && [ ! -e "$dst" ]; then
            echo "Site '$site' is not enabled (missing in $SITES_ENABLED)" >&2
            exit 1
        fi
        rm -f "$dst"
        echo "Disabled site '$site' (removed $dst)"
        ;;
    *)
        echo "This script must be named 'caddy-ensite' or 'caddy-dissite'." >&2
        exit 1
        ;;
esac

