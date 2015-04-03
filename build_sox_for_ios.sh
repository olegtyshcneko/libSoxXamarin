#!/bin/bash

# just run this script in terminal:$ sh <path to this script>

# manually expand tilde
homedir=~
eval homedir=$homedir

# define paths
repoPath="git://git.code.sf.net/p/sox/code"
targetPath="$homedir/sox"

# remove existed copy from previous run
if [ -d "$targetPath" ]; then
    echo "remove existed $targetPath"
    rm -fR "$targetPath"
fi

# clone repository
echo "clone from $repoPath to $targetPath"
git clone git://git.code.sf.net/p/sox/code sox

# goto sox sources path
DIR="$targetPath"
cd "$DIR"

# set up build dir
BUILD_DIR="$DIR/buil"

# create configure from autoreconf.ac
echo "start autoreconf -i"
autoreconf -i

# set up build archs, to build all Device and Simulator at ones
ARCHS_IPHONE_OS="-arch armv7 -arch armv7s -arch arm64"
ARCHS_IPHONE_SIMULATOR="-arch i386 -arch x86_64"


# build for armv7 armv7s arm64 (Devices)
echo "build for armv7 armv7s arm64 (devices)"
SDKROOT="$(xcrun --sdk iphoneos --show-sdk-path)"
CC="$(xcrun --sdk iphoneos -f clang)"
CXX="$(xcrun --sdk iphoneos -f clang++)"
CFLAGS="-isysroot $SDKROOT $ARCHS_IPHONE_OS -miphoneos-version-min=7.0"
CXXFLAGS="$CFLAGS"
export CC CXX CFLAGS CXXFLAGS

make clean
make distclean

./configure \
    --host=arm-apple-darwin \
    --prefix="$BUILD_DIR/iphoneos" \
    --disable-shared \
    --enable-static

make -j4
make install


# build for i386 x86_64 (Simulators)
echo "build for i386 x86_64 (simulator)"
SDKROOT=$(xcrun --sdk iphonesimulator --show-sdk-path)
CC="$(xcrun --sdk iphonesimulator -f clang)"
CXX="$(xcrun --sdk iphonesimulator -f clang++)"
CFLAGS=" -isysroot $SDKROOT $ARCHS_IPHONE_SIMULATOR -mios-simulator-version-min=7.0"
CXXFLAGS=$CFLAGS
export CC CXX CFLAGS CXXFLAGS

make clean
make distclean

./configure \
    --prefix="$BUILD_DIR/iphonesimulator" \
    --disable-shared \
    --enable-static

make -j4
make install


# lipo together the different architectures /Devices + Simulators/ into a universal 'fat' file
mkdir "$BUILD_DIR/_iphoneos+iphonesimulator_fat_lib"
lipo -create "$BUILD_DIR/iphoneos/lib/libsox.a" "$BUILD_DIR/iphonesimulator/lib/libsox.a" -output "$BUILD_DIR/_iphoneos+iphonesimulator_fat_lib/libsox.a"

echo "Products are in $BUILD_DIR"
