wordlist = []
with open("wordlist.txt", "r") as wordlistf:
    wordlist = wordlistf.read().split("\n")

wl_to_add = []
with open("wl.txt", "r") as wl_to_addf:
    wl_to_add = wl_to_addf.read().split("\n")

for w in wl_to_add:
    if w not in wordlist:
        wordlist.append(w)

with open("new-wordlist.txt", "w+") as new_wordlist_f:
    new_wordlist_f.write("\n".join(wordlist))
