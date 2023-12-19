Red [Title: "bigint"]

as-big: function[a] [reduce [a]]

; 'a and 'b must be a block of integers <10000
; 'a and 'b may be mutated
big-add-big: function[a b] [
  if (length? b) > (length? a) [
    return big-add-big b a
  ]
  if (length? b) > 1 [
    big-add-big skip a 1 skip b 1
  ]
  big-add a b/1
]

; 'a must be a block of integers <10000
; 'b must be a (small) integer
; 'a may be mutated
big-add: function[a b] [
  repeat i length? a [
    if b == 0 [
      return a
    ]

    part: pick a i
    sum: part + b
    poke a i sum % 10000
    b: to-integer sum / 10000
  ]
  if b > 0 [
    append a b
  ]
  a
]

; 'a must be a block of integers <10000
; 'a may be mutated
big-mul: function[a b] [
  if (length? a) > 1 [
    big-mul skip a 1 b
  ]
  big-add a (a/1 * (b - 1))
  a
]

big-to-string: function[a] [
  if integer? a [
    return to-string a
  ]

  result: copy ""
  foreach part a [
    result: append pad/left part 4 result
  ]
  replace/all trim/head result " " 0
]