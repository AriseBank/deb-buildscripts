#!/bin/bash
export NAME=clang+llvm
export VERSION=3.7.0
export DEBVERSION=${VERSION}-1
export DIRNAME=clang+llvm-${VERSION}-x86_64-linux-gnu-ubuntu-14.04
export FILENAME=${DIRNAME}.tar.xz
wget http://llvm.org/releases/${VERSION}/$FILENAME
tar xJvf $FILENAME
cd $DIRNAME
rm -rf debian
mkdir -p debian
#Use the LICENSE file from nodejs as copying file
touch debian/copying
#Create the changelog (no messages needed)
dch --create -v $DEBVERSION --package $NAME ""
#Create control file
echo "Source: $NAME" > debian/control
echo "Maintainer: None <none@example.com>" >> debian/control
echo "Section: misc" >> debian/control
echo "Priority: optional" >> debian/control
echo "Standards-Version: 3.9.2" >> debian/control
echo "Build-Depends: debhelper (>= 8)" >> debian/control
echo "" >> debian/control
#Library package
echo "Package: $NAME" >> debian/control
echo "Architecture: amd64" >> debian/control
echo "Provides: llvm, llvm-3.7, libllvm-3.7, clang, clang-3.7" >> debian/control
echo "Depends: ${shlibs:Depends}, ${misc:Depends}" >> debian/control
echo "Description: Vanilla LLVM + Clang distribution" >> debian/control
echo "" >> debian/control
#Dev package
echo "Package: ${NAME}-dev" >> debian/control
echo "Architecture: any" >> debian/control
echo "Provides: llvm-3.7-dev, llvm-dev, libllvm-3.7-dev, libclang-dev, clang-dev, libclang-3.7-dev" >> debian/control
echo "Depends: ${shlibs:Depends}, ${misc:Depends}, $NAME (= $DEBVERSION)" >> debian/control
echo "Description: Vanilla LLVM + Clang distribution (development files)" >> debian/control
#Create rules file
echo '#!/usr/bin/make -f' > debian/rules
echo '%:' >> debian/rules
echo -e '\tdh $@' >> debian/rules
echo 'override_dh_auto_configure:' >> debian/rules
echo -e '\t' >> debian/rules
echo 'override_dh_auto_build:' >> debian/rules
echo -e '\t' >> debian/rules
echo 'override_dh_auto_test:' >> debian/rules
echo -e '\t' >> debian/rules
echo 'override_dh_auto_install:' >> debian/rules
echo -e "\tmkdir -p debian/$NAME/usr debian/$NAME-dev/usr/" >> debian/rules
echo -e "\tcp -r lib bin share debian/$NAME/usr" >> debian/rules
echo -e "\tcp -r include debian/$NAME-dev/usr/" >> debian/rules
#Numba compatibility
echo -e "\tcp ./include/llvm/IR/Intrinsics.gen debian/$NAME-dev/usr/include/llvm" >> debian/rules
#Create some misc files
echo "8" > debian/compat
mkdir -p debian/source
echo "3.0 (quilt)" > debian/source/format
#Build the package
debuild -us -uc -b