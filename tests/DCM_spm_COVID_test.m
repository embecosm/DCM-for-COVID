% Placeholder to test the spm_covid function against an earlier Oracle run
%__________________________________________________________________________
# Copyright (C) 2021 Embecosm Limited
# Contributor: William Jones <william.jones@embecosm.com>
# SPDX-License-Identifier: GPL-2.0
function test_result = DCM_spm_COVID_test(verbosity)
    if nargin < 1
    verbosity = 2;
  end
  load('./tests/data/Octave/spm_COVID_in.mat')
  expected_passes =  {};
  expected_fails = {};
  expected_unknown = {};
  [F,Ep,Cp,pE,pC] = spm_COVID(Y,pE,pC,hC);
  test_result = compare_with_oracle(who, 2, 'tests/testdata/', 'spm_COVID_out.mat', expected_passes, expected_fails, expected_unknown);
end