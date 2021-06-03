function [Result] = DCM_test()
  page_screen_output(0);
  global ORACLE;
  global SKIP_INVERSION;
  SKIP_INVERSION = 0;
  DCM_test_suite(2);
  % DEM_COVID();
  % Function for testing the DCM for COVID model. Currently based on using the
  % MATLAB version of the model as an Oracle for performance. 
  %
  % Tests generally compare the state of the Octave implementation at a given
  % Point with the state of the MATLAB implementation at the same point
  Result = true;
end


%Verbosity = 0, only print pass/fails for each test
%Verbosity = 1, print detailed information about tests and error messages
%Verbosity = 2, as 1, but also print comparisons of variables to log files
function DCM_test_suite(verbosity)
  if nargin < 1
    verbosity = 0;
  end
  DCM_dcj = DCM_DATA_COVID_JHU_test(verbosity);

  DCM_sd = DCM_SPM_diff_test();
  switch(DCM_sd)
    case 1 disp("SPM_diff.m test passes");
    case 0 disp("SPM_diff.m test fails");
    otherwise disp("SPM_diff.m test did not run");
  end
  DCM_sdp = DCM_spm_dcm_peb_test();
  switch(DCM_sdp)
    case 1 disp("spm_dcm_peb.m test passes");
    case 0 disp("spm_dcm_peb.m test fails");
    otherwise disp("spm_dcm_peb.m test did not run");
  end
  DCM_sdbmr = DCM_spm_dcm_bmr_test();
  switch(DCM_sdbmr)
    case 1 disp("spm_dcm_bmr.m test passes");
    case 0 disp("spm_dcm_bmr.m test fails");
    otherwise disp("spm_dcm_bmr.m test did not run");
  end
  DCM_sdbpa = DCM_spm_dcm_bpa_test();
  switch(DCM_sdbpa)
    case 1 disp("spm_dcm_bpa.m test passes");
    case 0 disp("spm_dcm_bpa.m test fails");
    otherwise disp("spm_dcm_bpa.m test did not run");
  end
  DCM_sle = DCM_spm_log_evidence_test();
  switch(DCM_sle)
    case 1 disp("spm_log_evidence.m test passes");
    case 0 disp("spm_log_evidence.m test fails");
    otherwise disp("spm_log_evidence.m test did not run");
  end
  DCM_sc = 2;%DCM_SPM_COVID_test();
  switch(DCM_sc)
    case 1 disp("SPM_COVID.m test passes");
    case 0 disp("SPM_COVID.m test fails");
    otherwise disp("SPM_COVID.m test did not run");
  end


end




