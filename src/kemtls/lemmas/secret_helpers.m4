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

dnl 
dnl lemma_post_master_secret/* [reuse, hide_lemma=posths_rms]:
dnl   "All tid actor peer role hs rms aas messages #i #k.
dnl     running(PostHS, actor, role, hs, rms, peer, <aas, 'auth'>, messages)@i & 
dnl     commit(HS, actor, role, hs)@i & 
dnl     commit(IdentityPost, actor, role, peer, <aas, 'auth'>)@i &
dnl     KU(rms)@k ==>
dnl       (Ex #r. RevLtk(peer)@r & #r < #i) |
dnl       (Ex tid3 x #r. RevDHExp(tid3, peer, x)@r & #r < #i) |
dnl       (Ex tid4 y #r. RevDHExp(tid4, actor, y)@r & #r < #i) |
dnl       (Ex rms2 #r. RevealPSK(actor, rms2)@r & #r < #k) |
dnl       (Ex rms2 #r. RevealPSK(peer, rms2)@r & #r < #k)"
dnl */
dnl 
dnl lemma_invariant_post_hs/* [reuse, use_induction, hide_lemma=posths_rms]:
dnl   "All tid actor peer peer2 role hs hs2 rms rms2 as as2 msgs msgs2 #i #j.
dnl     running(PostHS, actor, role, hs, rms, peer, as, msgs)@i & 
dnl     running(PostHS, actor, role, hs2, rms2, peer2, as2, msgs2)@j ==>
dnl       peer = peer2 & rms = rms2 & msgs = msgs2 & hs = hs2"
dnl */
dnl 
dnl 
dnl /*
dnl   Strategy:
dnl   Intutition is that if two matching RMS then at some point a cert was hashed
dnl   into the handshake.
dnl 
dnl   To prove this, if RRMS and CommitIdentity(,... 'auth')
dnl   and RRMS2 is matching,
dnl   then there either there exists UseLtk and UsePk for the same person,
dnl   or RevLtk of peer.
dnl 
dnl   This will have to prove inductively over both RRMS (similar to matching sessions)
dnl   in fact, can probably roll it in to matching_sessions?
dnl   
dnl 
dnl */
dnl 
dnl 
dnl 
dnl lemma_handshake_secret/* [reuse, use_induction, hide_lemma=posths_rms_weak]:
dnl   "All tid actor peer role hs aas #i #k.
dnl     commit(HS, actor, role, hs)@i &
dnl     commit(Identity, actor, role, peer, <aas, 'auth'>)@i &
dnl     KU(hs)@k ==>
dnl         (Ex #r. RevLtk(peer)@r & #r < #i) |
dnl         (Ex tid3 x #r. RevDHExp(tid3, peer, x)@r & #r < #i) |
dnl         (Ex tid4 y #r. RevDHExp(tid4, actor, y)@r & #r < #i) |
dnl         (Ex rms #r. RevealPSK(actor, rms)@r & #r < #k) |
dnl         (Ex rms #r. RevealPSK(peer, rms)@r & #r < #k)"
dnl */
dnl 
dnl lemma_pfs_handshake_secret/* [reuse, hide_lemma=posths_rms_weak]:
dnl   "All tid actor peer role hs aas psk_ke_mode #i #k.
dnl     commit(HS, actor, role, hs)@i &
dnl     running(Mode, actor, role, psk_ke_mode)@i &
dnl     commit(Identity, actor, role, peer, <aas, 'auth'>)@i &
dnl     KU(hs)@k &
dnl     (not psk_ke_mode = psk_ke) ==>
dnl         (Ex #r. RevLtk(peer)@r & #r < #i) |
dnl         (Ex tid3 x #r. RevDHExp(tid3, peer, x)@r & #r < #i) |
dnl         (Ex tid4 y #r. RevDHExp(tid4, actor, y)@r & #r < #i) |
dnl         (Ex rms #r. RevealPSK(actor, rms)@r & #r < #i) |
dnl         (Ex rms #r. RevealPSK(peer, rms)@r & #r < #i)"
dnl */
dnl 


end
