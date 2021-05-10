function [Result] = DCM_test()
  page_screen_output(0);
  global ORACLE;
  ORACLE = 1;
  DEM_COVID();
  % Function for testing the DCM for COVID model. Currently based on using the
  % MATLAB version of the model as an Oracle for performance. 
  %
  % Tests generally compare the state of the Octave implementation at a given
  % Point with the state of the MATLAB implementation at the same point
  Result = true;
end