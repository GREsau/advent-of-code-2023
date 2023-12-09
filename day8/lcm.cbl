identification division.
program-id. lcm.

data division.
working-storage section.
  01 FACTORS          binary-double unsigned occurs 100 times.
  01 FACTORS-IDX      index.
  01 REM              binary-double unsigned.
  01 CURRENT-CYCLE    binary-double unsigned.
  01 CYCLE-IDX        index.
  01 CANDIDATE-FACTOR binary-double unsigned.

linkage section.
  01 CYCLES-OUTER.
    05 CYCLES         binary-double unsigned occurs 6 times.
  01 RET              binary-double.

procedure division using CYCLES-OUTER, RET.
  perform varying CYCLE-IDX from 1 by 1 until CYCLE-IDX > 6
    move CYCLES(CYCLE-IDX) to CURRENT-CYCLE

    perform varying FACTORS-IDX from 1 by 1 until FACTORS(FACTORS-IDX) = 0
      divide FACTORS(FACTORS-IDX) into CURRENT-CYCLE giving RET remainder REM

      if REM = 0 then
        move RET to CURRENT-CYCLE
      end-if
    end-perform

    move 2 to CANDIDATE-FACTOR
    perform until CURRENT-CYCLE = 1
      divide CANDIDATE-FACTOR into CURRENT-CYCLE giving RET remainder REM

      if REM = 0 then
        move RET to CURRENT-CYCLE
        move CANDIDATE-FACTOR to FACTORS(FACTORS-IDX)
        add 1 to FACTORS-IDX
      else
        add 1 to CANDIDATE-FACTOR
      end-if
    end-perform
  end-perform

  move 1 to RET

  perform varying FACTORS-IDX from 1 by 1 until FACTORS(FACTORS-IDX) = 0
    multiply FACTORS(FACTORS-IDX) by RET
  end-perform

  goback.
