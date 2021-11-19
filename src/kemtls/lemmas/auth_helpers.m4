changequote(<!,!>)
changecom(<!/*!>,<!*/!>)
pushdef(<!F_State_S4!>, <!L_State_S4($@)!>)dnl
pushdef(<!F_State_C4!>, <!L_State_C4($@)!>)dnl
define(<!State!>,<!F_State_$1(shift($@))!>)dnl
define(<!ClientCertReq!>,<!L_ClientCertReq($@)!>)dnl
define(<!ServerCertReq!>,<!L_ServerCertReq($@)!>)dnl
define(<!CachePSK!>, <!F_CachePSK($@)!>)dnl


theory TLS_13_auth_helpers
begin

include(header.m4i)
include(model.m4i)
include(all_lemmas.m4i)

include(includes/uniqueness.m4i)

include(includes/nonces.m4i)

end

popdef(<!F_State_S4!>)
popdef(<!F_State_C4!>)
