changequote(<!,!>)
changecom(<!/*!>,<!*/!>)
define(<!EKem!>,<!F_EKem($@)!>)
define(<!State!>,<!L_State_$1(shift($@))!>)
define(<!ClientCertReq!>,<!L_ClientCertReq($@)!>)
define(<!ServerCertReq!>,<!L_ServerCertReq($@)!>)
define(<!CachePSK!>, <!F_CachePSK($@)!>)
define(<!ClientPSK!>, <!L_ClientPSK($@)!>)
define(<!ServerPSK!>, <!L_ServerPSK($@)!>)


theory TLS_13_kem_chal
begin

include(header.m4i)
include(model.m4i)
include(all_lemmas.m4i)
include(../at_most_of.m4i)

at_most_of(4, RPostHS, 4)

lemma_cert_req_origin
lemma_nst_source

uniq(C0)
uniq(C1_retry)
uniq(S1)
uniq(C1)

lemma_ekem_sk_invariant
lemma_one_ekem_per_x
lemma_ekem_sk_secret_ordering
lemma_ekem_pk_can_be_decapsed
lemma_ekem_sk_can_be_revealed
lemma_rev_ekem_ordering
lemma_ekem_esk_can_only_be_revealed
lemma_ekem_chal_dual

end