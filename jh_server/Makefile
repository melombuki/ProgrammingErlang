.SUFFIXES: .erl .beam

EBIN = ./ebin
SRC = ./src
ERL = erl -boot start_clean

MODS = jh_server1.erl \
jh_server2.erl \
jh_server3.erl \
name_server1.erl \
name_server.erl

%.beam: 
	erlc -o $(EBIN) -W $(SRC)/$*

all: compile
	$(ERL) -pa $(EBIN)

compile: $(MODS:%=%.beam)

clean: 
	find . -type f \( -name '*.beam' -o -name 'erl_crash.dump' \) | xargs rm