galaxies := OrderedCollection new.

f := FileStream open: 'input.txt' mode: FileStream read.

| x y |
y := 1.
f linesDo: [:line |
  x := 1.
  line do: [:char |
    (char = $#) ifTrue: [galaxies addLast: {x. y}].
    x := x + 1
  ].
  y := y + 1.
].

colSizes := 1 to: (x-1) collect: [:x | 2].
rowSizes := 1 to: (y-1) collect: [:y | 2].

galaxies do: [:p |
  x := p at: 1.
  y := p at: 2.
  colSizes at: x put: 1.
  rowSizes at: y put: 1.
].

result := 0.

galaxies keysAndValuesDo: [:i :p1 |
  | x1 y1 |
  x1 := p1 at: 1.
  y1 := p1 at: 2.

  galaxies from: 1 to: (i-1) do: [:p2 |
    | x2 xmin xmax y2 ymin ymax |
    x2 := p2 at: 1.
    xmin := x1 min: x2.
    xmax := x1 max: x2.

    xmin to: (xmax - 1) do: [:x | result := result + (colSizes at: x)].

    y2 := p2 at: 2.
    ymin := y1 min: y2.
    ymax := y1 max: y2.

    ymin to: (ymax - 1) do: [:y | cr. result := result + (rowSizes at: y)].
  ].
].

Transcript show: 'Part 1: '; print: result; cr.