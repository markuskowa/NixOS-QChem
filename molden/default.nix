{ stdenv, fetchurl, which, gfortran, mesa, xorg } :
  
stdenv.mkDerivation rec {
  version = "5.8";
  name = "molden-${version}";

  src = fetchurl {
    url = "ftp://ftp.cmbi.ru.nl/pub/molgraph/molden/molden${version}.tar.gz";
    sha256 = "1dwkkp83id2674iphn3cb7bmlsg0fm41f5dgkbcf0ygj044sqyx1";
  };

  nativeBuildInputs = [ which ];
  buildInputs = [ gfortran mesa xorg.libX11 xorg.libXmu ];

  postPatch = ''
     substituteInPlace ./makefile --replace '-L/usr/X11R6/lib'  "" \
                                  --replace '-I/usr/X11R6/include' "" \
                                  --replace '/usr/local/' $out/ \
                                  --replace 'sudo' "" \
                                  --replace '-C surf depend' '-C surf'
     sed -in '/^# DO NOT DELETE THIS LINE/q;' surf/Makefile
  '';

  preInstall = ''
     mkdir -p $out/bin
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
     description = "Display and manipulate molecular structures";
     homepage = http://www.cmbi.ru.nl/molden/;
     license = {
       fullName = "Free for academic/non-profit use";
       url = http://www.cmbi.ru.nl/molden/CopyRight.html;
       free = false;
     };
     platforms = platforms.linux;
     maintainers = with maintainers; [ markuskowa ];
  };
}
