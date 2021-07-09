% Unit tests for the DCM for COVID model
% MATLAB and Octave have rather different schemes for writing tests. This
% function attempts to make a testing suite compatible with both.
%
% This testing suite is focused on making sure that the functions conform to an
% earlier "Oracle" run. This means these tests are tests of conformity and not
% necessarily of correctness.
%
% Note that MATLAB and Octave produce different outputs for certain floating
% point operations. Testing that such differences are within acceptable bounds
% is the responsibility of each test seperately. 
% 
% Verbosity:
% 0: print nothing but end result
% 1: output details of test results to console
% 2: output logs of failed comparisons to text file
%

function DEM_COVID_tests(verbosity)
  if nargin < 1
    verbosity = 2;
  end
  % add tests directory to path, store old path for restoration at the end
  if exist ('OCTAVE_VERSION', 'builtin');
    page_screen_output(0);
  end
  oldpath = addpath('tests');
  
  % Notes: Include all necessary parameters for each test in the tex
  tests = {
    %["DCM_spm_COVID_test(",int2str(verbosity),")"] 
    strcat('DCM_DATA_COVID_JHU_test(',int2str(verbosity),')')
    strcat('DCM_spm_dcm_peb_test(',int2str(verbosity),')')
    strcat('DCM_spm_dcm_bmr_test(',int2str(verbosity),')')
    strcat('DCM_spm_dcm_bpa_test(',int2str(verbosity),')')
    strcat('DCM_spm_log_evidence_test(',int2str(verbosity),')')
    strcat('DCM_spm_diff_test(',int2str(verbosity),')')
  };
  for i = 1:length(tests) 
    tests{i, 2} = eval(tests{i,1});
  end

  % Produce test result cell
  for i = 1:length(tests)
    switch(tests{i, 2})
      case 1
        test_result = "passes";
      case 0
        test_result = "fails";
      otherwise
        test_result = "did not run";
    end
    disp(strcat(tests{i, 1}, ":", test_result));
  end
  
  %restore path
  path(oldpath);
end




