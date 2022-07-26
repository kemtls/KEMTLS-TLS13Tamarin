# KEMTLS model in Tamarin

We've been adapting the Tamarin model for TLS 1.3 to analyse KEMTLS.

See the [`src/kemtls`](src/kemtls) folder for our updated model.
The previous versions of the model, as available on the [original project page](https://github.com/tls13tamarin/TLS13Tamarin) are included as a reference.

The `src/kemtls/README.md` file contains more details about the model.

## Running the proofs

The completed proofs of the KEMTLS model live in `src/kemtls/lemmas/proofs`.
We include archived versions of this folder in the `src/kemtls/lemmas` folder.
They can be validated through `tamarin-prover <proof.spthy>`.
In `src/kemtls/lemmas/proofs`, there is a file for each individual lemma.
The `.stats` file includes some runtime and memory statistics.
If you want to run the proofs themselves, in `src/kemtls/lemmas`, run ``make all.spthy`` and run
``tamarin-prover all.spthy --prove``.
You an also run `python3 run_proofs.py all.spthy` to prove the lemmas one-at-a-time.
Output will be written in the `proofs` folder.

On a 80-core machine with 192 GiB of RAM, proving all lemmas takes 1 day and 18 hours with Tamarin 1.6.1.

## The docs

We've made some updates to the documentation in the `docs/` subfolder and it lives at https://thomwiggers.github.io/TLS13Tamarin/.

# Original README below:
# TLS13Tamarin
This is a Tamarin model of TLS 1.3

The most recent code is included in [src/rev21](src/rev21), however we provide previous
versions for reference.

For a detailed comparison between the specification and our model, please see:
https://samscott89.github.io/TLS13_Tamarin

For more background information, including our previous publication, please visit our [project page](http://tls13tamarin.github.io/TLS13Tamarin/).
