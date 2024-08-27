# RCE

Github for RCE: Royal Context Evaluator. This script will run basics cmds when starting a pentest. 
Output is quite colored :)

It performs the following cmds :
- nmap : `nmap -sS -sU -sV -O -p1-10000 DOMAIN`.
- dig  : `dig ANY DOMAIN`.
- review cert : `openssl s_client -showcerts -connect DOMAIN:443 </dev/null`.
- Qcrawl : `Qcrawl -sf -ua 'Mozilla/5.0 Firefox/126.0' -u 'https://DOMAIN/`
- ffuf : `ffuf -c -r -H 'User-Agent: Mozilla/5.0 Firefox/126.0' -w 'WORDLIST' -u 'https://DOMAIN/FUZZ'`

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

# Example

> Confidential

# Contact

Real hackers have no contact with anyone.
