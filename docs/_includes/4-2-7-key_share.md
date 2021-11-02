
<div class="row">
### Key Share
</div>
<div class="row">
<div class="col1">

The "key_share" extension contains the endpoint's cryptographic parameters.

Clients MAY send an empty client_shares vector in order to request
group selection from the server at the cost of an additional round trip.
(see {{hello-retry-request}})

%%% Key Exchange Messages

       struct {
           NamedGroup group;
           opaque key_exchange<1..2^16-1>;
       } KeyShareEntry;

group
: The named group for the key being exchanged.
  Finite Field Diffie-Hellman {{DH}} parameters are described in
  {{ffdhe-param}}; Elliptic Curve Diffie-Hellman parameters are
  described in {{ecdhe-param}}.

key_exchange
: Key exchange information.  The contents of this field are
  determined by the specified group and its corresponding
  definition.
{:br }

The "extension_data" field of this extension contains a
"KeyShare" value:

%%% Key Exchange Messages

       struct {
           select (Handshake.msg_type) {
               case client_hello:
                   KeyShareEntry client_shares<0..2^16-1>;

               case hello_retry_request:
                   NamedGroup selected_group;

               case server_hello:
                   KeyShareEntry server_share;
           };
       } KeyShare;

client_shares
: A list of offered KeyShareEntry values in descending order of client preference.
  This vector MAY be empty if the client is requesting a HelloRetryRequest.
  Each KeyShareEntry value MUST correspond to a group offered in the
  "supported_groups" extension and MUST appear in the same order.  However, the
  values MAY be a non-contiguous subset of the "supported_groups" extension and
  MAY omit the most preferred groups. Such a situation could arise if the most
  preferred groups are new and unlikely to be supported in enough places to
  make pregenerating key shares for them efficient.

selected_group
: The mutually supported group the server intends to negotiate and
  is requesting a retried ClientHello/KeyShare for.

server_share
: A single KeyShareEntry value that is in the same group as one of the
  client's shares.
{:br }

Clients offer an arbitrary number of KeyShareEntry values, each
representing a single set of key exchange parameters. For instance, a
client might offer shares for several elliptic curves or multiple
FFDHE groups.  The key_exchange values for each KeyShareEntry MUST be
generated independently.  Clients MUST NOT offer multiple
KeyShareEntry values for the same group.  Clients MUST NOT offer any
KeyShareEntry values for groups not listed in the client's
"supported_groups" extension.  Servers MAY check for violations of
these rules and abort the handshake with an
"illegal_parameter" alert if one is violated.

Upon receipt of this extension in a HelloRetryRequest, the client MUST
verify that (1) the selected_group field corresponds to a group which was provided
in the "supported_groups" extension in the original ClientHello; and (2)
the selected_group field does not correspond to a group which was
provided in the "key_share" extension in the original ClientHello. If either of
these checks fails, then the client MUST abort the handshake with an
"illegal_parameter" alert.  Otherwise, when sending the new ClientHello, the
client MUST replace the original "key_share" extension with one
containing only a new KeyShareEntry for the group indicated in the
selected_group field of the triggering HelloRetryRequest.

If using ephemeral KEM key establishment, servers offer exactly one
KeyShareEntry in the ServerHello. This value MUST be the ciphertext encapsulated
to the KeyShareEntry value offered
by the client that the server has selected for the negotiated key exchange.
Servers MUST NOT send a KeyShareEntry for any group not
indicated in the "supported_groups" extension and
MUST NOT send a KeyShareEntry when using the "psk_ke" PskKeyExchangeMode.
If a HelloRetryRequest was received by the client, the client MUST verify that the
selected NamedGroup in the ServerHello is the same as that in the HelloRetryRequest. If this check
fails, the client MUST abort the handshake with an "illegal_parameter" alert.

`---snip---`

<!--
####  Diffie-Hellman Parameters {#ffdhe-param}

Diffie-Hellman {{DH}} parameters for both clients and servers are encoded in
the opaque key_exchange field of a KeyShareEntry in a KeyShare structure.
The opaque value contains the
Diffie-Hellman public value (Y = g^X mod p) for the specified group
(see {{RFC7919}} for group definitions)
encoded as a big-endian integer, padded with zeros to the size of p in
bytes.

Note: For a given Diffie-Hellman group, the padding results in all public keys
having the same length.

Peers SHOULD validate each other's public key Y by ensuring that 1 < Y
< p-1. This check ensures that the remote peer is properly behaved and
isn't forcing the local system into a small subgroup.


#### ECDHE Parameters {#ecdhe-param}

ECDHE parameters for both clients and servers are encoded in the
the opaque key_exchange field of a KeyShareEntry in a KeyShare structure.

For secp256r1, secp384r1 and secp521r1, the contents are the byte string
representation of an elliptic curve public value following the conversion
routine in Section 4.3.6 of ANSI X9.62 {{X962}}.

Although X9.62 supports multiple point formats, any given curve
MUST specify only a single point format. All curves currently
specified in this document MUST only be used with the uncompressed
point format (the format for all ECDH functions is considered
uncompressed). Peers MUST validate each other's public value Y by ensuring
that the point is a valid point on the elliptic
curve.

For the curves secp256r1, secp384r1 and secp521r1, the appropriate
validation procedures are defined in Section 4.3.7 of {{X962}}
and alternatively in Section 5.6.2.6  of {{KEYAGREEMENT}}.
This process consists of three steps: (1) verify that Y is not the point at 
infinity (O), (2) verify that for Y = (x, y) both integers are in the correct
interval, (3) ensure that (x, y) is a correct solution to the elliptic curve equation.
For these curves, implementers do not need to verify membership in the correct subgroup. 

For x25519 and x448, the contents of the public value are the byte string inputs and outputs of the
corresponding functions defined in {{RFC7748}}, 32 bytes for x25519 and 56
bytes for x448. Peers SHOULD use the approach specified in {{RFC7748}} to calculate
the Diffie-Hellman shared secret, and MUST
check whether the computed Diffie-Hellman shared secret is the all-zero value and abort if so, as described
in Section 6 of {{RFC7748}}. If implementers
use an alternative implementation of these elliptic curves, they should perform
the additional checks specified in Section 7 of {{RFC7748}}.

Note: Versions of TLS prior to 1.3 permitted point format negotiation;
TLS 1.3 removes this feature in favor of a single point format
for each curve.
-->
</div>
<div class="col2">

We reproduce the information in [HelloRetryRequest](#hello_retry_request) to
discuss the functionality of KeyShare:

```
       Client                        Server
    supports k1, k2               supports k

    <k1, k2>, <k1, kempk(k2) > ---->  if k != k1

                        <----- HRR <k>

    checks k2 == k 
    <k1, k2>, <k2, kempk(k2)> ---->  checks k == k2

                                  <------ <k, encaps(kempk(k1))>

```

We model ephemeral KEM key exchange with abstract KEM `$g`. The client initially
supports a pair of KEMs `<$k1, $k2>`, and the server supports some group `$k`
not necessarily equal to `$k1` or `$k2`. 

On the first flight, the client sends both supported groups, and the `KeyShare`
extension:
```
define(<!KeyShareCH!>, <!Extension('40', k, epk)!>)
```
(locally we have `ekem = $k1`, `$epk = kempk(ekem, ~esk)`).

If the server rejects this group and requests a retry, the client will simply
set `ekem = $k2` and generate a new value of `~sk`.

If the server requests a HRR, this contains the extension:
```
define(<!KeyShareHRR!>, <!Extension('40', new_ekem)!>)
```
where `new_ekem` is set locally to the server's group `$k` which is checked to be
`$k = $k2`.

Finally, the server hello message contains the server's key share:
```
define(<!KeyShareSH!>, <!Extension('40', k, ect)!>)
```
where, again, `k` is set locally to `$k` and `ect = kemencaps(k, ~eseed, epk)`. If the server is sending
a server hello message, we know the group must have been successfully negotiated with
the client.
</div>
</div>
