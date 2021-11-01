cat _includes/* > manual.tmp
python3 parser.py  | colordiff -y -W 180 - tls13-spec/draft-ietf-tls-tls13.md | less -R
rm manual.tmp
