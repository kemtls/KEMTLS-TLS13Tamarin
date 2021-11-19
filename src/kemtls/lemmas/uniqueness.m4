changequote(<!,!>)dnl
changecom(<!/*!>,<!*/!>)dnl
dnl
pushdef(<!F_State_S4!>, <!L_State_S4($@)!>)dnl
pushdef(<!F_State_C4!>, <!L_State_C4($@)!>)dnl
define(<!State!>,<!F_State_$1(shift($@))!>)dnl
dnl
theory TLS13_uniqueness
begin

include(header.m4i)
include(model.m4i)
include(all_lemmas.m4i)

include(includes/uniqueness.m4i)

end

popdef(<!F_State_S4!>)
popdef(<!F_State_C4!>)

// vim: ft=spthy 
