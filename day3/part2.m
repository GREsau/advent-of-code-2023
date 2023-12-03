global inputlines = strsplit(fileread("/data/input.txt"))

# y, xs, xe, number
global numberranges = {}

for y = 1:length(inputlines)
  line = inputlines{y};
  [starts, ends, _, matches] = regexp(line, "\\d+");
  for i = 1:length(starts)
    s = starts(i);
    e = ends(i);
    match = matches(i);
    num = str2double(match);

    numberranges = [numberranges; {y, s, e, num}];
  endfor
endfor

function retval = gearratio (x0, y0)
  global numberranges
  adjacentcount = 0;
  retval = 1;
  for i = 1:length(numberranges)
    [y, xs, xe, number] = numberranges{i,:};
    if (y >= y0-1 && y <= y0+1 && xs <= x0+1 && xe >= x0-1)
      adjacentcount += 1;
      retval *= number;
    endif
  endfor
  if (adjacentcount != 2)
    retval = 0;
  endif
endfunction


result = 0;

for y = 1:length(inputlines)
  line = inputlines{y};
  [starts] = regexp(line, "\\*");
  for i = 1:length(starts)
    x = starts(i);
    result += gearratio (x,y);
  endfor
endfor

result