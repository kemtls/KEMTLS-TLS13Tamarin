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

ifdef(<!PDK!>, <!

lemma exists_pdk_works_nocert:
  exists-trace
  "Ex tid #i #f.
    CPDK_start_nocert(tid)@#i & 
    C3_PDK(tid)@#f &
    not (Ex a #r. RevLtk(a)@#r) &
    not (Ex tid2 a esk #r. RevEKemSk(tid2, a, esk)@#r)
  "

lemma exists_pdk_works_cert:
  exists-trace
  "Ex tid #i #f.
    CPDK_start_cert(tid)@#i & 
    C3_PDK(tid)@#f &
    not (Ex a #r. RevLtk(a)@#r) &
    not (Ex tid2 a esk #r. RevEKemSk(tid2, a, esk)@#r)
  "

lemma exists_reject_pdk:
  exists-trace
  "Ex tid #i #j #f.
    C0_PDK(tid)@#i & 
    C1(tid)@#j &
    C3b(tid)@#f &
    not (Ex a #r. RevLtk(a)@#r) &
    not (Ex tid2 a esk #r. RevEKemSk(tid2, a, esk)@#r)
    "

!>)

end

// vim: ft=spthy 
