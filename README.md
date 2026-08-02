# RCE

**RCE: Remote Context Enumerator**. This script will run basic enumeration when starting a pentest. 

> All this output is saved on files contained in `_rce-<DOMAIN>` so you will never have to run them again :)
> You can skip each part of the script if you want to.

Enjoy !

# Install

```bash
$ git clone https://github.com/Baabbou/rce.git
$ cd ./rce
$ chmod +x ./rce.sh
$ echo "alias rce $PWD/rce.sh" >> ~/.zshrc
```

# Usage

```bash
$ rce -h
Royal Context Enumerator: a script for lazy hackers
        ex: rce -d 'domain.local' -s 3 -l

        -h  | --help       : Print this.
        -d  | --domain     : The domain where the script perform (required).
        -o  | --output     : Name of the output directory (_rce-<DOMAIN> by default).
        -s  | --speed      : Speed of the scan. Can be 1: slow, 2: normal, or 3: quick.
        -l  | --light      : Light version of scan, less acurate results.

    Enjoy it little hacker ( ͡° ͜ʖ ͡°)
```

# Contact

Real hackers have no contact with anyone. 
