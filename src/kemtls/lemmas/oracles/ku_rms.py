#!/usr/bin/env python3


from typing import Iterator, List


def order_actions(lines: List[str], lemma: str, *args) -> Iterator[str]:
    if lemma != "ku_rms":
        return


    p1: List[str] = []
    tail: List[str] = []
    for line in lines:
        num: str = line.split(':')[0]
        if "h(messages)" in line and "RevealPSK" not in line and  "RRMS" not in line:
            p1.append(num)
        else:
            tail.append(num)
    
    for num in p1 + tail:
        yield num


if __name__ == "__main__":
    import sys
    import time
    for action in order_actions(sys.stdin.readlines(), *sys.argv[1:]):
        print(action)