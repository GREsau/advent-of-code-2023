@echo off
setlocal EnableDelayedExpansion

goto :main

:mul
  :: multiplies %1 and %2, which may be GT 32-bit ints, variable %mul_result% set to output

  set _m_num1=%1
  set _m_num2=%2

  if "%_m_num1%" == "0" (
    set mul_result=0
    exit /B
  )
  if "%_m_num2%" == "0" (
    set mul_result=0
    exit /B
  )

  :: fast path for small numbers that can be multiplied as 32-bit ints
  if "%_m_num1%" == "%_m_num1:~0,4%" (
    if "%_m_num2%" == "%_m_num2:~0,4%" (
      set /A mul_result= %_m_num1% * %_m_num2%
      exit /B
    )
  )

  set mul_result=0

  set _m_num1=    %1
  set _m_num2=    %2

  :: offset from right of num1
  set _m_o1=0
  set _m_o1_0s=_
  :_mul_loop_o
    set /A _m_o1 -= 4
    set _m_num1_4d=!_m_num1:~%_m_o1%,4!

    @REM echo "_m_num1_4d: %_m_num1_4d%"

    :_mul_remove_leading_0s_1
    if not "%_m_num1_4d%" == "0" if "%_m_num1_4d:~0,1%" == "0" set _m_num1_4d=%_m_num1_4d:~1%& goto _mul_remove_leading_0s_1

    :: offset from right of num4
    set _m_o2=0
    set _m_total_0s=%_m_o1_0s%
    :_mul_loop_i
      set /A _m_o2 -= 4
      set _m_num2_4d=!_m_num2:~%_m_o2%,4!

      @REM echo "_m_num2_4d: %_m_num2_4d%"

      :_mul_remove_leading_0s_2
      if not "%_m_num2_4d%" == "0" if "%_m_num2_4d:~0,1%" == "0" set _m_num2_4d=%_m_num2_4d:~1%& goto _mul_remove_leading_0s_2

      set /A _m_product= (%_m_num1_4d%+0) * (%_m_num2_4d%+0)
      if not "%_m_total_0s%" == "_" set _m_product=%_m_product%%_m_total_0s%

      call :add %mul_result% %_m_product%
      set mul_result=%add_result%

      if "%_m_total_0s%" == "_" (set _m_total_0s=0000) else (set _m_total_0s=%_m_total_0s%0000)
      :: are there still more digits in num2?
      set _m_remaining_digits="!_m_num2:~0,%_m_o2%!"
      @REM echo "_m_remaining_digits(1): %_m_remaining_digits: =%"
      if not %_m_remaining_digits: =% == "" goto _mul_loop_i

    if "%_m_o1_0s%" == "_" (set _m_o1_0s=0000) else (set _m_o1_0s=%_m_o1_0s%0000)
    :: are there still more digits in num1?
    set _m_remaining_digits="!_m_num1:~0,%_m_o1%!"
    @REM echo "_m_remaining_digits(1): %_m_remaining_digits: =%"
    if not %_m_remaining_digits: =% == "" goto _mul_loop_o
    @REM if not "!_m_num1:~0,%_m_o1%!" == "" goto _mul_loop_o

  exit /B

:add
  @REM echo "Adding '%1' to '%2'"
  :: adds %1 and %2, which may be GT 32-bit ints, variable %add_result% set to output
  set _num1=%1
  set _num2=%2

  if "%_num1%" == "0" (
    set add_result=%2
    exit /B
  )
  if "%_num2%" == "0" (
    set add_result=%1
    exit /B
  )

  :: fast path for small numbers that can be summed as 32-bit ints
  if "%_num1%" == "%_num1:~0,9%" (
    if "%_num2%" == "%_num2:~0,9%" (
      set /A add_result= %_num1% + %_num2%
      exit /B
    )
  )

  :: this needs trimming off before returning
  set add_result=_

  set _overflow=0
  :_add_loop
    :: extract next nine least-significant digits
    set _num1_9ls=%_num1:~-9%
    set _num2_9ls=%_num2:~-9%

    :_add_remove_leading_0s_1
    if not "%_num1_9ls%" == "0" if "%_num1_9ls:~0,1%" == "0" set _num1_9ls=%_num1_9ls:~1%& goto _add_remove_leading_0s_1
    :_add_remove_leading_0s_2
    if not "%_num2_9ls%" == "0" if "%_num2_9ls:~0,1%" == "0" set _num2_9ls=%_num2_9ls:~1%& goto _add_remove_leading_0s_2

    if "%_num1_9ls%" == "%_num1%" (set _num1=0) else set _num1=%_num1:~0,-9%
    if "%_num2_9ls%" == "%_num2%" (set _num2=0) else set _num2=%_num2:~0,-9%

    set /A _sum= %_num1_9ls% + %_num2_9ls% + %_overflow%

    :: _sum_9ls must have exactly 9 digits, with leading 0s if necessary
    set _sum_l0=00000000%_sum%
    set _sum_9ls=%_sum_l0:~-9%

    set add_result=%_sum_9ls%%add_result%
    :: other digits of sum
    set /A _overflow= %_sum:~0,-9% + 0

    if not "%_num1%" == "0" goto _add_loop
    if not "%_num2%" == "0" goto _add_loop
    if not "%_overflow%" == "0" goto _add_loop

  :: remove the trailing underscore
  set add_result=%add_result:~0,-1%
  :_add_remove_leading_0s_r
  if "%add_result:~0,1%" == "0" set add_result=%add_result:~1%& goto _add_remove_leading_0s_r

  exit /B

:mid
  :: finds the midpoint (mean) of %1 and %2, which may be GT 32-bit ints, variable %mid_result% set to output, decimal truncated
  call :add %1 %2
  call :mul %add_result% 5
  set mid_result=%mul_result:~0,-1%
  exit /B

:main

@REM call :add 35765 1
@REM echo ADD %add_result%
@REM exit /B


for /F "tokens=1,*" %%a in (input.txt) do (
  if "%%a"=="Time:" set times=%%b
  if "%%a"=="Distance:" set distances=%%b
)

set time=%times: =%
set record_distance=%distances: =%


:: find the lowest hold-time t which beats record_distance

set min=0
set max=%time%

:main_loop

call :mid %min% %max%
set mid=%mid_result%

echo trying midpoint %mid%

call :mul %mid% %time%
set a=00000000000000000000%mul_result%
set a=%a:~-20%

call :mul %mid% %mid%
call :add %mul_result% %record_distance%
set b=00000000000000000000%add_result%
set b=%b:~-20%

if "%a%" GTR "%b%" (
  if %max% == %mid% (
    set losses=%mid%
    goto end
  )
  set max=%mid%
) else (
  if %min% == %mid% (
    call :add %mid% 1
    set losses=!add_result!
    goto end
  )
  set min=%mid%
)

goto main_loop

:end
set /A wins = %time% + 1 - 2*%losses%
echo %wins%