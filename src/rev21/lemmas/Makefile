DEPS= $(wildcard *.m4i) $(wildcard ../model/*.m4i)
M4= $(patsubst %.m4,%.spthy,$(wildcard *.m4))
PIPE=--quit-on-warning 2>error.log 1>>success.log
TAM=tamarin-prover
FLAGS= -DPSK=1

all: $(M4)

clean:
	rm -f $(M4)

%.spthy: %.m4 $(DEPS)
	m4 -Q $(FLAGS) -I ../ -I../model -I . $< > $@
	# Strip extra new lines introduced by M4 macros
	perl -0777pi -e 's/\n{3,}/\n\n/g' $@
	# Replace "prev_" with "p_" to save space...
	perl -0777pi -e 's/prev_/p_/g' $@


proofs:
	rm -f error.log
	rm -rf success.log
	bash -c "$(TAM) invariants.spthy --prove=tid* --output=../proofs/invariants.1.spthy $(PIPE)"
	bash -c "$(TAM) invariants.spthy --prove=one_start* --output=../proofs/invariants.2.spthy $(PIPE)"
	bash -c "$(TAM) uniqueness.spthy --prove --output=../proofs/uniqueness.spthy $(PIPE)"
	bash -c "$(TAM) auth_helpers.spthy --prove=matching* --prove=consistent* --prove=invariant* --output=../proofs/auth_helpers.spthy $(PIPE)"
	bash -c "$(TAM) kem_chal.spthy --prove=one_ekem* --prove=ekem_sk* --prove=ekem_pk_* --output=../proofs/kem_chal.1.spthy $(PIPE)"
	# To prove manually:
	#   - ekem_esk_can_only_be_revealed
	#   - ekem_seed_needs_rev_esk
	#   - kem_chal: ekem_chal_dual (somewhat mostly pressing 1)
	bash -c "$(TAM) secret_helpers.spthy --prove=tid* --prove=ku* --prove=hsms* --prove=sig_origin* --prove=posths_rms* --heuristic=S --output=../proofs/secret_helpers.1.spthy $(PIPE)"
	bash -c "$(TAM) secret_helpers.spthy --prove=matching_rms_posths* --prove=matching_transcripts_posths* --prove=matching_rms_actors* --bound=8 --heuristic=CCCiiiiiiii --output=../proofs/secret_helpers.2.spthy $(PIPE)"
	bash -c "$(TAM) secret_helpers.spthy --prove=matching_sessions* --heuristic=CCCCCissssssssssssssssssssssss --output=../proofs/secret_helpers.3.spthy $(PIPE)"
	# To prove manually:
	#   - auth_psk (75% auto: autoprove for recv_server_auth{_cert} and  recv_client_auth_cert. The rest is manual by using CommitID -> $S.1 = $S.
	#   - hsms_hs_thingy
	#   - post_master_secret (quick)
	#   - invariant_post_hs (quick: solve for RunningRMS then CommitIdentity)
	#   - handshake_secret (the big one)

	#bash -c "$(TAM) lemma.spthy --prove=secret_session_keys* --output=../proofs/lemmas.1.spthy $(PIPE)"
	#bash -c "$(TAM) lemma.spthy --prove=unique_session_keys --heuristic=c --output=../proofs/lemmas.2.spthy --bound=10 $(PIPE)"


	# To prove manually:
	#   - entity_authentication
	#   - mutual_entity authentication
	#   - transcript_agreement
	#   - mutual_transcript_agreement
	#   - session_key_agreement


.PHONY: clean proofs

