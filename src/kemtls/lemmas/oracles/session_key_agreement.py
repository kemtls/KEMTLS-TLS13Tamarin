#!/usr/bin/env python3

import sys
import re

from typing import Iterator, List, Optional

CRIBS = [
    re.compile(crib.replace(" ", "")) for crib in
    (
        r"^contradiction",
        r"^SessionKey\(",
        r"^EKem\(.*?, .*?, ~ltk.*\)",
        r"^EKem\(.*?, \$S, .*?\)",
        r"^CAHS\(",
        r"^CIdentity\(~tid",
        r"^RNonces\(",
        r"^RTranscript\(",
        r"^RIdentity\(",
        #r"^!KU\(~seed\.",
        #r"^!KU\(~eseed",
        r"^Start\(~tid(\.1)?,",
        r"^EKem\(~tid, \$C, ~esk\)",
        r"^F_State_S3",
        r"^F_State_S2",
        r"^F_State_C3",
        r"^F_State_C2d\(.*kemencaps\(",
        r"^F_State_C2d\(.*Extract\(kemss\(",
        r"^F_State_C2[^d]",
        r"^F_State_C2d",
        r"\(last\(",
        r"^!KU\(senc\(<'11'",
        r"^!KU\(hmac\(",
        r"^!KU\(h\(<",
        #r"^!KU\(Expand\(Extract\(kemss\(",
        #r"^!KU\(Expand\(Expand\(Extract\(kemss\(",
        #r"^!KU\(Expand\(Extract\(",
        #r"^!KU\(Extract\(kemss\(",
        #r"^!KU\(Extract\((p_)?clauth",
        #r"^!KU\(senc\(<'16'",
        #r"^!KU\(senc\(<'20'",
        r"^!KU\(senc\(<",
        #r"^EKem\(",
        #r"^!KU\(kemencaps\(",
    )
]

IGNORE = [
    "EKemSk(~seed",
    "RecvStream(",
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
    if lemma not in ("session_key_agreement",):
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
