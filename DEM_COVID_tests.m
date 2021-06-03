% MATLAB and Octave unfortunately have rather different schemes for writing
% tests. MATLAB makes use of xUnit-like testing suites, while Octave uses BIST
% tests denoted by %!. This file (and supporting tests) serve as a best attempt
% at making a test suite that should be compatible with both.
%
% This testing suite is generally focused on making sure that the covered
% functions conform to those from an oracle run (results from an MATLAB run).
% It was designed to ensure that the Octave port of these functions gives the 
% same results at the MATLAB one. Especially note that this means these tests
% are tests of conformity, not of correctness.
%
% MATLAB and Octave produce different outputs for certain floating point
% Testing that such differences are within acceptable bounds should be accounted
% for in each testing function individually.

function DEM_COVID_tests(verbosity)
  if nargin < 1
    verbosity = 2;
  end
  % add tests directory to path, store old path for restoration at the end
  page_screen_output(0);
  oldpath = addpath('tests');
  
  % Notes: Include all necessary parameters for each test in the tex
  tests = {
    "DCM_DATA_COVID_JHU_test(verbosity)"
    "DCM_spm_dcm_peb_test(verbosity)"
    "DCM_spm_dcm_bmr_test(verbosity)"
    "DCM_spm_dcm_bpa_test(verbosity)"
    "DCM_spm_log_evidence_test(verbosity)"
    "DCM_SPM_diff_test(verbosity)"
  };
  for i = 1:length(tests)
    tests{i, 2} = eval(tests{i,1});
  end

  % Produce test result cell
  for i = 1:length(tests)
    switch(tests{i, 2})
      case 1 test_result = "passes";
      case 0 test_result = "fails";
      otherwise test_result = "did not run";
    end
    disp(strcat(tests{i, 1}, ":", test_result));
  end
  
  %restore path
  path(oldpath);
end




