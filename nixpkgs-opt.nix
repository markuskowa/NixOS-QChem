self: super:
{
  #
  # Package set with optimized upstream libraries
  #

  # Compile fftw with full AVX features
  fftw = super.fftw.overrideDerivation ( oldAttrs: {
    configureFlags = oldAttrs.configureFlags
    ++ [
      "--enable-avx"
      "--enable-avx2"
      "--enable-fma"
      "--enable-avx-128-fma"
    ];
    buildInputs = oldAttrs.buildInputs ++ [ self.gfortran ];
  });

  fftwSinglePrec = self.fftw.override { precision = "single"; };

  libxsmm = super.libxsmm.overrideAttrs ( x: {
    makeFlags = x.makeFlags ++ [ "OPT=3" "AVX=2" ];
  });

  scalapack = super.scalapack.overrideAttrs ( x: {
    CFLAGS = "-O3 -mavx2 -mavx -msse2";
    FFLAGS = "-O3 -mavx2 -mavx -msse2";
  });

  gromacs = super.gromacs.override {
    cpuAcceleration = "AVX2_256";
    singlePrec = true;
    fftw = self.fftwSinglePrec;
  };

  gromacsMpi = super.gromacs.override {
    cpuAcceleration = "AVX2_256";
    singlePrec = true;
    mpiEnabled = true;
    fftw = self.fftwSinglePrec;
  };

  gromacsDouble = super.gromacs.override {
    cpuAcceleration = "AVX2_256";
    singlePrec = false;
    fftw = self.fftw;
  };

  gromacsDoubleMpi = super.gromacs.override {
    cpuAcceleration = "AVX2_256";
    singlePrec = false;
    mpiEnabled = true;
    fftw = self.fftw;
  };
}
