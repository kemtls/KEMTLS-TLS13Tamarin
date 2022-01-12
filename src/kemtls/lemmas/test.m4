changequote(<!,!>)
changecom(<!/*!>,<!*/!>)
define(<!State!>,<!F_State_$1(shift($@))!>)dnl
define(<!ClientCertReq!>,<!L_ClientCertReq($@)!>)dnl
define(<!ServerCertReq!>,<!L_ServerCertReq($@)!>)dnl
define(<!CachePSK!>, <!F_CachePSK($@)!>)dnl

define(<!SecretPSK!>, <!F_SecretPSK($@)!>)dnl


theory TLS_13_work
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

include(includes/authentication.m4i)

dnl include(includes/properties.m4i)

dnl include(includes/experiments.m4i)


// not helpful?
lemma commit_identity_authsecret_consistency []:
  "All tid actor role peer pas cas #ctime.
    commit(Identity, actor, role, peer, <pas, cas>)@#ctime
    ==>
      (Ex secret pas2 #authstat. running(AuthSecret, actor, role, secret, <pas2, cas>)@#authstat & #authstat < #ctime) &
      (Ex secret cas2 #pauthstat. running(MutualAuthSecret, actor, role, secret, <pas, cas2>)@#pauthstat & #pauthstat < #ctime)"


lemma matching_transcript_requires_matching_nonces [reuse]:
  "All tid tid2 actor peer transcript #i #ii.
    running(Transcript, actor, 'server', transcript)@#i &
    commit2(Transcript, peer, 'client', transcript)@#ii
    ==>
    Ex nonces #j #jj.
      commit(Nonces, actor, 'server', nonces)@#j & #j < #i &
      commit2(Nonces, peer, 'client', nonces)@#jj & #jj = #ii
  "

lemma cert_reception_matches_transcript [
      reuse,
      hide_lemma=authenticated_handshake_secret,
      hide_lemma=authenticated_handshake_secret_pfs,
      hide_lemma=kem_chal_dual,
      hide_lemma=entity_authentication,
      hide_lemma=mutual_entity_authentication,
      hide_lemma=injective_mutual_entity_authentication,
      hide_lemma=transcript_agreement,
      hide_lemma=mutual_transcript_agreement,
      hide_lemma=handshake_secret,
      hide_lemma=handshake_secret_pfs]:
  "All tid tid2 actor peer transcript #i #ii.
    running(Transcript, actor, 'server', transcript)@#i &
    commit2(Transcript, peer, 'client', transcript)@#ii
    ==>
      (Ex #sendcrtcrmt #recvcrt. C3_cert(tid2)@#sendcrtcrmt & S3_cert(tid)@#recvcrt & #sendcrtcrmt < #ii & #recvcrt < #i) |
      ((not Ex #sendcrtcrmt. C3_cert(tid2)@#sendcrtcrmt & #sendcrtcrmt < #ii) & not (Ex #recvcrt. S3_cert(tid)@#recvcrt & #recvcrt < #i))
  "

lemma auth_secret_consistency [reuse]:
  "All tid actor role aas pas secret #as.
    running(AuthSecret, actor, role, secret, <aas, pas>)@#as
    ==>
    (pas = '0' & secret = '0') |
    (pas = 'auth' & not (secret = '0'))"

lemma mutual_auth_secret_consistency [reuse]:
  "All tid actor role aas pas secret #as.
    running(MutualAuthSecret, actor, role, secret, <aas, pas>)@#as
    ==>
    (aas = '0' & secret = '0') |
    (aas = 'auth' & not (secret = '0'))"



/* IDEAS:
  running(AuthSecret, actor, role, '0', <aas, pas>)@#ras
  ==>
  p as = '0'

  ==> trivial

  commit(Identity, <'auth', 'auth'> has predecessor)
*/

// proves in 4 steps, probably not so useful
lemma commit_auth_secret_consistent [hide_lemma=kem_chal_dual]:
  "All tid actor role peer aas pas #commit12.
    commit(Identity, actor, role, peer, <aas, pas>)@#commit12
    ==>
      (Ex secret aas2 #runauth. running(AuthSecret, actor, role, secret, <aas2, pas>)@#runauth & #runauth < #commit12) &
      (Ex mutsecret pas2 #runmutauth. running(MutualAuthSecret, actor, role, mutsecret, <aas, pas2>)@#runmutauth & #runmutauth < #commit12)"

lemma commit_auth_running_consistent [hide_lemma=kem_chal_dual]:
  "All tid actor role peer aas pas #commit13.
    commit(Identity, actor, role, peer, <aas, pas>)@#commit13
    ==>
      (Ex #runid. running(Identity, actor, role, peer, <aas, pas>)@#runid & #runid < #commit13)"

// proves but not useful?
lemma auth_secret_ms_consistency [
    hide_lemma=kem_chal_dual]:
  "All tid actor role clauth_ss ms #t.
    running(MS, actor, role, clauth_ss, ms)@#t
    ==>
      (Ex auth_status #preauth. running(AuthSecret, actor, 'server', clauth_ss, auth_status)@#preauth & #preauth < #t) |
      (Ex auth_status #premutauth. running(MutualAuthSecret, actor, 'client', clauth_ss, auth_status)@#premutauth & #premutauth = #t)  
    " 

// autoproves but takes a while
lemma auth_implies_cert_was_sent_by_same_nonces [
    reuse,
    hide_lemma=kem_chal_dual]:
  "All tid tid2 actor peer aas nonces #t1 #t2.
    commit(Identity, actor, 'server', peer, <aas, 'auth'>)@#t1 &
    commit(Nonces, actor, 'server', nonces)@#t1 &
    commit2(Nonces, peer, 'client', nonces)@#t2
    ==>
      (Ex #recvcrt_aic. S3_cert(tid)@#recvcrt_aic & #recvcrt_aic < #t1) & (
        (Ex #sendcert_aic. C3_cert(tid2)@#sendcert_aic & #sendcert_aic < #t1) | 
        (Ex #revclcrt_aic. RevLtk(peer)@#revclcrt_aic)
      )"


lemma client_auth_means_clauth_ss_nonzero_client [
    reuse,
    hide_lemma=authenticated_handshake_secret_server,
    hide_lemma=handshake_secret,
    hide_lemma=handshake_secret_pfs,
    hide_lemma=kem_chal_dual,
    hide_lemma=authenticated_handshake_secret,
    hide_lemma=entity_authentication,
    hide_lemma=mutual_entity_authentication,
    hide_lemma=injective_mutual_entity_authentication,
    hide_lemma=transcript_agreement,
    hide_lemma=mutual_transcript_agreement,
    hide_lemma=authenticated_handshake_secret_pfs,
    hide_lemma=ku_extract,
    hide_lemma=master_secret,
    hide_lemma=master_secret_pfs]:
  "All tid actor peer sas #cid.
    commit(Identity, actor, 'client', peer, <'auth', sas>)@#cid
    ==> 
    (Ex clauth_ss ms #runms. running(MS, actor, 'client', clauth_ss, ms)@#runms & #runms < #cid & not (clauth_ss = '0'))"


lemma client_auth_means_clauth_ss_nonzero_server [reuse,
    hide_lemma=authenticated_handshake_secret_server,
    hide_lemma=handshake_secret,
    hide_lemma=handshake_secret_pfs,
    hide_lemma=kem_chal_dual,
    hide_lemma=authenticated_handshake_secret,
    hide_lemma=entity_authentication,
    hide_lemma=mutual_entity_authentication,
    hide_lemma=injective_mutual_entity_authentication,
    hide_lemma=transcript_agreement,
    hide_lemma=mutual_transcript_agreement,
    hide_lemma=authenticated_handshake_secret_pfs,
    hide_lemma=ku_extract,
    hide_lemma=master_secret,
    hide_lemma=master_secret_pfs]:
  "All tid actor peer sas #cid.
    commit(Identity, actor, 'server', peer, <sas, 'auth'>)@#cid
    ==> 
    (Ex clauth_ss ms #runms. running(MS, actor, 'server', clauth_ss, ms)@#runms & #runms = #cid & not (clauth_ss = '0'))"

lemma session_key_auth_agreement_right [
    reuse,
    hide_lemma=injective_mutual_entity_authentication,
    hide_lemma=transcript_agreement,
    hide_lemma=entity_authentication,
    hide_lemma=mutual_entity_authentication,
    hide_lemma=mutual_transcript_agreement,
    dnl the above is definitely distracting tamarin many, many steps extra
    dnl above is iig afleiding
    dnl hide_lemma=kem_chal_dual,
    dnl hide_lemma=handshake_secret,
    dnl hide_lemma=handshake_secret_pfs,
    dnl hide_lemma=authenticated_handshake_secret_server,
    dnl hide_lemma=authenticated_handshake_secret,
    dnl hide_lemma=authenticated_handshake_secret_pfs,
    dnl hide_lemma=master_secret,
    dnl hide_lemma=master_secret_pfs,
    dnl hide_lemma=ku_extract,
    dnl hide_lemma=ku_expand,
    dnl hide_lemma=ku_ahs,
    dnl hide_lemma=ku_hs,
    dnl hide_lemma=cert_reception_matches_transcript,
    dnl hide_lemma=commit_identity_authsecret_consistency,
    dnl hide_lemma=auth_secret_consistency,
    dnl hide_lemma=mutual_auth_secret_consistency,
    hide_lemma=posths_rms]:
  "All tid tid2 actor peer actor2 peer2 nonces keys keys2 cas sas cas2 sas2 #i #j #k #l.
    SessionKey(tid, actor, peer2, <cas, sas>, keys)@i &
    running(Nonces, actor, 'client', nonces)@j &
    SessionKey(tid2, peer, actor2, <sas2, cas2>, keys2)@k &
    running2(Nonces, peer, 'server', nonces)@l &
    not (Ex #r. RevLtk(actor)@r & #r < #i) &
    not (Ex #r. RevLtk(peer)@r & #r < #i & #r < #k) &
    not (Ex tid3 esk #r. RevEKemSk(tid3, actor, esk)@r & #r < #i & #r < #k)
    ifdef(<!PSK!>, <!
    &
    not (Ex rms #r. RevealPSK(actor, rms)@r & #r < #i & #r < #k) &
    not (Ex rms #r. RevealPSK(peer, rms)@r & #r < #i & #r < #k)
    !>)
    ==>
      sas = sas2"

lemma session_key_auth_agreement_left [
    reuse,
    dnl hide_lemma=injective_mutual_entity_authentication,
    dnl the above is definitely distracting tamarin many, many steps extra on _right
    dnl hide_lemma=entity_authentication,
    dnl hide_lemma=mutual_entity_authentication,
    dnl hide_lemma=transcript_agreement,
    dnl hide_lemma=mutual_transcript_agreement,
    dnl the above distracted _right?
    dnl hide_lemma=handshake_secret,
    hide_lemma=handshake_secret_pfs,
    hide_lemma=kem_chal_dual,
    dnl hide_lemma=authenticated_handshake_secret,
    hide_lemma=authenticated_handshake_secret_server,
    hide_lemma=authenticated_handshake_secret_pfs,
    hide_lemma=ku_extract,
    dnl hide_lemma=master_secret,
    hide_lemma=master_secret_pfs,
    hide_lemma=posths_rms]:
  "All tid tid2 actor peer actor2 peer2 nonces keys keys2 cas sas cas2 sas2 #i #j #k #l.
    SessionKey(tid, actor, peer2, <cas, sas>, keys)@i &
    running(Nonces, actor, 'client', nonces)@j &
    SessionKey(tid2, peer, actor2, <sas2, cas2>, keys2)@k &
    running2(Nonces, peer, 'server', nonces)@l &
    not (Ex #r. RevLtk(actor)@r & #r < #i) &
    not (Ex #r. RevLtk(peer)@r & #r < #i & #r < #k) &
    not (Ex tid3 esk #r. RevEKemSk(tid3, actor, esk)@r & #r < #i & #r < #k)
    ifdef(<!PSK!>, <!
    &
    not (Ex rms #r. RevealPSK(actor, rms)@r & #r < #i & #r < #k) &
    not (Ex rms #r. RevealPSK(peer, rms)@r & #r < #i & #r < #k)
    !>)
    ==>
      cas = cas2"

lemma session_key_auth_agreement_both [
    reuse,
    hide_lemma=authenticated_handshake_secret_server,
    hide_lemma=handshake_secret,
    hide_lemma=handshake_secret_pfs,
    hide_lemma=kem_chal_dual,
    hide_lemma=authenticated_handshake_secret,
    hide_lemma=entity_authentication,
    hide_lemma=mutual_entity_authentication,
    hide_lemma=injective_mutual_entity_authentication,
    hide_lemma=transcript_agreement,
    hide_lemma=mutual_transcript_agreement,
    hide_lemma=authenticated_handshake_secret_pfs,
    hide_lemma=ku_extract,
    hide_lemma=master_secret,
    hide_lemma=master_secret_pfs,
    hide_lemma=posths_rms]:
  "All tid tid2 actor peer actor2 peer2 nonces keys keys2 cas sas cas2 sas2 #i #j #k #l.
     SessionKey(tid, actor, peer2, <cas, sas>, keys)@i &
     running(Nonces, actor, 'client', nonces)@j &
     SessionKey(tid2, peer, actor2, <sas2, cas2>, keys2)@k &
     running2(Nonces, peer, 'server', nonces)@l &
      not (Ex #r. RevLtk(actor)@r & #r < #i) &
      not (Ex #r. RevLtk(peer)@r & #r < #i & #r < #k) &
      not (Ex tid3 esk #r. RevEKemSk(tid3, actor, esk)@r & #r < #i & #r < #k)
      ifdef(<!PSK!>, <!
      &
      not (Ex rms #r. RevealPSK(actor, rms)@r & #r < #i & #r < #k) &
      not (Ex rms #r. RevealPSK(peer, rms)@r & #r < #i & #r < #k)
      !>)
      ==>
       cas = cas2 & sas = sas2"

end
