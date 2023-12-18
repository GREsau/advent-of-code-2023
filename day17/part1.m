  set sd="input.txt"
  open sd:readonly
  use sd
  read line
  set width=$length(line)
  set height=0
  for y=1:1 quit:(line="")  do
  . for x=1:1:width set costs(x,y)=$extract(line,x)
  . set height=height+1
  . read line
  close sd

  set counter=0

  do enqueue(-costs(1,1),1,1,0,0,0,0)

  set finished=0

  for  q:finished  do
  . set cost=$order(queue(""))
  . set dedup=$order(queue(cost,""))
  . set x=queue(cost,dedup,"x")         kill queue(cost,dedup,"x")
  . set y=queue(cost,dedup,"y")         kill queue(cost,dedup,"y")
  . set up=queue(cost,dedup,"up")       kill queue(cost,dedup,"up")
  . set right=queue(cost,dedup,"right") kill queue(cost,dedup,"right")
  . set down=queue(cost,dedup,"down")   kill queue(cost,dedup,"down")
  . set left=queue(cost,dedup,"left")   kill queue(cost,dedup,"left")
  . if (x=width)&(y=height) write "Part 1: ",+cost,! set finished=1
  . ; move up
  . if (y>1)&(up<3)&(down=0) do enqueue(cost,x,y-1,up+1,0,0,0)
  . ; move down
  . if (y<height)&(down<3)&(up=0) do enqueue(cost,x,y+1,0,0,down+1,0)
  . ; move left
  . if (x>1)&(left<3)&(right=0) do enqueue(cost,x-1,y,0,0,0,left+1)
  . ; move right
  . if (x<width)&(right<3)&(left=0) do enqueue(cost,x+1,y,0,right+1,0,0)

  quit

enqueue(prevcost,x,y,up,right,down,left)
  if $data(visited(x,y,up,right,down,left)) quit
  set visited(x,y,up,right,down,left)=1
  set counter=counter+1
  new dedup,cost
  set cost=prevcost+costs(x,y)
  set dedup=counter
  set queue(cost,dedup,"x")=x
  set queue(cost,dedup,"y")=y
  set queue(cost,dedup,"up")=up
  set queue(cost,dedup,"right")=right
  set queue(cost,dedup,"down")=down
  set queue(cost,dedup,"left")=left
  quit