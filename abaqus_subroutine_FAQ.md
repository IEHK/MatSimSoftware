# FAQ for Abaqus subroutine


## Problem shooting
### Symbol lookup error during runtime

When Abaqus tries to load a subroutine from the shared library file compiled by intel compiler, it throw the following message:

    symbol lookup error: /xxx/libstandardU.so: undefined symbol: _intel_fast_memmove

#### Cause
The version of Intel compiler is higher than the version of the Intel runtime included in Abaqus (`ABQ_ROOT/code/bin/`).
The symbol `_intel_fast_memmove` is defined in `libirc.so` with version >= 14.0 [(Ref.)][1].

#### Solution
1. Upgrade Abaqus or use older version of Intel compiler.
2. Link the subroutine to libirc [statically][2].


[1]: https://software.intel.com/zh-cn/forums/intel-fortran-compiler-for-linux-and-mac-os-x/topic/591214
[2]: http://www.opal-rt.com/KMP/index.php?/article/AA-00609/0/Undefined-reference-to-_intel_fast_memset-build-error-related-to-rte_delay.html

### MPI_init error with cpus > 1

Command line option `cpus=X` where X>1 causes MPI_init errors in abaqus/2017 on ITC cluster.

#### Cause

The default parallelization mode of abaqus 2017 on ITC is MPI.

#### Solution

Set the option `mp_mode=THREADS` according to the [manuel](https://abaqus-docs.mit.edu/2017/English/SIMACAEEXCRefMap/simaexc-c-envfile.htm)
