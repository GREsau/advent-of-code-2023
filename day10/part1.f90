module part1
  implicit none

  private
  public part1_run

  integer, parameter :: north = 0, east = 1, south = 2, west = 3

contains

  subroutine part1_run(lines)
    character(*), dimension(:), intent(in) :: lines
    integer :: start_x, start_y, direction, ret

    ! find start position
    do start_y = 1, size(lines)
      start_x = index(lines(start_y), "S")
      if (start_x > 0) then
        exit
      end if
    end do

    do direction = north, 3
      ret = steps_to_start(lines, start_x, start_y, direction)
      if (ret > 0) then
        print *, "Part 1:", ret/2
        exit
      end if
    end do

  end subroutine part1_run

  recursive function steps_to_start(lines, x, y, direction) result(ret)
    character(*), dimension(:), intent(in) :: lines
    integer, value :: x, y, direction
    integer :: ret

    select case (direction)
      case (north)
        y = y - 1
      case (east)
        x = x + 1
      case (south)
        y = y + 1
      case (west)
        x = x - 1
    end select

    select case (lines(y)(x:x))
      case ("|")
        select case (direction)
          case (north, south)
          case default
            ret = -1
            return
        end select
      case ("-")
        select case (direction)
          case (east, west)
          case default
            ret = -1
            return
        end select
      case ("L")
        select case (direction)
          case (south)
            direction = east
          case (west)
            direction = north
          case default
            ret = -1
            return
        end select
      case ("J")
        select case (direction)
          case (south)
            direction = west
          case (east)
            direction = north
          case default
            ret = -1
            return
        end select
      case ("7")
        select case (direction)
          case (north)
            direction = west
          case (east)
            direction = south
          case default
            ret = -1
            return
        end select
      case ("F")
        select case (direction)
          case (north)
            direction = east
          case (west)
            direction = south
          case default
            ret = -1
            return
        end select
      case ("S")
        ret = 1
        return
      case default
        ret = -1
        return
    end select

    ret = 1 + steps_to_start(lines, x, y, direction)
  end function

end module part1