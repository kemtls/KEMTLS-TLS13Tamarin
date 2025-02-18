changequote(<!,!>)
changecom(<!/*!>,<!*/!>)
define(<!State!>,<!F_State_$1(shift($@))!>)dnl
define(<!ClientCertReq!>,<!L_ClientCertReq($@)!>)dnl
define(<!ServerCertReq!>,<!L_ServerCertReq($@)!>)dnl
define(<!CachePSK!>, <!F_CachePSK($@)!>)dnl

define(<!SecretPSK!>, <!F_SecretPSK($@)!>)dnl


theory TLS_13_invariants
begin

include(header.m4i)
include(model.m4i)
include(all_lemmas.m4i)

include(includes/sources.m4i)

include(includes/uniqueness.m4i)

include(includes/invariants.m4i)

end
