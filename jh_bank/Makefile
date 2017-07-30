.SUFFIXES: .erl .beam

EBIN = ./ebin
SRC = ./src
ERL = erl -boot start_clean

MODS = jh_bank.erl

%.beam: 
	erlc -o $(EBIN) -W $(SRC)/$*

all: compile
	$(ERL) -pa $(EBIN)

compile: $(MODS:%=%.beam)

clean: 
	find . -type f \( -name '*.beam' -o -name 'erl_crash.dump' \) | xargs rm