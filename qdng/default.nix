{ stdenv, fetchurl, requireFile, gfortran, fftw, protobuf, liblapack, blas
, automake, autoconf, libtool, zlib, bzip2, libxml2, flex, bison
, srcurl ? null
}:

let
  version = "20180527";
  srcfile = "qdng-${version}.tar.xz";
  sha256 = "16agzp2aqb6yjmdpbnshjh6cw4kliqfvgfrbj76xcrycrbyk8hf9";

in stdenv.mkDerivation {
  name = "qdng-${version}";

  src = if srcurl != null then
    fetchurl {
      url = srcurl + "/" + srcfile;
      sha256 = sha256;
    }
  else
    requireFile {
      url = "http://nowebsite";
      name = srcfile;
      inherit sha256;
    };

  configureFlags = [ "--enable-openmp" ];

  enableParallelBuilding = true;

  preConfigure = ''
    ./genbs
  '';

  buildInputs = [ gfortran fftw protobuf liblapack
                  blas bzip2 zlib libxml2
                  flex bison ];
  nativeBuildInputs = [ automake autoconf libtool ];

  meta = {
    description = "Quantum dynamics program package";
    platforms = stdenv.lib.platforms.linux;
    maintainer = "markus.kowalewski@gmail.com";
  };

}
