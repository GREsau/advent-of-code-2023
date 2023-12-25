)copy dfns segs path remlink span

lines ← ': '∘segs¨⊃⎕NGET 'input.txt' 1
words ← ∪(⊃¨lines),⊃,/lines

graph ← {⊃words∘⍳¨⊂⍵}¨1∘↓¨lines
⍝ pad with empty vectors
graph ← graph,((⍴words)-⍴graph)⍴⍬
⍝ change graph from directed to undirected
graph ← {{⍵/⍳⍴⍵}¨↓⍵}∘{⍵∨⍉⍵}∘{⍉(⍳⍴⍵)∘.∊⍵}graph

⍝ remove path between 1 and ⍵ from graph ⍵
rempath1 ← {p ← ⍺ path 1 ⍵ ⋄ e ← ↓⍉↑(¯1↓p)(1↓p) ⋄ e ← e,⌽¨e ⋄ ⊃remlink⍨/e,⊂⍺}
⍝ repeats rempath1 and again and again
rempath1p3 ← {⍵∘(rempath1⍨⍣3)⍺}

partition ← {+/¯2=(⍺ rempath1p3 ⍵)span 1}

partition_size ← ⊃{_ n g ← ⍵ ⋄ (g partition n) (n+1) g}⍣{0<⊃⍺} 0 2 graph

result ← partition_size × (⍴words) - partition_size
⎕ ← 'Part 1: ' result
