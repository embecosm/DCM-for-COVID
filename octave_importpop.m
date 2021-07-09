% Function to import time series CSV files for COVID data. Should work well on
% the following specific files:
%   - 'population.csv'
% and probably won't work well on much else

function out = octave_importpop(filename, delim)
  if (nargin < 2)
    delim = ',';
  end
  lines = textread(filename, '%s', "delimiter", "\n");
  data = [];
  textdata = {};
  for i = 1:length(lines)
    line = lines{i,1};
    data_counter = 1;
    text_counter = 1;
    quote_open = 0;
    buffer = '';
    for j = 1:(length(line)+1)
      if(j <= length(line))
        current_char = line(j);
      else
        current_char = delim;
      end
      if(current_char == ("\""))
        quote_open = !quote_open;
        continue;
      end
      if((current_char == delim)&&!quote_open)
        if text_counter < 2
          textdata{i, text_counter} = buffer;
          text_counter = text_counter + 1;
        else
          if(isempty(buffer))
            data(i, data_counter) = NaN;
          else
            try
              data(i, data_counter) = str2num(buffer);
            catch
              disp(buffer);
            end
          end
          data_counter = data_counter + 1;
        end
        buffer = '';
      else
        buffer = [buffer, current_char];
      end
    end 
  end
  out.data = data;
  out.textdata = textdata;
  out.rowheaders = textdata;
end