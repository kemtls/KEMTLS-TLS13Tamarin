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

lemma ms_secret [hide_lemma=ku_encaps, hide_lemma=ku_decaps, hide_lemma=ku_ms,
                 hide_lemma=ku_extract, hide_lemma=ku_expand, hide_lemma=client_finished_running,
                 hide_lemma=server_finished_running]:
    "
    All tid tid2 server client sas cas ms #i #j.
    commit(MS, server, 'server', ms)@#i &
    commit(Identity, server, 'server', client, <sas, 'auth'>)@#i & 
    commit2(MS, client, 'client', ms)@#j &
    commit2(Identity, client, 'client', server, <cas, 'auth'>)@#j &
    not (Ex #revserv. RevLtk(server)@#revserv & #revserv < #i) &
    not (Ex #revcl.   RevLtk(client)@#revcl & #revcl < #j) &
    not (Ex esk #revesk. RevEKemSk(tid2, client, esk)@#revesk)
    ==>
    not (Ex #kums. KU(ms)@#kums)
    " 

include(includes/secrets_todo.m4i)

end
