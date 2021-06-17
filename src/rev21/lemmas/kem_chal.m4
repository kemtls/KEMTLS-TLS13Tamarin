changequote(<!,!>)
changecom(<!/*!>,<!*/!>)
define(<!State!>,<!F_State_$1(shift($@))!>)
define(<!ClientCertReq!>,<!L_ClientCertReq($@)!>)
define(<!ServerCertReq!>,<!L_ServerCertReq($@)!>)
define(<!CachePSK!>, <!F_CachePSK($@)!>)
define(<!ClientPSK!>, <!L_ClientPSK($@)!>)
define(<!ServerPSK!>, <!L_ServerPSK($@)!>)


theory TLS_13_dh_chal
begin

include(header.m4i)
include(model.m4i)
include(all_lemmas.m4i)

uniq(C0)
uniq(C1_retry)
uniq(S1)
uniq(C1)

lemma_one_kem_per_x
lemma_kem_sk_secret
lemma_kem_pk_can_be_decapsed

end