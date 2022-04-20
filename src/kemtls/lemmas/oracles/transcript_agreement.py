#!/usr/bin/env python3

import sys
import re

from typing import Iterator, List, Optional

CRIBS = [
    re.compile(crib.replace(" ", "")) for crib in
    (
        r"^contradiction",
        r"^CTranscript\(tid,",
        r"^CIdentity\(~tid,",
        r"\(∃ #r. \(RevLtk\( \$S \) @ #r\) ∧ #r < #i\)  ∥ \(∃ tid2 #j_ea.   \(RNonces\( tid2, \$S, 'server', <p_nc, p_ns> \) @ #j_ea\) ∧ #j_ea < #i\)",
        r"^RNonces\(~tid,",
        r"^RNonces\(tid2,",
        r"^!KU\(senc\(<'20', .* p_a?hs_key(s|c)\)",
#        r"hmac\(<Expand\((Extract\(p_clauth_ss, p_hs\)|p_ms), <'32', 'TLS13finished_(client|server)', '0'>, '32'\), h\((transcript|p_messages)\)>\)>, p_a?hs_key(s|c)\)",
        r"^!KU\(hmac\(<Expand\((Extract\(p_clauth_ss, p_a?hs\)|p_ms)",
        r"^!KU\(Expand\((Extract\(p_clauth|p_ms)",
    )
]

IGNORE = [
]


def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def match_crib(crib: re.Pattern, lines: List[str]) -> Optional[str]:
    for line in lines:
        num, rule = line.split(': ', maxsplit=2)

        rule = rule.strip().replace(" ", "")
        rule = rule.replace("\t", "")

        if crib.search(rule) is not None:
            return f"{num}\n# {crib.pattern}"


def order_actions(lines: List[str], lemma: str, *args) -> str:
    if lemma not in ("transcript_agreement", "mutual_transcript_agreement"):
        eprint("Unexpected lemma")
        sys.exit(1)

    for crib in CRIBS:
        if (result := match_crib(crib, lines)) is not None:
            eprint("Found CRIB")
            return result

    for line in lines:
        num, rule = line.split(': ', maxsplit=2)

        rule = rule.strip().replace(" ", "")
        rule = rule.replace("\t", "")
        match = False
        for crib in IGNORE:
            if rule.startswith(crib):
                match = True
                break
        if not match:
            return f"{num}\n# ignored"


    #eprint(crib)
    #print('\n'.join(lines), file=sys.stderr)


    # default
    return f"0\n # default"



if __name__ == "__main__":
    import sys
    import time
    print(order_actions(sys.stdin.readlines(), *sys.argv[1:]))
