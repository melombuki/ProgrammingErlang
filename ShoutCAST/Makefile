.SUFFIXES: .erl .beam

EBIN = ./ebin
SRC = ./src
ERL = erl -boot start_clean

MODS = mp3_manager.erl \
lib_files_find.erl \
lib_misc.erl \
shout.erl \
id3_tag_lengths.erl

%.beam: 
	erlc -o $(EBIN) -W $(SRC)/$*

all: compile
	$(ERL) -pa $(EBIN)

compile: $(MODS:%=%.beam)

clean: 
	find . -type f \( -name '*.beam' -o -name 'erl_crash.dump' \) | xargs rm