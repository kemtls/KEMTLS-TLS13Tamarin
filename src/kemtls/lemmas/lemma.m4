changequote(<!,!>)
changecom(<!/*!>,<!*/!>)
pushdef(<!F_State_S4!>, <!L_State_S4($@)!>)dnl
pushdef(<!F_State_C4!>, <!L_State_C4($@)!>)dnl
define(<!State!>,<!F_State_$1(shift($@))!>)dnl
define(<!ClientCertReq!>,<!L_ClientCertReq($@)!>)dnl
define(<!ServerCertReq!>,<!L_ServerCertReq($@)!>)dnl
define(<!CachePSK!>, <!F_CachePSK($@)!>)dnl


theory TLS_13_lemmas
begin

include(header.m4i)
include(model.m4i)
include(all_lemmas.m4i)

include(includes/uniqueness.m4i)

include(includes/sources.m4i)

ifdef(<!NOPE!>, <!

lemma_ahsms_derive

// For any running(PostHS...) either the auth_status was set in the main HS and
// unchanged (along with the RMS), or there was post-hs auth, which means the
// auth_status is 'auth', the actor is a server*/

lemma_posths_rms/* [reuse, use_induction]:
  "All tid actor role hs rms peer aas pas messages #i. 
    running(PostHS, actor, role, hs, rms, peer, <aas, pas>, messages)@i ==>
      Ex ms #j. running(RMS, actor, role, peer, rms, messages)@j &
                ms = MasterSecret & rms = resumption_master_secret() & #j < #i &
      (
        (Ex aas2 #k. commit(Identity, actor, role, peer, <aas2, pas>)@k & #k < #i) |
        (Ex aas2 #k. commit(IdentityPost, actor, role, peer, <aas2, pas>)@k &
                role = 'server' & pas = 'auth' & (#k < #i | #k = #i)
        )
      )"
*/

lemma_matching_transcripts_posths/* [reuse]:
  "All tid tid2 actor peer actor2 peer2 role role2 rms rms2 messages #i #j.
    running(RMS, actor, role, peer2, rms, messages)@i &
    running2(RMS, peer, role2, actor2, rms2, messages)@j & not (role = role2) ==>
     rms = rms2"
*/

lemma_matching_rms_posths/* [reuse]:
  "All tid tid2 actor peer actor2 peer2 role role2 rms messages messages2 #i #j.
    running(RMS, actor, role, peer2, rms, messages)@i &
    running2(RMS, peer, role2, actor2, rms, messages2)@j & not (role = role2) ==>
     messages = messages2"
*/

lemma_sig_origin/* [reuse]:
  "All certificate certificate_request_context signature verify_data hs_key sig_messages ltkA  #i.
        KU(senc{Certificate, CertificateVerify, Finished}hs_key)@i & (signature = sign{sig_messages}ltkA) ==>
      (Ex #j. KU(ltkA)@j & #j < i) | (Ex #k. UseLtk(ltkA, signature)@k & #k < #i)"
*/

lemma_post_master_secret/* [reuse, hide_lemma=posths_rms]:
  "All tid actor peer role hs rms aas messages #i #k.
    running(PostHS, actor, role, hs, rms, peer, <aas, 'auth'>, messages)@i & 
    commit(HS, actor, role, hs)@i & 
    commit(IdentityPost, actor, role, peer, <aas, 'auth'>)@i &
    KU(rms)@k ==>
      (Ex #r. RevLtk(peer)@r & #r < #i) |
      (Ex tid3 x #r. RevDHExp(tid3, peer, x)@r & #r < #i) |
      (Ex tid4 y #r. RevDHExp(tid4, actor, y)@r & #r < #i) |
      (Ex rms2 #r. RevealPSK(actor, rms2)@r & #r < #k) |
      (Ex rms2 #r. RevealPSK(peer, rms2)@r & #r < #k)"
*/

lemma_invariant_post_hs/* [reuse, use_induction, hide_lemma=posths_rms]:
  "All tid actor peer peer2 role hs hs2 rms rms2 as as2 msgs msgs2 #i #j.
    running(PostHS, actor, role, hs, rms, peer, as, msgs)@i & 
    running(PostHS, actor, role, hs2, rms2, peer2, as2, msgs2)@j ==>
      peer = peer2 & rms = rms2 & msgs = msgs2 & hs = hs2"
*/

lemma_handshake_secret/* [reuse, use_induction, hide_lemma=posths_rms_weak]:
  "All tid actor peer role hs aas #i #k.
    commit(HS, actor, role, hs)@i &
    commit(Identity, actor, role, peer, <aas, 'auth'>)@i &
    KU(hs)@k ==>
        (Ex #r. RevLtk(peer)@r & #r < #i) |
        (Ex tid3 x #r. RevDHExp(tid3, peer, x)@r & #r < #i) |
        (Ex tid4 y #r. RevDHExp(tid4, actor, y)@r & #r < #i) |
        (Ex rms #r. RevealPSK(actor, rms)@r & #r < #k) |
        (Ex rms #r. RevealPSK(peer, rms)@r & #r < #k)"
*/

lemma_secret_session_keys/*:
  "All tid actor peer kw kr pas #i.
      SessionKey(tid, actor, peer, <pas, 'auth'>, <kw, kr>)@i & 
      not (Ex #r. RevLtk(peer)@r & #r < #i) &
      not (Ex tid3 x #r. RevDHExp(tid3, peer, x)@r & #r < #i) &
      not (Ex tid4 y #r. RevDHExp(tid4, actor, y)@r & #r < #i) &
      not (Ex rms #r. RevealPSK(actor, rms)@r) &
      not (Ex rms #r. RevealPSK(peer, rms)@r)
        ==> not Ex #j. K(kr)@j"
*/

lemma_pfs_handshake_secret/* [reuse, hide_lemma=posths_rms_weak]:
  "All tid actor peer role hs aas psk_ke_mode #i #k.
    commit(HS, actor, role, hs)@i &
    running(Mode, actor, role, psk_ke_mode)@i &
    commit(Identity, actor, role, peer, <aas, 'auth'>)@i &
    KU(hs)@k &
    (not psk_ke_mode = psk_ke) ==>
        (Ex #r. RevLtk(peer)@r & #r < #i) |
        (Ex tid3 x #r. RevDHExp(tid3, peer, x)@r & #r < #i) |
        (Ex tid4 y #r. RevDHExp(tid4, actor, y)@r & #r < #i) |
        (Ex rms #r. RevealPSK(actor, rms)@r & #r < #i) |
        (Ex rms #r. RevealPSK(peer, rms)@r & #r < #i)"
*/

lemma_secret_session_keys_pfs/*:
  "All tid actor peer kw kr pas #i.
      SessionKey(tid, actor, peer, <pas, 'auth'>, <kw, kr>)@i & 
      not (Ex #r. RevLtk(peer)@r & #r < #i) &
      not (Ex tid3 x #r. RevDHExp(tid3, peer, x)@r & #r < #i) &
      not (Ex tid4 y #r. RevDHExp(tid4, actor, y)@r & #r < #i) &
      not (Ex rms #r. RevealPSK(actor, rms)@r) &
      not (Ex rms #r. RevealPSK(peer, rms)@r)
        ==> not Ex #j. K(kr)@j"
*/


lemma_unique_session_keys/*:
  "All tid tid2 actor peer peer2 kr kw as as2 #i #j.
     SessionKey(tid, actor, peer, as, <kr, kw>)@i & 
     SessionKey(tid2, actor, peer2, as2, <kr, kw>)@j
      ==>
        #i = #j"
*/


lemma_consistent_nonces/* [reuse]:
  "All tid actor role nonces #i. 
    commit(Nonces, actor, role, nonces)@i ==>
      Ex #j. running(Nonces, actor, role, nonces)@j"
*/


lemma_auth_psk/* [reuse, use_induction, hide_lemma=posths_rms_weak]:
  "All tid tid2 actor actor2 role role2 peer peer2 rms messages aas #i #j #k.
    running(RMS, actor, role, peer2, rms, messages)@i & 
    running2(RMS, peer, role2, actor2, rms, messages)@j &
    commit(Identity, actor, role, peer, <aas, 'auth'>)@k &
    not (role = role2)
     ==>
      peer2 = peer |
      Ex #r. RevLtk(peer2)@r & #r < #k"
*/

/*
  Unilateral (entity) authentication
*/
lemma_entity_authentication/* [reuse, use_induction]:
  "All tid actor peer nonces cas #i. 
      commit(Nonces, actor, 'client', nonces)@i & commit(Identity, actor, 'client', peer, <cas, 'auth'>)@i &
      not (Ex #r. RevLtk(peer)@r & #r < #i) &
      not (Ex tid3 x #r. RevDHExp(tid3, peer, x)@r & #r < #i) &
      not (Ex tid4 y #r. RevDHExp(tid4, actor, y)@r & #r < #i) &
      not (Ex rms #r. RevealPSK(actor, rms)@r) &
      not (Ex rms #r. RevealPSK(peer, rms)@r)
          ==> (Ex tid2 #j. running2(Nonces, peer, 'server', nonces)@j & #j < #i)"
*/

/*
  Integrity of handshake messages
*/
lemma_transcript_agreement/* [reuse]:
  "All tid actor peer transcript cas #i.
      commit(Transcript, actor, 'client', transcript)@i & commit(Identity, actor, 'client', peer, <cas, 'auth'>)@i &
      not (Ex #r. RevLtk(peer)@r & #r < #i) &
      not (Ex tid3 x #r. RevDHExp(tid3, peer, x)@r & #r < #i) &
      not (Ex tid4 y #r. RevDHExp(tid4, actor, y)@r & #r < #i) &
      not (Ex rms #r. RevealPSK(actor, rms)@r) &
      not (Ex rms #r. RevealPSK(peer, rms)@r)
          ==> (Ex tid2 #j. running2(Transcript, peer, 'server', transcript)@j & #j < #i)"
*/

/*
  Mutual (entity) authentication
*/
lemma_mutual_entity_authentication/* [reuse, use_induction]:
  "All tid actor peer nonces #i.
      commit(Nonces, actor, 'server', nonces)@i & commit(Identity, actor, 'server', peer, <'auth', 'auth'>)@i &
      not (Ex #r. RevLtk(peer)@r & #r < #i) &
      not (Ex tid3 x #r. RevDHExp(tid3, peer, x)@r & #r < #i) &
      not (Ex tid4 y #r. RevDHExp(tid4, actor, y)@r & #r < #i) &
      not (Ex rms #r. RevealPSK(actor, rms)@r) &
      not (Ex rms #r. RevealPSK(peer, rms)@r)
          ==> (Ex tid2 #j. running2(Nonces, peer, 'client', nonces)@j & #j < #i)"
*/

/*
  Integrity of handshake messages
*/
lemma_mutual_transcript_agreement/* [reuse]:
  "All tid actor transcript peer #i.
      commit(Transcript, actor, 'server', transcript)@i & commit(Identity, actor, 'server', peer, <'auth', 'auth'>)@i & 
      not (Ex #r. RevLtk(peer)@r & #r < #i) &
      not (Ex tid3 x #r. RevDHExp(tid3, peer, x)@r & #r < #i) &
      not (Ex tid4 y #r. RevDHExp(tid4, actor, y)@r & #r < #i) &
      not (Ex rms #r. RevealPSK(actor, rms)@r) &
      not (Ex rms #r. RevealPSK(peer, rms)@r)
          ==> (Ex tid2 #j. running2(Transcript, peer, 'client', transcript)@j & #j < #i)"
*/

/*
  Mutual (entity) authentication
*/
lemma_mutual_injective_entity_authentication/* [reuse, use_induction]:
  "All tid actor peer role nonces aas #i.
      commit(Nonces, actor, role, nonces)@i & commit(Identity, actor, role, peer, <aas, 'auth'>)@i &
      not (Ex #r. RevLtk(peer)@r & #r < #i) &
      not (Ex tid3 x #r. RevDHExp(tid3, peer, x)@r & #r < #i) &
      not (Ex tid4 y #r. RevDHExp(tid4, actor, y)@r & #r < #i) &
      not (Ex rms #r. RevealPSK(actor, rms)@r) &
      not (Ex rms #r. RevealPSK(peer, rms)@r)
          ==> 
          Ex role2 tid2 #j. running2(Nonces, peer, role2, nonces)@j & #j < #i & not role = role2 &
          (All tid3 peer2 #k. running3(Nonces, peer2, role2, nonces)@k ==> #k = #j)"
*/

lemma_tid_invariant/* [use_induction, reuse]:
  "All tid actor role #i. Instance(tid, actor, role)@i==>
      (Ex #j. Start(tid, actor, role)@j & (#j < #i))"
*/

lemma_one_start_per_tid/* [reuse]:
  "All tid actor actor2 role role2 #i #j. Start(tid, actor, role)@i & Start(tid, actor2, role2)@j ==>#i=#j"
*/

lemma_ku_fresh_psk/* [reuse]:
  "All ticket res_psk #i #k.
      FreshPSK(ticket,res_psk)@i & KU(res_psk)@k ==> 
        Ex actor #j. 
          RevealPSK(actor, res_psk)@j & #j < #k"
*/

lemma_session_key_agreement/*:
  "All tid tid2 actor peer nonces kr kr2 kw kw2 as as2 #i #j #k #l.
     SessionKey(tid, actor, peer, as, <kr, kw>)@i & 
     running(Nonces, actor, 'client', nonces)@j &
     SessionKey(tid2, peer, actor, as2, <kw2, kr2>)@k &
     running2(Nonces, peer, 'server', nonces)@l
      ==>
        kr = kr2 & kw = kw2"
*/


!>)
end

popdef(<!F_State_S4!>)
popdef(<!F_State_C4!>)
