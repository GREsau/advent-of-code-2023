identification division.
program-id. parse-input2.

environment division.
input-output section.
file-control.
  select INPUT-FILE	assign to "/data/input.txt" organization line sequential.

data division.
  file section.
    fd INPUT-FILE.
    01 LINE-INSTRUCTIONS  pic a(1000).
    01 LINE-NODE-DEF REDEFINES LINE-INSTRUCTIONS.
      05 LINE-NODE    pic a(3).
      05 FILLER       pic x(4). *> " = ("
      05 LINE-NODE-L  pic a(3).
      05 FILLER       pic x(2). *> ", "
      05 LINE-NODE-R  pic a(3).

  working-storage section.
    01 CURRENT-NODE       pic 9(5).
    01 START-NODES-INDEX  pic 9.

  linkage section.
    copy input.

    01 START-NODES-OUTER.
      05 START-NODES   pic 9(5) occurs 6 times.

procedure division using INPUT-DATA START-NODES-OUTER.
  open input INPUT-FILE

  read INPUT-FILE
  move LINE-INSTRUCTIONS to INSTRUCTIONS

  read INPUT-FILE *> skip blank line

  perform forever
    read INPUT-FILE at end
      exit perform
    end-read
    call "parse-node" using LINE-NODE CURRENT-NODE end-call
    call "parse-node" using LINE-NODE-L NODES-L(CURRENT-NODE) end-call
    call "parse-node" using LINE-NODE-R NODES-R(CURRENT-NODE) end-call

    if function mod(CURRENT-NODE, 26) = 1 then
      add 1 to START-NODES-INDEX
      move CURRENT-NODE to START-NODES(START-NODES-INDEX)
    end-if
  end-perform

  close INPUT-FILE
  goback.
