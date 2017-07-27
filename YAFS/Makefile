.SUFFIXES: .erl .beam

EBIN = ./ebin
SRC = ./src
ERL = erl -boot start_clean

MODS = kvs.erl \
mod_name_server.erl \
lib_chan.erl \
lib_chan_mm.erl \
lib_chan_cs.erl \
lib_chan_auth.erl \
lib_md5.erl \
jh_yafs.erl

%.beam: 
	erlc -o $(EBIN) -W $(SRC)/$*

all: compile
	$(ERL) -pa $(EBIN)

compile: $(MODS:%=%.beam)

clean: 
	find . -type f \( -name '*.beam' -o -name 'erl_crash.dump' \) | xargs rm