#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

if [ "$UID" -ne 0 ]; then
    echo -e "${RED}[error]${NC} You must run this as root user."
    exit 1
fi

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
        -i|--interface)
            INTERFACE="$2"
            shift
            shift
            ;;
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
        --seclists-path)
            SECLISTS="$2"
            shift
            shift
            ;;
        --slow)
            SLOW=YES
            shift
            ;;
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
    echo -e """${RED}[n00b]${NC} rtfscript if you need help n00b"""
    exit 1
fi

if [ -z "$DOMAIN" ]; then
    echo -e "${RED}[error]${NC} Domain must be set with -d or --domain "
    exit 1
fi

if [ -z "$INTERFACE" ]; then
    INTERFACE=$(ip route | grep '^default' | awk '{print $5}')
fi
echo -e "${BLUE}[rce]${NC} Interface set to '$INTERFACE'  (-i / --interface)"

if [ -z "$OUTPUT" ]; then
    OUTPUT="rce-output-$(echo "$DOMAIN" | tr -d ' ')"
fi
mkdir -p "$(pwd)/$OUTPUT"
echo -e "${BLUE}[rce]${NC} Output dir set to '$OUTPUT'  (-o / --output)"
OUTPUT="$(pwd)/$OUTPUT"

if [ -z "$USER_AGENT" ]; then
    USER_AGENT="Mozilla/5.0 (X11; Linux x86_64; rv:126.0) Gecko/20100101 Firefox/126.0"
fi

if [ -z "$SECLISTS" ]; then
    SECLISTS="/home/tklingler/Documents/CTF/SecLists"
fi


# === NMAP ===
echo 
echo -ne "${YELLOW}[rce]${NC} nmap -sS -sU -sV -O -e '$INTERFACE' -p1-10000 '$DOMAIN'"
read -p " [y/N] " res
res=${res,,}

if [[ "$res" == "y" ]]; then
    echo -e "${YELLOW}[rce]${NC} Starting nmap - ($OUTPUT/nmap.txt)"
    nmap -sS -sV -O -e "$INTERFACE" -p1-100 "$DOMAIN" | tee "$OUTPUT/nmap.txt"
fi


# === Qcrawl ===
echo
QCRAWL="Qcrawl -sf -ua '$USER_AGENT'"
if [ -n "$COOKIE" ]; then
    QCRAWL="$QCRAWL -c '$COOKIE'"
fi
if [ -n "$HEADER" ]; then
    QCRAWL="$QCRAWL -H '$HEADER'"
fi
QCRAWL="$QCRAWL -u https://$DOMAIN/ -o $OUTPUT/Qcrawl"

echo -ne "${YELLOW}[rce]${NC} $QCRAWL"
read -p " [y/N] " res
res=${res,,}

if [[ "$res" == "y" ]]; then
    echo -e "${YELLOW}[rce]${NC} Starting Qcrawl - ($OUTPUT/Qcrawl.txt)"
    echo "$QCRAWL" | bash | tee "$OUTPUT/Qcrawl.txt"
fi


# === ffuf ===
echo
echo -ne "${YELLOW}[rce]${NC} ffuf -c -w "$(find $SECLISTS/Discovery/Web-Content/ -type f | fzf)" -u '$DOMAIN'"
read -p " [y/N] " res
res=${res,,}

if [[ "$res" == "y" ]]; then
    echo -e "${YELLOW}[rce]${NC} Starting nmap - ($OUTPUT/nmap.txt)"
    nmap -sS -sV -O -e "$INTERFACE" -p1-100 "$DOMAIN" | tee "$OUTPUT/nmap.txt"
fi