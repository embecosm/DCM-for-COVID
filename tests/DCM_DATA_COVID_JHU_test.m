function test_result = DCM_DATA_COVID_JHU_test(verbosity)
  if nargin < 1
    verbosity = 0;
  end
  %try
    data = DATA_COVID_JHU(16);
    expected_passes =  {'cases',
      'country',
      'date',
      'days',
      'death',
      'lat',
      'long',
      'names',
      'pop'};
    expected_fails = {'cum'};
    expected_unknown = {};
    names = fieldnames(data);
    for i = 1:length(names)
      tmp_var = {data.(names{i})};
      eval(strcat(names{i}, " = tmp_var;"));  
    end
    clear i tmp_var data
    test_outcome = test_compare(who, verbosity, 'tests/data/Octave/', 'DATA_COVID_JHU_out.mat', expected_passes, expected_fails, expected_unknown);
    test_result = test_outcome.result;
    % Check that "failed" comparisons are out by an amount appropriate for
    % FP errors on the operations performed
    failed = test_outcome.failed;
    failedvars = test_outcome.failedvars; 
    thresh = 1e-9;
    if exist ('OCTAVE_VERSION', 'builtin')
      float_errors = all(cellfun(@(a,b) (a - b) < thresh,cum,failedvars.cum,'Un',1));
    else
      float_errors = 1;
    end    
    test_result = test_result&float_errors;
   
%   catch e
%     disp("Error in DATA_COVID_JHU.m test");
%     if(verbosity)
%       disp(strcat('Error Identifier: ',e.identifier));
%       disp(strcat('Error Message: ',e.message));   
%     end
%     test_result = 2;
%   end
  if(verbosity)
    switch(test_result)
      case 1 
        disp("DATA_COVID_JHU.m test passes")
      case 0 
        disp("DATA_COVID_JHU.m test fails")
      otherwise 
        disp("DATA_COVID_JHU.m test did not run")
    end
  end
  
  
end