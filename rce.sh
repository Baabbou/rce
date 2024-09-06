#!/bin/bash
# 

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' 


POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            HELP=YES
            shift
            ;;
        -d|--domain)
            DOMAIN="$2"
            shift # past argument
            shift # past value
            ;;
        # -i|--interface)
        #     INTERFACE="$2"
        #     shift
        #     shift
        #     ;;
        -o|--output)
            OUTPUT="$2"
            shift
            shift
            ;;
        -ua|--user-agent)
            USER_AGENT="$2"
            shift
            shift
            ;;
        -c|--cookie)
            COOKIE="$2"
            shift
            shift
            ;;
        -H|--header)
            HEADER="$2"
            shift
            shift
            ;;
        -w|--wordlist)
            WORDLIST="$2"
            shift
            shift
            ;;
        # --slow)
        #     SLOW=YES
        #     shift
        #     ;;
        -*|--*)
            echo -e "${RED}[error]${NC} Unknown option $1"
            exit 1
            ;;
        *)
        POSITIONAL_ARGS+=("$1") # save positional arg
        shift
        ;;
    esac
done
set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

if [ -n "$HELP" ]; then
echo -e """${BLUE}Royal Context Evaluator${NC} : a script for lazy hackers
    ex: ${YELLOW}rce -d example.c0m -ua 'Pwn-Babbz-TIE-yolo-2024'${NC}

    -h  | --help       : Print this.
    -d  | --domain     : The domain where the script perform.
    -ua | --user-agent : Precise a user-agent for HTTP tools.
    -c  | --cookie     : Precise a cookie for HTTP tools.
    -H  | --header     : Precise a header for HTTP tools (limited to one header).
    -w  | --wordlist   : By default './dist/common-custom.txt'.

    -o | --output : Name of the output directory rce-<md5> by default.

Enjoy it little hacker ( ͡° ͜ʖ ͡°)"""
    exit 1
fi

# if [ "$UID" -ne 0 ]; then
#     echo -e "${RED}[error]${NC} You must run this as root user."
#     exit 1
# fi

if [ -z "$DOMAIN" ]; then
    echo -e "${RED}[error]${NC} Domain must be set with -d or --domain "
    exit 1
fi

# if [ -z "$INTERFACE" ]; then
#     INTERFACE=$(ip route | grep '^default' | awk '{print $5}')
# fi
# echo -e "${BLUE}[rce]${NC} Interface set to '$INTERFACE'  (-i / --interface)"

if [ -z "$OUTPUT" ]; then
    OUTPUT="rce-$(echo "$DOMAIN" | md5sum | cut -c 1-16 )"
fi
mkdir -p "$(pwd)/$OUTPUT"
echo -e "${BLUE}[rce]${NC} Output dir set to '$OUTPUT'  (-o / --output)"
OUTPUT="$(pwd)/$OUTPUT"

if [ -z "$USER_AGENT" ]; then
    USER_AGENT="Mozilla/5.0 Firefox/126.0"
fi

if [ -z "$WORDLIST" ]; then
    WORDLIST="$(which rce | sed -E 's/.* (.+)$/\1/')/dist/common-custom.txt"
fi


# === NMAP ===
echo 
echo -ne "${YELLOW}[rce]${NC} nmap -sS -sU -sV -O -p1-10000 '$DOMAIN'"
read -p " [y/N] " res
res=${res,,}

if [[ "$res" == "y" ]]; then
    echo -e "${YELLOW}[rce]${NC} Starting nmap - ($OUTPUT/nmap.txt)"
    sudo nmap -sS -sV -O -e "$INTERFACE" -p1-100 "$DOMAIN" | tee "$OUTPUT/nmap.txt"
fi


# === dig ===
echo 
echo -ne "${YELLOW}[rce]${NC} dig ANY @8.8.8.8 '$DOMAIN'"
read -p " [y/N] " res
res=${res,,}

if [[ "$res" == "y" ]]; then
    echo -e "${YELLOW}[rce]${NC} Starting dig - ($OUTPUT/dig.txt)"
    dig ANY @8.8.8.8 "$DOMAIN" | tee "$OUTPUT/dig.txt"
fi


# === Cert === 
echo 
echo -ne "${YELLOW}[rce]${NC} openssl s_client -showcerts -connect '$DOMAIN:443' </dev/null"
read -p " [y/N] " res
res=${res,,}

if [[ "$res" == "y" ]]; then
    echo -e "${YELLOW}[rce]${NC} Starting openssl - ($OUTPUT/openssl.txt)"
    openssl s_client -showcerts -connect "$DOMAIN:443" </dev/null | tee "$OUTPUT/openssl.txt"
fi


# === Qcrawl ===
build_Qcrawl() {
    qcrawl_cmd="Qcrawl -sf -ua '$USER_AGENT'"

    if [ -n "$COOKIE" ]; then
        qcrawl_cmd="$qcrawl_cmd -c '$COOKIE'"
    fi

    if [ -n "$HEADER" ]; then
        qcrawl_cmd="$qcrawl_cmd -H '$HEADER'"
    fi

    qcrawl_cmd="$qcrawl_cmd -u https://$DOMAIN/ -o $OUTPUT/Qcrawl"
    echo "$qcrawl_cmd"
}

echo
qcrawl=$(build_Qcrawl)
echo -ne "${YELLOW}[rce]${NC} $qcrawl"
read -p " [y/N] " res
res=${res,,}

if [[ "$res" == "y" ]]; then
    echo -e "${YELLOW}[rce]${NC} Starting Qcrawl - ($OUTPUT/Qcrawl.txt)"
    bash -c "$qcrawl" | tee "$OUTPUT/Qcrawl.txt"
    bash -c "$qcrawl" | tee "$OUTPUT/Qcrawl.txt"
fi


# === ffuf ===
build_ffuf() {
    local ffuf_cmd="ffuf -c -r -H 'User-Agent: $USER_AGENT'"

    if [ -n "$COOKIE" ]; then
        ffuf_cmd="$ffuf_cmd -b '$COOKIE'"
    fi

    if [ -n "$HEADER" ]; then
        ffuf_cmd="$ffuf_cmd -H '$HEADER'"
    fi

    ffuf_cmd="$ffuf_cmd -w '$WORDLIST' -u 'https://$DOMAIN/FUZZ' -o '$OUTPUT/ffuf.json'"
    echo "$ffuf_cmd"
}
echo
ffuf=$(build_ffuf)

echo -ne "${YELLOW}[rce]${NC} $ffuf"
read -p " [y/N] " res
res=${res,,}

if [[ "$res" == "y" ]]; then
    echo -e "${YELLOW}[rce]${NC} Starting ffuf - ($OUTPUT/ffuf.txt)"
    bash -c "$ffuf" | tee "$OUTPUT/ffuf.txt"
    echo -e "${YELLOW}[rce]${NC} Starting ffuf - ($OUTPUT/ffuf.txt)"
    bash -c "$ffuf" | tee "$OUTPUT/ffuf.txt"
fi

sudo chown -R $(whoami):$(whoami) "$OUTPUT"
