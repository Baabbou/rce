# RCE

Github for RCE: Royal Context Evaluator. This script will run basics cmds when starting a pentest. 
Output is quite colored :)

It performs the following cmds :
- nmap : `nmap -sV -sS -p- '$DOMAIN'` ;
- dnsx  : `echo -n '$DOMAIN' | dnsx -silent -recon -r '9.9.9.9'` ;
- Subfinder : `subfinder -silent -d '$DOMAIN' -all | sort -uV` (+ dnsx) ;
- review cert : `openssl s_client -showcerts -connect '$DOMAIN:443' </dev/null` ;
- Httpx for simple http enum : `httpx -u '$DOMAIN' -wc -sc -cl -location -tech-detect -p http:80,8000-8080,https:443,8443 -timeout 5 $o_speed -silent` ;
- Katana : `katana -u '$DOMAIN' -js-crawl -jsluice -kf all -timeout 5 -pc -fs fqdn -silent $o_speed | sort -uV` ;
- ffuf : `ffuf -c -r -H 'User-Agent: Mozilla/5.0 Firefox/126.0' -w 'dist/common-custom.txt' -u 'https://$DOMAIN/FUZZ'`.

> All this output is saved on files contained in `_rce-<DOMAIN>` so you will never have to run them again :)
> You can skip each part of the script if you want to.

Enjoy !

# Install

```bash
git clone https://github.com/Baabbou/rce.git
cd ./rce
echo "export PATH=\"\$PATH:$(pwd)\"" >> ~/.zshrc
```

# Usage

```bash
rce -h
Royal Context Evaluator : a script for lazy hackers
        ex: rce -d 'babbz.net' -s 3 -l

        -h  | --help       : Print this.
        -d  | --domain     : The domain where the script perform (required).
        -o  | --output     : Name of the output directory _rce-<DOMAIN> by default.
        -s  | --speed      : Speed of the scan. Can be 1: slow, 2: normal, or 3: quick.
        -l  | --light      : Light version of scan, less acurate results.

    Enjoy it little hacker ( ͡° ͜ʖ ͡°)
```

## Next ?

- sn0int

# Example

```
$ sudo rce -d 'watermark.babbz.net' -s 3 -l
[rce] Output directory created at '$PWD/_rce-watermark-babbz-net'

[rce] ### nmap -oN '$PWD/_rce-watermark-babbz-net/nmap.txt' -sV -sS --top-ports 10000 -T5 'watermark.babbz.net'  [y/N] y
[rce] Starting nmap - ($PWD/_rce-watermark-babbz-net/nmap.txt)
Starting Nmap 7.93 ( https://nmap.org ) at 2025-08-21 22:42 CEST
Nmap scan report for watermark.babbz.net (163.172.93.114)
Host is up (0.025s latency).
rDNS record for 163.172.93.114: mail.babbz.net
Not shown: 8357 closed tcp ports (reset)
PORT    STATE    SERVICE       VERSION
...
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 38.23 seconds

[rce] ### echo -n 'watermark.babbz.net' | dnsx -silent -recon -r '9.9.9.9' | tee '$PWD/_rce-watermark-babbz-net/dns.txt'  [y/N] y
[rce] Starting dnsx - ($PWD/_rce-watermark-babbz-net/dns.txt)
watermark.babbz.net [A] [163.172.93.114] 
watermark.babbz.net [SOA] [dns19.ovh.net] 
watermark.babbz.net [SOA] [tech.ovh.net] 

[rce] ### subfinder -silent -d 'watermark.babbz.net' -all | sort -uV | tee '$PWD/_rce-watermark-babbz-net/domains.txt'  [y/N] y
[rce] Starting subfinder - ($PWD/_rce-watermark-babbz-net/domains.txt)
watermark.babbz.net

[rce] ### cat '$PWD/_rce-watermark-babbz-net/domains.txt' | dnsx -silent -a -ptr -resp-only -r '9.9.9.9' | sort -uV | tee '$PWD/_rce-watermark-babbz-net/ips.txt'  [y/N] y
[rce] Starting dnsx - ($PWD/_rce-watermark-babbz-net/ips.txt)
163.172.93.114

[rce] ### openssl s_client -showcerts -connect 'watermark.babbz.net:443' </dev/null  | tee '$PWD/_rce-watermark-babbz-net/openssl.txt'  [y/N] y
[rce] Starting openssl - ($PWD/_rce-watermark-babbz-net/openssl.txt)
depth=2 C = US, O = Internet Security Research Group, CN = ISRG Root X1
verify return:1
depth=1 C = US, O = Let's Encrypt, CN = E6
verify return:1
depth=0 CN = *.babbz.net
verify return:1
DONE
CONNECTED(00000003)
---
Certificate chain
 0 s:CN = *.babbz.net
   i:C = US, O = Let's Encrypt, CN = E6
   a:PKEY: id-ecPublicKey, 256 (bit); sigalg: ecdsa-with-SHA384
   v:NotBefore: May 27 20:36:25 2025 GMT; NotAfter: Aug 25 20:36:24 2025 GMT
...

[rce] ### httpx -u 'watermark.babbz.net' -sc -cl -ct -location -tech-detect -p http:80,8000-8080,https:443,8443 -timeout 5 -rl 100 -silent | tee '$PWD/_rce-watermark-babbz-net/technos.txt'  [y/N] y
[rce] Starting httpx - ($PWD/_rce-watermark-babbz-net/web-info-scan.txt)
http://watermark.babbz.net [301] [https://watermark.babbz.net/] [162] [text/html]
https://watermark.babbz.net [200] [] [4294] [text/html] [Bootstrap:5.3]

[rce] ### katana -u 'watermark.babbz.net' -js-crawl -jsluice -kf all -timeout 5 -pc -fs fqdn -silent -rl 150 | sort -uV | tee '$PWD/_rce-watermark-babbz-net/crawl.txt'  [y/N] y
[rce] Starting katana - ($PWD/_rce-watermark-babbz-net/crawl.txt)
https://watermark.babbz.net
https://watermark.babbz.net/
...

[rce] ### cat '$PWD/_rce-watermark-babbz-net/crawl.txt' | httpx -sc -cl -ct -location -tech-detect -silent -rl 100 | tee '$PWD/_rce-watermark-babbz-net/crawl.txt'  [y/N] y
[rce] Starting httpx+ - ($PWD/_rce-watermark-babbz-net/crawl.txt)
https://watermark.babbz.net/ [200] [] [4294] [text/html] [Bootstrap:5.3]
https://watermark.babbz.net/static/custom/icon [301] [/static/custom/icon/] [0] []
https://watermark.babbz.net/static/bootstrap-5.3/js/bootstrap.min.js [200] [] [60582] [text/javascript]
https://watermark.babbz.net/static/bootstrap-5.3/css/bootstrap.min.css [200] [] [232855] [text/css]
...

[rce] ### ffuf -c -r -o '$PWD/_rce-watermark-babbz-net/ffuf.json' -H 'User-Agent: Mozilla/5.0 Firefox/126.0' -w '$PWD/_Tests/rce/rcedist/common-custom.txt' -t 40 -rate 1000 -u 'https://watermark.babbz.net/FUZZ' | tee '$PWD/_rce-watermark-babbz-net/fuff.txt'  [y/N]  N
[rce] RCE done.

$ tree _rce-watermark-babbz-net
_rce-watermark-babbz-net
├── crawl.txt
├── dns.txt
├── domains.txt
├── ips.txt
├── nmap.txt
├── openssl.txt
└── technos.txt
```

# Contact

Real hackers have no contact with anyone. 
