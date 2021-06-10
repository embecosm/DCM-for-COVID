# DCM

A repository for the COVID dynamic causal model from the [SPM12 software](https://github.com/spm/spm12), ported to be standalone and compatible with both MATLAB and Octave. 

# Usage 

1. Install and run [Octave](https://www.gnu.org/software/octave/download) (or [MATLAB](https://uk.mathworks.com/help/install/))
2. Navigate to the top level directory of this repository
3. Run the command DEM_COVID()
4. Wait (A full run will take several hours on MATLAB, and substantially longer on Octave)

# Notes
To keep things simple in this early version, none of the compiled MATLAB/Octave functions have been ported from SPM12. This does mean this version is slower. 

Octave intrinsically runs slower than MATLAB. Early benchmarking suggests this program will take around 10x longer to run on Octave than MATLAB. 

# Testing
SPM12 comes with it's own unit tests for many of the functions in this standalone. Untangling and porting these remains a TODO.

In the meantime, a set of tests is provided that checks that the Octave implementation produces the same output as the MATLAB version. This is complicated by Octave and MATLAB producing slightly different outputs for certain floating point operations. Current tests work around this by testing that the Octave version only diverges from the MATLAB version by an amount appropriate for floating point errors in the operations it undertakes.

MATLAB and Octave have substantially different inbuilt testing frameworks. MATLAB uses xUnit-like unit testing framework, while Octave uses a BIST framework. These tests are functions themselves, and should be compatible with both.

To run the current set of tests, run DEM_COVID_tests();