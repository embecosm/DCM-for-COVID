function S = octave_websave(filename, url)
  txt = urlread(url);
  fid = fopen(filename,'w');
  fprintf(fid,'%s',txt);
  fclose(fid);  
end