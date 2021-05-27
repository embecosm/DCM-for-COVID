function [Result] = DCM_test()
  page_screen_output(0);
  global ORACLE;
  global SKIP_INVERSION;
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
    case 0 disp("DATA_COVID_JHU.m test fails")
    otherwise disp("DATA_COVID_JHU.m test did not run")
  end
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


function test_result = DCM_SPM_diff_test()
  load('./tests/testdata/spm_diff_in.mat')
  M.G   = @spm_COVID_gen;           % generative function
  M.L   = @spm_COVID_LL;            % log-likelihood function
  M.FS  = @spm_COVID_FS;            % feature selection (link function)
  IS = @(P,M,U)M.FS(M.IS(P,M,U));
  expected_passes =  {"C",
  "Ep",
  "Eu",
  "Q",
  "U",
  "V",
  "Y",
  "criterion",
  "dFdh",
  "dFdhh",
  "dfdu",
  "dt",
  "h",
  "hE",
  "ihC",
  "ip",
  "ipC",
  "iu",
  "k",
  "nh",
  "np",
  "nq",
  "nr",
  "ns",
  "nu",
  "ny",
  "p",
  "pC",
  "pE",
  "uC",
  "v",
  "y"};
  expected_fails = {"M",
  "ans",
  "dfdp",
  "f",
  "tStart"};
  expected_unknown = {}; 
  [dfdp,f] = spm_diff(IS,Ep,M,U,1,{V});
  test_result = compare_with_oracle(who, 2, 'tests/testdata/', 'spm_diff_out.mat', expected_passes, expected_fails, expected_unknown);
end

function test_result = DCM_SPM_COVID_test()
  load('./tests/testdata/spm_COVID_in.mat')
  expected_passes =  {};
  expected_fails = {};
  expected_unknown = {};
  [F,Ep,Cp,pE,pC] = spm_COVID(Y,pE,pC,hC);
  test_result = compare_with_oracle(who, 2, 'tests/testdata/', 'spm_COVID_out.mat', expected_passes, expected_fails, expected_unknown);
end

function test_result = DCM_spm_dcm_peb_test()
  load('./tests/testdata/spm_dcm_peb_in.mat')
  expected_passes =  {"Cp",
  "Ep",
  "F",
  "GCM",
  "GLM",
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
  expected_fails = {"DCM",
  "PEB"};
  expected_unknown = {};
  [PEB,DCM] = spm_dcm_peb(GCM,GLM,str.field);
  test_result = compare_with_oracle(who, 2, 'tests/testdata/', 'spm_dcm_peb_out.mat', expected_passes, expected_fails, expected_unknown);
end

function test_result = DCM_spm_dcm_bmr_test()
  load('./tests/testdata/spm_dcm_bmr_in.mat')
  expected_passes =  {"Cp",
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
  expected_fails = {"BMA",
  "BMR"};
  expected_unknown = {"Fsi",
  "ans"};
  [BMA,BMR] = spm_dcm_bmr_all(PEB,str.field);
  test_result = compare_with_oracle(who, 2, 'tests/testdata/', 'spm_dcm_bmr_out.mat', expected_passes, expected_fails, expected_unknown);
end

function test_result = DCM_spm_dcm_bpa_test()
  load('./tests/testdata/spm_dcm_bpa_in.mat')
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
  test_result = compare_with_oracle(who, 2, 'tests/testdata/', 'spm_dcm_bpa_out.mat', expected_passes, expected_fails, expected_unknown);
end

function test_result = DCM_spm_log_evidence_test()
  load('./tests/testdata/spm_log_evidence_in.mat')
  expected_passes =  {  "C",
  "DCM",
  "GS",
  "K",
  "OPT",
  "R",
  "S",
  "U",
  "Z",
  "beta",
  "field",
  "gamma",
  "i",
  "j",
  "k",
  "nK",
  "nmax",
  "nparam",
  "pC",
  "pE",
  "q",
  "qC",
  "qE",
  "r",
  "rC",
  "rE",
  "s",
  "z"};
  expected_fails = {"G"};
  expected_unknown = {};
  G(i) = spm_log_evidence(qE,qC,pE,pC,rE,rC);
  test_result = compare_with_oracle(who, 2, 'tests/testdata/', 'spm_log_evidence_out.mat', expected_passes, expected_fails, expected_unknown);
 
end


% likelihood model
%__________________________________________________________________________

function L = spm_COVID_LL(P,M,U,Y)
% log-likelihood function
% FORMAT L = spm_COVID_LL(P,M,U,Y)
% P    - model parameters
% M    - model structure
% U    - inputs or control variables
% Y    - outputs or response variables
%
% This auxiliary function evaluates the log likelihood of a sequence of
% count data under Poisson assumptions
%__________________________________________________________________________

% generate prediction
%--------------------------------------------------------------------------
[T,N]  = size(Y);
M.T    = T;
y      = M.G(P,M,U);
y      = y(1:T,1:N);

% ensure all counts are greater than zero
%--------------------------------------------------------------------------
i      = logical(Y < 1); Y(i) = 1;
i      = logical(y < 1); y(i) = 1;

% place MDP in trial structure
%--------------------------------------------------------------------------
p      = spm_Npdf(y(:),Y(:),Y(:));
L      = sum(log(p + 1e-6));
end
% link function for feature selection (square root transform)
%__________________________________________________________________________

function Y = spm_COVID_FS(Y)
% feature selection for COVID model
% FORMAT Y = spm_COVID_FS(Y)
% P    - model parameters
% M    - model structurel
% U    - inputs or control variables
% Y    - outputs or response variables
%
% This auxiliary function takes appropriate gradients and performs a square
% root transform
%__________________________________________________________________________

% ensure all counts are greater than zero
%--------------------------------------------------------------------------
i      = logical(Y < 1); Y(i) = 1;

% square root transform
%--------------------------------------------------------------------------
Y      = sqrt(Y);

return
end