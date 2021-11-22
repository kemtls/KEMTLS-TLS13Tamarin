#!/usr/bin/env python3


from typing import Iterator, List


def order_actions(lines: List[str], lemma: str, *args) -> Iterator[str]:
    if lemma != "kem_encaps_ordering":
        return


    p1: List[str] = []
    p2: List[str] = []
    p3: List[str] = []
    tail: List[str] = []
    for line in lines:
        num: str = line.split(':')[0]
        if "KemEncap(" in line:
            p1.append(num)
        elif "KemDecaps(" in line:
            p2.append(num)
        elif "kemencaps(" in line:
            p3.append(num)
        else:
            tail.append(num)
    
    for num in p1 + p2 + p3 + tail:
        yield num
         



if __name__ == "__main__":
    import sys
    import time
    for action in order_actions(sys.stdin.readlines(), *sys.argv[1:]):
        print(action)