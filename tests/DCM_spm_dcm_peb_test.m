function test_result = DCM_spm_dcm_peb_test(verbosity)
  if nargin < 1
    verbosity = 0;
  end
  try
    load('./tests/data/Octave/spm_dcm_peb_in.mat')
    expected_passes =  {'Cp',
      'Ep',
      'F',
      'GCM',
      'GLM',
      'X',
      'Xn',
      'Y',
      'country',
      'data',
      'hC',
      'i',
      'lat',
      'lon',
      'pC',
      'pE',
      'str'};
    expected_fails = {'DCM',
      'PEB'};
    expected_unknown = {};
    [PEB,DCM] = spm_dcm_peb(GCM,GLM,str.field);
    test_outcome = test_compare(who, 2, 'tests/data/Octave/', 'spm_dcm_peb_out.mat', expected_passes, expected_fails, expected_unknown);
    test_result = test_outcome.result;
    % Check that "failed" comparisons are out by an amount appropriate for
    % FP errors on the operations performed
    failed = test_outcome.failed;
    failedvars = test_outcome.failedvars;
    thresh = 1e-8;
    if exist ('OCTAVE_VERSION', 'builtin')
      PEB_diff = struct_diff(PEB, failedvars.PEB);
      DCM_diff = cell_diff(DCM, failedvars.DCM);
      F_diff = all(cellfun(@(x) x.F < 1e-05, DCM_diff, 'Un', 1));
      DCM_diff = cellfun(@(x) rmfield(x, 'F'), DCM_diff, 'Un', 0);
      float_errors = structfun_recursive(PEB_diff, @(a) all(all(a < thresh))) ...
      & cellfun_recursive(DCM_diff, @(a) all(all(a < thresh))) ...
      & F_diff;
    else
      float_errors = 1;
    end   
    test_result = test_result&float_errors;
  catch e
    disp("Error in spm_dcm_peb.m test");
    if(verbosity)
      disp(strcat('Error Identifier: ',e.identifier));
      disp(strcat('Error Message: ',e.message));   
    end
    test_result = 2;
  end
  if(verbosity)
    switch(test_result)
      case 1 
        disp("spm_dcm_peb.m test passes")
      case 0 
        disp("spm_dcm_peb.m test fails")
      otherwise 
        disp("spm_dcm_peb.m test did not run")
    end
  end
end

% Subtract structure 2 from each of the fields of structure 1 recursively
function out = struct_diff(s1, s2)
  fieldn = fieldnames(s1);
  for i = 1:length(fieldn)
    varname = fieldn{i,1};
    if(isstruct(s1.(varname)));
      out.(varname) = struct_diff(s1.(varname), s2.(varname));
    elseif(iscell(s1.(varname)))
      out.(varname) = cell_diff(s1.(varname), s2.(varname));;
    else
      out.(varname) = s1.(varname) - s2.(varname);
    end
  end
end

% Subtract cell 2 from each of the fields of cell 1 recursively
function out = cell_diff(s1, s2)
  for i = 1:length(s1)
    if(isstruct(s1{i}));
      out{i} = struct_diff(s1{i}, s2{i});
    elseif(iscell(s1{i}))
      out{i} = cell_diff(s1{i}, s2{i});
    else
      out{i} = s1{i} - s2{i};
    end
  end
end

% Perform an AND fold using function fun on structure s1 recursively
function out = structfun_recursive(s1, fun)
  out = 1;
  fieldn = fieldnames(s1);
  for i = 1:length(fieldn)
    varname = fieldn{i,1};
    if(isstruct(s1.(varname)));
      out = out & structfun_recursive(s1.(varname), fun);
    elseif(iscell(s1.(varname)))
      out = out & cellfun_recursive(s1.(varname), fun);
    else
      out = out & fun(s1.(varname));
    end
  end
end

% Perform an AND fold using function fun on cell s1 recursively
function out = cellfun_recursive(s1, fun)
  out = 1;
  for i = 1:length(s1)
    if(isstruct(s1{i}));
      out = out & structfun_recursive(s1{i}, fun);
    elseif(iscell(s1{i}))
      out = out & cellfun_recursive(s1{i}, fun);
    else
      out = out & fun(s1{i});
    end
  end
end