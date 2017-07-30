.SUFFIXES: .erl .beam

EBIN = ./ebin
SRC = ./src
ERL = erl -boot start_clean

MODS = area_server.erl \
prime_server.erl \
lib_primes.erl \
sellaprime_sup.erl \
my_alarm_handler.erl \
lib_lin.erl

%.beam: 
	erlc -o $(EBIN) -W $(SRC)/$*

all: compile
	$(ERL) -pa $(EBIN)

compile: $(MODS:%=%.beam)

clean: 
	find . -type f \( -name '*.beam' -o -name 'erl_crash.dump' \) | xargs rm