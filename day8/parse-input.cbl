identification division.
program-id. parse-input.

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
    01 CURRENT-NODE   pic 9(5).

  linkage section.
    copy input.

procedure division using INPUT-DATA.
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
  end-perform

  close INPUT-FILE
  goback.
