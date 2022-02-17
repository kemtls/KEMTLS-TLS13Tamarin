from datetime import datetime
from math import log10
from ssl import CERT_REQUIRED
import subprocess
import re
from typing import Iterable, List, Optional, Tuple

#: Fetch lemmas from incomplete output
LEMMA_REGEX: re.Pattern = re.compile(r"^\s*(?P<lemma>[a-zA-Z0-9_]+) \((all-traces|exists-trace)\): analysis incomplete \(1 steps\)\s*$")

#: Parse out steps
STEPS_REGEX: str = r"^\s*{lemma} \((all-traces|exists-trace)\): verified \((?P<steps>\d+) steps\)\s*$"


def run_tamarin(model: str, prove: Optional[str] = None) -> str:
    cmd = ["tamarin-prover", model]
    if prove is not None:
        modelname = model.removesuffix(".spthy")
        cmd.append(f"--prove={prove}")
        cmd.append(f"--output=proofs/{modelname}_{prove}.spthy")
    result = subprocess.run(
        cmd,
        check=True,
        capture_output=True,
        text=True,
    )
    return result.stdout


def get_lemmas(model: str) -> Iterable[str]:
    """Parse out the lemmas from the output of Tamarin"""
    lines = run_tamarin(model).splitlines()

    for line in lines:
        if m := LEMMA_REGEX.match(line):
            yield m.group("lemma")


def get_steps(tamarin_output: str, lemma) -> Optional[str]:
    pattern = STEPS_REGEX.format(lemma=lemma)
    if match := re.search(pattern, tamarin_output, re.MULTILINE):
        return match.group("steps")


def prove_lemmas(model, lemmas: Iterable[str]):
    lemmas = list(lemmas)
    max_lemma_length = max(len(lemma) for lemma in lemmas)
    for idx, lemma in enumerate(lemmas):
        start_time = datetime.now()
        stridx = str(idx+1).rjust(len(str(len(lemmas))))
        lemma_name = lemma.ljust(max_lemma_length)
        print(f"[{stridx}/{len(lemmas)}] Proving {lemma_name} at {start_time.time()}...", end="", flush=True)
        output = run_tamarin(model, lemma)
        duration = datetime.now() - start_time
        steps = get_steps(output, lemma)
        if steps is None:
            print(output)
            print(f"Proving {lemma} failed after {duration}!?")
            break
        print(f"\tCompleted in {steps: >4} steps in {duration}")


if __name__ == "__main__":
    import sys
    import itertools
    if len(sys.argv) not in (2, 3):
        print(f"Usage: {sys.argv[0]} model.spthy [start_lemma]")
        sys.exit(1)
    model = sys.argv[1]
    lemmas = get_lemmas(model)

    if len(sys.argv) == 3:
        opt_start_lemma = sys.argv[2]
        lemmas = list(lemmas)
        while len(lemmas) > 0:
            if lemmas[0] != opt_start_lemma:
                print(f"Skipping {lemmas[0]}")
                lemmas.pop(0)
            else:
                break
        assert len(lemmas) > 0, "Dropped all lemmas"

    start_time = datetime.now()
    prove_lemmas(model, lemmas)
    duration = datetime.now() - start_time
    print(f"\n\nAll done in {duration}")