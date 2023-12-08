78 NODE-AAA VALUE 1.
78 NODE-ZZZ VALUE 17576.  *> 26*26*26

01 INPUT-DATA.
  05 INSTRUCTIONS   pic a(1000).  *> support up to 1000 instructions

  05 NODES-MAP occurs NODE-ZZZ times.
    10 NODES-L      pic 9(5).
    10 NODES-R      pic 9(5).
