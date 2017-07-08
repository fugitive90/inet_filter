#!/bin/bash

#Author: @fugitive
#Year: 2017


# REGEXES
_match_ip="(([0-9]{1,3})\.){3}([0-9]{1,3})"
_match_localhost="(127\.0\.0\.[0-9])"
_match_start_space="^[[:space:]]*"
_match_ports_on_end="(.*)(:[0-9]+$)/\1"
_match_non_alpha="(^([^0-9a-z]+))"
_match_comments="(.*)#(.*)/\1"
_match_blank_lines="^$"
_match_any_ip="(0\.0\.\0\.0)"
_match_domains="(^(\w+(\.|-))+([a-z]+))"


src=$(readlink -f $( dirname "${0}") )
tmp="$(mktemp)"


# Optional - Replace those with absolute paths for your blacklists
blacklist_domains="${src}/blacklist"
blacklist_ips="${src}/ips"


# List of blacklist hosts, populate the array if you have any other source
urls=(
"https://adaway.org/hosts.txt"
"http://winhelp2002.mvps.org/hosts.txt"
"http://someonewhocares.org/hosts/hosts"
"http://pgl.yoyo.org/as/serverlist.php?hostformat=;showintro=0"
)

# Add in this array more elements that you want 
# to block from shalla BL
shalla_bl=("adv" "spyware" "porn" "warez" "urlshortener" "gamble" "drugs" "chat")
shalla="http://www.shallalist.de/Downloads/shallalist.tar.gz"
shalla_dir="${src}/BL"

curl --silent -o - "$shalla" | tar xzf - -C "$src"

#BL1
for url in ${urls[*]}; do 
	curl --silent -o -  "$url" | tee -a "$tmp" 
done 1>/dev/null

#BL2

for blacklist in ${shalla_bl[*]};do
			grep -E -o "${_match_ip}" "${shalla_dir}/${blacklist}/domains" > "$blacklist_ips" 
			grep -E -o "${_match_domains}" "${shalla_dir}/${blacklist}/domains" > $blacklist_domains 
done 1> /dev/null 


			 
sed -r  -e "s/$_match_localhost//g" \
				-e "s/$_match_any_ip//g" \
				-e  "s/$_match_start_space//g" \
				-e "s/$_match_ports_on_end/g" \
				-e "s/$_match_non_alpha//g" \
				-e "s/$_match_comments/g" \
				-e "/$_match_blank_lines/d" "$tmp" \
				| grep -E -o "${_match_domains}" >> $blacklist_domains 1>/dev/null
				
echo "Total domains: $(wc -l $blacklist_domains)"
echo "Total IP's: $(wc -l $blacklist_ips)"		
rm -f "${tmp}"		
exit 0	
