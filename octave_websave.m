% A simple websave function for Octave. 
%__________________________________________________________________________
# Copyright (C) 2021 Embecosm Limited
# Contributor: William Jones <william.jones@embecosm.com>
# SPDX-License-Identifier: GPL-2.0

function S = octave_websave(filename, url)
  txt = urlread(url);
  fid = fopen(filename,'w');
  fprintf(fid,'%s',txt);
  fclose(fid);  
end