#!/usr/bin/env bash
# Loops through a list of websites and reports whether each one is reachable.
#
# Usage:
#   ./check_websites.sh                      # uses the default list below
#   ./check_websites.sh websites.txt         # one URL per line (# for comments)
#   ./check_websites.sh google.com github.com
#
# A site is "reachable" when curl gets any HTTP response (status 1xx-5xx)
# within the timeout. Exit code = number of unreachable sites (0 = all up).

TIMEOUT=10

websites=(
    "https://www.google.com"
    "https://github.com"
    "https://hub.docker.com"
    "https://portal.azure.com"
    "https://www.iie.ac.za"
    "https://this-site-does-not-exist-12345.com"
)

# Websites passed as a file or as arguments replace the default list
if [[ $# -eq 1 && -f "$1" ]]; then
    mapfile -t websites < <(grep -vE '^\s*(#|$)' "$1")
elif [[ $# -gt 0 ]]; then
    websites=("$@")
fi

reachable=0
unreachable=0

printf "%-45s %-12s %s\n" "WEBSITE" "STATUS" "HTTP CODE"
printf "%-45s %-12s %s\n" "-------" "------" "---------"

for site in "${websites[@]}"; do
    site="$(echo "$site" | tr -d '[:space:]')"
    # add https:// when no scheme is given
    [[ "$site" =~ ^https?:// ]] || site="https://$site"

    # -s silent, -o discard body, -L follow redirects, -w print the status code
    code=$(curl -s -o /dev/null -L --max-time "$TIMEOUT" -w "%{http_code}" "$site")

    if [[ "$code" =~ ^[1-5][0-9][0-9]$ ]]; then
        printf "%-45s \e[32m%-12s\e[0m %s\n" "$site" "REACHABLE" "$code"
        ((reachable++))
    else
        printf "%-45s \e[31m%-12s\e[0m %s\n" "$site" "UNREACHABLE" "-"
        ((unreachable++))
    fi
done

echo
echo "Summary: $reachable reachable, $unreachable unreachable (of ${#websites[@]})"
exit "$unreachable"
