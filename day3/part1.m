global inputlines = strsplit(fileread("/data/input.txt"))

function retval = getinputchar (x, y)
  global inputlines
  if (0 < y && y < length(inputlines) && 0 < x && x < length(inputlines{y}))
    retval = inputlines{y}(x);
  else
    retval = '.';
  endif
endfunction

function retval = containssymbol (x1, y1, x2, y2)
  for y = y1:y2
    for x = x1:x2
      c = getinputchar (x, y);
      if (!isdigit(c) && c != ".")
        retval = 1;
        return
      endif
    endfor
  endfor
  retval = 0;
endfunction

result = 0;

for y = 1:length(inputlines)
  line = inputlines{y};
  [starts, ends, _, matches] = regexp(line, "\\d+");
  for i = 1:length(starts)
    s = starts(i);
    e = ends(i);
    match = matches(i);
    if containssymbol(s-1, y-1, e+1, y+1)
      num = str2double(match);
      result += num;
    endif
  endfor
endfor

result