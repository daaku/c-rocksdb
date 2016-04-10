#!/usr/bin/env sh

set -eu

rm -rf *.cc internal
mkdir internal
curl -sL https://github.com/daaku/rocksdb/archive/master.tar.gz | tar zxf - -C internal --strip-components=1
make -C internal util/build_version.cc
patch -p1 < gitignore.patch

# symlink so cgo compiles them
for source_file in $(make sources | grep -vE '(/redis/|_(cmd|tool).cc$)'); do
  ln -sf $source_file $(echo $source_file | sed s,/,_,g)
done

# manually use internal/build_tools/build_detect_platform to update the per-
# platform flags in cgo_flags.

# restore the repo to what it would look like when first cloned.
# comment this line out while updating upstream.
#git clean -dxf
