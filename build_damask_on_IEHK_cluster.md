# Build DAMASK v2.0.2 on the internal cluster of IEHK

DAMASK v2.0.2 depends on [PETSc 3.9.x](http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.9.4.tar.gz) and
[FFTW 3.3.x](http://www.fftw.org/fftw-3.3.8.tar.gz).
You should first download tar balls of these packages together with DAMASK, and extract all of them.
Then run the following script in BASH.

This script assumes that Intel compiler and Openmpi are properly configurated on the system.

``` bash
#!/bin/bash
set -e
module load intel
module load openmpi

#wget http://www.fftw.org/fftw-3.3.8.tar.gz && tar -xf fftw-*.tar.gz && rm fftw-*.tar.gz
#wget http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.9.4.tar.gz && tar -xf petsc-*.tar.gz && rm petsc-*.tar.gz
#wget https://damask.mpie.de/pub/Download/Current/DAMASK-2.0.2.tar.xz && tar -xf DAMASK-*.tar.xz

FFTWROOT=$(  cd fftw*  && pwd)
PETSCROOT=$( cd petsc* && pwd)
INTELROOT=$( which ifort | sed -e 's:bin/\w*/*ifort::' )
OMPIROOT=$(  which mpicc | sed -e 's:bin/\w*/*mpicc::' )

export PETSC_ARCH=linux-gnu-intel

ls "$INTELROOT"/mkl "$OMPIROOT" "$FFTWROOT" "$PETSCROOT" > /dev/null

function build_petsc () {(
    cd petsc-*/
    unset PETSC_DIR
    mkdir -p "$PETSC_ARCH"
    ./configure PETSC_ARCH=$PETSC_ARCH \
         --with-blaslapack-dir="$INTELROOT"/mkl \
         --with-mpi-dir="$OMPIROOT" \
         --with-fftw=1 \
         --with-fftw-dir="$FFTWROOT"/deploy_avx \
         --with-x=0
    make PETSC_DIR=$PWD PETSC_ARCH=$PETSC_ARCH all test

    export PETSC_DIR=$PWD
    export PETSC_ARCH=$PETSC_ARCH
    [ -d $PETSC_DIR/$PETSC_ARCH ] || exit 1
)}

function build_damask () {(
    [ -z "$PETSC_DIR" ] && export PETSC_DIR=$PETSCROOT
    mkdir -p DAMASK_build
    cd ./DAMASK_build
    cmake --version
    cmake -DDAMASK_SOLVER=SPECTRAL -DDAMASK_ROOT=$PWD/../DAMASK ../DAMASK
    make --no-print-directory -ws all
    make install
)}

#http://www.fftw.org/fftw3_doc/Installation-on-Unix.html#Installation-on-Unix
function build_fftw () {(
    cd fftw*
    ./configure --enable-mpi    \
                --enable-openmp \
                --enable-avx    \
                --enable-shared \
                --prefix=$PWD/deploy_avx
    mkdir -p $PWD/deploy_avx
    make
    make install
)}

function test () {
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"$FFTWROOT"/deploy_avx/lib:"$PETSCROOT/$PETSC_ARCH"/lib
    DAMASK/bin/DAMASK_spectral --help
}

[ -d "$FFTWROOT"/deploy_avx/lib ]   || build_fftw
[ -d "$PETSCROOT/$PETSC_ARCH"/lib ] || build_petsc
[ -f DAMASK/bin/DAMASK_spectral ]   || build_damask
test
```
