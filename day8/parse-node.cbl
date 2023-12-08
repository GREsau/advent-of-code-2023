identification division.
program-id. parse-node.
  
data division.
working-storage section.
  78 A-CHAR VALUE 66. *> ASCII value of 'A' + 1 (ugh 1-based counting)

linkage section.    
  01 IN-TEXT  pic a(3).
  01 OUT-NUM  pic 9(5).

procedure division using IN-TEXT, OUT-NUM.

  move function ord(IN-TEXT) to OUT-NUM
  compute OUT-NUM = (OUT-NUM - A-CHAR) * 26

  add function ord(IN-TEXT(2:)) to OUT-NUM
  compute OUT-NUM = (OUT-NUM - A-CHAR) * 26

  add function ord(IN-TEXT(3:)) to OUT-NUM
  compute OUT-NUM = OUT-NUM - A-CHAR + 1

  goback.
