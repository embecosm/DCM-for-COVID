function test_result = DCM_spm_dcm_bpa_test(verbosity)
  if nargin < 1
    verbosity = 0;
  end
  try
    load('./tests/data/Octave/spm_dcm_bpa_in.mat')
    expected_passes =  {"BMA",
      "BMR",
      "BPA",
      "Cp",
      "DCM",
      "Ep",
      "F",
      "GCM",
      "GLM",
      "PEB",
      "X",
      "Xn",
      "Y",
      "country",
      "data",
      "hC",
      "i",
      "lat",
      "lon",
      "pC",
      "pE",
      "str"};
    expected_fails = {};
    expected_unknown = {};
    BPA = spm_dcm_bpa(DCM,'nocd');
    test_outcome = test_compare(who, 2, 'tests/data/Octave/', 'spm_dcm_bpa_out.mat', expected_passes, expected_fails, expected_unknown);
    test_result = test_outcome.result;
    %failed = test_outcome.failed;
    %failedvars = test_outcome.failedvars;  
  catch e
    disp("Error in spm_dcm_bpa.m test");
    if(verbosity)
      disp(strcat('Error Identifier: ',e.identifier));
      disp(strcat('Error Message: ',e.message));   
    end
    test_result = 2;
  end
  if(verbosity)
    switch(test_result)
      case 1 disp("spm_dcm_bpa.m test passes")
      case 0 disp("spm_dcm_bpa.m test fails")
      otherwise disp("spm_dcm_bpa.m test did not run")
    end
  end
end