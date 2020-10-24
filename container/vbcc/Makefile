LHA_OPTS ?= fgq
LHA_X = lha x$(LHA_OPTS)
RSYNC = rsync -a --no-p --no-g --chmod=ugo=rwX
CURL = curl -fLO

PREFIX ?= $(HOME)/.local
VBCC ?= $(PREFIX)/vbcc

VASM_URL = http://sun.hasenbraten.de/vasm/release/vasm.tar.gz
VLINK_URL = http://sun.hasenbraten.de/vlink/release/vlink.tar.gz
VBCC_URL = http://phoenix.owl.de/tags/vbcc0_9g.tar.gz
VBCC_AMIGAOS_URL = http://phoenix.owl.de/vbcc/2019-10-04/vbcc_target_m68k-amigaos.lha
VBCC_CONFIG_URL = http://phoenix.owl.de/vbcc/2019-10-04/vbcc_unix_config.tar.gz
VBCC_POSIXLIB_URL = http://aminet.net/dev/c/vbcc_PosixLib.lha
AMIGAOS_NDK_URL = http://www.haage-partner.de/download/AmigaOS/NDK39.lha

DOWNLOAD_TARGETS = cache/vasm.tar.gz cache/vlink.tar.gz cache/vbcc0_9g.tar.gz
DOWNLOAD_TARGETS += cache/vbcc_target_m68k-amigaos.lha
DOWNLOAD_TARGETS += cache/vbcc_unix_config.tar.gz
DOWNLOAD_TARGETS += cache/vbcc_PosixLib.lha
DOWNLOAD_TARGETS += cache/NDK39.lha

.PHONY: all
all: vasm vlink vbcc xdk

.PHONY: install
install: bindirs install-vasm install-vlink install-vbcc install-vc install-xdk

bindirs: $(PREFIX)/bin $(VBCC)/bin

$(PREFIX)/bin:
	install -d $@

$(VBCC)/bin:
	install -d $@

.PHONY: download
download: $(DOWNLOAD_TARGETS)

ifeq ($(PREFIX),$(VBCC))
install-vc:
else
install-vc: $(PREFIX)/bin/vc

$(PREFIX)/bin/vc: vc.sh
	install -CSpvm0755 $^ $@

vc.sh: src/vc.sh.in
	sed -e s:__VBCC__:$(VBCC): $< > $@
endif

##
## VASM goals
##
VASM_TARGETS = vasm/vasmm68k_mot vasm/vobjdump
.PHONY: install-vasm
install-vasm: $(VASM_TARGETS)
	install -CSpsv $^ $(VBCC)/bin

.PHONY: vasm
vasm: $(VASM_TARGETS)

vasm/vasmm68k_mot: vasm/Makefile
	make -C vasm CPU=m68k SYNTAX=mot vasmm68k_mot

vasm/vobjdump: vasm/Makefile
	make -C vasm CPU=m68k SYNTAX=mot vobjdump

vasm/Makefile: cache/vasm.tar.gz
	tar zxf $<

cache/vasm.tar.gz:
	mkdir -p cache && cd cache && $(CURL) $(VASM_URL)

##
## VLINK goals
##
VLINK_TARGETS = vlink/vlink
.PHONY: install-vlink
install-vlink: $(VLINK_TARGETS)
	install -CSpsv $^ $(VBCC)/bin

.PHONY: vlink
vlink: $(VLINK_TARGETS)

vlink/vlink: vlink/Makefile
	make -C vlink vlink

vlink/Makefile: cache/vlink.tar.gz
	tar zxf $<

cache/vlink.tar.gz:
	mkdir -p cache && cd cache && $(CURL) $(VLINK_URL)

##
## VBCC goals
##
VBCC_TARGETS = vbcc/bin/vbccm68k vbcc/bin/vbccm68ks vbcc/bin/vc vbcc/bin/vprof

.PHONY: install-vbcc
install-vbcc: vbcc
	install -CSpsv $(VBCC_TARGETS) $(VBCC)/bin

.PHONY: vbcc
vbcc: vbcc/Makefile vbcc/bin
	yes '' | make -C vbcc TARGET=m68k
	yes '' | make -C vbcc TARGET=m68ks

vbcc/bin:
	mkdir -p $@

vbcc/Makefile: cache/vbcc0_9g.tar.gz
	tar zxf $<

cache/vbcc0_9g.tar.gz:
	mkdir -p cache && cd cache && $(CURL) $(VBCC_URL)

##
## XDK goals
##
.PHONY: install-xdk
install-xdk: install-amigaos-sdk install-config install-posixlib install-ndk

.PHONY: xdk
xdk: vbcc_target_m68k-amigaos config PosixLib NDK_3.9

TARGET_VBCC = $(VBCC)/targets/m68k-amigaos
.PHONY: install-amigaos-sdk
install-amigaos-sdk: vbcc_target_m68k-amigaos
	install -d $(TARGET_VBCC)
	$(RSYNC) $</targets/m68k-amigaos $(VBCC)/targets/

vbcc_target_m68k-amigaos: cache/vbcc_target_m68k-amigaos.lha
	$(LHA_X) $<

cache/vbcc_target_m68k-amigaos.lha:
	mkdir -p cache && cd cache && $(CURL) $(VBCC_AMIGAOS_URL)

CONFIG_FILES = config/aos68k config/aos68km config/aos68kr config/aos68kp
.PHONY: install-config
install-config: $(VBCC)/config $(VBCC)/config/vc.config

$(VBCC)/config: config
	install -d $(VBCC)/config
	install -CSpvm0644 $(CONFIG_FILES) $(VBCC)/config

$(VBCC)/config/vc.config:
	ln -s aos68kp $@

config: cache/vbcc_unix_config.tar.gz config.diff
	tar zxf cache/vbcc_unix_config.tar.gz
	patch -d config < config.diff

cache/vbcc_unix_config.tar.gz:
	mkdir -p cache && cd cache && $(CURL) $(VBCC_CONFIG_URL)

.PHONY: install-posixlib
install-posixlib: PosixLib
	install -d $(VBCC)/posix
	$(RSYNC) PosixLib $(VBCC)/posix
	rm -rf $(VBCC)/posix/lib
	ln -fs PosixLib/AmigaOS3 $(VBCC)/posix/lib
	rm -rf $(VBCC)/posix/include
	ln -fs PosixLib/include $(VBCC)/posix/include

PosixLib: cache/vbcc_PosixLib.lha
	$(LHA_X) $<

cache/vbcc_PosixLib.lha:
	mkdir -p cache && cd cache && $(CURL) $(VBCC_POSIXLIB_URL)

.PHONY: install-ndk
install-ndk: NDK_3.9
	install -d $(VBCC)/ndk
	$(RSYNC) NDK_3.9 $(VBCC)/ndk
	rm -rf $(VBCC)/ndk/include
	ln -fs NDK_3.9/Include/include_h $(VBCC)/ndk/include

NDK_3.9: cache/NDK39.lha
	$(LHA_X) $<

cache/NDK39.lha:
	mkdir -p cache && cd cache && $(CURL) $(AMIGAOS_NDK_URL)

##
## Infrastructure goals
##

.PHONY: clean
clean:
	-rm -rf config posixlib v* NDK*
