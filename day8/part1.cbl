identification division.
program-id. part1.

data division.
working-storage section. 
  copy input.

  01 INSTRUCTION-INDEX  pic 9(3).
  01 INSTRUCTION-COUNT  pic 9(8).
  01 CURRENT-NODE       pic 9(5).

procedure division.
  call "parse-input" using INPUT-DATA end-call
  move NODE-AAA to CURRENT-NODE

  perform until CURRENT-NODE = NODE-ZZZ
    add 1 to INSTRUCTION-COUNT
    add 1 to INSTRUCTION-INDEX
    
    if INSTRUCTIONS(INSTRUCTION-INDEX:1) = space
      then move 1 to INSTRUCTION-INDEX
    end-if
    
    evaluate INSTRUCTIONS(INSTRUCTION-INDEX:1)
      when "L"
        move NODES-L(CURRENT-NODE) to CURRENT-NODE
      when "R"
        move NODES-R(CURRENT-NODE) to CURRENT-NODE
      when other
        display "Unexpected direction character!"
        goback
    end-evaluate
  end-perform

  display
    "Part 1: "
    INSTRUCTION-COUNT
  end-display
  goback.
