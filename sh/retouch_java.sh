#!/bin/sh

rm ~/.anyenv/envs/jenv/*.time
anyenv update

VERSION_DIR=`ls /opt/homebrew/Cellar/openjdk@17`
jenv add /opt/homebrew/Cellar/openjdk@17/$VERSION_DIR/libexec/openjdk.jdk/Contents/Home

echo $VERSION_DIR
jenv global $VERSION_DIR
jenv rehash

