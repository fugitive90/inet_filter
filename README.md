# inet_filter

Generate blacklists to filter ads, malware etc.
Preferable option is to be used with dnscrypt to block nasties on domain level, although it can be used with proxies like Squid.

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

## Author ##
fugitive90

2017

## License ##

GPL-v3 
