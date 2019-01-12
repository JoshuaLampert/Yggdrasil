using BinaryBuilder

name = "PCRE2"
version = v"10.32"

# Collection of sources required to build Pcre
sources = [
    "https://ftp.pcre.org/pub/pcre/pcre2-$(version.major).$(version.minor).tar.bz2" =>
    "f29e89cc5de813f45786580101aaee3984a65818631d4ddbda7b32f699b87c2e",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/pcre2-*/

# On OSX, override choice of AR
if [[ ${target} == *apple-darwin* ]]; then
    export AR=/opt/${target}/bin/${target}-ar
fi
./configure --prefix=$prefix --host=$target --enable-utf8 --enable-unicode-properties --enable-jit
make -j${nproc} VERBOSE=1
make install VERBOSE=1
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libpcre", :libpcre)
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

