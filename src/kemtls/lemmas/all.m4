changequote(<!,!>)
changecom(<!/*!>,<!*/!>)
pushdef(<!F_State_S4!>, <!L_State_S4($@)!>)dnl
pushdef(<!F_State_C4!>, <!L_State_C4($@)!>)dnl
define(<!State!>,<!F_State_$1(shift($@))!>)dnl
define(<!ClientCertReq!>,<!L_ClientCertReq($@)!>)dnl
define(<!ServerCertReq!>,<!L_ServerCertReq($@)!>)dnl
define(<!CachePSK!>, <!F_CachePSK($@)!>)dnl


theory TLS_13_all_lemmas
begin

include(header.m4i)
include(model.m4i)
include(all_lemmas.m4i)

/* sources */
include(includes/sources.m4i)

/* invariants */
include(includes/uniqueness.m4i)

include(includes/invariants.m4i)

/* kems */
include(includes/kems.m4i)

/*  auth_helpers */
include(includes/nonces.m4i)

/* Secret helpers */
include(includes/ku.m4i)

include(includes/matching.m4i)

dnl include(includes/posths.m4i)

lemma_transcript_agreement

end


popdef(<!F_State_S4!>)
popdef(<!F_State_C4!>)
