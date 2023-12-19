Red [Title: "AoC 2023 day 19 part 2"]

do %bigint.red

letter: charset [#"a" - #"z"]
digit: charset "0123456789"
name: [some letter]
number: [some digit]
comparison: charset [#"<" #">"]
destination: [name | "A" | "R"]
nl: [opt cr lf]
rule: [
  [ahead [name comparison] collect [keep name keep comparison keep number ":" keep destination]] | keep destination
]
workflow: [collect [
  keep name collect ["{" some [rule opt ","] "}"]
]]
part: [collect [
  "{"
    "x=" keep number ","
    "m=" keep number ","
    "a=" keep number ","
    "s=" keep number
  "}"
]]
parser: [
  collect set workflows [some [ahead letter workflow opt nl]]
  nl
  collect set parts [some [ahead "{" part opt nl]]
]

parse read %input.txt parser

to-wf-word: function[s] [ to-word append copy "wf-" s ]

foreach workflow workflows [
  body: copy []

  foreach rule workflow/2 [
    either block? rule [
      append body either rule/2 == #"<" [reduce [
        to-set-word 'rest 'as-pair load rule/3 'pick to-word rule/1 2
        to-set-word rule/1 'as-pair 'pick to-word rule/1 1 load rule/3
      ]] [reduce [
        to-set-word 'rest 'as-pair 'pick to-word rule/1 1 load rule/3 '+ 1
        to-set-word rule/1 'as-pair load rule/3 '+ 1 'pick to-word rule/1 2
      ]]
      append body reduce [
        to-wf-word rule/4 'x 'm 'a 's
        to-set-word rule/1 'rest
      ]
    ] [
      append body to-wf-word rule
      append body [x m a s]
    ]
  ]

  set to-wf-word workflow/1 function[x m a s] body
]

range-empty?: function[r] [ r/1 >= r/2 ]
range-size?: function[r] [ either r/1 >= r/2 [0] [r/2 - r/1] ]

wf-A: func[x m a s] [
  product: as-big range-size? x
  product: big-mul product range-size? m
  product: big-mul product range-size? a
  product: big-mul product range-size? s
  result: big-add-big result product
]
wf-R: func[x m a s] [ ]

result: [0]
wf-in 1x4001 1x4001 1x4001 1x4001

print ["Part 2:" big-to-string result]

