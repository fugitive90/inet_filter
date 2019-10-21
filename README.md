# inet_filter

Generate blacklists to filter ads, malware etc. This script processes raw blacklists, sorts, and removes duplicate domains/ips.
Preferable option is to be used with dnscrypt to block nasties on domain level, although it can be used with proxies like Squid.

Link to **dnscrypt** https://www.dnscrypt.org/

## How to use it? ##

Clone the repository:
```
git clone https://github.com/fugitive90/inet_filter inet_filter ; cd inet_filter
chmod u+x inet_filter.sh
./inet_filter.sh
```
If there is no parameters specified, blacklists will be created at $PWD/blacklists. Optionally, use custom path where blacklists will be generated:
```
./inet_filter.sh /etc/dnscrypt-proxy
```

Blacklists both: **blacklist-domains.txt** and **blacklist-ips.txt** will be generated under 'source dir/blacklists', or 'specified path/blacklists'.

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
