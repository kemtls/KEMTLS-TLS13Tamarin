changequote(<!,!>)dnl
changecom(<!/*!>,<!*/!>)dnl
dnl
define(<!State!>,<!State_$1(shift($@))!>)dnl
dnl
define(<!In!>,<!F_MessageIn($*)!>)dnl
define(<!Out!>,<!MessageOut($*)!>)dnl
dnl
theory <!TLS_13_reachability_tests_!>RULE
begin

include(header.m4i)
include(model.m4i)
include(../at_most_of.m4i)

restriction one_actor_per_role: "All actor actor2 nc nc2 role #i #j. Instance(nc, actor, role)@i & Instance(nc2, actor2, role)@j ==> actor = actor2"

/*
  This trick allows Tamarin to lazily evaluate where messages came from.
  Otherwise, Tamarin attempts to preprocess too much and struggles.
*/
rule in_out:
[MessageOut(m)]-->[F_MessageIn(m)]

define(<!AXIOMS!>, <!!>)
define(<!LEMMAS!>, <!!>)

define(<!create_lemma!>, <!
define(<!AXIOMS!>, AXIOMS <!
at_most_of($2, $1, 1)
restriction one_$1_per_tid:
    "All tid #i #j. $1(tid)@i & $1(tid)@j ==> #i = #j"

!>)
define(<!LEMMAS!>, LEMMAS <!
lemma exists_$1:
  exists-trace
    "Ex tid #i. $1(tid)@i"
!>)
!>)

dnl at_most_of(1, S1_retry, 1)
dnl at_most_of(1, C1_retry, 1)

ifdef(<!BASIC!>, <!
create_lemma(C0, 1)
create_lemma(C1_retry, 1)
create_lemma(S1, 1)
create_lemma(C1, 1)
create_lemma(S2a, 2)
create_lemma(S2b, 2)
create_lemma(S2c, 1)
create_lemma(S2c_req, 1)
create_lemma(S2d, 1)
create_lemma(S2e, 1)
create_lemma(C2a, 2)
create_lemma(C2b, 2)
create_lemma(C2c, 2)
create_lemma(C2c_req, 1)
create_lemma(C2d, 1)
create_lemma(C3_skip_cert, 1)
create_lemma(C3a, 1)
create_lemma(C3b, 2)
create_lemma(S3, 1)
create_lemma(S3_cert, 1)
create_lemma(S3a, 1)
create_lemma(S3fin, 1)
create_lemma(Send, 1)
create_lemma(Recv, 1)
ifdef(<!PSK!>,<!
create_lemma(S4_NST, 1)
create_lemma(C4_NST, 1)
create_lemma(C0_PSK, 1)
create_lemma(S0_PSK, 2)
create_lemma(S1_PSK, 1)
create_lemma(S1_PSK_DHE, 1)
create_lemma(C1_PSK, 1)
create_lemma(C1_retry_PSK, 1)
create_lemma(C1_PSK_DHE, 1)
create_lemma(S2d_PSK, 1)
create_lemma(C2d_PSK, 1)
dnl create_lemma(C_ZeroRTT_Auth, 1)
dnl create_lemma(S_RecvZeroRTTAuth, 1)
create_lemma(C_EndZeroRTT, 1)
create_lemma(S_RecvEndZeroRTT, 1)
create_lemma(C_SendZeroRTT, 1)
create_lemma(S_RecvZeroRTT, 1)
!>)
ifdef(<!POST_HS!>, <!
at_most_of(4, RPostHS, 4)

create_lemma(S4_req, 1)
create_lemma(C4_req, 1)
create_lemma(S4_cert, 1)
create_lemma(C4_cert, 1)
create_lemma(C4_update_req, 1)
create_lemma(C4_update_recv, 1)
create_lemma(C4_update_fin, 1)
create_lemma(S4_update_req, 1)
create_lemma(S4_update_recv, 1)
create_lemma(S4_update_fin, 1)
!>)

!>) dnl ENDIFDEF BASIC

ifdef(<!PDK!>, <!
/*
 * PDK lemmas
 */
create_lemma(C0_PDK, 1)
// emit cert?
create_lemma(C1_PDK_cert, 1)
create_lemma(C1_PDK_skip_cert, 1)
// receive SH
create_lemma(C1a_PDK, 1)
// gen keys
create_lemma(C2a_PDK, 1)
// eenc
create_lemma(C2b_PDK, 1)
//ciphertext
create_lemma(C2c_PDK, 1)
create_lemma(C2c_PDK_skip_ct, 1)
// receive finished
create_lemma(C2d_PDK, 1)
// send finished
create_lemma(C3_PDK, 1)

// server side
// receive CH
create_lemma(S0_PDK, 1)
// SH
create_lemma(S1_PDK_cert, 1)
create_lemma(S1_PDK_no_cert, 1)
// genkeys
create_lemma(S2a_PDK, 1)
// eenc
create_lemma(S2b_PDK, 1)
// ct
create_lemma(S2c_PDK_no_cert, 1)
create_lemma(S2c_PDK_cert, 1)
// send finished
create_lemma(S2d_PDK, 1)
// recv finished
create_lemma(S3_PDK, 1)

!>)

AXIOMS

dnl Uncomment this to have lemmas for all rules/states
ifdef(<!ALL!>, <!
LEMMAS
!>, <!
lemma <!exists_!>RULE:
  exists-trace
    "Ex tid #i. RULE<!(tid)!>@i"
!>)

end

// vim: ft=spthy 
