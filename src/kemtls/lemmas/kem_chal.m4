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

include(includes/uniqueness.m4i)

include(includes/sources.m4i)

include(includes/kems.m4i)

end

popdef(<!F_State_C4!>)
popdef(<!F_State_S4!>)