marker part1-marker
1024 100 * constant bufsize

create input-buffer bufsize allot
s" input.txt" r/o open-file throw value fd
input-buffer bufsize fd read-file throw input-buffer + value input-end
fd close-file throw

44 constant comma

create input-pointer input-buffer ,

: next-char ( -- c )
  input-pointer @ dup
  1+ input-pointer !
  c@ ;

: next-hash ( -- n )
  0
  begin
    input-pointer @ input-end = if
      exit
    endif
    next-char
    dup comma = if
      drop exit
    endif
    +
    17 *
    256 mod
  again ;

: part1 ( -- n )
  0
  begin
    next-hash +
    input-pointer @ input-end =
  until ;

." Part 1: " part1 . cr
part1-marker