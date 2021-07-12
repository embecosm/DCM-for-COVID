% Comparison function for current workspace against one stored in a .mat file.
% 
% Takes a list of expected passes, expected fails and expected unknown variables
%
% Expected passes: Variables we expect to match between workspaces
%
% Expected fails: It is to be expected that some variables fail the comparison.
% This might be because they are e.g. function handles that may vary from
% machine to machine, or because floating point calculations may differ between
% MATLAB and Octave. Such variables are enumerated here.
%
% Expected unknown: Variables that are in one workspace but not the other, for 
% whatever reason. 
%
% May result in false negatives (unable to parse a variable, for example)
% but should not result in any false positives.
%__________________________________________________________________________
# Copyright (C) 2021 Embecosm Limited
# Contributor: William Jones <william.jones@embecosm.com>
# SPDX-License-Identifier: GPL-2.0
function [testresult] = test_compare(callervars, verbosity, folder, oracle_name, expected_passes, expected_fails, expected_unknown)
  O = load(strcat(folder, oracle_name));
  oraclevars = fieldnames(O);
  passed = {};
  failed = {};
  unknown = {};
  for i = 1:length(oraclevars)
    varname = oraclevars{i,1};
    a = O.(varname);
    try
      b = evalin('caller', varname);
    catch
      unknown = [unknown, varname];
      continue;
    end
    if (isequaln(a,b))
      passed = [passed, varname];
    else
      failed = [failed, varname];
    end
  end
 
type1_passes = setdiff(expected_passes, passed);
type2_passes = setdiff(passed, expected_passes);
type1_fails = setdiff(expected_fails, failed);
type2_fails = setdiff(failed, expected_fails);
type1_unknown = setdiff(expected_unknown, unknown);
type2_unknown = setdiff(unknown, expected_unknown);
 
failedvars = {};
  for i = 1:length(failed)
    Ofail = O.(failed{i});
    failedvars.(failed{i}) = O.(failed{i});
    Rfail = evalin('caller', failed{i});
    if (verbosity > 1)
      split_oracle_name = strsplit(oracle_name, ".");
      Fpath = (strcat(folder, 'logs/', split_oracle_name{1}, "/"));
      FOname = strcat(int2str(i) ,"_R_", failed{i}, "_" ,oracle_name);
      FRname = strcat(int2str(i) ,"_O_", failed{i}, "_" ,oracle_name);
      mkdir(Fpath);
      save(strcat(Fpath, FOname), "Ofail");
      save(strcat(Fpath, FRname), "Rfail");
    end
  end

  testresult.result = (isempty(type1_passes));% ... 
    %& isempty(type1_fails) ...
    %& isempty(type2_passes) ...
    %& isempty(type2_fails) ...
    %& isempty(type1_unknown) ... 
    %& isempty(type2_unknown) ...
  testresult.passed = passed;
  testresult.failed = failed;
  testresult.failedvars = failedvars;
  testresult.unknown = unknown;
  
  if(verbosity&(~(testresult.result)))
    disp(strcat(oracle_name," test"));
    disp("The following variables didn't match the Oracle when they should have:");
    disp(union(type1_passes, type2_fails));
    disp("The following variables matched the Oracle when they may not have been expected to:");
    disp(union(type2_passes, type1_fails));
    disp("The following variables are unknown when they should not be:");
    disp(type1_unknown);
    disp("The following variables are not unknown when they should be:");
    disp(type2_unknown);
    
  end
end