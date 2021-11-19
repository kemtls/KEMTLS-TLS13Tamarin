changequote(<!,!>)
changecom(<!/*!>,<!*/!>)
define(<!EKem!>,<!F_EKem($@)!>)
pushdef(<!State_C4!>, <!L_State_S4($@)!>)dnl
pushdef(<!State_C4!>, <!L_State_C4($@)!>)dnl~
define(<!State!>,<!State_$1(shift($@))!>)
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

include(restrictions.m4i)

lemma_cert_req_origin
lemma_nst_source

lemma_ekem_sk_invariant
lemma_one_ekem_per_x
lemma_ekem_sk_secret_ordering
lemma_ekem_pk_can_be_decapsed
lemma_ekem_sk_can_be_revealed
lemma_rev_ekem_ordering
lemma_ekem_only_revsk_in_client
lemma_rev_ekem_before_hs
lemma_ekem_esk_can_only_be_revealed
lemma_ekem_seed_needs_rev_esk

lemma_ekem_chal_dual

end

popdef(<!F_State_C4!>)
popdef(<!F_State_S4!>)