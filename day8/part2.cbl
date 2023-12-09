identification division.
program-id. part2.

data division.
working-storage section.
  copy input.

  01 START-NODES-OUTER.
    05 START-NODES      pic 9(5) occurs 6 times.
  01 START-NODE-INDEX   pic 9.
  01 CYCLES-OUTER.
    05 CYCLES           binary-double unsigned occurs 6 times.

  01 INSTRUCTION-INDEX  index.
  01 INSTRUCTION-COUNT  binary-double unsigned.
  01 CURRENT-NODE       pic 9(5).
  01 LCM                binary-double unsigned.

procedure division.
  call "parse-input2" using INPUT-DATA START-NODES-OUTER end-call

  move 1 to LCM

  perform varying START-NODE-INDEX from 1 by 1 until START-NODE-INDEX > 6
    move START-NODES(START-NODE-INDEX) to CURRENT-NODE
    move 0 to INSTRUCTION-COUNT
    move 0 to INSTRUCTION-INDEX

    perform until function mod(CURRENT-NODE, 26) = 0
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

    move INSTRUCTION-COUNT to CYCLES(START-NODE-INDEX)
  end-perform

  call "lcm" using CYCLES-OUTER LCM

  display
    "Part 2: "
    LCM
  end-display
  goback.
