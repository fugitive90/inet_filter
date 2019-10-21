#!/bin/bash -e

#Author: @fugitive90
#Year: 2017

custom_path="${1%/*}"
_error () { echo "Interrupted. Cleaning.";  rm -rf "${tmp}" "$shalla_dir" 2>/dev/null ; exit 5 ; }

trap _error HUP INT


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
tmp_shalla="$( mktemp -d)"

if [[ -n "$custom_path"  ]] ;then
		  delme="$( mktemp -d -p "$custom_path" 2>/dev/null )"
		  test -n "$delme" ||  { echo -e "Unable to write to $custom_path !\nPlease provide different directory." &&  exit 2 ; }
		  rm -r $delme && dest="$custom_path"
else
	dest="${src}/blacklists"
fi


test  -d "$dest" || mkdir -p "$dest"

blacklist_domains="${dest}/blacklist-domains.txt"
blacklist_ips="${dest}/blacklist-ips.txt"


# List of blacklist hosts, populate the array if you have any other source
urls=(
"https://adaway.org/hosts.txt"
"http://winhelp2002.mvps.org/hosts.txt"
"http://someonewhocares.org/hosts/hosts"
"http://pgl.yoyo.org/as/serverlist.php?hostformat=;showintro=0"
"https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt"
"https://raw.githubusercontent.com/notracking/hosts-blocklists/master/hostnames.txt"
)

# Add in this array more elements that you want 
# to block from shalla BL
shalla_bl=("adv" "spyware" "porn" "warez" "urlshortener" "gamble" "drugs" "chat")
shalla_url="http://www.shallalist.de/Downloads/shallalist.tar.gz"
shalla_dir="${tmp_shalla}"

clear
echo "Downloading Shalla blacklists"
curl --silent -o - "$shalla_url" | tar --strip-components=1 -xzf - -C "$shalla_dir"

#BL1 , download raw lists
for url in "${urls[@]}"; do 
	clear
	echo "Fetching $url"
	curl --silent -o -  "$url" | tee -a "$tmp" 1>/dev/null
done 

#BL2
echo "Processing shalla blacklists"
for blacklist in "${shalla_bl[@]}";do
			grep -E -o "${_match_ip}" "${shalla_dir}/${blacklist}/domains" > "$blacklist_ips" 
			grep -E -o "${_match_domains}" "${shalla_dir}/${blacklist}/domains" > $blacklist_domains 
done 


# cleanup			 
sed -r  -e "s/$_match_localhost//g" \
				-e "s/$_match_any_ip//g" \
				-e  "s/$_match_start_space//g" \
				-e "s/$_match_ports_on_end/g" \
				-e "s/$_match_non_alpha//g" \
				-e "s/$_match_comments/g" \
				-e "/$_match_blank_lines/d" "$tmp" \
				| grep -E -o "${_match_domains}" > $blacklist_domains 
				
echo "Total domains: $(wc -l $blacklist_domains)"
echo "Total IP's: $(wc -l $blacklist_ips)"		
rm -rf "${tmp}"		$shalla_dir 
exit 0	
