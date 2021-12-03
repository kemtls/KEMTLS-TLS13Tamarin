#!/usr/bin/env python3

import sys

from typing import Iterator, List, Optional

P1_CRIBS = [
    "CIdentity( tid, actor, role, <peer, 'auth', 'auth'> ) @ #comm",
    "(last(#comm))  ∥ (∃ #rev.   (RevLtk( $C ) @ #rev) ∧ (¬(last(#rev))) ∧ (#rev < #comm))  ∥ (∃ role2 tid2 #peer.   (RIdentity( tid2, $C, role2, <$S, 'auth', 'auth'> ) @ #peer)  ∧   (¬(last(#peer))) ∧ (¬('server' = role2)) ∧ (#peer < #comm))",
    "(∃ #kms #msgs.   (!KU( p_ms ) @ #kms) ∧ (!KU( p_messages ) @ #msgs)  ∧   (#kms < #vk) ∧ (#msgs < #vk))  ∥ (∃ tid actor #run.   (RTranscript( tid, actor, 'server', p_messages ) @ #run))",
    "RNonces( ~tid, $C, 'client', <p_nc, p_ns> ) @ #j.1",
    "RTranscript( tid.1, actor, 'server', p_messages ) @ #run",
    "RNonces(~tid, $S, 'server', <p_nc, ~new_ns>)",
]

P2_CRIBS = []

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def match_crib(crib:str, lines: List[str]) -> Optional[str]:
    crib = crib.replace(" ", "")
    for line in lines:
        num, rule = line.split(': ', maxsplit=2)

        rule = rule.strip().replace(" ", "")
        rule = rule.replace("\t", "")

        if f"{crib}" in rule:
            return num


def order_actions(lines: List[str], lemma: str, *args) -> str:
    if lemma != "commit_means_other_side_mutual":
        eprint("Unexpected lemma")
        sys.exit(1)

    for prios in [P1_CRIBS, P2_CRIBS]:
        for crib in prios:
            if (result := match_crib(crib, lines)) is not None:
                return result
    
    #eprint(crib)
    #print('\n'.join(lines), file=sys.stderr)


    # default
    num: str = lines[0].split(':')[0]
    return f"{num}\n # default"
    


if __name__ == "__main__":
    import sys
    import time
    print(order_actions(sys.stdin.readlines(), *sys.argv[1:]))