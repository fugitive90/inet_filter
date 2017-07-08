# inet_filter

Generate blacklists to filter ads, malware etc.
Preferable option is to be used with dnscrypt to block nasties on domain level, although it can be used with proxies like Squid.

Link to **dnscrypt** https://www.dnscrypt.org/

## How to use it? ##

Clone the repository:
```
git clone https://github.com/fugitive90/inet_filter inet_filter ; cd inet_filter
chmod u+x inet_filter.sh
./inet_filter.sh
```
Blacklists both: **blacklist-domains** and **blacklist-ips** will be generated at the source dir.

Replace the following variables with the absolute paths, if you want blacklists to be generated in specific folder
```
blacklist_domains="${src}/blacklist-domains"
blacklist_ips="${src}/blacklist-ips"
```
## Tested on ##

Debian 9
	
	* sed (GNU sed) 4.4
	* curl 7.52.1 
	* GNU bash, version 4.4.12(1)-release

FreeBSD 11.0
	
	* sed
	* curl 7.54.1 (amd64-portbld-freebsd11.0)
	* GNU bash, version 4.4.12(2)-release (amd64-portbld-freebsd11.0)
 
## Author ##
fugitive90

2017

## License ##

GPL-v3 
