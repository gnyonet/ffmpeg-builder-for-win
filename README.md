# ffmpeg-builder-for-win
ffmpeg builder for windows subsystem for linux

## 概要
個人的な作業効率改善のためのffmpegビルド環境です。
特に、Windows10のwindows subsystem for linuxをターゲットにしたffmpegのビルド環境を提供します。
CentOS系でも普通に動くでしょうが、yumでインストールすべきパッケージは自分で調べてください。
https://trac.ffmpeg.org/wiki/Encode/AAC
に記載があるように、AAC encoderはnonfreeなので、自分でビルドしてください。

## セットアップ
1. windows subsystem for linuxを有効にする
1. ファイル名を指定して実行でbashを起動
1. ```sudo apt-get install git gcc g++ yasm pkg-config make autoconf libtool```

## ビルド
1. ```git submodule init```
1. ```git submodule update```
1. ```make```
1. binディレクトリにffmpegが配置されます

## 実行
1. ```bin/ffmpeg```

