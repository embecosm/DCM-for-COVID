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
      Fpath = strcat(folder, 'logs/', (strsplit(oracle_name, ".")){1}, "/");
      FOname = strcat(int2str(i) ,"_R_", failed{i}, "_" ,oracle_name);
      FRname = strcat(int2str(i) ,"_O_", failed{i}, "_" ,oracle_name);
      mkdir(Fpath);
      save(strcat(Fpath, FOname), "Ofail");
      save(strcat(Fpath, FRname), "Rfail");
    end
  end
  
if(!verbosity)
  disp(strcat(oracle_name," test"));
  disp("The following variables didn't match the Oracle when they should have:");
  disp(union(type1_passes, type2_fails));
  disp("The following variables matched the Oracle when they shouldn't have:");
  disp(union(type2_passes, type1_fails));
  disp("The following variables are unknown when they should not be:");
  disp(type1_unknown);
  disp("The following variables are not unknown when they should be:");
  disp(type2_unknown);
  
end

#  fidO = fopen('tests/testdata/Result/DATA_COVID_JHU_O.mat', 'w');
#  fidR = fopen('tests/testdata/Result/DATA_COVID_JHU_R.mat', 'w');

#  for i = 1:length(failed)
#    varname = failed{1,i};
#    fprintf(fidO, '%g\n', O.(varname));
#    fprintf(fidR, '%g\n', evalin('caller', varname));
#  end
    
#  fclose(fidO);
#  fclose(fidR);

  testresult.result = (isempty(type1_passes)
    & isempty(type1_fails)
    & isempty(type2_passes)
    & isempty(type2_fails)
    & isempty(type1_unknown)
    & isempty(type2_unknown));
  testresult.passed = passed;
  testresult.failed = failed;
  testresult.failedvars = failedvars;
  testresult.unknown = unknown;
end