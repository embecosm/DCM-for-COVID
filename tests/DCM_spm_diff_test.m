% Test the spm_diff function against an earlier Oracle run
%__________________________________________________________________________
# Copyright (C) 2021 Embecosm Limited
# Contributor: William Jones <william.jones@embecosm.com>
# SPDX-License-Identifier: GPL-2.0
function test_result = DCM_spm_diff_test(verbosity)
  if nargin < 1
    verbosity = 0;
  end
  try
    load('./tests/data/Octave/spm_diff_in.mat')
    M.G   = @spm_COVID_gen;           % generative function
    M.IS   = @spm_COVID_gen; 
    M.L   = @spm_COVID_LL;            % log-likelihood function
    M.FS  = @spm_COVID_FS;            % feature selection (link function)
    IS = @(P,M,U)M.FS(M.IS(P,M,U));
    expected_passes =  {'C',
      'Ep',
      'Eu',
      'Q',
      'U',
      'V',
      'Y',
      'criterion',
      'dFdh',
      'dFdhh',
      'dfdu',
      'dt',
      'h',
      'hE',
      'ihC',
      'ip',
      'ipC',
      'iu',
      'k',
      'nh',
      'np',
      'nq',
      'nr',
      'ns',
      'nu',
      'ny',
      'p',
      'pC',
      'pE',
      'uC',
      'v',
      'y',
      'M'};
    expected_fails = {'dfdp',
      'f',
      'tStart'};
    expected_unknown = {}; 
    [dfdp,f] = spm_diff(IS,Ep,M,U,1,{V});

    M = rmfield(M, 'G');
    M = rmfield(M, 'IS');
    M = rmfield(M, 'L');
    M = rmfield(M, 'FS');    % generative function
    clear IS;    
    test_outcome = test_compare(who, 2, 'tests/data/Octave/', 'spm_diff_out.mat', expected_passes, expected_fails, expected_unknown);
    test_result = test_outcome.result;
    % Check that "failed" comparisons are out by an amount appropriate for
    % FP errors on the operations performed
    failed = test_outcome.failed;
    failedvars = test_outcome.failedvars;
    thresh = 1e-8;
    if exist ('OCTAVE_VERSION', 'builtin')
      float_errors = all(all((f - failedvars.f) < 1e-9)) ...
      & all(cellfun(@(a,b) all(all((a - b) < thresh)),dfdp,failedvars.dfdp,'Un',1));
    else
      float_errors = 1;
    end    
    test_result = test_result&float_errors;  
  catch e
    disp("Error in SPM_diff.m test");
    if(verbosity)
      disp(strcat('Error Identifier: ',e.identifier));
      disp(strcat('Error Message: ',e.message));   
    end
    test_result = 2;
  end
  if(verbosity)
    switch(test_result)
      case 1 
        disp("SPM_diff.m test passes")
      case 0 
        disp("SPM_diff.m test fails")
      otherwise 
        disp("SPM_diff.m test did not run")
    end
  end
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