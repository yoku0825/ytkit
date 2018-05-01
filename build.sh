#!/bin/bash

package="ytkit"
version=$(grep "^Version:" ${package}.spec | awk '{print $2}')
dirname="${package}-${version}"
source="${dirname}.tar.gz"

test -d ../$dirname && rm -rf ../$dirname
cp -r . ../$dirname
rm -rf ../$dirname/.git
tar -C .. -cvzf $source $dirname
mv $source ~/rpmbuild/SOURCES/

rpmbuild -bb ${package}.spec && rm -rf ../$dirname
