marker part2-marker
1024 100 * constant bufsize

create input-buffer bufsize allot
s" input.txt" r/o open-file throw value fd
input-buffer bufsize fd read-file throw input-buffer + value input-end
fd close-file throw

char , constant ascii,
char = constant ascii=
char - constant ascii-
char 0 constant ascii0

create input-pointer input-buffer ,

struct
  cell% field lens-label
  cell% field lens-label-length
  cell% field lens-focal-length
end-struct lens%

struct
  cell% field box-lenses-count
  lens% 200 * field box-lenses
end-struct box%

create boxes box% 256 * %allot box% %size 256 * 0 fill

: get-box ( uhash -- addr )
  box% %size * boxes + ;

: get-or-insert-lens { c-label ulabel uhash -- a-lens }
\ returned `lens%` may have uninitialized `lens-focal-length`
  uhash get-box
  ( a-box )
  dup box-lenses-count @
  ( a-box ucount )
  over box-lenses dup
  ( a-box ucount a-lenses a-lenses )
  rot lens% %size * + swap
  2dup > if
    begin
      ( a-box a-box-lenses-end a-lens )
      dup lens-label @
      over lens-label-length @
      ( a-box a-box-lenses-end a-lens c-lens-label u-lens-label-length )
      c-label ulabel str= if
        nip nip
        exit
      endif
      lens% %size +
      2dup =
    until
  endif
  \ box doesn't contain lens with given label, so add it to the end
  drop
  ( a-box a-lens )
  dup c-label swap lens-label !
  dup ulabel swap lens-label-length !
  swap
  ( a-lens a-box )
  box-lenses-count dup @ 1+ swap !
  ;

: set-lens { c-label ulabel uhash ufl -- }
  c-label ulabel uhash get-or-insert-lens
  ufl swap lens-focal-length !
  ;

: remove-lens { c-label ulabel uhash -- }
  uhash get-box
  ( a-box )
  dup box-lenses-count @
  ( a-box ucount )
  over box-lenses dup
  ( a-box ucount a-lenses a-lenses )
  rot lens% %size * + swap
  2dup > if
    begin
      ( a-box a-box-lenses-end a-lens )
      dup lens-label @
      over lens-label-length @
      ( a-box a-box-lenses-end a-lens c-lens-label u-lens-label-length )
      c-label ulabel str= if
        ( a-box a-box-lenses-end a-lens )
        dup lens% %size +
        dup 3 roll swap -
        rot swap
        ( a-box a-lens2 a-lens ucount )
        move
        ( a-box )
        box-lenses-count dup @ 1- swap !
        exit
      endif
      lens% %size +
      2dup =
    until
  endif
  drop drop drop
  ;

: next-char ( -- c )
  input-pointer @ dup
  1+ input-pointer !
  c@ ;

: next-step ( -- c-label ulabel uhash u-op )
\ c-label is the address in buffer of the label start, with length ulabel
\ uhash is the HASH of the label
\ u-op is 0 for "-", or the focal length for "="
  input-pointer @
  0
  0
  begin
    next-char
    dup ascii, = if
      drop
      rot 1+ -rot
      next-char
    endif
    dup ascii- = if
      drop
      ( c-label ulabel uhash )
      0
      exit
    endif
    dup ascii= = if
      drop
      ( c-label ulabel uhash )
      next-char
      ascii0 -
      exit
    endif
    +
    17 *
    256 mod
    swap 1+ swap
  again ;

: run-step ( c-label ulabel uhash u-op -- )
  dup 0> if
    set-lens
  else
    drop
    remove-lens
  endif ;

: box-focusing-power ( ubox -- ufp )
  0 over get-box
  ( ubox acc a-box )
  dup box-lenses-count @ 0
  ( ubox acc a-box ucount 0 )
  +do
    dup
    i dup 1+ -rot
    ( ubox acc a-box i+1 a-box i )
    lens% %size * + box-lenses lens-focal-length @
    ( ubox acc a-box i+1 ufl )
    * rot + swap
  loop
  drop
  swap 1+ * ;

: total-focusing-power ( -- ufp )
  0
  256 0 +do
    i box-focusing-power +
  loop ;

: part2 ( -- n )
  begin
    next-step run-step
    input-pointer @ input-end =
  until
  total-focusing-power ;


." Part 2: " part2 . cr

part2-marker
