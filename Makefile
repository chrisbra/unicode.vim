SCRIPT   = $(wildcard plugin/*.vim)
AUTOL    = $(wildcard autoload/*.vim)
SYNTAX   = $(wildcard syntax/*.vim)
FTDETECT = $(wildcard ftdetect/*.vim)
DOC      = $(wildcard doc/*.txt)
PLUGIN   = $(shell basename "$$PWD")
VERSION  = $(shell sed -n '/Version:/{s/^.*\(\S\.\S\+\)$$/\1/;p}' $(SCRIPT))

.PHONY: $(PLUGIN).vmb

all: uninstall dummy vimball install rm_dummy

vimball: $(PLUGIN).vmb

dummy:
	printf ' " This space intentionally left blank\n'> autoload/unicode/UnicodeData.vim

rm_dummy:
	rm autoload/unicode/UnicodeData.vim

clean:
	rm -f *.vba *.vmb */*.orig *.~* .VimballRecord

dist-clean: clean

install:
	vim -N -c':so %' -c':q!' $(PLUGIN)-$(VERSION).vmb

uninstall:
	vim -N -c':RmVimball' -c':q!' $(PLUGIN)-$(VERSION).vmb

undo:
	for i in */*.orig; do mv -f "$$i" "$${i%.*}"; done

$(PLUGIN).vmb:
	rm -f $(PLUGIN)-$(VERSION).vmb
	vim -N -c 'ru! vimballPlugin.vim' -c ':call append("0", [ "$(SCRIPT)", "$(AUTOL)", "$(DOC)", "autoload/unicode/UnicodeData.vim", "$(SYNTAX)", "$(FTDETECT)"])' -c '$$d' -c ":%MkVimball $(PLUGIN)-$(VERSION)  ." -c':q!'
	ln -f $(PLUGIN)-$(VERSION).vmb $(PLUGIN).vmb
     
release: version all

version:
	perl -i.orig -pne 'if (/Version:/) {s/\.(\d*)/sprintf(".%d", 1+$$1)/e}' ${SCRIPT} ${AUTOL}
	perl -i -pne 'if (/GetLatestVimScripts:/) {s/(\d+)\s+:AutoInstall:/sprintf("%d :AutoInstall:", 1+$$1)/e}' ${SCRIPT}  ${AUTOL}
	#perl -i -pne 'if (/Last Change:/) {s/\d+\.\d+\.\d\+$$/sprintf("%s", `date -R`)/e}' ${SCRIPT}
	perl -i -pne 'if (/Last Change:/) {s/(:\s+).*\n/sprintf(": %s", `date -R`)/e}' ${SCRIPT} ${AUTOL}
	perl -i.orig -pne 'if (/Version:/) {s/\.(\d+).*\n/sprintf(".%d %s", 1+$$1, `date -R`)/e}' ${DOC}
	VERSION=$(shell sed -n '/Version:/{s/^.*\(\S\.\S\+\)$$/\1/;p}' $(SCRIPT))
