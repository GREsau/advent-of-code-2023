module part2
  implicit none

  private
  public part2_run

  integer, parameter :: north = 0, east = 1, south = 2, west = 3

contains

  subroutine part2_run(lines)
    character(*), dimension(:), intent(in) :: lines
    character, dimension(:,:), allocatable :: pipes
    integer :: start_x, start_y, direction, ret, x, y, start_direction

    allocate(pipes(size(lines),size(lines)))

    ! find start position
    do start_y = 1, size(lines)
      start_x = index(lines(start_y), "S")
      if (start_x > 0) then
        exit
      end if
    end do

    do start_direction = north, 3
      pipes(:,:) = "."
      direction = start_direction
      ret = steps_to_start(lines, start_x, start_y, direction, pipes)
      if (ret > 0) then
        exit
      end if
    end do

    if (start_direction == east .and. direction == north) then
      pipes(start_y, start_x) = "F"
    else if (start_direction == south .and. direction == east) then
      pipes(start_y, start_x) = "7"
    end if

    ret = 0
    do y = 1, size(lines)
      do x = 1, size(lines)
        if (is_contained(y, x, pipes)) then
          ret = ret + 1
        end if
      end do
    end do

    print *, "Part 2:", ret

  end subroutine part2_run

  function is_contained(x, y, pipes) result(ret)
    character, dimension(:,:), intent(in) :: pipes
    integer, value :: x, y
    logical :: ret

    if (pipes(y, x) /= ".") then
      ret = .false.
    else
      ret = modulo(count(pipes(y, x:) == "|" .or. pipes(y, x:) == "F") - count(pipes(y, x:) == "7"), 2) == 1
    end if

  end function

  recursive function steps_to_start(lines, x, y, direction, pipes) result(ret)
    character(*), dimension(:), intent(in) :: lines
    character, dimension(:,:), intent(inout) :: pipes
    integer, value :: x, y
    integer, intent(inout) :: direction
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

    pipes(y,x) = lines(y)(x:x)

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

    ret = 1 + steps_to_start(lines, x, y, direction, pipes)
  end function

end module part2