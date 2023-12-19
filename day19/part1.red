Red [Title: "AoC 2023 day 19 part 1"]

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
      append body reduce [
        'if
        to-word rule/1
        to-word rule/2
        load rule/3
        reduce [
          'return to-wf-word rule/4 'x 'm 'a 's
        ]
      ]
    ] [
      append body to-wf-word rule
      append body [x m a s]
    ]
  ]

  set to-wf-word workflow/1 function[x m a s] body
]

wf-A: func[x m a s] [ (x + m + a + s) ]
wf-R: func[x m a s] [ 0 ]

result: 0
foreach part parts [
  x: load to-string part/1
  m: load to-string part/2
  a: load to-string part/3
  s: load to-string part/4
  result: result + wf-in x m a s
]

print ["Part 1:" result]