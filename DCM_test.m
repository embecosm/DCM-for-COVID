function [Result] = DCM_test()
  page_screen_output(0);
  global ORACLE;
  global SKIP_INVERSION;
  ORACLE = 1;
  SKIP_INVERSION = 0;
  DCM_test_suite();
  % DEM_COVID();
  % Function for testing the DCM for COVID model. Currently based on using the
  % MATLAB version of the model as an Oracle for performance. 
  %
  % Tests generally compare the state of the Octave implementation at a given
  % Point with the state of the MATLAB implementation at the same point
  Result = true;
end

function DCM_test_suite()
  DCM_dcj = DCM_DATA_COVID_JHU_test();
  switch(DCM_dcj)
    case 1 disp("DATA_COVID_JHU.m test passes")
    otherwise disp("DATA_COVID_JHU.m test fails")
  end
  DCM_sc = DCM_SPM_COVID_test();
  switch(DCM_sc)
    case 1 disp("SPM_COVID.m test passes")
    otherwise disp("SPM_COVID.m test fails")
  end
end

function test_result = DCM_DATA_COVID_JHU_test()
  data = DATA_COVID_JHU(16);
  expected_passes =  {"cases",
    "country",
    "date",
    "days",
    "death",
    "lat",
    "long",
    "names",
    "pop"};
  expected_fails = {"cum",
    "data"};
  expected_unknown = {};
  names = fieldnames(data);
  for i = 1:length(names)
    tmp_var = {data.(names{i})};
    eval(strcat(names{i}, " = tmp_var;"));  
  end
  clear i tmp_var
  test_result = compare_with_oracle(who, 2, 'tests/testdata/', 'DATA_COVID_JHU_out.mat', expected_passes, expected_fails, expected_unknown);

end

function test_result = DCM_SPM_COVID_test()
  load('./tests/testdata/spm_COVID_in.mat')
  expected_passes =  {};
  expected_fails = {};
  expected_unknown = {};
  [F,Ep,Cp,pE,pC] = spm_COVID(Y,pE,pC,hC);
  test_result = compare_with_oracle(who, 2, 'tests/testdata/', 'SPM_COVID_out.mat', expected_passes, expected_fails, expected_unknown);

end