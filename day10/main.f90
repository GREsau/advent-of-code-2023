program main
  use part1
  use part2
  implicit none

  character(200), dimension(200) :: lines
  integer :: io, stat

  lines(:) = ""

  open(newunit=io, file="/data/input.txt", status="old", action="read")
  ! shift map down by 1 row to allow optimistically searching north even if S is on top row
  read(io, "(A)", iostat=stat) lines(2:)
  close(io)

  call part1_run(lines)
  call part2_run(lines)

end program main