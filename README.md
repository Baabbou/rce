# RCE

Github for RCE: Royal Context Evaluator. This script will run basics cmds when starting a pentest. 
Output is quite colored :)

It performs the following cmds :
- nmap : `nmap -oN "$OUTPUT/nmap.txt" -sSV -p- "$DOMAIN"` ;
- dnsx  : `echo "$DOMAIN" | dnsx -silent -recon -r '8.8.8.8' | tee "$OUTPUT/dns.txt"` ;
- Subfinder : `subfinder -silent -d "$DOMAIN" -all | sort -uV | tee "$OUTPUT/domains.txt"` (+ dnsx) ;
- review cert : `openssl s_client -showcerts -connect "$DOMAIN:443" </dev/null | tee "$OUTPUT/openssl.txt"` ;
- Httpx for simple http enum : `httpx -u "$DOMAIN" -tech-detect -p http:80,8000-8080,https:443,8443 -timeout 5 -silent | tee "$OUTPUT/technos.txt"` ;
- Katana : `katana -u "$DOMAIN" -js-crawl -jsluice -kf all -passive -fs fqdn -silent | sort -uV | tee "$OUTPUT/crawl.txt"` ;
- Katana (+ httpx ) : `cat "$OUTPUT/crawl.txt" | httpx -status-code -cl -tech-detect -silent | tee "$OUTPUT/crawl.txt"` ;
- ffuf : `ffuf -c -r -H 'User-Agent: Mozilla/5.0 Firefox/126.0' -w '$WORDLIST' -u 'https://DOMAIN/FUZZ'`.

> All this output is saved on files contained in `rce-<md5>` so you will never have to run them again :)
> You can skip each part of the script if you want to.

Enjoy !

# Install

```bash
git clone https://github.com/Baabbou/rce.git
cd ./rce
echo "alias rce='$(pwd)/rce.sh'" >> ~/.zshrc
```

# Usage

```bash
rce -h
Royal Context Evaluator : a script for lazy hackers
    ex: rce -d example.c0m -ua 'Pwn-Babbz-TIE-yolo-2024'

    -h  | --help       : Print this.
    -d  | --domain     : The domain where the script perform.
    -ua | --user-agent : Precise a user-agent for HTTP tools.
    -c  | --cookie     : Precise a cookie for HTTP tools.
    -H  | --header     : Precise a header for HTTP tools (limited to one header).
    -w  | --wordlist   : By default './dist/common-custom.txt'.

    -o | --output : Name of the output directory rce-<md5> by default.

Enjoy it little hacker ( ͡° ͜ʖ ͡°)
```

## Next ?

- sn0int

# Example

> Confidential

# Contact

Real hackers have no contact with anyone. 
