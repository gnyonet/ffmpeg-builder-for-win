
PREFIX=$(PWD)

all:ffmpeg/configure ffmpeg

ffmpeg/configure:
	git submodule init
	git submodule update

.PHONY:ffmpeg ffmpeg-build
ffmpeg:bin/ffmpeg
bin/ffmpeg:ffmpeg/ffmpeg_g
	$(MAKE) -C ffmpeg install
ffmpeg/ffmpeg_g:lib/libx264.a lib/libfdk-aac.a ffmpeg/config.mak ffmpeg-build
ffmpeg-build:
	$(MAKE) -C ffmpeg
FFMPEG-OPTIONS+=--prefix=$(PREFIX)
FFMPEG-OPTIONS+=--enable-gpl
FFMPEG-OPTIONS+=--enable-libx264
FFMPEG-OPTIONS+=--enable-nonfree
FFMPEG-OPTIONS+=--enable-libfdk-aac
ffmpeg/config.mak:
	cd ffmpeg && PKG_CONFIG_PATH=$(PREFIX)/lib/pkgconfig ./configure $(FFMPEG-OPTIONS)

.PHONY:x264 x264-build
x264:lib/libx264.a
lib/libx264.a:x264/libx264.a
	$(MAKE) -C x264 install
x264/libx264.a:x264/config.mak x264-build
x264-build:
	$(MAKE) -C x264
X264-OPTIONS+=--prefix=$(PREFIX)
X264-OPTIONS+=--enable-static
x264/config.mak:
	cd x264 && ./configure $(X264-OPTIONS)

.PHONY:fdk-aac fdk-aac-build
fdk-aac:lib/libfdk-aac.a
lib/libfdk-aac.a:fdk-aac/.libs/libfdk-aac.a
	$(MAKE) -C fdk-aac install
fdk-aac/.libs/libfdk-aac.a:fdk-aac/Makefile fdk-aac-build
fdk-aac-build:
	$(MAKE) -C fdk-aac
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

