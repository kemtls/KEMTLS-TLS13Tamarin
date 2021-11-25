changequote(<!,!>)
changecom(<!/*!>,<!*/!>)
define(<!State!>,<!F_State_$1(shift($@))!>)dnl
define(<!ClientCertReq!>,<!L_ClientCertReq($@)!>)dnl
define(<!ServerCertReq!>,<!L_ServerCertReq($@)!>)dnl
define(<!CachePSK!>, <!F_CachePSK($@)!>)dnl

define(<!SecretPSK!>, <!F_SecretPSK($@)!>)dnl


theory TLS_13_secret_helpers
begin

include(header.m4i)
include(model.m4i)
include(all_lemmas.m4i)

/* precursors */

include(includes/sources.m4i)

include(includes/uniqueness.m4i)

include(includes/invariants.m4i)

include(includes/kems.m4i)

include(includes/nonces.m4i)

// secret_helper lemmas

include(includes/ku.m4i)

include(includes/derive.m4i)

include(includes/matching.m4i)

include(includes/secrets.m4i)

// to know the AHS key for an authenticated server, the
// server's ltk must've been revealed (to impersonate the server, because it needs to know HS as well).
lemma authenticated_handshake_secret_client [reuse, heuristic=cic]:
    "All tid actor peer hs ahs aas #i #k.
        commit(HS, actor, 'client', hs)@#i &
        commit(AHS, actor, 'client', ahs)@#i &
        commit(Identity, actor, 'client', peer, <aas, 'auth'>)@#i &
        KU(ahs)@k ==>
            (Ex #e. KU(hs)@#e & #e < #k) &
            (Ex #r. RevLtk(peer)@r & #r < #k)"

// to know the server's ahs for an authenticated client, the client's LTK must have
// been revealed (to impersonate the client, because it needs to know HS as well).
lemma authenticated_handshake_secret_server [reuse]:
    "All tid actor peer hs ahs aas #i #k.
        commit(HS, actor, 'server', hs)@#i &
        commit(AHS, actor, 'server', ahs)@#i &
        commit(Identity, actor, 'server', peer, <aas, 'auth'>)@#i &
        KU(ahs)@k ==>
            (Ex #e. KU(hs)@#e & #e < #k) &
            (Ex #r. RevLtk(peer)@r & #r < #k)"

// To learn the handshake secret in an authed connection, the adversary needs to
// either impersonate the peer (RevLtk), or reveal it.
lemma handshake_secret [reuse, use_induction, hide_lemma=posths_rms_weak, heuristic=i]:
  "All tid actor peer role hs aas #i #k.
    commit(HS, actor, role, hs)@i &
    commit(Identity, actor, role, peer, <aas, 'auth'>)@i &
    KU(hs)@k ==>
        (Ex #l. RevLtk(peer)@l & #l < #i) |                         dnl for impersonation
        (Ex tid3 esk #p. RevEKemSk(tid3, peer, esk)@p & #p < #i) |  dnl if the peer is client
        (Ex tid4 esk #r. RevEKemSk(tid4, actor, esk)@r & #r < #i) |   dnl if the actor is client
        (Ex rms #r. RevealPSK(actor, rms)@r & #r < #k) |
        (Ex rms #r. RevealPSK(peer, rms)@r & #r < #k)"

// not really relevant unless we do resumption
lemma pfs_handshake_secret [reuse, hide_lemma=posths_rms_weak, heuristic=s]:
  "All tid actor peer role hs aas psk_ke_mode #i #k.
    commit(HS, actor, role, hs)@i &
    running(Mode, actor, role, psk_ke_mode)@i &
    commit(Identity, actor, role, peer, <aas, 'auth'>)@i &
    KU(hs)@k &
    (not psk_ke_mode = psk_ke) ==>
        (Ex #r. RevLtk(peer)@r & #r < #i) |
        (Ex tid3 esk #r. RevEKemSk(tid3, peer, esk)@r & #r < #i) |
        (Ex tid4 esk #r. RevEKemSk(tid4, actor, esk)@r & #r < #i) |
        (Ex rms #r. RevealPSK(actor, rms)@r & #r < #i) |
        (Ex rms #r. RevealPSK(peer, rms)@r & #r < #i)"


end
