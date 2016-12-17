
PREFIX=$(PWD)

all:ffmpeg/configure ffmpeg

ffmpeg/configure:
	git submodule init
	git submodule update

.PHONY:ffmpeg
ffmpeg:ffmpeg/config.mak
	$(MAKE) -C ffmpeg install
FFMPEG-OPTIONS+=--prefix=$(PREFIX)
FFMPEG-OPTIONS+=--enable-gpl
FFMPEG-OPTIONS+=--enable-libx264
FFMPEG-OPTIONS+=--enable-nonfree
FFMPEG-OPTIONS+=--enable-libfdk-aac
ffmpeg/config.mak:x264 fdk-aac
	cd ffmpeg && PKG_CONFIG_PATH=$(PREFIX)/lib/pkgconfig ./configure $(FFMPEG-OPTIONS)

.PHONY:x264
x264:x264/config.mak
	$(MAKE) -C x264 install
X264-OPTIONS+=--prefix=$(PREFIX)
X264-OPTIONS+=--enable-static
x264/config.mak:
	cd x264 && ./configure $(X264-OPTIONS)

.PHONY:fdk-aac
fdk-aac:fdk-aac/Makefile
	$(MAKE) -C fdk-aac install
fdk-aac/configure:
	cd fdk-aac && autoreconf -fiv
FDK-AAC-OPTIONS+=--prefix=$(PREFIX)
FDK-AAC-OPTIONS+=--enable-shared=no
fdk-aac/Makefile:fdk-aac/configure
	cd fdk-aac && ./configure $(FDK-AAC-OPTIONS)

clean:ffmpeg-clean x264-clean
	$(RM) -r bin lib doc include share
ffmpeg-clean:
	$(MAKE) -C ffmpeg clean
	$(RM) ffmpeg/config.*
x264-clean:
	$(MAKE) -C x264 clean
	$(RM) x264/config.mak
fdk-aac-clean:
	$(MAKE) -C fdk-aac clean
	$(RM) fdk-aac/Makefile fdk-aac/configure

