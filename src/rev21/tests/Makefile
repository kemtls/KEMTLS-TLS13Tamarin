DEPS= $(wildcard *.m4i)
M4= $(patsubst %.m4,%.spthy,$(wildcard *.m4))

# MAKE_RULES=C1 S0a S1 S1a S1b S1c  C2 C2a C2b C2c C2d S2 Send Recv S_NST C_NST C1_PSK S0a_PSK S1_PSK S1_PSK_DHE C2_PSK C2_PSK_DHE S1c_PSK C2c_PSK\
 C_ZeroRTT_Auth S_RecvZeroRTTAuth C_EndZeroRTT C_SendZeroRTT S_RecvZeroRTT S_RecvEndZeroRTT
TEST_RULES=C0 C1_retry S1 C1 S2a S2b S2c S2c_req S2d C2a C2b C2c C2c_req C2d C3 C3_cert S3 S3_cert Send Recv S4_NST C4_NST C0_PSK S0_PSK C_ZeroRTT_Auth S_RecvZeroRTTAuth C_EndZeroRTT S_RecvEndZeroRTT C_SendZeroRTT S_RecvZeroRTT S1_PSK S1_PSK_DHE C1_PSK C1_retry_PSK C1_PSK_DHE S2d_PSK C2d_PSK S4_req C4_req S4_cert C4_cert C4_update_req C4_update_recv C4_update_fin S4_update_req S4_update_recv S4_update_fin
MAKE_RULES=$(TEST_RULES)

all:
	$(foreach rule, $(MAKE_RULES), \
	m4 -Q $(FLAGS) -I ../ -I../model -I . -D RULE=$(rule) reachability.m4 > $(rule).spthy;\
	perl -0777pi -e 's/\n{3,}/\n\n/g' $(rule).spthy ; \
	)

test: all
	$(foreach rule, $(TEST_RULES), tamarin-prover --heuristic=S --prove=exists_* $(rule).spthy -o=$(rule).spthy +RTS -N40 -H75G -M150G -RTS 2> output.log; )
clean:
	rm -f *.spthy

.PHONY: clean test all
