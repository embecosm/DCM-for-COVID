% Test the spm_log_evidence function against an earlier Oracle run
%__________________________________________________________________________
# Copyright (C) 2021 Embecosm Limited
# Contributor: William Jones <william.jones@embecosm.com>
# SPDX-License-Identifier: GPL-2.0
function test_result = DCM_spm_log_evidence_test(verbosity)
  if nargin < 1
    verbosity = 0;
  end
  try
    load('./tests/data/Octave/spm_log_evidence_in.mat')
    expected_passes =  {'C',
      'DCM',
      'GS',
      'K',
      'OPT',
      'R',
      'S',
      'U',
      'Z',
      'beta',
      'field',
      'gamma',
      'i',
      'j',
      'k',
      'nK',
      'nmax',
      'nparam',
      'pC',
      'pE',
      'q',
      'qC',
      'qE',
      'r',
      'rC',
      'rE',
      's',
      'z'};
    expected_fails = {'G'};
    expected_unknown = {};
    G(1) = spm_log_evidence(qE,qC,pE,pC,rE,rC);
    G(2) = 0;
    test_outcome = test_compare(who, 2, 'tests/data/Octave/', 'spm_log_evidence_out.mat', expected_passes, expected_fails, expected_unknown);
    test_result = test_outcome.result;
    % Check that "failed" comparisons are out by an amount appropriate for
    % FP errors on the operations performed
    failed = test_outcome.failed;
    failedvars = test_outcome.failedvars;
    thresh = 1e-10;
    if exist ('OCTAVE_VERSION', 'builtin')
      float_errors = all((G - failedvars.G) < thresh);
    else
      float_errors = 1;
    end    
    test_result = test_result & float_errors;
    
  catch e
    disp("Error in spm_log_evidence.m test");
    if(verbosity)
      disp(strcat('Error Identifier: ',e.identifier));
      disp(strcat('Error Message: ',e.message));   
    end
    test_result = 2;
  end
  if(verbosity)
    switch(test_result)
      case 1
        disp("spm_log_evidence.m test passes")
      case 0
        disp("spm_log_evidence.m test fails")
      otherwise
        disp("spm_log_evidence.m test did not run")
    end
  end
end